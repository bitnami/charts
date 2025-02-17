{{- define "realm_json" }}
{{- $services := list -}}
{{- range .Values.global.services }}
{{- if .m2m }}
  {{- $services = append $services . }}
{{- end }}
{{- end }}
{
  "realm": "hzp",
  "notBefore": 0,
  "defaultSignatureAlgorithm": "RS256",
  "revokeRefreshToken": true,
  "refreshTokenMaxReuse": 5,
  "accessTokenLifespan": 300,
  "resetPasswordAllowed": true,
  "accessTokenLifespanForImplicitFlow": 900,
  "ssoSessionIdleTimeout": 3600,
  "ssoSessionMaxLifespan": 604800,
  "ssoSessionIdleTimeoutRememberMe": 0,
  "ssoSessionMaxLifespanRememberMe": 0,
  "accessCodeLifespan": 60,
  "accessCodeLifespanUserAction": 300,
  "accessCodeLifespanLogin": 1800,
  "enabled": true,
  "bruteForceProtected": true,
  "failureFactor": 5,
  "waitIncrementSeconds": 60,
  "maxFailureWaitSeconds": 1800,
  "quickLoginCheckMilliSeconds": 1000,
  "minimumQuickLoginWaitSeconds": 60,
  "maxDeltaTimeSeconds": 43200,
  "actionTokenGeneratedByUserLifespan": 28800,
  "passwordPolicy": "forceExpiredPasswordChange(90) and notUsername(undefined) and notEmail(undefined) and digits(1) and passwordHistory(5) and lowerCase(1) and upperCase(1) and specialChars(1) and length(8)",
  "groups": [],
  "sslRequired": "${KC_SSL_REQUIRED}",
  "requiredCredentials": [
    "password"
  ],
  "users": [
    {{- range $services}}
    {
      "username": "internal-service-account-{{ .name }}",
      "enabled": true,
      "serviceAccountClientId": "internal-{{ .name }}",
      "realmRoles": ["internal-{{ .name }}"],
      "emailVerified": false,
      "disableableCredentialTypes": [],
      "notBefore": 0,
      "requiredActions": [],
      "totp": false
    },
    {{- end }}
    {
      "username": "administrator",
      "enabled": true,
      "credentials": [
        {
          "type": "password",
          "value": "${KEYCLOAK_SECURITY_ADMIN_USR_PWD}"
        }
      ],
      {{- if $.Values.global.keycloak.settings.forceAdminUserPostFirstLoginActions }}
      "requiredActions": [
        "UPDATE_PASSWORD",
        "UPDATE_PROFILE"
      ],
      {{- end }}
      "access": {
        "manageGroupMembership": true,
        "view": true,
        "mapRoles": true,
        "impersonate": true,
        "manage": true
      },
      "attributes": {
        "initial_admin": [
          "true"
        ],
        "EMAIL_OTP_ENABLED": [
          "false"
        ],
        "exposedUser": [
          "true"
        ],
        "storage": [
          "LOCAL"
        ]
      },
      "realmRoles": [
        "hzp-security-admin",
        "Administrator"
      ]
    },
    {
      "username": "service-account-${KEYCLOAK_IAM_CLIENT_NAME}",
      "enabled": true,
      "serviceAccountClientId": "${KEYCLOAK_IAM_CLIENT_NAME}",
      "clientRoles": {
        "realm-management": ["realm-admin"]
      }
    },
    {
      "username": "service-account-${KEYCLOAK_DELCO_CLIENT_NAME}",
      "enabled": true,
      "serviceAccountClientId": "${KEYCLOAK_DELCO_CLIENT_NAME}",
      "realmRoles": ["Administrator"]
    }
  ],
  "roles": {
    "realm": [
      {{- range $services}}
      {
        "name": "internal-{{ .name }}",
        "composite": false,
        "clientRole": true,
        "containerId": "hzp",
        "attributes": {
          "roletype": [
            "m2m"
          ]
        }
      },
      {{- end }}
      {
        "name": "hzp-security-admin",
        "composite": true,
        "composites": {
          "client": {
            "realm-management": [
              "realm-admin"
            ]
          }
        },
        "clientRole": true,
        "containerId": "hzp",
        "attributes": {}
      },
      {
        "name": "Administrator",
        "composite": false,
        "clientRole": false,
        "containerId": "hzp",
        "attributes": {
          "roletype": [
            "default"
          ]
        }
      },
      {
        "name": "Application Admin",
        "composite": false,
        "clientRole": false,
        "containerId": "hzp",
        "attributes": {
          "roletype": [
            "default"
          ]
        }
      },
      {
        "name": "Operational Manager",
        "composite": false,
        "clientRole": false,
        "containerId": "hzp",
        "attributes": {
          "roletype": [
            "default"
          ]
        }
      },
      {
        "name": "Viewer",
        "composite": false,
        "clientRole": false,
        "containerId": "hzp",
        "attributes": {
          "roletype": [
            "default"
          ]
        }
      }
    ]
  },
  "clients": [
    {{- range $services}}
    {
      "clientId": "internal-{{ .name }}",
      "name": "internal-{{ .name }}",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-valid-x509",
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": false,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": true,
      "serviceAccountsEnabled": true,
      "publicClient": false,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "redirectUris": [],
      "webOrigins": [],
      "authenticationFlowBindingOverrides": {},
      "nodeReRegistrationTimeout": -1,
      "optionalClientScopes": [],
      "defaultClientScopes": [
       "basic",
        "roles",
        "profile"
      ],
      "fullScopeAllowed": true
    },
    {{- end }}
    {
      "clientId": "hzp-client",
      "name": "hzp-client",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-secret",
      "redirectUris": [
        "*"
      ],
      "webOrigins": [
        "+"
      ],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": true,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": false,
      "serviceAccountsEnabled": false,
      "publicClient": true,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "defaultClientScopes": [
       "basic",
        "roles"
      ],
      "fullScopeAllowed": true
    },
    {
      "clientId": "hzp-auth-client",
      "name": "hzp-auth-client",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-secret",
      "secret": "${KEYCLOAK_AUTH_CLIENT_PWD}",
      "redirectUris": [
        "/api/v2/auth/callback"
      ],
      "webOrigins": [
        "+"
      ],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": true,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": true,
      "serviceAccountsEnabled": false,
      "publicClient": false,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "rootUrl": "",
      "authenticationFlowBindingOverrides": {},
      "nodeReRegistrationTimeout": -1,
      "optionalClientScopes": [],
      "protocolMappers": [
        {
          "name": "MiddleNameUserAttribueMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-attribute-mapper",
          "consentRequired": false,
          "config": {
            "user.attribute": "middleName",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "middleName",
            "userinfo.token.claim": "false",
            "jsonType.label": "String"
          }
        },
        {
          "name": "EnableMFAUserAttributeMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-attribute-mapper",
          "consentRequired": false,
          "config": {
            "userinfo.token.claim": "false",
            "user.attribute": "enableMfa",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "enableMfa",
            "jsonType.label": "boolean"
          }
        },
        {
          "name": "CellPhoneUserAttributeMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-attribute-mapper",
          "consentRequired": false,
          "config": {
            "userinfo.token.claim": "false",
            "user.attribute": "cellPhone",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "cellPhone",
            "jsonType.label": "String"
          }
        },
        {
          "name": "UserEnabledPropertyMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-property-mapper",
          "consentRequired": false,
          "config": {
            "userinfo.token.claim": "false",
            "user.attribute": "enabled",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "enabled",
            "jsonType.label": "boolean"
          }
        },
        {
          "name": "UserDisabledManuallyPropertyMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-property-mapper",
          "consentRequired": false,
          "config": {
            "userinfo.token.claim": "false",
            "user.attribute": "disabled_manually",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "disabled_manually",
            "jsonType.label": "boolean"
          }
        },
        {
          "name": "StorageUserAttributeMapper",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-attribute-mapper",
          "consentRequired": false,
          "config": {
            "userinfo.token.claim": "false",
            "user.attribute": "storage",
            "id.token.claim": "false",
            "access.token.claim": "true",
            "claim.name": "storage",
            "jsonType.label": "String"
          }
        }
      ],
      "defaultClientScopes": [
        "basic",
        "roles",
        "profile",
        "email"
      ],
      "fullScopeAllowed": true
    },
    {
      "clientId": "${KEYCLOAK_IAM_CLIENT_NAME}",
      "name": "${KEYCLOAK_IAM_CLIENT_NAME}",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-secret",
      "secret": "${KEYCLOAK_IAM_CLIENT_PWD}",
      "redirectUris": [
        "*"
      ],
      "webOrigins": [
        "+"
      ],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": false,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": true,
      "serviceAccountsEnabled": true,
      "publicClient": false,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "defaultClientScopes": [
        "basic",
        "roles",
        "profile",
        "email"
      ],
      "fullScopeAllowed": true
    },
    {
      "clientId": "${KEYCLOAK_DELCO_CLIENT_NAME}",
      "name": "${KEYCLOAK_DELCO_CLIENT_NAME}",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-secret",
      "secret": "${KEYCLOAK_DELCO_CLIENT_PWD}",
      "redirectUris": [
        "/api/v2/auth/callback"
      ],
      "webOrigins": [
        "+"
      ],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": true,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": true,
      "serviceAccountsEnabled": true,
      "publicClient": false,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "defaultClientScopes": [
        "basic",
        "roles",
        "profile",
        "email"
      ],
      "attributes": {
        "access.token.lifespan": "1800"
      },
      "fullScopeAllowed": true
    }
  ],
  "eventsEnabled": true,
  "eventsListeners": [
    "jboss-logging",
    "eo-event-listener"
  ],
  "enabledEventTypes": [
    "UPDATE_CONSENT_ERROR",
    "SEND_RESET_PASSWORD",
    "GRANT_CONSENT",
    "VERIFY_PROFILE_ERROR",
    "UPDATE_TOTP",
    "REMOVE_TOTP",
    "REVOKE_GRANT",
    "LOGIN_ERROR",
    "CLIENT_LOGIN",
    "RESET_PASSWORD_ERROR",
    "IMPERSONATE_ERROR",
    "CODE_TO_TOKEN_ERROR",
    "CUSTOM_REQUIRED_ACTION",
    "OAUTH2_DEVICE_CODE_TO_TOKEN_ERROR",
    "RESTART_AUTHENTICATION",
    "UPDATE_PROFILE_ERROR",
    "IMPERSONATE",
    "LOGIN",
    "UPDATE_PASSWORD_ERROR",
    "OAUTH2_DEVICE_VERIFY_USER_CODE",
    "CLIENT_INITIATED_ACCOUNT_LINKING",
    "TOKEN_EXCHANGE",
    "REGISTER",
    "LOGOUT",
    "AUTHREQID_TO_TOKEN",
    "DELETE_ACCOUNT_ERROR",
    "CLIENT_REGISTER",
    "IDENTITY_PROVIDER_LINK_ACCOUNT",
    "UPDATE_PASSWORD",
    "DELETE_ACCOUNT",
    "FEDERATED_IDENTITY_LINK_ERROR",
    "CLIENT_DELETE",
    "IDENTITY_PROVIDER_FIRST_LOGIN",
    "VERIFY_EMAIL",
    "CLIENT_DELETE_ERROR",
    "CLIENT_LOGIN_ERROR",
    "RESTART_AUTHENTICATION_ERROR",
    "REMOVE_FEDERATED_IDENTITY_ERROR",
    "EXECUTE_ACTIONS",
    "TOKEN_EXCHANGE_ERROR",
    "PERMISSION_TOKEN",
    "SEND_IDENTITY_PROVIDER_LINK_ERROR",
    "EXECUTE_ACTION_TOKEN_ERROR",
    "SEND_VERIFY_EMAIL",
    "OAUTH2_DEVICE_AUTH",
    "EXECUTE_ACTIONS_ERROR",
    "REMOVE_FEDERATED_IDENTITY",
    "OAUTH2_DEVICE_CODE_TO_TOKEN",
    "IDENTITY_PROVIDER_POST_LOGIN",
    "IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR",
    "UPDATE_EMAIL",
    "OAUTH2_DEVICE_VERIFY_USER_CODE_ERROR",
    "REGISTER_ERROR",
    "REVOKE_GRANT_ERROR",
    "LOGOUT_ERROR",
    "UPDATE_EMAIL_ERROR",
    "EXECUTE_ACTION_TOKEN",
    "CLIENT_UPDATE_ERROR",
    "UPDATE_PROFILE",
    "AUTHREQID_TO_TOKEN_ERROR",
    "FEDERATED_IDENTITY_LINK",
    "CLIENT_REGISTER_ERROR",
    "SEND_VERIFY_EMAIL_ERROR",
    "SEND_IDENTITY_PROVIDER_LINK",
    "RESET_PASSWORD",
    "CLIENT_INITIATED_ACCOUNT_LINKING_ERROR",
    "OAUTH2_DEVICE_AUTH_ERROR",
    "UPDATE_CONSENT",
    "REMOVE_TOTP_ERROR",
    "VERIFY_EMAIL_ERROR",
    "SEND_RESET_PASSWORD_ERROR",
    "CLIENT_UPDATE",
    "IDENTITY_PROVIDER_POST_LOGIN_ERROR",
    "CUSTOM_REQUIRED_ACTION_ERROR",
    "UPDATE_TOTP_ERROR",
    "CODE_TO_TOKEN",
    "VERIFY_PROFILE",
    "GRANT_CONSENT_ERROR",
    "IDENTITY_PROVIDER_FIRST_LOGIN_ERROR"
  ],
  "adminEventsEnabled": true,
  "adminEventsDetailsEnabled": true,
  "loginTheme": "dds",
  "emailTheme": "dds",
  "authenticationFlows": [
    {
      "id": "d6cb5606-8249-4142-bb02-728d173c5982",
      "alias": "Account verification options",
      "description": "Method with which to verity the existing account",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "idp-email-verification",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "ALTERNATIVE",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "Verify Existing Account by Re-authentication",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "836c4be2-e376-42d1-9b7a-98d758a01e75",
      "alias": "Authentication Options",
      "description": "Authentication options.",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "basic-auth",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "basic-auth-otp",
          "authenticatorFlow": false,
          "requirement": "DISABLED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "auth-spnego",
          "authenticatorFlow": false,
          "requirement": "DISABLED",
          "priority": 30,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "e87895cd-7182-4f1e-864c-b7ab20da7b56",
      "alias": "Browser - Conditional OTP",
      "description": "Flow to determine if the OTP is required for the authentication",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "conditional-user-configured",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "auth-otp-form",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "b8d2107d-43e9-4c1b-ba42-27ea64f8d461",
      "alias": "Custom browser",
      "description": "browser based authentication",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": false,
      "authenticationExecutions": [
        {
          "authenticator": "auth-cookie",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "auth-spnego",
          "authenticatorFlow": false,
          "requirement": "DISABLED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "identity-provider-redirector",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 25,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "ALTERNATIVE",
          "priority": 30,
          "autheticatorFlow": true,
          "flowAlias": "browser - otp forms",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "224ffad7-1fd6-46d6-80ae-841bfd8f42aa",
      "alias": "Custom clients",
      "description": "Base authentication for clients",
      "providerId": "client-flow",
      "topLevel": true,
      "builtIn": false,
      "authenticationExecutions": [
        {
          "authenticator": "client-secret",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-jwt",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-secret-jwt",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 30,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-valid-x509",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 41,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "d4f03df7-b346-4d95-ab35-6fd8e14d436a",
      "alias": "Direct Grant - Conditional OTP",
      "description": "Flow to determine if the OTP is required for the authentication",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "conditional-user-configured",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "direct-grant-validate-otp",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "b6cdc263-9743-4212-8de6-89162379c5ca",
      "alias": "Email OTP",
      "description": "",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": false,
      "authenticationExecutions": [
        {
          "authenticatorConfig": "EmailOTPAttribute",
          "authenticator": "conditional-user-attribute",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 0,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "otp-email-authenticator-provider",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 1,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "1be2e120-1a3f-4c3a-b2a0-3aae6333231d",
      "alias": "First broker login - Conditional OTP",
      "description": "Flow to determine if the OTP is required for the authentication",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "conditional-user-configured",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "auth-otp-form",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "14767816-1196-479c-894a-2360f7e5e188",
      "alias": "Handle Existing Account",
      "description": "Handle what to do if there is existing account with same email/username like authenticated identity provider",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "idp-confirm-link",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "Account verification options",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "cb295001-a70a-4f44-8c28-e22d43d8fa7e",
      "alias": "Reset - Conditional OTP",
      "description": "Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "conditional-user-configured",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "reset-otp",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "8fd132f3-12a6-4fba-84b2-8ecd9c0b2aa6",
      "alias": "User creation or linking",
      "description": "Flow for the existing/non-existing user alternatives",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticatorConfig": "create unique user config",
          "authenticator": "idp-create-user-if-unique",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "ALTERNATIVE",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "Handle Existing Account",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "5d047ae8-b5a3-4876-8e49-e6d47c564dac",
      "alias": "Verify Existing Account by Re-authentication",
      "description": "Reauthentication of existing account",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "idp-username-password-form",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "CONDITIONAL",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "First broker login - Conditional OTP",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "e5956648-a106-45e7-a9df-b56edd6a766c",
      "alias": "browser",
      "description": "browser based authentication",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "auth-cookie",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "auth-spnego",
          "authenticatorFlow": false,
          "requirement": "DISABLED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "identity-provider-redirector",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 25,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "ALTERNATIVE",
          "priority": 30,
          "autheticatorFlow": true,
          "flowAlias": "forms",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "e7950f15-ec44-4d47-9dab-2722e3259397",
      "alias": "browser - otp forms",
      "description": "Username, password, otp and other auth forms.",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": false,
      "authenticationExecutions": [
        {
          "authenticator": "auth-username-password-form",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "CONDITIONAL",
          "priority": 11,
          "autheticatorFlow": true,
          "flowAlias": "Email OTP",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "16b11db5-9084-4b88-bf7b-d2fa29e3a55f",
      "alias": "clients",
      "description": "Base authentication for clients",
      "providerId": "client-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "client-secret",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-jwt",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-secret-jwt",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 30,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "client-x509",
          "authenticatorFlow": false,
          "requirement": "ALTERNATIVE",
          "priority": 40,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "def6b8b3-6cff-4de8-95bd-ddb231a043fb",
      "alias": "direct grant",
      "description": "OpenID Connect Resource Owner Grant",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "direct-grant-validate-username",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "direct-grant-validate-password",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "CONDITIONAL",
          "priority": 30,
          "autheticatorFlow": true,
          "flowAlias": "Direct Grant - Conditional OTP",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "f1df37f0-1584-4f69-908d-8fb8e0ad05d4",
      "alias": "docker auth",
      "description": "Used by Docker clients to authenticate against the IDP",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "docker-http-basic-authenticator",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "c4f08bf9-c6ec-43a0-989f-fc7e991c1261",
      "alias": "first broker login",
      "description": "Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticatorConfig": "review profile config",
          "authenticator": "idp-review-profile",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "User creation or linking",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "8049e87d-0f8a-4812-9a0d-691f046a643a",
      "alias": "forms",
      "description": "Username, password, otp and other auth forms.",
      "providerId": "basic-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "auth-username-password-form",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "CONDITIONAL",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "Browser - Conditional OTP",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "edbc2c32-fea9-42e8-ab29-a13e2d183934",
      "alias": "http challenge",
      "description": "An authentication flow based on challenge-response HTTP Authentication Schemes",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "no-cookie-redirect",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": true,
          "flowAlias": "Authentication Options",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "fa9e95a9-6af5-4b51-af30-ac71b3578544",
      "alias": "registration",
      "description": "registration flow",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "registration-page-form",
          "authenticatorFlow": true,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": true,
          "flowAlias": "registration form",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "0adeabb1-4efc-4068-9290-f9c0d6dff90d",
      "alias": "registration form",
      "description": "registration form",
      "providerId": "form-flow",
      "topLevel": false,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "registration-user-creation",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "registration-profile-action",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 40,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "registration-password-action",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 50,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "registration-recaptcha-action",
          "authenticatorFlow": false,
          "requirement": "DISABLED",
          "priority": 60,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "c38ececa-677d-4692-be21-9c564de5921d",
      "alias": "reset credentials",
      "description": "Reset credentials for a user if they forgot their password or something",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "custom-reset-credentials-choose-user",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "reset-credential-email",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 20,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticator": "reset-password",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 30,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        },
        {
          "authenticatorFlow": true,
          "requirement": "CONDITIONAL",
          "priority": 40,
          "autheticatorFlow": true,
          "flowAlias": "Reset - Conditional OTP",
          "userSetupAllowed": false
        }
      ]
    },
    {
      "id": "bd594702-5d67-4092-a2e2-4c0269dd774c",
      "alias": "saml ecp",
      "description": "SAML ECP Profile Authentication Flow",
      "providerId": "basic-flow",
      "topLevel": true,
      "builtIn": true,
      "authenticationExecutions": [
        {
          "authenticator": "http-basic-authenticator",
          "authenticatorFlow": false,
          "requirement": "REQUIRED",
          "priority": 10,
          "autheticatorFlow": false,
          "userSetupAllowed": false
        }
      ]
    }
  ],
  "authenticatorConfig": [
    {
      "id": "a4f2204e-b879-40f9-85bb-2e76d6ebb600",
      "alias": "EmailOTPAttribute",
      "config": {
        "attribute_expected_value": "true",
        "attribute_name": "EMAIL_OTP_ENABLED"
      }
    },
    {
      "id": "00a612b1-d593-4335-bd05-b305743f2d54",
      "alias": "create unique user config",
      "config": {
        "require.password.update.after.registration": "false"
      }
    },
    {
      "id": "278871a0-c1ab-499d-a8fa-675e6a9a24f7",
      "alias": "review profile config",
      "config": {
        "update.profile.on.first.login": "missing"
      }
    }
  ],
  "browserFlow": "Custom browser",
    "attributes": {
  	    "userAuthMode":"local"
    },
  "clientAuthenticationFlow": "Custom clients"
}
{{- end }}
