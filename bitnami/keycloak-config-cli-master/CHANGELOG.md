# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2021-01-20

### Breaking

- keycloak-config-cli does not auto append `/auth/` to the keycloak path.
- Role and Clients are `fully manged` now. See: [docs/MANAGED.md](docs/MANAGED.md). *Take care while upgrade exist keycloak instances*. This upgrade
  should be tested carefully on existing instances. If `import.state` is enabled, only roles and clients created by keycloak-config-cli will be
  deleted. Set `--import.managed.role=no-delete` and `--import.managed.client=no-delete` will restore the keycloak-config-cli v2.x behavior.

### Added

- Support for Keycloak 12.0.1

### Changed

- Set `import.managed.role` and `import.managed.client` to `full` as default
- Remove experimental native builds
- Update to Resteasy to 4.5.8.Final

### Fixed

### Removed

- Support for Keycloak 8
- Auto append `/auth/` url

## [2.6.3] - 2020-12-09

### Changed

- Update Spring Boot to 2.4.0

### Fixed

- On client import `defaultClientScopes` and `optionalClientScopes` are ignored on existing clients.
- Prevent 409 Conflict error with users if "email as username" is enabled

## [2.6.2] - 2020-11-18

### Fixed

- On client import `defaultClientScopes` and `optionalClientScopes` are ignored if referenced scope does not exist before import.

## [2.6.1] - 2020-11-17

### Fixed

