# keycloak-config-cli

keycloak-config-cli is a Keycloak utility to ensure the desired configuration state for a realm based on a JSON/YAML file. The format of the JSON/YAML file based on the export realm format. Store and handle the configuration files inside git just like normal code. A Keycloak restart isn't required to apply the configuration.

## Config files

The config files are based on the keycloak export files. You can use them to re-import your settings.
But keep your files as small as possible. Remove all UUIDs and all stuff which is default set by keycloak.

[moped.json](https://github.com/adorsys/keycloak-config-cli/blob/master/contrib/example-config/moped.json) is a full working example file you can consider.
Other examples are located in the [test resources](https://github.com/adorsys/keycloak-config-cli/tree/master/src/test/resources/import-files).

### Variable Substitution

keycloak-config-cli supports variable substitution of config files. This could be enabled by `import.var-substitution=true` (disabled by default).
Use variables like `${sys:name-of-system-property}` or `${env:NAME_OF_ENVIRONMENT}` to replace the values with java system properties or environment variables.

The variable substitution is running before the json parser gets executed. This allows json structures or complex values.

See: [Apache Common StringSubstitutor](https://commons.apache.org/proper/commons-text/apidocs/org/apache/commons/text/StringSubstitutor.html) for more information and advanced usage.

## Compatibility matrix

| keycloak-config-cli | **Keycloak 4 - 7** | **Keycloak 8** | **Keycloak 9 - 11** | **Keycloak 12** |
| ------------------- | :----------------: | :------------: | :-----------------: | :-------------: |
| **v0.8.x**          |         ✓          |       ✗        |          ✗          |        ✗        |
| **v1.0.x - v2.6.x** |         ✗          |       ✓        |          ✓          |        ✗        |
| **v3.0.x - v3.0.x** |         ✗          |       ✗        |          ✓          |        ✓        |
| **master**          |         ✗          |       ✗        |          ✓          |        ✓        |

- `✓` Supported
- `✗` Not supported

### Helm

Since it make no sense to deploy keycloak-config-cli as standalone application, you could
add it as dependency to your chart deployment.

Checkout helm docs about [chart dependencies](https://helm.sh/docs/topics/charts/#chart-dependencies)!

#### CLI option / Environment Variables

| CLI Option                            | ENV Variable                       | Description                                                                       | Default     | Docs                          |
| ------------------------------------- | ---------------------------------- | --------------------------------------------------------------------------------- | ----------- | ----------------------------- |
| --keycloak.url                        | KEYCLOAK_URL                       | Keycloak URL including web context. Format: `scheme://hostname:port/web-context`. | -           |                               |
| --keycloak.user                       | KEYCLOAK_USER                      | login user name                                                                   | `admin`     |                               |
| --keycloak.password                   | KEYCLOAK_PASSWORD                  | login user name                                                                   | -           |                               |
| --keycloak.client-id                  | KEYCLOAK_CLIENTID                  | login clientId                                                                    | `admin-cli` |                               |
| --keycloak.login-realm                | KEYCLOAK_LOGINREALM                | login realm                                                                       | `master`    |                               |
| --keycloak.ssl-verify                 | KEYCLOAK_SSLVERIFY                 | Verify ssl connection to keycloak                                                 | `true`      |                               |
| --keycloak.http-proxy                 | KEYCLOAK_HTTPPROXY                 | Connect to Keycloak via HTTP Proxy. Format: `scheme://hostname:port`              | -           |                               |
| --keycloak.availability-check.enabled | KEYCLOAK_AVAILABILITYCHECK_ENABLED | Wait until Keycloak is available                                                  | `false`     |                               |
| --keycloak.availability-check.timeout | KEYCLOAK_AVAILABILITYCHECK_TIMEOUT | Wait timeout for keycloak availability check                                      | `120s`      |                               |
| --import.path                         | IMPORT_PATH                        | Location of config files (if location is a directory, all files will be imported) | `/config`   |                               |
| --import.var-substitution             | IMPORT_VARSUBSTITUTION             | Enable variable substitution config files                                         | `false`     |                               |
| --import.force                        | IMPORT_FORCE                       | Enable force import of realm config                                               | `false`     |                               |
| --import.cache-key                    | IMPORT_CACHEKEY                    | Cache key for importing config.                                                   | `default`   |                               |
| --import.state                        | IMPORT_STATE                       | Enable state management. Purge only resources managed by kecloak-config-cli. S.   | `true`      | [MANAGED.md](docs/MANAGED.md) |
| --import.state-encryption-key         | IMPORT_STATEENCRYPTIONKEY          | Enables state in encrypted format. If unset, state will be stored in plain        | -           |                               |
| --import.file-type                    | IMPORT_FILETYPE                    | Format of the configuration import file. Allowed values: AUTO,JSON,YAML           | `auto`      |                               |
| --import.parallel                     | IMPORT_PARALLEL                    | Enable parallel import of certain resources                                       | `false`     |                               |

