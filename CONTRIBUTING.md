# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

## How to Contribute

1. Fork this repository, develop and test your changes.
2. Submit a pull request.

***NOTE***: In order to make testing and merging of PRs easier, please submit changes to multiple charts in separate PRs.

### Technical Requirements

- Must pass CI jobs for linting and test the changes on top of different k8s platforms. (Automatically done by the Bitnami CI/CD pipeline).
- Must follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).
- If the chart contains a _values-production.yaml_ apart from _values.yaml_, ensure that changes are implemented in both files.
- Our CI/CD needs to modify the PR (`bitnami-bot` will update `values*.yaml`). To do so, it's necessary you allow "edits from maintainers". Find more information in [this link](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork).
- Any change to a chart requires a version bump following [semver](https://semver.org/) principles.

### Documentation Requirements

- A chart's `README.md` must include configuration options.
- A chart's `NOTES.txt` must include relevant post-installation information.
- The title of the PR starts with chart name (e.g. `[bitnami/chart]`)

### PR Approval and Release Process

1. Changes are manually reviewed by some Bitnami team members.
2. Once accepted the changes, the PR is tested into the Bitnami CI/CD pipeline, the chart is installed and tested on top of different k8s platforms.
3. If everything works fine, `bitnami-bot` will add a new commit to the PR updating the Docker images tags and dependencies. If something fails, we will continue with the review process.
4. PR is merged in GitHub and the new version of the chart is pushed to the registry, please note that may be a slight difference between the appearance of the code in GitHub and the chart in the repository.

### Adding a new chart to the repository

There are only three major requirements to add a new chart in our catalog:
- The chart should use Bitnami based container images. If they don't exist, you can [open a GitHub issue](https://github.com/bitnami/charts/issues/new/choose) and we will work together to create them.
- Follow the same structure/patterns that the rest of the Bitnami charts and the [Best Practices for Creating Production-Ready Helm charts](https://docs.bitnami.com/tutorials/production-ready-charts/) guide.
- Use an [OSI approved license](https://opensource.org/licenses) for all the software.
