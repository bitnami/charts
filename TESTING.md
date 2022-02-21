# Test Strategy

The overall test strategy can be described as _minimalistic_, rather than extensive. The goal of the tests is to verify that the application is deployed properly, so we will verify the main application features. 

Decide the testing scope carefully, keeping in mind the maintainability of the tests and the value they provide.
The tests described here are _deployment_ tests since their goal is to verify that the software is correctly deployed with all the inherent features. Both functional and non-functional characteristics are evaluated in these tests, focusing on the installation aspect. 

* The core asset features work properly when deployed
* There are no regression bugs 

Before writing any test scenario, understand the primary purpose of the chart. Take a look at [the documentation about the chart under test](https://github.com/bitnami/charts/tree/master/bitnami) as well as the [docker image documentation](https://github.com/bitnami?q=docker&type=all&language=&sort=). This will give you a solid base for creating valuable test scenarios.

## Common test cases

* Important files and folders are present in the docker image
* CRUD
* File upload
* SMTP (if applicable)
* Establish a connection 
* Login/Logout 
* Plugins (if applicable)

## HOW-TO:

### Tools 

The current test system supports a set of tools that are listed below. Test execution is done on temporary environments which are deployed and destroyed on the fly. In order to trigger the test execution in these test environments, internal approval is needed. Keeping in mind the acceptance criteria as well as the best practices for test automation using the supported tool will help you get your PR approved. 

#### Dynamic testing

* [Cypress](https://docs.cypress.io/guides/overview/why-cypress) (functional tests)
* [Goss](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md) (infrastructure and configuration tests)

* Health check
* Resilience check

#### Static analysis

* [Trivy](https://aquasecurity.github.io/trivy/v0.17.0/)
* Helm lint

Static analysis is needed for all assets. The need for other test types will be determined based on the asset needs. If your asset has a user interface, you will **need** to include the following tests:

* Cypress
* Goss 
* Health checks

Resilience check needs to be done for all assets that have a need for high availability (eg. databases).

## Test acceptance criteria

In order for your test code PR to be accepted the following criteria must be fulfilled. 

### Generic

- [ ] Minimum of 5 test cases per test type is needed 
- [ ] Key features of the asset need to be covered 
- [ ] Tests need to contain assertions 
- [ ] Tests need to be stateless 
- [ ] Tests need to be independent 
- [ ] Tests need to be retry-able
- [ ] Tests need to be executable in any order 
- [ ] Test scope needs to be focused on <span style="text-decoration:underline;">installation</span> of the asset and not testing the asset
- [ ] Tests need to be tested. Proof of testing needs to be attached to the PR whenever feasible
- [ ] Test code needs to be peer-reviewed
- [ ] Aim to write one scenario per test type. In case there is a need to divide test code into two scenarios, the reasoning should be provided
- [ ] Tests need to be as minimalistic as possible
- [ ] Tests should run properly for future versions without major changes 
- [ ] Avoid hardcoded values
- [ ] Use smart and uniform locator strategies
- [ ] Prefer fluid waits over hardcoded waits
- [ ] Favor URL’s for navigation over UI interaction
- [ ] Include only necessary files
- [ ] Test code needs to be [maintainable](https://testautomationpatterns.org/wiki/index.php/MAINTAINABLE_TESTWARE)

### Cypress

- [ ] Test suite name has the following format: Asset under test name + test suite (ex: `Wordpress test suite`)
- [ ] No `describe()` blocks for Cypress test
- [ ] Aim to have an assertion after every command to avoid flakiness, taking advantage of Cypress retry-ability 
- [ ] Test description is a sentence with the following format: Expected result summary, starting with a verb, in third person, no dots at the end of the sentence (ex: “**disallows login to an invalid user**”)
- [ ] Respect the folder structure recommended by Cypress: 
  * [fixtures](https://jira.eng.vmware.com/browse/CONTENT-1375) folder is for test data
  * [Integration](https://jira.eng.vmware.com/browse/CONTENT-1375) folder will contain the test scenario
  * [plugins](https://docs.cypress.io/guides/tooling/plugins-guide) folder will contain plugin configuration, if applicable
  * [support](https://jira.eng.vmware.com/browse/CONTENT-1375) folder will contain reusable behaviours and overrides 
  * [cypress.json](https://docs.cypress.io/guides/tooling/plugins-guide) file will contain configuration values you wish to store