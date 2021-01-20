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

package de.adorsys.keycloak.config.util;

import de.adorsys.keycloak.config.extensions.GithubActionsExtension;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(GithubActionsExtension.class)
class KeycloakUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, KeycloakUtil::new);
    }

    @Test
    void isDefaultRole() {
        RoleRepresentation role = new RoleRepresentation();
        role.setDescription(null);
        role.setName("test");
        assertFalse(KeycloakUtil.isDefaultRole(role));

        role.setDescription("${role_test}");
        role.setName(null);
        assertFalse(KeycloakUtil.isDefaultRole(role));

        role.setDescription("${role_test}");
        role.setName("test");
        assertTrue(KeycloakUtil.isDefaultRole(role));
    }

    @Test
    void isDefaultClient() {
        ClientRepresentation client = new ClientRepresentation();

        client.setClientId("account");
        assertFalse(KeycloakUtil.isDefaultClient(client));

        client.setName("${client_account}");
        assertTrue(KeycloakUtil.isDefaultClient(client));
    }
}
