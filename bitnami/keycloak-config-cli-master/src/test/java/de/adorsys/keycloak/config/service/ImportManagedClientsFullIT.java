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
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.test.context.TestPropertySource;

import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasItems;
import static org.hamcrest.Matchers.not;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@TestPropertySource(properties = {
        "import.managed.client=full"
})
public class ImportManagedClientsFullIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithManagedClients";

    ImportManagedClientsFullIT() {
        this.resourcePath = "import-files/managed-clients";
    }

    @Test
    void shouldDeleteExtraClient() {
        doImport("01_prepare_client_to_delete.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(false, true);
        assertNotNull(getClientByClientId(realm, "moped-client"));
        assertNotNull(getClientByClientId(realm, "admin-cli"));
        assertNotNull(getClientByClientId(realm, "delete-that-client-1"));
        assertNotNull(getClientByClientId(realm, "delete-that-client-2"));
        assertNotNull(getClientByClientId(realm, "delete-that-client-3"));
        assertNotNull(getClientByClientId(realm, "delete-that-client-4"));

        doImport("00_create_realm_with_client.json");
        RealmRepresentation realmAfterDelete = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(false, true);
        Set<String> clients = realmAfterDelete.getClients()
                .stream()
                .map(ClientRepresentation::getClientId)
                .collect(Collectors.toSet());

        assertThat(clients, hasItems("moped-client", "realm-management", "security-admin-console", "admin-cli", "broker", "account"));
        assertThat(clients, not(hasItems("delete-that-client-1", "delete-that-client-2", "delete-that-client-3", "delete-that-client-4")));
    }

    private ClientRepresentation getClientByClientId(RealmRepresentation realm, String clientId) {
        return realm
                .getClients()
                .stream()
                .filter(s -> Objects.equals(s.getClientId(), clientId))
                .findFirst()
                .orElse(null);
    }
}
