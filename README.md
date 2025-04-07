<p align="center">
    <img width="400px" height=auto src="https://dyltqmyl993wv.cloudfront.net/bitnami/bitnami-by-vmware.png" />
</p>

<p align="center">
    <a href="https://twitter.com/bitnami"><img src="https://badgen.net/badge/twitter/@bitnami/1DA1F2?icon&label" /></a>
    <a href="https://github.com/bitnami/charts"><img src="https://badgen.net/github/stars/bitnami/charts?icon=github" /></a>
    <a href="https://github.com/bitnami/charts"><img src="https://badgen.net/github/forks/bitnami/charts?icon=github" /></a>
    <a href="https://artifacthub.io/packages/search?repo=bitnami"><img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/bitnami" /></a>
    <a href="https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml"><img src="https://github.com/bitnami/charts/actions/workflows/cd-pipeline.yml/badge.svg" /></a>
</p>

# The Bitnami Library for Kubernetes

Popular applications, provided by [Bitnami](https://bitnami.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>
```

## Vulnerabilities scanner

Each Helm chart contains one or more containers. Those containers use images provided by Bitnami through its test & release pipeline and whose source code can be found at [bitnami/containers](https://github.com/bitnami/containers).

As part of the container releases, the images are scanned for vulnerabilities, [here](https://github.com/bitnami/containers#vulnerability-scan-in-bitnami-container-images) you can find more info about this topic.

Since the container image is an immutable artifact that is already analyzed, as part of the Helm chart release process we are not looking for vulnerabilities in the containers but running different verifications to ensure the Helm charts work as expected, see the testing strategy defined at [_TESTING.md_](https://github.com/bitnami/charts/blob/main/TESTING.md).

## Before you begin

### Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

### Setup a Kubernetes Cluster

The quickest way to set up a Kubernetes cluster to install Bitnami Charts is by following the "Bitnami Get Started" guides for the different services:

- [Get Started with Bitnami Charts using VMware Tanzu Kubernetes Grid (TKG)](https://docs.bitnami.com/kubernetes/get-started-tkg/)
- [Get Started with Bitnami Charts using VMware Tanzu Mission Control (TMC)](https://docs.bitnami.com/kubernetes/get-started-tmc/)
- [Get Started With Bitnami Charts Using Azure Marketplace Kubernetes Applications](https://docs.bitnami.com/kubernetes/get-started-cnab/)
- [Get Started with Bitnami Charts using the Amazon Elastic Container Service for Kubernetes (EKS)](https://docs.bitnami.com/kubernetes/get-started-eks/)
- [Get Started with Bitnami Charts using the Google Kubernetes Engine (GKE)](https://docs.bitnami.com/kubernetes/get-started-gke/)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](https://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise, the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:

- Install a chart: `helm install my-release oci://registry-1.docker.io/bitnamicharts/<chart>`
- Upgrade your application: `helm upgrade my-release oci://registry-1.docker.io/bitnamicharts/<chart>`

## Announcing General Availability of Bitnami Premium

### A new commercial version of Bitnami open source containers and Helm charts

Enterprises that love Bitnami can now purchase a Bitnami Premium subscription from [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=charts) and consume the containers and Helm charts right in Docker Hub. Bitnami Premium users will get access to private Docker Hub repositories with the same containers and Helm charts they are used to, plus new commercial features including:

* Enterprise support for all 500+ Bitnami Premium packages
* All LTS branches of all Bitnami application packages maintained up-to-date
* Unlimited pulls of all Bitnami Premium containers and Helm charts from Docker Hub
* Secure software supply chain metadata including Software Bills of Material (SBOMs), SLSA 3 pipeline validation with in-toto attestations, Notation and Cosign signatures, Build-time CVE and anti-virus scan reports, and more.

Alongside the launch of Bitnami Premium, we are making some changes to how we deliver the Bitnami Application Catalog:

* Unlimited pulls from Docker Hub will no longer be available. Free Bitnami Application Catalog containers and charts will be subject to the same limits as any other Docker Hub repos starting December 16th, 2024. Pulls of Bitnami Premium containers and Helm charts will not count towards your [Docker Hub pull](https://hub.docker.com/usage/pulls) limits or overages.
* Long-term-support (LTS) branches of the software we package will no longer be maintained in the free Bitnami Application Catalog. To continue receiving updates for LTS branches of packages, you will have to upgrade to Bitnami Premium.
* We are improving Bitnami Application Catalog users’ supply chain security through additional integrity checks in our Helm chart installation process. These checks enable users to be aware when they are using containers that were not created and tested by Bitnami.

These changes enable us to deliver a premium Bitnami experience to our enterprise users who will benefit from support and security metadata, but who do not need the extensive customization that is core to our other commercial offering called [Tanzu Application Catalog](https://www.vmware.com/products/app-platform/tanzu-application-catalog) (TAC). We are committed to continue delivering free Bitnami Application Catalog content to our community of developers and other open source project maintainers over the long term.

Read on to learn more about Bitnami Premium and the coming changes to the free Bitnami Application Catalog content.

### New goodness in Bitnami Premium

Bitnami Premium is a new version of the content packaged by Bitnami that is sold through [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=charts). You can connect to an Arrow salesperson if you have any questions or want to purchase access. Once you buy Bitnami Premium, you will be given access to the Bitnami Premium registries in Docker Hub. You can then return to Docker Hub where you will have access to the Bitnami Premium containers, Helm charts, and software supply chain metadata from the new **/bitnamiprem** and **/bitnamichartsprem** orgs. These private repos are what enable you to pull without limits or caps. You will also see containers for all LTS branches continuously maintained up-to-date: for example, you will see PostgreSQL containers for versions 12, 13, 14, 15, 16, and 17; while in the free Bitnami catalog, you will only find version 17.

#### A middle ground between free Bitnami Application Catalog and Tanzu Application Catalog customized packages

In Bitnami Premium, all of the applications are built on Debian just as they are in the free Bitnami library. You get the entire library of containers and Helm charts kept up-to-date with the latest changes anywhere in each app from the OS to the application code itself. You can consume the content through Docker Hub where you’ve already been pulling it to date. However, in the Bitnami Premium registries, you will also find important software supply chain security metadata delivered as OCI artifacts alongside the containers and Helm charts. This metadata is useful for enterprises that need third-party open source software to be compliant with policies around auditability, supply chain integrity, and time to remediation of vulnerabilities.

* **Supply chain security and integrity**: Bitnami Premium containers and Helm charts are built on an SLSA 3 pipeline, with attestations and signatures serving as proof that the software you’re deploying in your clusters is what you expect and has not been tampered with.
* **Software bills of material (SBOMs)**: At both the Helm chart and container levels, SBOMs give you fine-grained insight into the contents of every package. Bitnami Premium also includes build-time CVE scans and anti-virus reports (helpful for our Federal government customers). This will make it far easier to continuously validate the integrity of software supply chains and to track and triage vulnerabilities as they are discovered and patched.
* **Build time CVE scans, anti-virus scans, and more**: also included with Bitnami Premium content are Trivy CVE scan results and ClamAV scan results that satisfy requirements for, among other things, doing business with the US Federal government. You will also find the results of Bitnami’s automated functional tests that run as part of every artifact update, trigger information that specifies why the latest update was released, and more.

Bitnami Premium differs from Tanzu Application Catalog in that, just like our free Bitnami content, it is a one-size-fits-all library of containers and Helm charts all built on Debian. Tanzu Application Catalog gives you the ability to customize your artifacts along many different dimensions. Some of the key differences include:

* **Private delivery**: TAC containers and Helm charts are delivered directly to your private registries, or are hosted in a private registry maintained by us that you can pull from.
* **Choose a Linux distro or use your own “golden image”**: TAC gives you the ability to choose among four supported Linux distros: Debian, Ubuntu, RedHat UBI, or VMware’s own PhotonOS. All of the software packages on these distributions are maintained up-to-date and are tested to work in multiple Kubernetes environments as part of the release process. You can also use your own golden image: we’ll build and maintain the artifacts on top of it. For customers that need it, PhotonOS includes FIPS OpenSSL, is STIG-compliant, and includes zero/minimal CVES with VEX statements to triage any remaining ones.
* **App-specific customization**: With TAC, you can inject your own customizations such as user settings, certificates, or plugins into our SLSA 3 pipeline, so the artifacts you receive are truly promotable to production environments.
* **Software knowledge graph**: This keeps track of all your software dependencies at the individual package level. It continuously scans them for vulnerabilities, and organizes them into a searchable graph database so you can see in real-time which versions of which apps are affected and patched. It also includes useful information such as open source licenses, package management ecosystem data, and more.
* **UI and API**: TAC includes access to a user interface where you can add and remove applications from your catalog, and interact with the software knowledge graph to see at-a-glance details about your software. The [TAC API](https://developer.broadcom.com/xapis/application-catalog/latest/) enables you to build information from the software knowledge graph into your pipelines to ensure you are keeping your applications up-to-date with the latest patched applications.

### Continuing our long tradition of partnerships

Since Bitnami’s beginning over a decade ago, our many partnerships have propelled us to be a leading publisher of open source software. Bitnami cloud images drive billions of compute hours annually for our hyperscale cloud partners, for example, and our containers and Helm charts are pulled hundreds of millions of times per month from our partners at Docker Hub.

We now begin our newest endeavor with [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=charts). Arrow is a global leader in IT distribution. Arrow is known for its ability to help businesses navigate the complexities of modern IT landscapes, providing the tools, technology, and expertise needed to drive digital transformation and operational efficiency.

Arrow will sell Bitnami Premium access through its website. Bitnami users interested in purchasing Bitnami Premium will find a streamlined process to pay, share their Docker Hub user identification, and gain access to the private Bitnami Premium repos in Docker Hub. Bitnami Premium customers can add and remove users through Arrow's support team, as well as submit tickets for enterprise support jointly delivered by the software packaging experts at Arrow and Bitnami.

### What changes are coming for the free Bitnami library?

#### Pull limits for free Bitnami content

Beginning December 16th, 2024, the Bitnami Application Catalog will use [standard Docker Hub pull rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) for Bitnami apps. Enterprise customers will be able to access the full Bitnami library in Bitnami Premium, purchased through Arrow and consumed right in Docker Hub, with no rate limits or restrictions. Note that we are not changing any licenses for our packages, meaning that projects can continue to bundle our Helm charts and containers in their own application packages.

#### Long Term Support version updates

Many open source projects we publish packages for have multiple LTS versions supported by their communities. Currently, Bitnami maintains all of these LTS versions up-to-date. Starting December 10th, 2024, we will only continue updating the latest version available for apps in the free Bitnami Application Catalog. This will enable OSS projects and individual/small businesses to continue using the latest versions of Bitnami applications. Bitnami Premium customers who need to continue pulling up-to-date versions of LTS branches can access them in the Bitnami Premium repo in Docker Hub.

#### Supply chain integrity check in Bitnami Helm charts

Bitnami has invested hundreds of thousands of developer hours in constructing a world-leading pipeline to build, monitor, update, and test open source software in multiple Kubernetes environments. For these Helm charts to perform as intended, and for them to leverage the many security features built-in, they need to deploy the Bitnami containers they were designed to work with. Therefore, we are adding new checks in the deployment process to check that the containers they were designed to deploy are the ones being deployed.

### Keep an eye out for more updates

We are excited to deliver an enhanced experience for [Bitnami Premium](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=charts) users, but this is just the beginning. We will continue to build on the value that all of our Bitnami community members, both free and paid, realize through our many years of experience publishing high-quality open source software packages for the world’s developers.

Keep abreast of our blog for new updates and features, and be sure to check to follow us on [X (formerly Twitter)](https://x.com/bitnami) and [LinkedIn](https://www.linkedin.com/company/bitnami/).

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
