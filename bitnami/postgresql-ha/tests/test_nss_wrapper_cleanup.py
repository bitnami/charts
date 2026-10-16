#!/usr/bin/env python3
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

"""Run with: python3 -m unittest discover -s bitnami/postgresql-ha/tests -v.

Requires helm, bash, PyYAML, and the chart's common dependency. Database
commands are stubbed; the rendered probe and pre-stop scripts run unchanged
apart from redirecting their absolute library paths to isolated fixtures.
"""

import concurrent.futures
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

import yaml


CHART = Path(__file__).resolve().parents[1]
SCRIPTS = ("liveness-probe.sh", "readiness-probe.sh", "pre-stop.sh")

LIBRARY = r'''
debug() { :; }
info() { :; }
is_boolean_yes() { [[ "$1" == "yes" ]]; }
debug_execute() { "$@"; }
pg_isready() { return 0; }
psql() { printf '1\n'; }
ps() { :; }
sleep() { :; }
postgresql_stop() { :; }
repmgr_get_upstream_node() { printf 'primary.example\n'; }

# Model the image's helper: generate identity files only if the user lookup
# fails, and export them for the subsequent repmgr command.
postgresql_enable_nss_wrapper() {
    if [[ "$TEST_NSS_MODE" != "reuse" ]]; then
        export NSS_WRAPPER_PASSWD="$(mktemp)"
        if [[ "$TEST_NSS_MODE" == "partial" ]]; then
            return 9
        fi
        export NSS_WRAPPER_GROUP="$(mktemp)"
        printf 'postgres:x:%s:%s:PostgreSQL:/data:/bin/false\n' "$TEST_UID" "$TEST_GID" > "$NSS_WRAPPER_PASSWD"
        printf 'postgres:x:%s:\n' "$TEST_GID" > "$NSS_WRAPPER_GROUP"
    fi
}

check_identity() {
    [[ -s "$NSS_WRAPPER_PASSWD" && -s "$NSS_WRAPPER_GROUP" ]]
    [[ "$(cut -d: -f3 "$NSS_WRAPPER_PASSWD")" == "$TEST_UID" ]]
    [[ "$(cut -d: -f3 "$NSS_WRAPPER_GROUP")" == "$TEST_GID" ]]
    printf 'checked\n'
    if [[ "$TEST_RESULT" == "TERM" ]]; then
        kill -TERM "$$"
    elif [[ "$TEST_RESULT" == "INT" ]]; then
        kill -INT "$$"
    else
        return "$TEST_RESULT"
    fi
}
repmgr_check_status() { check_identity; }
'''


class NSSCleanupTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sandbox = tempfile.TemporaryDirectory(prefix="postgresql-nss-tests-")
        cls.root = Path(cls.sandbox.name)
        cls.library = cls.root / "lib"
        cls.library.mkdir()
        (cls.library / "libpostgresql.sh").write_text(LIBRARY)
        (cls.library / "librepmgr.sh").write_text("")
        # Test pre-stop errors through its main-shell stop command rather
        # than the process substitution, whose exit status bash ignores.
        with (cls.library / "libpostgresql.sh").open("a") as f:
            f.write('postgresql_stop() { check_identity; }\n')
        (cls.library / "postgresql-env.sh").write_text(
            'POSTGRESQL_PORT_NUMBER=5432\nPOSTGRESQL_ENABLE_TLS=no\n'
            'POSTGRESQL_USERNAME=postgres\nPOSTGRESQL_DATABASE=postgres\n'
            'POSTGRESQL_PASSWORD=test\nBITNAMI_DEBUG=yes\n'
            'REPMGR_NODE_NETWORK_NAME=standby.example\n'
        )
        render = subprocess.run(
            ["helm", "template", "nss-test", str(CHART), "--namespace", "test"],
            capture_output=True, text=True, check=True,
        )
        config = next(
            doc for doc in yaml.safe_load_all(render.stdout)
            if doc and doc.get("kind") == "ConfigMap"
            and doc["metadata"]["name"] == "nss-test-postgresql-ha-postgresql-scripts"
        )
        cls.scripts = {}
        for name in SCRIPTS:
            script = cls.root / name
            script.write_text(config["data"][name].replace("/opt/bitnami/scripts/", str(cls.library) + "/"))
            subprocess.run(["bash", "-n", str(script)], check=True)
            cls.scripts[name] = script

    @classmethod
    def tearDownClass(cls):
        cls.sandbox.cleanup()

    def run_script(self, name, directory, result="0", mode="create", inherited=False):
        env = dict(os.environ)
        for key in ("NSS_WRAPPER_PASSWD", "NSS_WRAPPER_GROUP", "LD_PRELOAD", "BASH_ENV"):
            env.pop(key, None)
        env.update(TMPDIR=str(directory), TEST_RESULT=result, TEST_NSS_MODE=mode,
                   TEST_UID="12345", TEST_GID="54321")
        if inherited:
            passwd = directory / "inherited passwd"
            group = directory / "inherited group"
            passwd.write_text("postgres:x:12345:54321:PostgreSQL:/data:/bin/false\n")
            group.write_text("postgres:x:54321:\n")
            env.update(NSS_WRAPPER_PASSWD=str(passwd), NSS_WRAPPER_GROUP=str(group))
        return subprocess.run(
            ["bash", str(self.scripts[name]), "0"], env=env,
            capture_output=True, text=True, timeout=10,
        )

    def test_repeated_success_and_failure_preserve_exit_status_and_remove_files(self):
        for name in SCRIPTS:
            for result in ("0", "7"):
                with self.subTest(script=name, result=result), tempfile.TemporaryDirectory(prefix="probe tmp-", dir=self.root) as d:
                    directory = Path(d)
                    for _ in range(25):
                        run = self.run_script(name, directory, result)
                        self.assertEqual(run.returncode, int(result), run.stderr)
                        self.assertIn("checked", run.stdout + run.stderr)
                        self.assertEqual(list(directory.iterdir()), [])

    def test_inherited_identity_files_are_preserved(self):
        for name in SCRIPTS:
            for mode in ("reuse", "create"):
                with self.subTest(script=name, mode=mode), tempfile.TemporaryDirectory(dir=self.root) as d:
                    directory = Path(d)
                    run = self.run_script(name, directory, mode=mode, inherited=True)
                    self.assertEqual(run.returncode, 0, run.stderr)
                    self.assertEqual({p.name for p in directory.iterdir()}, {"inherited passwd", "inherited group"})

    def test_partial_setup_failure_removes_only_new_files(self):
        for name in SCRIPTS:
            with self.subTest(script=name), tempfile.TemporaryDirectory(dir=self.root) as d:
                directory = Path(d)
                run = self.run_script(name, directory, mode="partial", inherited=True)
                self.assertEqual(run.returncode, 9, run.stderr)
                self.assertEqual({p.name for p in directory.iterdir()}, {"inherited passwd", "inherited group"})

    def test_no_wrapper_files_needed(self):
        for name in SCRIPTS:
            with self.subTest(script=name), tempfile.TemporaryDirectory(dir=self.root) as d:
                # Model the helper's no-op when the OS can resolve the user.
                # repmgr still succeeds, without any NSS variables being set.
                directory = Path(d)
                env = dict(os.environ, TMPDIR=str(directory), TEST_NSS_MODE="reuse", TEST_RESULT="0", TEST_UID="12345", TEST_GID="54321")
                for key in ("NSS_WRAPPER_PASSWD", "NSS_WRAPPER_GROUP", "LD_PRELOAD", "BASH_ENV"):
                    env.pop(key, None)
                # Remove the identity assertion from this isolated script's
                # fixture; it represents getent using the image's real user.
                script = self.scripts[name].read_text().replace(
                    '. ' + str(self.library) + '/librepmgr.sh',
                    '. ' + str(self.library) + '/librepmgr.sh\ncheck_identity() { printf "checked\\n"; }',
                )
                run = subprocess.run(["bash", "-c", script, "probe", "0"], env=env, capture_output=True, text=True, timeout=10)
                self.assertEqual(run.returncode, 0, run.stderr)
                self.assertEqual(list(directory.iterdir()), [])

    def test_signal_exit_cleans_files(self):
        for name in SCRIPTS:
            for signal, code in (("TERM", 143), ("INT", 130)):
                with self.subTest(script=name, signal=signal), tempfile.TemporaryDirectory(dir=self.root) as d:
                    directory = Path(d)
                    run = self.run_script(name, directory, result=signal)
                    self.assertEqual(run.returncode, code, run.stderr)
                    self.assertEqual(list(directory.iterdir()), [])

    def test_concurrent_probes_clean_only_their_own_files(self):
        with tempfile.TemporaryDirectory(dir=self.root) as d:
            directory = Path(d)
            def probe(i):
                return self.run_script(SCRIPTS[i % 2], directory)
            with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
                for run in pool.map(probe, range(40)):
                    self.assertEqual(run.returncode, 0, run.stderr)
            self.assertEqual(list(directory.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
