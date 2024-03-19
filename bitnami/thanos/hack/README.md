# bitnami/thanos hacks

## sync_alerting_rules.py

This script generates Prometheus rules set for Alertmanager from [thanos-io/thanos/mixin](https://github.com/thanos-io/thanos/tree/main/mixin) library.

Prerequisites:

- `python3` with packages from `requirements.txt` installed
- [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)

In order to update these rules:

- prepare and merge PR into [thanos](https://github.com/thanos-io/thanos/tree/main/mixin/rules) master and/or release branch
- run `sync_alerting_rules.py` inside your fork of this repository
- send PR with changes to this repository
