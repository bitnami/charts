# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

Any type of contribution is welcome; from new features, bug fixes, [tests](#testing), documentation improvements or even [adding charts to the repository](#adding-a-new-chart-to-the-repository) (if it's viable once evaluated the feasibility).

## How to Contribute

1. Fork this repository, develop, and test your changes.
2. Submit a pull request.

***NOTE***: To make the Pull Requests' (PRs) testing and merging process easier, please submit changes to multiple charts in separate PRs.

### Technical Requirements

When submitting a PR make sure that it:

- Must pass CI jobs for linting and test the changes on top of different k8s platforms. (Automatically done by the Bitnami CI/CD pipeline).
- Must follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).
- Any change to a chart requires a version bump following [semver](https://semver.org/) principles. This is the version that is going to be merged in the GitHub repository, then our CI/CD system is going to publish in the Helm registry a new patch version including your changes and the latest images and dependencies.
- Any change to a Helm template (especially new templates) must include a license header like the following:

```yaml
{{- /*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}
```

#### Sign Your Work

The sign-off is a simple line at the end of the explanation for a commit. All commits needs to be signed. Your signature certifies that you wrote the patch or otherwise have the right to contribute the material. The rules are pretty simple, you only need to certify the guidelines from [developercertificate.org](https://developercertificate.org/).

Then you just add a line to every git commit message:

```text
Signed-off-by: Joe Smith <joe.smith@example.com>
```

Use your real name (sorry, no pseudonyms or anonymous contributions.)

If you set your `user.name` and `user.email` git configs, you can sign your commit automatically with `git commit -s`.

Note: If your git config information is set properly then viewing the `git log` information for your commit will look something like this:

```text
Author: Joe Smith <joe.smith@example.com>
Date:   Thu Feb 2 11:41:15 2018 -0800

    Update README

    Signed-off-by: Joe Smith <joe.smith@example.com>
```

Notice the `Author` and `Signed-off-by` lines match. If they don't your PR will be rejected by the automated DCO check.

### Documentation Requirements

- A chart's `README.md` must include configuration options. The tables of parameters are generated based on the metadata information from the `values.yaml` file, by using [this tool](https://github.com/bitnami/readme-generator-for-helm).
- A chart's `NOTES.txt` must include relevant post-installation information.
- The title of the PR starts with chart name (e.g. `[bitnami/chart]`)

### PR Approval and Release Process

1. Changes are manually reviewed by Bitnami team members.
2. Once the changes are accepted, the PR is verified with a [Static analysis](https://github.com/bitnami/charts/blob/main/TESTING.md#Static-analysis) that includes the lint and the vulnerability checks. If that passes, the Bitnami team will review the changes and trigger the verification and functional tests.
3. When the PR passes all tests, the PR is merged by the reviewer(s) in the GitHub `main` branch.
4. Then our CI/CD system is going to push the chart to the Helm registry including the recently merged changes and also the latest images and dependencies used by the chart. The changes in the images will be also committed by the CI/CD to the GitHub repository, bumping the chart version again.

***NOTE***: Please note that, in terms of time, may be a slight difference between the appearance of the code in GitHub and the chart in the registry.

### Testing

1. Read the [Test Strategy](https://github.com/bitnami/charts/blob/main/TESTING.md) guide.
2. Determine the types of tests you will need based on the chart you are testing and the information in the test strategy.
3. Before you create a pull request, make sure you achieved the [Test Acceptance Criteria](https://github.com/bitnami/charts/blob/main/TESTING.md#Test-acceptance-criteria).
4. If you were able to achieve them, congrats! Create a PR and wait for the approval. You should then be able to see the result of the test execution for multiple cloud platforms (AKS, TKG, GKE) after the approval.

### Adding a new chart to the repository

There are five major technical requirements to add a new Helm chart to our catalog:

- The chart should use Bitnami based container images. If they don't exist, you can [open a GitHub issue](https://github.com/bitnami/charts/issues/new/choose) and we will work together to create them.
- Follow the same structure/patterns that the rest of the Bitnami charts (refer to [Creating a new chart](./README.md#creating-a-new-chart)) and the [Best Practices for Creating Production-Ready Helm charts](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-production-ready-charts-index.html) guide.
- Use an [OSI approved license](https://opensource.org/licenses) for all the software.
- Every new Helm template must include a license header like the following:

```yaml
{{- /*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}
```

- The exception to the license header rule above are `Chart.yaml` and `values.yaml` files, that use the following format instead:

```yaml
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
```

Please, note we will need to check internally and evaluate the feasibility of adding the new solution to the catalog. Due to limited resources this step could take some time.
