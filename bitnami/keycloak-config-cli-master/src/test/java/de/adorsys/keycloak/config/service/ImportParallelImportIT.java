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
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.*;
import org.springframework.test.context.TestPropertySource;

import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.core.Is.is;

@TestPropertySource(properties = {
        "import.force=true",
        "import.parallel=true",
})
class ImportParallelImportIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithParallelImport";

    ImportParallelImportIT() {
        this.resourcePath = "import-files/parallel";
    }

    @Test
    @Order(0)
    void shouldCreateRealm() {
        doImport("0_create_realm.json");

        assertRealm();
    }

    @Test
    @Order(1)
    void shouldUpdateRealm() {
        doImport("1_update_realm.json");

        assertRealm();
    }

    private void assertRealm() {
        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);
        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        List<ClientRepresentation> createdClients = createdRealm.getClients()
                .stream().filter(client -> client.getName().startsWith("client"))
                .collect(Collectors.toList());
        assertThat(createdClients, hasSize(10));

        List<ClientScopeRepresentation> createdClientScopes = createdRealm.getClientScopes()
                .stream().filter(clientScope -> clientScope.getName().startsWith("clientScope"))
                .collect(Collectors.toList());
        assertThat(createdClientScopes, hasSize(10));

        List<GroupRepresentation> createdGroup = createdRealm.getGroups();
        assertThat(createdGroup, hasSize(10));

        List<RoleRepresentation> createdRoles = createdRealm.getRoles().getRealm()
                .stream().filter(group -> group.getName().startsWith("role"))
                .collect(Collectors.toList());
        assertThat(createdRoles, hasSize(10));

        List<UserRepresentation> createdUsers = keycloakProvider.getInstance().realm(REALM_NAME).users().list()
                .stream().filter(u -> u.getUsername().startsWith("user"))
                .collect(Collectors.toList());
        assertThat(createdUsers, hasSize(10));
    }
}