- Pipeline related error inside release
  process. [GitHub Blog](https://github.blog/changelog/2020-10-01-github-actions-deprecating-set-env-and-add-path-commands/)

## [2.6.0] - 2020-11-17

### Added

- If `import.state-encryption-key` is set, the state will be stored in encrypted format.
- If 'import.var-substitution-in-variables' is set to false var substitution in variables is disabled (default: true)
- If 'import.var-substitution-undefined-throws-exceptions' is set to false unknown variables will be ignored (default: true)

### Changed

- Pre validate client with authorization settings
- Update to Keycloak 11.0.3

### Fixed

- Calculate import checksum after variable substitution
- Ignore the id from imports for builtin flows and identityProviderMappers if resource already exists
- Fix [KEYCLOAK-16082](https://issues.redhat.com/browse/KEYCLOAK-16082)
- Can't manage user membership of subgroups

## [2.5.0] - 2020-10-19

### Added

- Roles are fully managed now and could be deleted if absent from import (disabled by default)
- Clients are fully managed now and could be deleted if absent from import (disabled by default)
- client scope mapping can be managed through keycloak-config-cli

### Changed

- __DEPRECATION:__ Auto append `/auth` in server url.

### Fixed

- Required action providerId and alias can be different now
- ProviderId of required actions can be updated now

## [2.4.0] - 2020-10-05

### Added

- Builds are now reproducible.
- Provide checksums of prebuild artifacts.
- `import.var-substitution=true` to enable substitution of environment variables or system properties. (default: false)
- Multiple file formats could be detected by file ending
- HTTP Proxies now supported. Use `-Dhttp.proxyHost` and `-Dhttp.proxyHost` to specify proxy settings.

### Fixed

- On directory import, the order of files is consistent now. (default ordered)
- Allow custom sub paths of keycloak.

## [2.3.0] - 2020-09-22

### Added

- Allow loading Presentations (like RealmRepresentation) externally.
  See [docs](https://github.com/adorsys/keycloak-config-cli/blob/master/contrib/custom-representations/README.md) for more informations.
- Update flow descriptions form builtin flows

### Changed

- Update to Keycloak 11.0.2
- Update to Resteasy to 3.13.1.Final

### Fixed

- Fix update `authenticationFlowBindingOverrides` on clients [issue-170](https://github.com/adorsys/keycloak-config-cli/issues/170)
- Fix creation clientScopes with protocolMappers [issue-183](https://github.com/adorsys/keycloak-config-cli/issues/183)
- Fix could not update default clientScopes with protocolMappers [issue-183](https://github.com/adorsys/keycloak-config-cli/issues/183)

## [2.2.0] - 2020-08-07

### Added

- Add support for clients with fine-grained authorization

## [2.1.0] - 2020-07-23

### Added

- Keycloak 11 support

### Changed

- Implement checkstyle to ensure consistent coding style.

### Fixed

- Subflow requirement forced to ‘DISABLED’ when importing multiple subflows

## [2.0.2] - 2020-07-15

### Fixed

- Realm creation with an idp and custom auth flow results into a 500 HTTP error

## [2.0.1] - 2020-07-09

### Fixed

- Incorrect Docker entrypoint. Thanks to jBouyoud.

## [2.0.0] - 2020-07-05

### Breaking

- The availability check in docker images based on a shell script. The functionality moved into the application now.
- The availability check is disabled by default and can be re-enabled with `keycloak.availability-check.enabled=true`.
- `import.file` is removed. Use `import.path` instead for files and directories.
- `keycloak.migrationKey` is removed. Use `import.cache-key` instead.
- `keycloak.realm` is removed. Use `import.login-realm` to define the realm to login.
- If you have defined requiredActions, components, authentications flows or subcomponents in your realm configure, make sure you have defined all in
  your json files. All not defined actions will removed now by keycloak-config-cli unless `import.state=true` is set (default).
  See: [docs/MANAGED.md](docs/MANAGED.md)

### Added

- Create, Update, Delete IdentityProviderMappers
- Support for only updating changed IdentityProviders
- Support for managed IdentityProviders
- Manage group membership of users
- Parallel import (only some resources are supported. To enable use `--import.parallel=true`)
- Don't update client if not changed
- Don't update components config if not changed
- Don't update realm role if not changed
- Added Helm Chart
- Support yaml as configuration import format. (`--import.file-type=yaml`)
- In some situations if Keycloak gives 400 HTTP error, pass error message from keycloak to log.
- Allow updating builtin flows and executions (keycloak allows to change some properties)
- Remove authentications config from keycloak if not defined in realm
- PMD for static source code analysis
- _Experimental_ GraalVM support. Run keycloak-config-cli without Java!
- Throw errors on unknown properties in config files
- Add, update and remove clientScopes (thanks @spahrson)
- Remove required actions if they not defined in import json.
- Remove components if they not defined in import json.
- Remove subcomponents if they not defined in import json.
- Remove authentication flows if they not defined in import json.
- Control behavior of purging ressource via `import.manage.<type>` property. See: [docs/MANAGED.md](docs/MANAGED.md)
- State management for `requriedActions`, `clients`, `components`

### Changed

- Handle exit code in a spring native way.
- Improve error handling if keycloak returns a non 2xx http error
- The availability check in docker images is off by default. Re-enable with `keycloak.availability-check.enabled`.
- `WAIT_TIME_IN_SECONDS` is replaced by `keycloak.availability-check.timeout`.
- Set user to 1001 in Dockerfile
- Bump Keycloak from 8.0.1 to 8.0.2
- Define jackson version in pom.xml to avoid incompatibilities between `jackson-bom` and `keycloak-config-cli` dependencies.
- Reduce docker image size
- Bump SpringBoot from 2.2.7 to 2.3.1
- Bump keycloak from 10.0.0 to 10.0.2
- Used keycloak parent pom instead manage versions of 3rd party libs
- Add experimental profile for spring native builds
- Human friendly error messages instead stack traces if log level is not debug.
- SHA2 instead SHA3 is now used for config checksums
- Rename `keycloak.migrationKey` to `import.cache-key` instead.
- Rename `keycloak.realm` to `import.login-realm` instead.

### Fixed

- Fix import crash if last import crashed while a temporary flow was used.
- Do not delete authenticatorConfigs from builtin flows
- Don't update client if protocolMappers are not changed
- Don't update clientScope if protocolMappers are not changed
- Don't update groups config if subGroups are not changed
- Authentication configs in non top-level flow are not created.
- Updating `protocolMappers` on `clients`

### Removed

- `import.file` parameter

## [1.4.0] - 2020-04-30

### Added

- AuthenticatorConfig support (thanks @JanisPlots)
- Keycloak 10 support

### Changed

- Bump keycloak 9.0.3

### Fixed

- Fix spotbugs and sonar findings

## [1.3.1] - 2020-04-02

### Changed

- Bump Spring Boot version to 2.2.5
- Bump maven-javadoc-plugin from 3.1.1 to 3.2.0

### Fixed

- Use username filter for updating users, too.

## [1.3.0] - 2020-03-27

### Added

- Add and update groups
- Update composites in roles

### Changed

- Add copyright header to all java classes
- Bump Keycloak to 9.0.2

## [1.2.0] - 2020-03-15

### Added

- Implement migrationKey property for different config files per realm
- Implement identity providers

### Changed

- Add @SuppressWarnings("unchecked")
- Migrate to maven single module
- Use TestContainers

### Fixed

- Correct username on import

## [1.1.2] - 2020-02-25

### Changed

- Use Java 8 inside container again

## [1.1.1] - 2020-02-25

### Fixed

- Re-add Keycloak 8

## 1.1.0 - 2020-02-25

### Added

- Keycloak 9 support

### Changed

- Use Java 11 inside container
- Bump hibernate-validator from 6.0.13.Final to 6.1.0.Final

<!-- @formatter:off -->

[Unreleased]: https://github.com/adorsys/keycloak-config-cli/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.6.3...v3.0.0
[2.6.3]: https://github.com/adorsys/keycloak-config-cli/compare/v2.6.2...v2.6.3
[2.6.2]: https://github.com/adorsys/keycloak-config-cli/compare/v2.6.1...v2.6.2
[2.6.1]: https://github.com/adorsys/keycloak-config-cli/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/adorsys/keycloak-config-cli/compare/v2.0.2...v2.1.0
[2.0.2]: https://github.com/adorsys/keycloak-config-cli/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/adorsys/keycloak-config-cli/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/adorsys/keycloak-config-cli/compare/v1.4.0...v2.0.0
[1.4.0]: https://github.com/adorsys/keycloak-config-cli/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/adorsys/keycloak-config-cli/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/adorsys/keycloak-config-cli/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/adorsys/keycloak-config-cli/compare/v1.1.2...v1.2.0
[1.1.2]: https://github.com/adorsys/keycloak-config-cli/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/adorsys/keycloak-config-cli/compare/v1.1.0...v1.1.1
