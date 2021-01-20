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
import org.keycloak.representations.idm.ClientScopeRepresentation;
import org.keycloak.representations.idm.ProtocolMapperRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportClientScopesIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithClientScopes";

    ImportClientScopesIT() {
        this.resourcePath = "import-files/client-scopes";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithClientScope() {
        doImport("00_create_realm_with_clientScope.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("true"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(createdClientScope.getProtocolMappers(), is(nullValue()));
    }

    @Test
    @Order(1)
    void shouldAddClientScope() {
        doImport("01_update_realm__add_clientScope.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_other_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My other clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("true"));
        assertThat(createdClientScope.getProtocolMappers(), is(nullValue()));
    }

    @Test
    @Order(2)
    void shouldChangeClientScope() {
        doImport("02_update_realm__change_clientScope.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_other_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My changed other clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(createdClientScope.getProtocolMappers(), is(nullValue()));
    }

    @Test
    @Order(3)
    void shouldChangeClientScopeWithAddProtocolMapper() {
        doImport("03_update_realm__change_clientScope_add_protocolMapper.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_other_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My changed other clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(createdClientScope.getProtocolMappers(), hasSize(1));

        ProtocolMapperRepresentation protocolMapper = getProtocolMapper(createdClientScope, "my_protocol_mapper");

        assertThat(protocolMapper, notNullValue());
        assertThat(protocolMapper.getProtocol(), is("openid-connect"));
        assertThat(protocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(protocolMapper.getConfig().get("user.attribute"), is("my-attribute"));
        assertThat(protocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("claim.name"), is("my-claim"));
        assertThat(protocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
    }

    @Test
    @Order(4)
    void shouldChangeClientScopeWithChangeProtocolMapper() {
        doImport("04_update_realm__change_clientScope_change_protocolMapper.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_other_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My changed other clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(createdClientScope.getProtocolMappers(), hasSize(1));

        ProtocolMapperRepresentation protocolMapper = getProtocolMapper(createdClientScope, "my_protocol_mapper");

        assertThat(protocolMapper, notNullValue());
        assertThat(protocolMapper.getProtocol(), is("openid-connect"));
        assertThat(protocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(protocolMapper.getConfig().get("user.attribute"), is("my-changed-attribute"));
        assertThat(protocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("claim.name"), is("my-changed-claim"));
        assertThat(protocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
    }

    @Test
    @Order(5)
    void shouldChangeClientScopeWithReplaceProtocolMapper() {
        doImport("05_update_realm__change_clientScope_replace_protocolMapper.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("my_other_clientScope"));
        assertThat(createdClientScope.getDescription(), is("My changed other clientScope"));
        assertThat(createdClientScope.getProtocol(), is("openid-connect"));
        assertThat(createdClientScope.getAttributes(), aMapWithSize(2));
        assertThat(createdClientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(createdClientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(createdClientScope.getProtocolMappers(), hasSize(1));

        ProtocolMapperRepresentation protocolMapper = getProtocolMapper(createdClientScope, "my_replaced_protocol_mapper");

        assertThat(protocolMapper, notNullValue());
        assertThat(protocolMapper.getProtocol(), is("openid-connect"));
        assertThat(protocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(protocolMapper.getConfig().get("user.attribute"), is("my-changed-attribute"));
        assertThat(protocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("claim.name"), is("my-changed-claim"));
        assertThat(protocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
    }

    @Test
    @Order(6)
    void shouldNotUpdateRealmUpdateScopeMappingsWithError() {
        RealmImport foundImport = getImport("06_update_realm__try-to-change_clientScope_invalid_protocolMapper.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot update protocolMapper 'my_replaced_protocol_mapper' for clientScope 'my_other_clientScope' in realm 'realmWithClientScopes': .*"));
    }

    @Test
    @Order(9)
    void shouldChangeDefaultClientScopeAddProtocolMapper() {
        doImport("09_update_realm__change_default_clientScope_add_protocolMapper.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "profile");
        assertThat(createdClientScope, notNullValue());

        ProtocolMapperRepresentation protocolMapper = getProtocolMapper(createdClientScope, "tmp");

        assertThat(protocolMapper, notNullValue());
        assertThat(protocolMapper.getProtocol(), is("openid-connect"));
        assertThat(protocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(protocolMapper.getConfig().get("user.attribute"), is("name"));
        assertThat(protocolMapper.getConfig().get("claim.name"), is("tmp"));
        assertThat(protocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("jsonType.label"), is("String"));
    }

    @Test
    @Order(11)
        // https://github.com/adorsys/keycloak-config-cli/issues/183
    void shouldCreateClientScopeWithProtocolMapper() {
        doImport("70.0_create_empty_realm.json");
        doImport("70.1_update_realm__create_clientScope_with_protocolMapper.json");

        final String REALM_NAME_70 = REALM_NAME.concat("_70");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME_70).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME_70));
        assertThat(realm.isEnabled(), is(true));


        ClientScopeRepresentation updatedDefaultScope = getClientScope(realm, "profile");
        assertThat(updatedDefaultScope, notNullValue());

        ProtocolMapperRepresentation defaultScopeProtocolMapper = getProtocolMapper(updatedDefaultScope, "tmp2");

        assertThat(defaultScopeProtocolMapper, notNullValue());
        assertThat(defaultScopeProtocolMapper.getProtocol(), is("openid-connect"));
        assertThat(defaultScopeProtocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("user.attribute"), is("name"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("claim.name"), is("tmp"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
        assertThat(defaultScopeProtocolMapper.getConfig().get("jsonType.label"), is("String"));

        ClientScopeRepresentation createdClientScope = getClientScope(realm, "new_protocolMappers_clientScope");

        assertThat(createdClientScope, notNullValue());
        assertThat(createdClientScope.getName(), is("new_protocolMappers_clientScope"));
        assertThat(createdClientScope.getAttributes(), anEmptyMap());
        assertThat(createdClientScope.getProtocolMappers(), hasSize(1));

        ProtocolMapperRepresentation protocolMapper = getProtocolMapper(createdClientScope, "mapper");

        assertThat(protocolMapper, notNullValue());
        assertThat(protocolMapper.getProtocol(), is("openid-connect"));
        assertThat(protocolMapper.getProtocolMapper(), is("oidc-usermodel-attribute-mapper"));
        assertThat(protocolMapper.getConfig().get("user.attribute"), is("name"));
        assertThat(protocolMapper.getConfig().get("claim.name"), is("tmp"));
        assertThat(protocolMapper.getConfig().get("access.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("id.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("userinfo.token.claim"), is("true"));
        assertThat(protocolMapper.getConfig().get("jsonType.label"), is("String"));
    }

    @Test
    @Order(96)
    void shouldChangeClientScopeDeleteProtocolMapper() {
        doImport("96_update_realm__change_clientScope_delete_protocolMapper.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation clientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(clientScope, notNullValue());
        assertThat(clientScope.getName(), is("my_other_clientScope"));
        assertThat(clientScope.getDescription(), is("My changed other clientScope"));
        assertThat(clientScope.getProtocol(), is("openid-connect"));
        assertThat(clientScope.getAttributes(), aMapWithSize(2));
        assertThat(clientScope.getAttributes().get("include.in.token.scope"), is("false"));
        assertThat(clientScope.getAttributes().get("display.on.consent.screen"), is("false"));
        assertThat(clientScope.getProtocolMappers(), nullValue());
    }

    @Test
    @Order(97)
    void shouldDeleteClientScope() {
        doImport("97_update_realm__delete_clientScope.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation deletedClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(deletedClientScope, is(nullValue()));
    }

    @Test
    @Order(98)
    void shouldDeleteNothingWithNonExistingClientScopes() {
        doImport("98_update_realm__skip_delete.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        ClientScopeRepresentation clientScope = getClientScope(realm, "my_clientScope");
        ClientScopeRepresentation otherClientScope = getClientScope(realm, "my_other_clientScope");

        assertThat(clientScope, notNullValue());
        assertThat(otherClientScope, is(nullValue()));
    }

    @Test
    @Order(99)
    void shouldDeleteEverythingExpectDefaultScopesWithEmptyClientScopes() {
        doImport("99_update_realm__delete_all.json");

        RealmResource realmResource = keycloakProvider.getInstance().realm(REALM_NAME);
        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        final List<ClientScopeRepresentation> defaultClientScopes = new ArrayList<>();
        defaultClientScopes.addAll(realmResource.getDefaultDefaultClientScopes());
        defaultClientScopes.addAll(realmResource.getDefaultOptionalClientScopes());

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ClientScopeRepresentation> clientScopes = getClientScopes(realm);

        //TODO: Documentation needed. I don't get this.
        assertThat(clientScopes.stream().allMatch(s -> defaultClientScopes.stream().anyMatch(d -> Objects.equals(s.getName(), d.getName()))), is(true));
    }

    private List<ClientScopeRepresentation> getClientScopes(RealmRepresentation realmExport) {
        return realmExport.getClientScopes();
    }

    private ClientScopeRepresentation getClientScope(RealmRepresentation realmExport, String clientScopeName) {
        return getClientScopes(realmExport)
                .stream()
                .filter(s -> clientScopeName.equals(s.getName()))
                .findFirst()
                .orElse(null);
    }

    private ProtocolMapperRepresentation getProtocolMapper(ClientScopeRepresentation clientScope, String protocolMapper) {
        List<ProtocolMapperRepresentation> protocolMappers = clientScope.getProtocolMappers();
        if (protocolMappers == null) return null;

        return protocolMappers.stream()
                .filter(m -> protocolMapper.equals(m.getName()))
                .findFirst()
                .orElse(null);
    }
}
