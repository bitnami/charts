# Testing information

At Bitnami, we are committed to ensure the quality of the assets we deliver, and as such, tests play a fundamental role in the `bitnami/charts` repository. Bear in mind that every contribution to our charts is ultimately published to our Helm index, where it is made available for the rest of the community to benefit from. Before this happens, different checks are required to succeed. More precisely, tests are run when:

1. A new contribution (regardless of its author) is made through a GitHub Pull Request.
2. Accepted changes are merged to the `main` branch, prior to their release.

This strategy ensures that a set of changes must have succeeded twice before a new version is sent out to the public.

In this section, we will discuss:

* [Where to find the tests](#where-to-find-the-tests)
* [VMware Image Builder (VIB)](#vmware-image-builder-vib)
* [VIB pipeline files](#vib-pipeline-files)
  * [vib-verify.json vs vib-publish.json](#vib-verifyjson-vs-vib-publishjson)
* [Testing strategy](#testing-strategy)
  * [Defining the scope](#defining-the-scope)
  * [The strategy](#the-strategy)
  * [Runtime parameters](#runtime-parameters)
* [Test types and tools](#test-types-and-tools)
* [Generic acceptance criteria](#generic-acceptance-criteria)
* [Cypress](#cypress)
  * [Run Cypress locally](#run-cypress-locally)
  * [Useful Cypress information](#useful-cypress-information)
  * [Specific Cypress acceptance criteria](#specific-cypress-acceptance-criteria)
* [Ginkgo](#ginkgo)
  * [Run Ginkgo locally](#run-ginkgo-locally)
  * [Useful Ginkgo information](#useful-ginkgo-information)
  * [Specific Ginkgo acceptance criteria](#specific-ginkgo-acceptance-criteria)
* [GOSS](#goss)
  * [Run GOSS locally](#run-goss-locally)
  * [Useful GOSS information](#useful-goss-information)
  * [Specific GOSS acceptance criteria](#specific-goss-acceptance-criteria)

## Where to find the tests

All the assets have an associated folder inside [/.vib](https://github.com/bitnami/charts/tree/main/.vib) with their tests implementations (the subfolders `cypress`, `goss` and/or `ginkgo`) and files containing their test plans (`vib-verify.json` and `vib-publish.json`). More on the latter in [VIB pipeline files](#vib-pipeline-files).

## VMware Image Builder (VIB)

The service that powers the verification of the thousands of monthly tests performed in the repository is VMware Image Builder. VMware Image Builder (VIB) is a platform-agnostic, API-first modular service that allows large enterprises and independent software vendors to automate the packaging, **verification**, and publishing processes of software artifacts on any platform and cloud.

For more information about VIB, you can refer to [its official page](https://tanzu.vmware.com/image-builder).

## VIB pipeline files

The CI/CD pipelines in the repository are configured to trigger VIB when an asset needs to be verified. But as every application is different, VIB needs to be supplied with a definition of the set of actions and configurations that precisely describe the verification process to perform in each case. This is the role of the aforementioned `vib-verify.json` and `vib-publish.json` files, which every asset defines and can be found alongside its tests inside the `/.vib` folder.

Let's take a look at an example and try to understand it!

```json
{
  "phases": {
    ...
    "verify": {
      "context": {
        "resources": {
          "url": "{SHA_ARCHIVE}",
          "path": "/bitnami/jenkins"
        },
        ...
      },
      "actions": [
        {
          "action_id": "health-check",
          "params": {
            "endpoint": "lb-jenkins-http",
            "app_protocol": "HTTP"
          }
        },
        {
          "action_id": "goss",
          "params": {
            "resources": {
              "path": "/.vib"
            },
            "tests_file": "jenkins/goss/goss.yaml",
            "vars_file": "jenkins/runtime-parameters.yaml",
            "remote": {
              "pod": {
                "workload": "deploy-jenkins"
              }
            }
          }
        },
        {
          "action_id": "cypress",
          "params": {
            "resources": {
              "path": "/.vib/jenkins/cypress"
            },
            "endpoint": "lb-jenkins-http",
            "app_protocol": "HTTP",
            "env": {
              "username": "user",
              "password": "ComplicatedPassword123!4"
            }
          }
        }
      ]
    }
  }
}
```

This guide will focus in the `verify` phase section, in which there are some things to remark:

* There is a list of the actions to execute as part of the testing plan. Namely, this example includes a `health-check`, an instance of `goss` tests and another instance of `cypress` tests.

* For each of the `actions`, VIB will deploy **a brand new release** of the chart provided by `verify.context.resources.path`. Consequently, the state between actions is not shared.

* The installation of the chart can be customized via runtime parameters, which are provided using the `runtimes-parameters.yaml` file. See the [Runtime parameters](#runtime-parameters) section for further information.

* The runtime parameters are shared accross all `actions`, which guarantees that each release of the chart is based on the exact same configuration.

### vib-verify.json vs vib-publish.json

As seen in the introduction, there are two different events that will trigger the execution of the tests. These two files are associated to those two events respectively (`vib-verify.json` to the creation of a PR, meanwhile `vib-publish.json` to the merging of changes to `main`), and define what VIB should do when they are triggered.

Hence, tweaking the files allows to define different action policies depending on the event that was fired. Nevertheless, it was decided that the verification process should be identical in both cases. Therefore, the `verify` section in `vib-verify.json` and `vib-verify.json` files must coincide.

## Testing strategy

### Defining the scope

The general aim of the tests should be to verify the Chart package works as expected. As such, the focus IS NOT on the application OR the container images, which should be regarded as trustful components (i.e. they should have been respectively tested at a previous stage), but in the Chart itself and the different features it provides. It is expected though to assert the CORE functionality (or functionalities) of the application works, but checks defined in this repository should never aim to replace the official test suite.

Some examples on the suitability of tests for the `bitnami/wordpress` chart:

* ✅ Creating a blog post (represents the CORE functionality of the asset)
* ❌ Creating a comment in a post (far too specific, not useful)
* ❌ Installing a plugin through the admin panel (far too specific, not useful)
* ✅ Specifying a different UID using the `containerSecurityContext.runAsUser` in `values.yaml` and checking it (checks a feature intrinsic to the Chart)

The tests may be regarded as _deployment_ tests since their goal is to verify that the software is correctly deployed with all the inherent features. Both functional and non-functional characteristics are evaluated in these tests, focusing on the installation aspect.

### The strategy

Before writing any test scenario, understand the primary purpose of the chart and its components. Take a look at [the documentation about the chart under test](https://github.com/bitnami/charts/tree/main/bitnami), explore the different templates and configurations in `values.yaml` and glance over the [docker image documentation](https://github.com/bitnami/containers). This will give you a solid base for creating valuable test scenarios.

As Charts are usually composed of a number of different components, it is also essential to test their integrations and the Chart as a whole. As a general guideline, testing a `bitnami/chart` can be reduced to:

1. Identifying the components of the Chart and verifying their integration. _e.g. WordPress + MariaDB + PHP + Data Volume_
2. Summarizing the main area features the asset offers and asserting the Chart delivers them. _e.g. Creating a post in a blog_
3. Focusing on the unique features the Chart offers. _e.g. ConfigMaps, PVCs, Services, secrets, etc._

It is easily noticeable though that Charts are usually highly configurable artifacts. Through parameters exposed in `values.yaml`, it is fairly common to perform customizations that range from enabling simple features (e.g. exporting metrics to Prometheus) to complete changes in the architecture of the application that will be deployed (e.g. standalone vs. main-secondary replication in DBs). In order to cope with this high variability, we should:

* Stick to the KISS (Keep It Short and Simple) principle: only test/consider the features that are enabled by default.
* When params allow to customize the deployment architecture, give preference to: (1) the more representative blueprint and (2) the one that provides more code-covering.
* Change the values for parameters of features enabled by default. This allows to ensure they are correctly picked up by the Chart.

#### Runtime parameters

Helm allows to customize how a Chart is deployed [during its installation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). The subset of parameters from `values.yaml` (and their values) that are passed in during a Helm Chart installation are referred to as runtime/installation/deployment parameters in this guide. They are of **uttermost** importance as they have a great impact on the instance under test.

When designing a new test suite for an asset, the runtime parameters used for its installation should be inferred. This is not a straightforward task, as only the relevant parameters should be included. In order to determine which parameters from `values.yaml` should form part of the runtime parameters, use the following idea:

> Does the parameter have a direct influence over any of the tests?

This guarantees that the information in `runtime-parameters.yaml` is kept to the essential and prevents lengthy, unrelated params. Let's use a real example for a better undertanding:

```bash
$ cat .vib/moodle/runtime-parameters.yaml
moodleUsername: test_user
moodlePassword: ComplicatedPassword123!4
service:
  type: LoadBalancer
  ports:
    http: 80
    https: 444
mariadb:
  auth:
    database: test_moodle_database
    username: test_moodle_user
podSecurityContext:
  enabled: true
  fsGroup: 1002
containerSecurityContext:
  enabled: true
  runAsUser: 1002
containerPorts:
  http: 8081
  https: 8444
```

> ℹ️ We used to inject the parameters directly into the VIB pipelines under `phases.verify.context.runtime_parameters` and encoded them as a base64 string. This approach was deprecated in favor of using a separate `.yaml` file under `.vib/ASSET/runtime-parameters.yaml`.

1. Why was `moodleUsername` included?

    The default vale for `moodleUsername` is `user` (you can check in [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/moodle/values.yaml)). Following the strategy, the default value was changed to see if the Chart is able to correctly pick it up. This is later checked [in one the tests](https://github.com/bitnami/charts/blob/30f2069e0b8ce5331987d06dc744b6d1bc1f04ec/.vib/moodle/cypress/cypress/support/commands.js#L19).

2. Why were other properties, like `moodleEmail`, NOT included?

    Although the same reasoning would apply, there are no implicit checks in any of the tests that actively assert the email was changed.

3. Does that mean that every property in `runtime-parameters.yaml` should have an associated test?

    No, there is no need to have an specific test for each property, but the property **should have influence over the tests** to include it in the installation parameters. For instance, the property `service.type=LoadBalancer` does not have an associated test, but it is crucial for [Cypress](#cypress) to succeed.

    Put it this way: if the property had another value, the verification process would fail.

## Test types and tools

Although VIB pipeline files include static testing for the generated code, it does not need specific test implementations per se. Thus, this guide focuses on dynamic testing, which happens during the verification phase and represents the bulk of test implementation files in this repository.

Below is a list of the different tests types and the associated tools that may be used:

* Functional tests: [Cypress](#cypress)
* Integration tests: [Goss](#goss) & [Ginkgo](#ginkgo)

## Generic acceptance criteria

In order for your test code PR to be accepted the following criteria must be fulfilled:

* [ ] Key features of the asset need to be covered
* [ ] Tests need to contain assertions
* [ ] Tests need to be stateless
* [ ] Tests need to be independent
* [ ] Tests need to be retry-able
* [ ] Tests need to be executable in any order
* [ ] Test scope needs to be focused on **installation** of the asset and not testing the asset
* [ ] Test code needs to be peer-reviewed
* [ ] Tests need to be as minimalistic as possible
* [ ] Tests should run properly for future versions without major changes
* [ ] Avoid hardcoded values
* [ ] Include only necessary files
* [ ] Test code needs to be [maintainable](https://testautomationpatterns.org/wiki/index.php/MAINTAINABLE_TESTWARE)
* [ ] Test names should be descriptive
* [ ] Test data should be generated dynamically

Depending on the tool used, additional acceptance criteria may apply. Please, refer to the corresponding section for further info.

## Cypress

[Cypress](https://docs.cypress.io/guides/overview/why-cypress) is the framework used to implement functional tests. Related files should be located under `/.vib/ASSET/cypress`.

In order for VIB to execute Cypress tests, the following block of code needs to be defined in the corresponding [VIB pipeline files](#vib-pipeline-files) (`/.vib/ASSET/vib-{verify,publish}.json`).

> Values denoted withing dollar signs (`$$VALUE$$`) should be treated as placeholders

```json
        {
          "action_id": "cypress",
          "params": {
            "resources": {
              "path": "/.vib/$$ASSET$$/cypress"
            },
            "endpoint": "lb-$$LB_SERVICE_NAME$$-$$LB_SERVICE_PORT_NAME$$", // ex: lb-jenkins-http
            "app_protocol": "HTTP", // or HTTPS
            "env": {
              "$$ENV_1$$": "$$VALUE_1$$",
              ...
            }
          }
        }
```

> ℹ️❗️ Cypress tests needs the UI to be accessible from outside the K8s testing cluster. This means (in most cases) that the service of the chart which exposes such UI should be set to use a `LoadBalancer` type and port `80` or `443`.

### Run Cypress locally

Sometimes it is of interest to run the tests locally, for example during development. Though there may be different approaches, you may follow the steps below to execute the tests locally:

1. Deploy the target Chart in your cluster, using the same installation parameters specified in the `vib-verify.json` pipeline file

    ```bash
    $ helm install nginx bitnami/nginx -f .vib/nginx/runtime-parameters.yaml
    ```

2. Download and install [Cypress](https://www.cypress.io/). The version currently used is `9.5.4`
3. Obtain the IP and port of the Service exposing the UI of the application and adapt `cypress.json` to these values

    ```bash
    $ kubectl get svc
    NAME         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                      AGE
    kubernetes   ClusterIP      10.99.32.1    <none>          443/TCP                      3m32s
    nginx        LoadBalancer   10.99.41.53   1.1.1.1   80:31102/TCP,444:30230/TCP   65s

    $ cd .vib/nginx/cypress
    $ cat cypress.json
    {
      "baseUrl": "http://localhost"
    }
    # Edit the file to point to 1.1.1.1:80
    $ nano cypress.json
    $ cat cypress.json
    {
      "baseUrl": "http://1.1.1.1:80"
    }
    ```

    > NOTE: There are assets that require to have a host configured instead of a plain IP address to properly work. In this cases, you may find a `hosts` entry in the `cypress.json` file instead of the `baseUrl`. Proceed as follows:

    ```bash
    $ cd .vib/prestashop/cypress
    $ cat cypress.json
    {
      ...
      "hosts": {
        "vmware-prestashop.my": "{{ TARGET_IP }}"
      },
      ...
    }
    # Replace the {{ TARGET_IP }} placeholder by the IP and port of the Service
    $ nano cypress.json
    $ cat cypress.json
    {
      ...
      "hosts": {
        "vmware-prestashop.my": "1.1.1.1:80"
      },
      ...
    }
    ```

4. Launch Cypress indicating the folder where tests are located

    ```bash
    $ cypress run .

    =====================================================================================

      (Run Starting)

      ┌─────────────────────────────────────────────────────────────────────────────────┐
      │ Cypress:        9.5.4                                                           │
      │ Browser:        Electron 94 (headless)                                          │
      │ Node Version:   v16.13.2 (/usr/local/bin/node)                                  │
      │ Specs:          1 found (nginx_spec.js)                                         │
      └─────────────────────────────────────────────────────────────────────────────────┘
    ...
    ✔  All specs passed!                        371ms        1        1
    ```

### Useful Cypress information

* In most cases, a single test which covers the following topics is enough:
  * Login/Logout: Checks the UI, app, and DB are working together
  * Basic functionality test

* Avoid multiple tests for the same block of functionality.

* If the asset exposes an API, Cypress is an excellent option to test this feature!

### Specific Cypress acceptance criteria

* [ ] Test file name has the following format: Helm chart name + spec (ex: `wordpress_spec.js`)
* [ ] No `describe()` blocks should be present
* [ ] Aim to have an assertion after every command to avoid flakiness, taking advantage of Cypress retry-ability
* [ ] Test description is a sentence with the following format: Expected result summary, starting with a verb, in third person, no dots at the end of the sentence (ex: `it('checks if admin can edit a site', ()`)
* [ ] Respect the folder structure recommended by Cypress:
  * [fixtures](https://docs.cypress.io/guides/core-concepts/writing-and-organizing-tests#Fixture-Files) - for test data
  * integration - test scenario
  * [plugins](https://docs.cypress.io/guides/tooling/plugins-guide) - plugin configuration, if applicable
  * support - reusable behaviours and overrides
  * [cypress.json](https://docs.cypress.io/guides/references/legacy-configuration#cypressjson) - configuration values you wish to store
* [ ] DOM selectors should be resilient. See best practices [here](https://docs.cypress.io/guides/references/best-practices#Selecting-Elements)
* [ ] Unnecessary waiting should be avoided
* [ ] Apply the following code style:
  * Use 2 spaces for indentation
  * Semicolons should be used
  * Lines over 80 columns long should preferably be devided into sensible chunks
  * Prefer single-quotes over double ones for strings
  * Use template literals (\`The value is: ${var}\`) for string interpolation

## Ginkgo

[Ginkgo](https://onsi.github.io/ginkgo/#top) is one of the frameworks used to implement integration tests. Related files should be located under `/.vib/ASSET/ginkgo`. It is the reference tool to use when tests require interaction with the K8s cluster.

In order for VIB to execute Ginkgo tests, the following block of code needs to be defined in the corresponding [VIB pipeline files](#vib-pipeline-files) (`/.vib/ASSET/vib-{verify,publish}.json`).

> Values denoted withing dollar signs (`$$VALUE$$`) should be treated as placeholders

```json
        {
          "action_id": "ginkgo",
          "params": {
            "resources": {
              "path": "/.vib/$$ASSET$$/ginkgo"
            },
            "params": {
              "kubeconfig": "{{kubeconfig}}",
              "namespace": "{{namespace}}",
              "$$PARAM_3$$": "$$VALUE_3$$",
              ...
            }
          }
        }
```

### Run Ginkgo locally

Sometimes it is of interest to run the tests locally, for example during development. Though there may be different approaches, you may follow the steps below to execute the tests locally:

1. Deploy the target Chart in your cluster, using the same installation parameters specified in the `vib-verify.json` pipeline file

    ```bash
    $ helm install metallb bitnami/metallb -f .vib/metallb/runtime-parameters.yaml
    ```

2. Download and [install Ginkgo](https://onsi.github.io/ginkgo/#installing-ginkgo) in your system
3. Execute the tests. Provide the necessary params (usually, the path to the kubeconfig file and namespace name, but check `vib-verify.json`).

    ```bash
    $ cd .vib/metallb/ginkgo
    $ ginkgo -- --kubeconfig=./kube.config --namespace=default
      Running Suite: MetalLB Integration Tests - /.vib/metallb/ginkgo
      ===============================================================
      Random Seed: 1674578785
      Will run 1 of 1 specs

      Ran 1 of 1 Specs in 1.341 seconds
      SUCCESS! -- 1 Passed | 0 Failed | 0 Pending | 0 Skipped
      PASS

      Ginkgo ran 1 suite in 6.895174927s
      Test Suite Passed
    ```

### Useful Ginkgo information

Ginkgo provides extreme flexibility when it comes to tests. Nonetheless, here are the most frequent use cases we have used it for so far:

* Checking logs produced by a scratch or a k8s-native pod
* Deploying, managing and interacting with K8s resources: CRDs, Ingresses, Secrets... Really useful for **K8s operators**
* Directly interacting (instead of managing) resources deployed at installation time using the `extraDeploy` param, available in bitnami charts

### Specific Ginkgo acceptance criteria

* [ ] Test file name has the following format: Helm chart name + `test` (ex: `metallb_test.go`)
* [ ] Helper functions should be placed in an additional file named `integration_suite_test.go`
* [ ] Created cluster resources must be cleaned up after execution

## GOSS

[GOSS](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md) is one of the frameworks used to implement integration tests. Related files should be located under `/.vib/ASSET/goss`. It is the reference tool to use when tests require interaction with a specific pod. Unlike Cypress or Ginkgo, GOSS tests are executed from within the pod.

In order for VIB to execute GOSS tests, the following block of code needs to be defined in the corresponding [VIB pipeline files](#vib-pipeline-files) (`/.vib/ASSET/vib-{verify,publish}.json`).

> Values denoted withing dollar signs (`$$VALUE$$`) should be treated as placeholders

```json
        {
          "action_id": "goss",
          "params": {
            "resources": {
              "path": "/.vib"
            },
            "tests_file": "$$ASSET$$/goss/goss.yaml",
            "vars_file": "$$ASSET$$/runtime-parameters.yaml",
            "remote": {
              "pod": {
                "workload": "deploy-$$DEPLOYMENT_NAME$$" // Use "ds-" or "sts-" for DaemonSet and StatefulSet controllers.
              }
            }
          }
        }
```

> ℹ️ Goss will use the `runtime-parameters.yaml` file containing the chart's deployment parameters as its vars file.

### Run GOSS locally

Sometimes it is of interest to run the tests locally, for example during development. Though there may be different approaches, you may follow the steps below to execute the tests locally:

1. Deploy the target Chart in your cluster, using the same installation parameters specified in the `vib-verify.json` pipeline file

    ```bash
    $ helm install nginx bitnami/nginx -f .vib/nginx/runtime-parameters.yaml
    ```

2. Download the [GOSS binary for Linux AMD64](https://github.com/goss-org/goss/releases/)
3. Copy the binary and test files to the target pod where it should be executed

    ```bash
    $ kubectl get pods
    NAME                    READY   STATUS    RESTARTS   AGE
    nginx-5fbc8786f-95rpl   1/1     Running   0          17m

    $ kubectl cp ./goss-linux-amd64 nginx-5fbc8786f-95rpl:/tmp/
    $ kubectl cp .vib/nginx/goss/goss.yaml nginx-5fbc8786f-95rpl:/tmp/
    $ kubectl cp .vib/nginx/runtime-parameters.yaml nginx-5fbc8786f-95rpl:/tmp/
    ```

4. Grant execution permissions to the binary and launch the tests

    ```bash
    $ kubectl exec -it nginx-5fbc8786f-95rpl -- chmod +x /tmp/goss-linux-amd64
    $ kubectl exec -it nginx-5fbc8786f-95rpl -- /tmp/goss-linux-amd64 --gossfile /tmp/goss.yaml --vars /tmp/runtime-parameters.yaml validate
    .........

    Total Duration: 0.011s
    Count: 8, Failed: 0, Skipped: 0
    ```

### Useful GOSS information

As our Charts implement some standardized properties, there are a number of test cases that have been found recurrently throughout the catalog:

* Correct user ID and Group of the running container
* Reachability of the different ports exposed through services
* Existence of mounted volumes
* Correct configuration was applied to a config file or enviroment variable
* Existence of a created Service Account
* Restricted capabilities are applied to a running container
* Valuable CLI checks (when available)

[Kong](https://github.com/bitnami/charts/blob/main/.vib/kong/goss/goss.yaml) or [MetalLB](https://github.com/bitnami/charts/blob/main/.vib/metallb/goss/goss.yaml) are two good examples of tests implementing some of the above.

### Specific GOSS acceptance criteria

* [ ] Main test file name should be `goss.yaml`
* [ ] Tests should not rely on system packages (e.g. `curl`). Favor built-in GOSS primitives instead
* [ ] Prefer checking the exit status of a command rather than looking for a specific output. This will avoid most of the potential flakiness
* [ ] Use templating to parametrize tests with the help of the `runtime-parameters.yaml` file. This `.yaml` can only contain chart's defined parameters and Goss tests should conform to its structure, not the other way around.
