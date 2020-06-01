# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

Any type of contribution is welcome; from new features, bug fixes, documentation improvements or even [adding charts to the repository](#adding-a-new-chart-to-the-repository).

## How to Contribute

1. Fork this repository, develop, and test your changes.
2. Submit a pull request.

***NOTE***: To make the Pull Requests' (PRs) testing and merging process easier, please submit changes to multiple charts in separate PRs.

### Technical Requirements

When submitting a PR make sure that it:
- Must pass CI jobs for linting and test the changes on top of different k8s platforms. (Automatically done by the Bitnami CI/CD pipeline).
- Must follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).
- Implements changes in both files if the chart contains a _values-production.yaml_ and a _values.yaml_.
- Has the "edits and maintainers" option enabled to allow our CI/CD to modify the PR (`bitnami-bot` will update _values*.yaml_). Find more information in [this link](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork).
- Any change to a chart requires a version bump following [semver](https://semver.org/) principles.

### Documentation Requirements

- A chart's `README.md` must include configuration options.
- A chart's `NOTES.txt` must include relevant post-installation information.
- The title of the PR starts with chart name (e.g. `[bitnami/chart]`)

### PR Approval and Release Process

1. Changes are manually reviewed by Bitnami team members.
2. Once the changes are accepted, the PR is tested into the CI pipeline, the chart is installed and tested on top of different k8s platforms.
3. If everything works fine, the `bitnami-bot` will add a new commit to the PR updating all the Docker images tags and dependencies. If something fails, the review process continues.
4. When the PR passes all tests it is merged in the GitHub master branch and the new version of the chart is pushed to the registry. Please note that may be a slight difference between the appearance of the code in GitHub and the chart in the registry.

### Adding a new chart to the repository

There are only three major requirements to add a new chart in our catalog:
- The chart should use Bitnami based container images. If they don't exist, you can [open a GitHub issue](https://github.com/bitnami/charts/issues/new/choose) and we will work together to create them.
- Follow the same structure/patterns that the rest of the Bitnami charts and the [Best Practices for Creating Production-Ready Helm charts](https://docs.bitnami.com/tutorials/production-ready-charts/) guide.
- Use an [OSI approved license](https://opensource.org/licenses) for all the software.
