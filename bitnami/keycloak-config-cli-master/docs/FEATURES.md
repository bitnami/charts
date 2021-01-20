# Supported features

| Feature                                            | Since | Description                                                                                              |
| -------------------------------------------------- | ----- | -------------------------------------------------------------------------------------------------------- |
| Create clients                                     | 1.0.0 | Create client configuration (inclusive protocolMappers) while creating or updating realms                |
| Update clients                                     | 1.0.0 | Update client configuration (inclusive protocolMappers) while updating realms                            |
| Manage fine-grained authorization of clients       | 2.2.0 | Add and remove fine-grained authorization resources and policies of clients                              |
| Add roles                                          | 1.0.0 | Add roles while creating or updating realms                                                              |
| Update roles                                       | 1.0.0 | Update role properties while updating realms                                                             |
| Add composites to roles                            | 1.3.0 | Add role with realm-level and client-level composite roles while creating or updating realms             |
| Add composites to roles                            | 1.3.0 | Add realm-level and client-level composite roles to existing role while creating or updating realms      |
| Remove composites from roles                       | 1.3.0 | Remove realm-level and client-level composite roles from existing role while creating or updating realms |
| Add users                                          | 1.0.0 | Add users (inclusive password!) while creating or updating realms                                        |
| Add users with roles                               | 1.0.0 | Add users with realm-level and client-level roles while creating or updating realms                      |
| Update users                                       | 1.0.0 | Update user properties (inclusive password!) while updating realms                                       |
| Add role to user                                   | 1.0.0 | Add realm-level and client-level roles to user while updating realm                                      |
| Remove role from user                              | 1.0.0 | Remove realm-level or client-level roles from user while updating realm                                  |
| Add groups to user                                 | 2.0.0 | Add groups to user while updating realm                                                                  |
| Remove groups from user                            | 2.0.0 | Remove groups from user while updating realm                                                             |
| Add authentication flows and executions            | 1.0.0 | Add authentication flows and executions while creating or updating realms                                |
| Update authentication flows and executions         | 1.0.0 | Update authentication flow properties and executions while updating realms                               |
| Remove authentication flows and executions         | 2.0.0 | Remove existing authentication flow properties and executions while updating realms                      |
| Update builtin authentication flows and executions | 2.0.0 | Update builtin authentication flow properties and executions while updating realms                       |
| Add authentication configs                         | 1.0.0 | Add authentication configs while creating or updating realms                                             |
| Update authentication configs                      | 2.0.0 | Update authentication configs while updating realms                                                      |
| Remove authentication configs                      | 2.0.0 | Remove existing authentication configs while updating realms                                             |
| Add components                                     | 1.0.0 | Add components while creating or updating realms                                                         |
| Update components                                  | 1.0.0 | Update components properties while updating realms                                                       |
| Remove components                                  | 2.0.0 | Remove existing sub-components while creating or updating realms                                         |
| Update sub-components                              | 1.0.0 | Add sub-components properties while creating or updating realms                                          |
| Remove sub-components                              | 2.0.0 | Remove existing sub-components while creating or updating realms                                         |
| Add groups                                         | 1.3.0 | Add groups (inclusive subgroups!) to realm while creating or updating realms                             |
| Update groups                                      | 1.3.0 | Update existing group properties and attributes while creating or updating realms                        |
| Remove groups                                      | 1.3.0 | Remove existing groups while updating realms                                                             |
| Add/Remove group attributes                        | 1.3.0 | Add or remove group attributes in existing groups while updating realms                                  |
| Add/Remove group roles                             | 1.3.0 | Add or remove roles to/from existing groups while updating realms                                        |
| Update/Remove subgroups                            | 1.3.0 | Like groups, subgroups may also be added/updated and removed while updating realms                       |
| Add scope-mappings                                 | 1.0.0 | Add scope-mappings while creating or updating realms                                                     |
| Add roles to scope-mappings                        | 1.0.0 | Add roles to existing scope-mappings while updating realms                                               |
| Remove roles from scope-mappings                   | 1.0.0 | Remove roles from existing scope-mappings while updating realms                                          |
| Add required-actions                               | 1.0.0 | Add required-actions while creating or updating realms                                                   |
| Update required-actions                            | 1.0.0 | Update properties of existing required-actions while updating realms                                     |
| Remove required-actions                            | 2.0.0 | Remove existing required-actions while updating realms                                                   |
| Add identity providers                             | 1.2.0 | Add identity providers while creating or updating realms                                                 |
| Update identity providers                          | 1.2.0 | Update identity providers while updating realms (improved with 2.0.0)                                    |
| Remove identity providers                          | 2.0.0 | Remove identity providers while updating realms                                                          |
| Add identity provider mappers                      | 2.0.0 | Add identityProviderMappers while updating realms                                                        |
| Update identity provider mappers                   | 2.0.0 | Update identityProviderMappers while updating realms                                                     |
| Remove identity provider mappers                   | 2.0.0 | Remove identityProviderMappers while updating realms                                                     |
| Add clientScopes                                   | 2.0.0 | Add clientScopes (inclusive protocolMappers) while creating or updating realms                           |
| Update clientScopes                                | 2.0.0 | Update existing (inclusive protocolMappers) clientScopes while creating or updating realms               |
| Remove clientScopes                                | 2.0.0 | Remove existing clientScopes while creating or updating realms                                           |
| Add clientScopeMappings                            | 2.5.0 | Add clientScopeMapping while creating or updating realms                                                 |
| Update clientScopeMappings                         | 2.5.0 | Update existing clientScopeMappings while creating or updating realms                                    |
| Remove clientScopeMappings                         | 2.5.0 | Remove existing clientScopeMappings while creating or updating realms                                    |

# Specificities

# Client - authenticationFlowBindingOverrides

`authenticationFlowBindingOverrides` on client is configured by Keycloak like this,

```json
{
    "authenticationFlowBindingOverrides": {
        "browser": "ad7d518c-4129-483a-8351-e1223cb8eead"
    }
}
```

In order to be able to configure this in `keycloak-config-cli`, we use authentication flow alias instead of `id` (which is not known)

`keycloak-config-cli` will automatically resolve the alias reference to its ids.

So if you need this, you have to configure it like :

```json
{
    "authenticationFlowBindingOverrides": {
        "browser": "my awesome browser flow"
    }
}
```

