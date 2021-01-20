/*-
 * ---license-start
 * keycloak-config-cli
 * ---
 * Copyright (C) 2017 - 2021 adorsys GmbH & Co. KG @ https://adorsys.com
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */

package de.adorsys.keycloak.config.service;

import de.adorsys.keycloak.config.AbstractImportTest;
import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.model.RealmImport;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.common.util.MultivaluedHashMap;
import org.keycloak.representations.idm.ComponentExportRepresentation;
import org.keycloak.representations.idm.ComponentRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.test.context.TestPropertySource;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

@TestPropertySource(properties = {
        "import.managed.component=full"
})
class ImportComponentsIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithComponents";

    ImportComponentsIT() {
        this.resourcePath = "import-files/components";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithComponent() {
        doImport("00_create_realm_with_component.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("4096"));
    }

    @Test
    @Order(1)
    void shouldUpdateComponentsConfig() {
        doImport("01_update_realm__change_component_config.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));
    }

    @Test
    @Order(2)
    void shouldUpdateAddComponentsConfig() {
        doImport("02_update_realm__add_component_with_config.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        ComponentRepresentation createdComponent = getComponent(
                "org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy",
                "Allowed Protocol Mapper Types",
                "authenticated"
        );

        assertThat(createdComponent.getName(), is("Allowed Protocol Mapper Types"));
        assertThat(createdComponent.getProviderId(), is("allowed-protocol-mappers"));
        assertThat(createdComponent.getSubType(), is("authenticated"));
        MultivaluedHashMap<String, String> componentConfig = createdComponent.getConfig();

        List<String> mapperTypes = componentConfig.get("allowed-protocol-mapper-types");
        assertThat(mapperTypes, hasSize(8));
        assertThat(mapperTypes, containsInAnyOrder(
                "oidc-full-name-mapper",
                "oidc-sha256-pairwise-sub-mapper",
                "oidc-address-mapper",
                "saml-user-property-mapper",
                "oidc-usermodel-property-mapper",
                "saml-role-list-mapper",
                "saml-user-attribute-mapper",
                "oidc-usermodel-attribute-mapper"
        ));
    }

    @Test
    @Order(3)
    void shouldAddComponentForSameProviderType() {
        doImport("03_update_realm__add_component_for_same_providerType.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        ComponentRepresentation createdComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "hmac-generated"
        );

        assertThat(createdComponent.getName(), is("hmac-generated"));
        assertThat(createdComponent.getProviderId(), is("hmac-generated"));
        assertThat(createdComponent.getProviderType(), is("org.keycloak.keys.KeyProvider"));
        MultivaluedHashMap<String, String> componentConfig = createdComponent.getConfig();

        List<String> secretSizeSize = componentConfig.get("secretSize");
        assertThat(secretSizeSize, hasSize(1));
        assertThat(secretSizeSize.get(0), is("32"));
    }

    @Test
    @Order(4)
    void shouldAddComponentWithSubComponent() {
        doImport("04_update_realm__add_component_with_subcomponent.json");

        ComponentExportRepresentation createdComponent = exportComponent(
                REALM_NAME,
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(10));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "true");
        assertConfigHasValue(config, "role.object.classes", "group");
    }

    @Test
    @Order(5)
    void shouldUpdateConfigOfSubComponent() {
        doImport("05_update_realm__update_config_in_subcomponent.json");

        ComponentExportRepresentation createdComponent = exportComponent(
                REALM_NAME,
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent, notNullValue());
        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(11));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "false");
        assertConfigHasValue(config, "role.object.classes", "group");
        assertConfigHasValue(config, "client.id", "my-client-id");
    }

    @Test
    @Order(6)
    void shouldUpdateComponentAddSubComponent() {
        doImport("06.1_create_realm__with_component_without_subcomponent.json");
        doImport("06.2_update_realm__update_component_add_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(10));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "true");
        assertConfigHasValue(config, "role.object.classes", "group");
    }

    @Test
    @Order(7)
    void shouldUpdateComponentAddMoreSubComponent() {
        doImport("07_update_realm__update_component_add_more_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(10));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "true");
        assertConfigHasValue(config, "role.object.classes", "group");

        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2.getName(), is(equalTo("picture")));
        assertThat(subComponent2.getProviderId(), is(equalTo("user-attribute-ldap-mapper")));

        MultivaluedHashMap<String, String> config2 = subComponent2.getConfig();
        assertThat(config2.size(), is(5));

        assertConfigHasValue(config2, "ldap.attribute", "jpegPhoto");
        assertConfigHasValue(config2, "is.mandatory.in.ldap", "true");
        assertConfigHasValue(config2, "is.binary.attribute", "true");
        assertConfigHasValue(config2, "always.read.value.from.ldap", "true");
        assertConfigHasValue(config2, "user.model.attribute", "picture");
    }

    @Test
    @Order(8)
    void shouldUpdateComponentUpdateSubComponent() {
        doImport("08_update_realm__update_component_update_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(10));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "true");
        assertConfigHasValue(config, "role.object.classes", "group");

        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2.getName(), is(equalTo("picture")));
        assertThat(subComponent2.getProviderId(), is(equalTo("user-attribute-ldap-mapper")));

        MultivaluedHashMap<String, String> config2 = subComponent2.getConfig();
        assertThat(config2.size(), is(6));

        assertConfigHasValue(config2, "ldap.attribute", "jpegPhoto");
        assertConfigHasValue(config2, "is.mandatory.in.ldap", "false");
        assertConfigHasValue(config2, "is.binary.attribute", "true");
        assertConfigHasValue(config2, "read.only", "true");
        assertConfigHasValue(config2, "always.read.value.from.ldap", "true");
        assertConfigHasValue(config2, "user.model.attribute", "picture");
    }

    /*
    @Test
    @Disabled("subComponent will be a empty map instead a null value. subComponent will deleted instead skipped")
    @Order(9)
    void shouldUpdateComponentSkipSubComponent() {
        doImport("09_update_realm__update_component_skip_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent, notNullValue());
        assertThat(subComponent.getName(), is(equalTo("my-realm-role-mapper")));
        assertThat(subComponent.getProviderId(), is(equalTo("role-ldap-mapper")));

        MultivaluedHashMap<String, String> config = subComponent.getConfig();
        assertThat(config.size(), is(10));

        assertConfigHasValue(config, "mode", "LDAP_ONLY");
        assertConfigHasValue(config, "membership.attribute.type", "DN");
        assertConfigHasValue(config, "user.roles.retrieve.strategy", "LOAD_ROLES_BY_MEMBER_ATTRIBUTE_RECURSIVELY");
        assertConfigHasValue(config, "roles.dn", "someDN");
        assertConfigHasValue(config, "membership.ldap.attribute", "member");
        assertConfigHasValue(config, "membership.user.ldap.attribute", "userPrincipalName");
        assertConfigHasValue(config, "memberof.ldap.attribute", "memberOf");
        assertConfigHasValue(config, "role.name.ldap.attribute", "cn");
        assertConfigHasValue(config, "use.realm.roles.mapping", "true");
        assertConfigHasValue(config, "role.object.classes", "group");

        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2.getName(), is(equalTo("picture")));
        assertThat(subComponent2.getProviderId(), is(equalTo("user-attribute-ldap-mapper")));

        MultivaluedHashMap<String, String> config2 = subComponent2.getConfig();
        assertThat(config2.size(), is(6));

        assertConfigHasValue(config2, "ldap.attribute", "jpegPhoto");
        assertConfigHasValue(config2, "is.mandatory.in.ldap", "false");
        assertConfigHasValue(config2, "is.binary.attribute", "true");
        assertConfigHasValue(config2, "read.only", "true");
        assertConfigHasValue(config2, "always.read.value.from.ldap", "true");
        assertConfigHasValue(config2, "user.model.attribute", "picture");
    }
    */

    @Test
    @Order(10)
    void shouldUpdateComponentRemoveSubComponent() {
        doImport("10_update_realm__update_component_remove_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, notNullValue());
        assertThat(createdComponent.getName(), is("my-realm-userstorage"));
        assertThat(createdComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = createdComponent.getSubComponents();
        ComponentExportRepresentation subComponent = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "my-realm-role-mapper"
        );

        assertThat(subComponent, is(nullValue()));

        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2.getName(), is(equalTo("picture")));
        assertThat(subComponent2.getProviderId(), is(equalTo("user-attribute-ldap-mapper")));

        MultivaluedHashMap<String, String> config2 = subComponent2.getConfig();
        assertThat(config2.size(), is(6));

        assertConfigHasValue(config2, "ldap.attribute", "jpegPhoto");
        assertConfigHasValue(config2, "is.mandatory.in.ldap", "false");
        assertConfigHasValue(config2, "is.binary.attribute", "true");
        assertConfigHasValue(config2, "read.only", "true");
        assertConfigHasValue(config2, "always.read.value.from.ldap", "true");
        assertConfigHasValue(config2, "user.model.attribute", "picture");
    }

    @Test
    @Order(11)
    void shouldUpdateComponentRemoveAllSubComponent() {
        doImport("11_update_realm__update_component_remove_all_subcomponent.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation subComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(subComponent, notNullValue());
        assertThat(subComponent.getName(), is("my-realm-userstorage"));
        assertThat(subComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = subComponent.getSubComponents();
        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2, is(nullValue()));
    }

    @Test
    @Order(12)
    void shouldNotCreateComponents() {
        RealmImport foundImport = getImport("12_update_realm__try-to-create-component.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create component '.*' in realm 'realmWithSubComponents': .*"));
    }

    @Test
    @Order(97)
    void shouldUpdateSkipComponents() {
        doImport("97_update_realm__skip_components.json");

        ComponentRepresentation rsaComponent = getComponent(
                "org.keycloak.keys.KeyProvider",
                "rsa-generated"
        );

        assertThat(rsaComponent.getName(), is("rsa-generated"));
        assertThat(rsaComponent.getProviderId(), is("rsa-generated"));
        MultivaluedHashMap<String, String> componentConfig = rsaComponent.getConfig();

        List<String> keySize = componentConfig.get("keySize");
        assertThat(keySize, hasSize(1));
        assertThat(keySize.get(0), is("2048"));

        ComponentExportRepresentation subComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(subComponent, notNullValue());
        assertThat(subComponent.getName(), is("my-realm-userstorage"));
        assertThat(subComponent.getProviderId(), is("ldap"));

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponentsMap = subComponent.getSubComponents();
        ComponentExportRepresentation subComponent2 = getSubComponent(
                subComponentsMap,
                "org.keycloak.storage.ldap.mappers.LDAPStorageMapper",
                "picture"
        );

        assertThat(subComponent2, is(nullValue()));
    }

    @Test
    @Order(98)
    void shouldUpdateRemoveComponents() {
        doImport("98_update_realm__remove_component.json");

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, is(nullValue()));

        ComponentRepresentation clientRegistrationPolicyComponent = getComponent(
                "org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy",
                "Allowed Protocol Mapper Types",
                "authenticated"
        );

        assertThat(clientRegistrationPolicyComponent.getName(), is("Allowed Protocol Mapper Types"));
        assertThat(clientRegistrationPolicyComponent.getProviderId(), is("allowed-protocol-mappers"));
        assertThat(clientRegistrationPolicyComponent.getSubType(), is("authenticated"));
        MultivaluedHashMap<String, String> componentConfig = clientRegistrationPolicyComponent.getConfig();

        List<String> mapperTypes = componentConfig.get("allowed-protocol-mapper-types");
        assertThat(mapperTypes, hasSize(8));
        assertThat(mapperTypes, containsInAnyOrder(
                "oidc-full-name-mapper",
                "oidc-sha256-pairwise-sub-mapper",
                "oidc-address-mapper",
                "saml-user-property-mapper",
                "oidc-usermodel-property-mapper",
                "saml-role-list-mapper",
                "saml-user-attribute-mapper",
                "oidc-usermodel-attribute-mapper"
        ));
    }

    @Test
    @Order(99)
    void shouldUpdateRemoveAllComponents() {
        doImport("99_update_realm__remove_all_components.json");

        ComponentExportRepresentation createdComponent = exportComponent(
                "realmWithSubComponents",
                "org.keycloak.storage.UserStorageProvider",
                "my-realm-userstorage"
        );

        assertThat(createdComponent, is(nullValue()));
    }

    private void assertConfigHasValue(MultivaluedHashMap<String, String> config, String configKey, String expectedConfigValue) {
        assertThat(config, hasKey(configKey));
        List<String> configValues = config.get(configKey);

        assertThat(configValues, hasSize(1));

        String configValue = configValues.get(0);
        assertThat(configValue, is(equalTo(expectedConfigValue)));
    }

    private ComponentRepresentation getComponent(String providerType, String name, String subType) {
        return tryToGetComponent(providerType, name, subType).orElse(null);
    }

    private ComponentRepresentation getComponent(String providerType, String name) {
        return tryToGetComponent(providerType, name).orElse(null);
    }

    private ComponentExportRepresentation exportComponent(String realm, String providerType, String name) {
        RealmRepresentation exportedRealm = keycloakProvider.getInstance().realm(realm).partialExport(true, true);

        List<ComponentExportRepresentation> components = exportedRealm.getComponents().get(providerType);

        if (components == null) {
            return null;
        }

        return components
                .stream()
                .filter(c -> c.getName().equals(name))
                .findFirst()
                .orElse(null);
    }

    private ComponentExportRepresentation getSubComponent(MultivaluedHashMap<String, ComponentExportRepresentation> subComponents, String providerType, String name) {
        return subComponents.get(providerType)
                .stream()
                .filter(c -> Objects.equals(c.getName(), name))
                .findFirst()
                .orElse(null);
    }

    private Optional<ComponentRepresentation> tryToGetComponent(String providerType, String name, String subType) {
        RealmResource realmResource = keycloakProvider.getInstance()
                .realm(REALM_NAME);

        Optional<ComponentRepresentation> maybeComponent;

        List<ComponentRepresentation> existingComponents = realmResource.components()
                .query().stream()
                .filter(c -> c.getProviderType().equals(providerType))
                .filter(c -> c.getName().equals(name))
                .filter(c -> c.getSubType().equals(subType))
                .collect(Collectors.toList());

        assertThat(existingComponents, hasSize(1));

        if (existingComponents.isEmpty()) {
            maybeComponent = Optional.empty();
        } else {
            maybeComponent = Optional.of(existingComponents.get(0));
        }

        return maybeComponent;
    }

    private Optional<ComponentRepresentation> tryToGetComponent(String providerType, String name) {
        RealmResource realmResource = keycloakProvider.getInstance()
                .realm(REALM_NAME);

        Optional<ComponentRepresentation> maybeComponent;

        List<ComponentRepresentation> existingComponents = realmResource.components()
                .query().stream()
                .filter(c -> c.getProviderType().equals(providerType))
                .filter(c -> c.getName().equals(name))
                .filter(c -> c.getSubType() == null)
                .collect(Collectors.toList());

        assertThat(existingComponents, hasSize(1));

        if (existingComponents.isEmpty()) {
            maybeComponent = Optional.empty();
        } else {
            maybeComponent = Optional.of(existingComponents.get(0));
        }

        return maybeComponent;
    }
}
