#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

cd "${GITHUB_WORKSPACE}/upstream-charts" || exit 1
          
# Get PR title using the API to avoid malicious string substitutions
pr_title="$(gh api "/repos/${GITHUB_REPOSITORY}/pulls/${PULL_REQUEST_NUMBER}" | jq -r '.title')"
# The generator needs the file to exist
chart_version="$(yq e '.version' "${GITHUB_WORKSPACE}/charts/bitnami/${CHART}/Chart.yaml")"
changelog_file="${GITHUB_WORKSPACE}/charts/bitnami/${CHART}/CHANGELOG.md"
changelog_tmp="${GITHUB_WORKSPACE}/charts/bitnami/${CHART}/CHANGELOG.md.tmp"
touch "$changelog_file"
npx conventional-changelog-cli -i "$changelog_file" -s -t "${CHART}/" -r 0 --commit-path "bitnami/${CHART}"
# The tool uses short sha to generate commit links. Sometimes, Github does not offer links with the short sha, so we change all commit links to use the full sha instead
for short_sha in $(grep -Eo "/commit/[a-z0-9]+" "$changelog_file" | awk -F/ '{print $3}'); do
    long_sha="$(git rev-list @ | grep "^$short_sha" | head -n 1)";
    sed -i "s%/commit/$short_sha%/commit/$long_sha%g" "$changelog_file";
done

cd "${GITHUB_WORKSPACE}/charts" || exit 1
# Remove unreleased section (includes all intermediate commits in the branch) and create future entry based on PR title
# The unreleased section looks like this "## (YYYY-MM-DD)" whereas a released section looks like this "## 0.0.1 (YYYY-MM-DD)"
# So we only need to find a released section to start printing in the awk script below
awk '/^##[^(]*[0-9]/ {flag=1} flag {print}' "$changelog_file" > "$changelog_tmp"
# Remove extra newlines so the changelog file passes the markdown linter
sed -i -E -e '/^$/d' "$changelog_tmp" && sed -i -E -e 's/(##.*)/\n\1\n/g' "$changelog_tmp"
# Include h1 heading and add entry for the current version. There is no tag for the current version (this will be created once merged), so we need to manually add it.
# We know the final squashed commit title, which will be the PR title. We cannot add a link to the commit in the main branch because it has not been
# merged yet (this will be corrected once a new version regenerates the changelog). Instead, we add the PR url which contains the exact same information.
echo -e -n "# Changelog\n\n## $chart_version ($(date +'%Y-%m-%d'))\n\n* ${pr_title} ([#${PULL_REQUEST_NUMBER}](${PULL_REQUEST_URL}))\n" > "$changelog_file"
cat "$changelog_tmp" >> "$changelog_file"
rm "$changelog_tmp"

# Commit all changes, if any
if git status -s | grep "bitnami/${CHART}/CHANGELOG.md"; then
    git add "bitnami/${CHART}/CHANGELOG.md"
    git commit -m "Update CHANGELOG.md" --signoff
fi
