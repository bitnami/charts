# Test Strategy

The overall test strategy can be described as _minimalistic_, rather than extensive. The goal of the tests is to verify that the application is deployed properly, so we will verify the main application features.

Decide the testing scope carefully, keeping in mind the maintainability of the tests and the value they provide.
The tests described here are _deployment_ tests since their goal is to verify that the software is correctly deployed with all the inherent features. Both functional and non-functional characteristics are evaluated in these tests, focusing on the installation aspect.

* The core asset features work properly when deployed
* There are no regression bugs

Before writing any test scenario, understand the primary purpose of the chart. Take a look at [the documentation about the chart under test](https://github.com/bitnami/charts/tree/master/bitnami) as well as the [docker image documentation](https://github.com/bitnami?q=docker&type=all&language=&sort=). This will give you a solid base for creating valuable test scenarios.

## Common test cases

* Login/Logout
* Important files and folders are present in the docker image
* CRUD
* File upload
* SMTP (if applicable)
* Establish a connection
* Plugins (if applicable)

## HOW-TO:

### Tools

The current test system supports a set of tools that are listed below. Test execution is done on temporary environments which are deployed and destroyed on the fly. In order to trigger the test execution in these test environments, internal approval is needed. Keeping in mind the acceptance criteria as well as the best practices for test automation using the supported tool will help you get your PR approved.

#### Test types

* Functional tests
* Integration tests

#### Dynamic testing

This part is of the most interest for the contributor. This is where the test design, test execution and test maintenance efforts will be focused.

If your asset has a user interface, you will **need** to include the following tests:

* [Cypress](https://docs.cypress.io/guides/overview/why-cypress) (functional tests)
* [Goss](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md) (integration tests)

#### Static analysis

Static analysis is included for all assets as a part of the pipeline. Since this analysis is generic, it is defined internally and added as an action to the existing the pipeline. There is no need for additional work on the contributor side related to this. The following types of static analysis are supported:

* [Helm lint](https://helm.sh/docs/helm/helm_lint/)

***NOTE***: Cypress and Goss tests need to be tailored per application under test.

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
- [ ] Test scope needs to be focused on **installation** of the asset and not testing the asset
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
- [ ] Test names should be descriptive
- [ ] Test data should be generated dynamically

### Cypress

- [ ] Test file name has the following format: Helm chart name + spec (ex: `wordpress_spec.js`)
- [ ] No `describe()` blocks for Cypress test
- [ ] Aim to have an assertion after every command to avoid flakiness, taking advantage of Cypress retry-ability
- [ ] Test description is a sentence with the following format: Expected result summary, starting with a verb, in third person, no dots at the end of the sentence (ex: `it('checks if admin can edit a site', ()`)
- [ ] Respect the folder structure recommended by Cypress:
  * [fixtures](https://docs.cypress.io/api/commands/fixture) - for test data
  * [Integration](https://docs.cypress.io/api/commands/fixture) - test scenario
  * [plugins](https://docs.cypress.io/guides/tooling/plugins-guide) - plugin configuration, if applicable
  * [support](https://docs.cypress.io/api/commands/fixture) - reusable behaviours and overrides
  * [cypress.json](https://docs.cypress.io/guides/tooling/plugins-guide) - configuration values you wish to store
