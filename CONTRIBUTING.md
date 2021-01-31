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
- Any change to a chart requires a version bump following [semver](https://semver.org/) principles. This is the version that is going to be merged in the GitHub repository, then our CI/CD system is going to publish in the Helm registry a new patch version including your changes and the latest images and dependencies.

### Documentation Requirements

- A chart's `README.md` must include configuration options.
- A chart's `NOTES.txt` must include relevant post-installation information.
- The title of the PR starts with chart name (e.g. `[bitnami/chart]`)

### PR Approval and Release Process

1. Changes are automatically linted and tested using the [`ct` tool](https://github.com/helm/chart-testing) as a [GitHub action](https://github.com/helm/chart-testing-action). Those tests are based on `helm install`, `helm lint` and `helm test` commands and provide quick feedback about the changes in the PR. For those tests, the chart is installed on top of [kind](https://github.com/kubernetes-sigs/kind) and this step is not blocking (as opposed to 3rd step).
2. Changes are manually reviewed by Bitnami team members.
3. Once the changes are accepted, the PR is tested (if needed) into the Bitnami CI pipeline, the chart is installed and tested (verification and functional tests) on top of different k8s platforms.
4. When the PR passes all tests, the PR is merged by the reviewer(s) in the GitHub `master` branch.
5. Then our CI/CD system is going to push the chart to the Helm registry including the recently merged changes and also the latest images and dependencies used by the chart. The changes in the images will be also committed by the CI/CD to the GitHub repository, bumping the chart version again.

***NOTE***: Please note that, in terms of time, may be a slight difference between the appearance of the code in GitHub and the chart in the registry.

[Here](https://docs.bitnami.com/kubernetes/faq/get-started/understand-charts-release-process/) you can find more information about this process.

### Adding a new chart to the repository

There are only three major requirements to add a new chart in our catalog:
- The chart should use Bitnami based container images. If they don't exist, you can [open a GitHub issue](https://github.com/bitnami/charts/issues/new/choose) and we will work together to create them.
- Follow the same structure/patterns that the rest of the Bitnami charts (you can find a basic scaffolding in the [`template` directory](https://github.com/bitnami/charts/tree/master/template)) and the [Best Practices for Creating Production-Ready Helm charts](https://docs.bitnami.com/tutorials/production-ready-charts/) guide.
- Use an [OSI approved license](https://opensource.org/licenses) for all the software.
