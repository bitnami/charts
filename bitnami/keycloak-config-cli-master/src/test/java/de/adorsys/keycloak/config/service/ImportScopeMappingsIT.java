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
import de.adorsys.keycloak.config.exception.KeycloakRepositoryException;
import de.adorsys.keycloak.config.model.RealmImport;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.RealmRepresentation;
import org.keycloak.representations.idm.ScopeMappingRepresentation;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsEqual.equalTo;
import static org.hamcrest.core.IsNull.nullValue;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportScopeMappingsIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithScopeMappings";

    ImportScopeMappingsIT() {
        this.resourcePath = "import-files/scope-mappings";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithScopeMappings() {
        doImport("00_create-realm-with-scope-mappings.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(1));

        ScopeMappingRepresentation scopeMapping = scopeMappings.get(0);
        assertThat(scopeMapping.getClient(), is(nullValue()));
        assertThat(scopeMapping.getClientScope(), is(equalTo("offline_access")));
        assertThat(scopeMapping.getRoles(), hasSize(1));
        assertThat(scopeMapping.getRoles(), contains("offline_access"));
    }

    @Test
    @Order(1)
    void shouldUpdateRealmByAddingScopeMapping() {
        doImport("01_update-realm__add-scope-mapping.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();
        assertThat(scopeMappingRoles, hasSize(1));
        assertThat(scopeMappingRoles, contains("scope-mapping-role"));
    }

    @Test
    @Order(2)
    void shouldUpdateRealmByAddingRoleToScopeMapping() {
        doImport("02_update-realm__add-role-to-scope-mapping.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(2));
        assertThat(scopeMappingRoles, contains("scope-mapping-role", "added-scope-mapping-role"));
    }

    @Test
    @Order(3)
    void shouldUpdateRealmByAddingAnotherScopeMapping() {
        doImport("03_update-realm__add-scope-mapping.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(3));

        // check scope-mapping for client 'scope-mapping-client'
        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(2));
        assertThat(scopeMappingRoles, contains("scope-mapping-role", "added-scope-mapping-role"));

        // check scope-mapping for client 'scope-mapping-client-two'
        scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client-two");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client-two")));

        scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(2));
        assertThat(scopeMappingRoles, contains("scope-mapping-role", "added-scope-mapping-role"));
    }

    @Test
    @Order(4)
    void shouldUpdateRealmByRemovingRoleFromScopeMapping() {
        doImport("04_update-realm__delete-role-from-scope-mapping.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(3));

        // check scope-mapping for client 'scope-mapping-client'
        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(2));
        assertThat(scopeMappingRoles, contains("scope-mapping-role", "added-scope-mapping-role"));

        // check scope-mapping for client 'scope-mapping-client-two'
        scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client-two");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client-two")));

        scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(1));
        assertThat(scopeMappingRoles, contains("added-scope-mapping-role"));
    }

    @Test
    @Order(5)
    void shouldUpdateRealmByDeletingScopeMappingForClient() {
        doImport("05_update-realm__delete-scope-mapping-for-client.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        // check scope-mapping for client 'scope-mapping-client-two'
        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client-two");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client-two")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(1));
        assertThat(scopeMappingRoles, contains("added-scope-mapping-role"));


        // check scope-mapping for client 'scope-mapping-client' -> should not exist
        Optional<ScopeMappingRepresentation> maybeNotExistingScopeMapping = tryToFindScopeMappingForClient(realm, "scope-mapping-client");
        assertThat(maybeNotExistingScopeMapping.isPresent(), is(false));
    }

    @Test
    @Order(6)
    void shouldUpdateRealmByNotChangingScopeMappingsIfOmittedInImport() {
        doImport("06_update-realm__do-not-change-scope-mappings.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        ScopeMappingRepresentation scopeMapping = findScopeMappingForClient(realm, "scope-mapping-client-two");
        assertThat(scopeMapping.getClient(), is(equalTo("scope-mapping-client-two")));

        Set<String> scopeMappingRoles = scopeMapping.getRoles();

        assertThat(scopeMappingRoles, hasSize(1));
        assertThat(scopeMappingRoles, contains("added-scope-mapping-role"));
    }

    @Test
    @Order(7)
    void shouldUpdateRealmByDeletingAllExistingScopeMappings() {
        doImport("07_update-realm__delete-all-scope-mappings.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();

        assertThat(scopeMappings, is(nullValue()));
    }

    @Test
    @Order(8)
    void shouldUpdateRealmByAddingScopeMappingsForClientScope() {
        doImport("08_update-realm__add-scope-mappings-for-client-scope.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        ScopeMappingRepresentation scopeMappingClientScope = scopeMappings
                .stream()
                .filter(scopeMapping -> scopeMapping.getClientScope() != null)
                .findFirst()
                .orElse(null);

        assertThat(scopeMappingClientScope, notNullValue());
        assertThat(scopeMappingClientScope.getClient(), is(nullValue()));
        assertThat(scopeMappingClientScope.getClientScope(), is(equalTo("offline_access")));
        assertThat(scopeMappingClientScope.getRoles(), hasSize(2));
        assertThat(scopeMappingClientScope.getRoles(), contains("scope-mapping-role", "added-scope-mapping-role"));

        ScopeMappingRepresentation scopeMappingClient = scopeMappings
                .stream()
                .filter(scopeMapping -> scopeMapping.getClient() != null)
                .findFirst()
                .orElse(null);

        assertThat(scopeMappingClient, notNullValue());
        assertThat(scopeMappingClient.getClient(), is(equalTo("scope-mapping-client")));
        assertThat(scopeMappingClient.getClientScope(), is(nullValue()));
        assertThat(scopeMappingClient.getRoles(), hasSize(1));
        assertThat(scopeMappingClient.getRoles(), contains("user"));
    }

    @Test
    @Order(9)
    void shouldUpdateRealmByAddingRolesForClient() {
        doImport("09_update-realm__update-role-for-client.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(2));

        ScopeMappingRepresentation scopeMappingClientScope = scopeMappings
                .stream()
                .filter(scopeMapping -> scopeMapping.getClientScope() != null)
                .findFirst()
                .orElse(null);

        assertThat(scopeMappingClientScope, notNullValue());
        assertThat(scopeMappingClientScope.getClient(), is(nullValue()));
        assertThat(scopeMappingClientScope.getClientScope(), is(equalTo("offline_access")));
        assertThat(scopeMappingClientScope.getRoles(), hasSize(2));
        assertThat(scopeMappingClientScope.getRoles(), contains("offline_access", "added-scope-mapping-role"));

        ScopeMappingRepresentation scopeMappingClient = scopeMappings
                .stream()
                .filter(scopeMapping -> scopeMapping.getClient() != null)
                .findFirst()
                .orElse(null);

        assertThat(scopeMappingClient, notNullValue());
        assertThat(scopeMappingClient.getClient(), is(equalTo("scope-mapping-client")));
        assertThat(scopeMappingClient.getClientScope(), is(nullValue()));
        assertThat(scopeMappingClient.getRoles(), hasSize(1));
        assertThat(scopeMappingClient.getRoles(), contains("admin"));
    }

    @Test
    @Order(10)
    void shouldThrowOnUpdateRealmNonExistClientScope() {
        RealmImport foundImport = getImport("10_1_update-realm__throw-invalid-client-scope.json");

        KeycloakRepositoryException thrown = assertThrows(KeycloakRepositoryException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Cannot find client-scope by name 'non-exists-client-scope'"));
    }

    @Test
    @Order(11)
    void shouldThrowOnUpdateRealmClientScopeWithNonExistRoles() {
        RealmImport foundImport = getImport("10_2_update-realm__throw-invalid-client-scope-role.json");

        KeycloakRepositoryException thrown = assertThrows(KeycloakRepositoryException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Cannot find realm role 'non-exists-role' within realm 'realmWithScopeMappings'"));
    }

    @Test
    @Order(12)
    void shouldThrowOnUpdateRealmNonExistClient() {
        RealmImport foundImport = getImport("10_3_update-realm__throw-invalid-client.json");

        KeycloakRepositoryException thrown = assertThrows(KeycloakRepositoryException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Cannot find client by clientId 'non-exists-client'"));
    }

    @Test
    @Order(13)
    void shouldThrowOnUpdateRealmClientWithNonExistRoles() {
        RealmImport foundImport = getImport("10_4_update-realm__throw-invalid-client-role.json");

        KeycloakRepositoryException thrown = assertThrows(KeycloakRepositoryException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Cannot find realm role 'non-exists-role' within realm 'realmWithScopeMappings'"));
    }

    @Test
    @Order(70)
    void shouldCreateRealmWithScopeMappingsAndClient() {
        final String REALM_NAME = "realmWithScopeMappingsClient";

        doImport("70_create-realm-with-scope-mappings-and-client.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        List<ScopeMappingRepresentation> scopeMappings = realm.getScopeMappings();
        assertThat(scopeMappings, hasSize(1));

        ScopeMappingRepresentation scopeMapping = scopeMappings.get(0);
        assertThat(scopeMapping.getClient(), is("scope-mapping-client"));
        assertThat(scopeMapping.getRoles(), contains("scope-mapping-role"));
    }

    private ScopeMappingRepresentation findScopeMappingForClient(RealmRepresentation realm, String client) {
        return tryToFindScopeMappingForClient(realm, client)
                .orElseThrow(() -> new RuntimeException("Cannot find scope-mapping for client" + client));
    }

    private Optional<ScopeMappingRepresentation> tryToFindScopeMappingForClient(RealmRepresentation realm, String client) {
        return realm.getScopeMappings()
                .stream()
                .filter(scopeMapping -> Objects.equals(scopeMapping.getClient(), client))
                .findFirst();
    }
}
