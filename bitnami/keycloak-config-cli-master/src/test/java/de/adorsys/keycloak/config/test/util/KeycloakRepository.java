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

package de.adorsys.keycloak.config.test.util;

import de.adorsys.keycloak.config.provider.KeycloakProvider;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasSize;

@Component
public class KeycloakRepository {

    private final KeycloakProvider keycloakProvider;

    @Autowired
    public KeycloakRepository(KeycloakProvider keycloakProvider) {
        this.keycloakProvider = keycloakProvider;
    }

    public UserRepresentation getUser(String realmName, String username) {
        List<UserRepresentation> foundUsers = keycloakProvider.getInstance().realm(realmName)
                .users()
                .list()
                .stream()
                .filter(u -> u.getUsername().equals(username))
                .collect(Collectors.toList());

        assertThat(foundUsers, hasSize(1));

        return foundUsers.get(0);
    }

    public List<String> getUserRealmLevelRoles(String realmName, String username) {
        UserRepresentation user = getUser(realmName, username);
        UserResource userResource = keycloakProvider.getInstance()
                .realm(realmName)
                .users()
                .get(user.getId());

        List<RoleRepresentation> roles = userResource.roles()
                .realmLevel()
                .listEffective();

        return roles.stream().map(RoleRepresentation::getName).collect(Collectors.toList());
    }

    public ClientRepresentation getClient(String realmName, String clientId) {
        List<ClientRepresentation> foundClients = keycloakProvider.getInstance()
                .realm(realmName)
                .clients()
                .findByClientId(clientId);

        assertThat(foundClients, hasSize(1));

        return foundClients.get(0);
    }

    public List<String> getUserClientLevelRoles(String realmName, String username, String clientId) {
        UserRepresentation user = getUser(realmName, username);
        ClientRepresentation client = getClient(realmName, clientId);

        UserResource userResource = keycloakProvider.getInstance()
                .realm(realmName)
                .users()
                .get(user.getId());

        List<RoleRepresentation> roles = userResource.roles()
                .clientLevel(client.getId())
                .listEffective();

        return roles.stream().map(RoleRepresentation::getName).collect(Collectors.toList());
    }

    public boolean isClientRoleExisting(String realm, String clientId, String role) {
        ClientRepresentation client = getClient(realm, clientId);

        List<RoleRepresentation> clientRoles = keycloakProvider.getInstance()
                .realm(realm)
                .clients().get(client.getId())
                .roles()
                .list();

        long count = clientRoles.stream()
                .filter(r -> Objects.equals(r.getName(), role))
                .count();

        return count > 0;
    }

    public RoleRepresentation getRealmRole(RealmRepresentation realmRepository, String roleName) {
        return realmRepository
                .getRoles()
                .getRealm()
                .stream()
                .filter(r -> Objects.equals(r.getName(), roleName))
                .findFirst()
                .orElse(null);
    }

    public RoleRepresentation getClientRole(RealmRepresentation realmRepository, String clientId, String roleName) {
        return realmRepository
                .getRoles()
                .getClient()
                .get(clientId)
                .stream()
                .filter(r -> Objects.equals(r.getName(), roleName))
                .findFirst()
                .orElse(null);
    }
}
