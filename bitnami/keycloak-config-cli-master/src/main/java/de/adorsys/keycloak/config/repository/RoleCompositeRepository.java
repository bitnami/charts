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

package de.adorsys.keycloak.config.repository;

import org.keycloak.admin.client.resource.RoleResource;
import org.keycloak.common.util.MultivaluedHashMap;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@Service
public class RoleCompositeRepository {

    private final RoleRepository roleRepository;
    private final ClientRepository clientRepository;

    @Autowired
    public RoleCompositeRepository(RoleRepository roleRepository, ClientRepository clientRepository) {
        this.roleRepository = roleRepository;
        this.clientRepository = clientRepository;
    }

    public Set<RoleRepresentation> searchRealmRoleRealmComposites(String realmName, String roleName) {
        RoleResource roleResource = loadRealmRole(realmName, roleName);
        return roleResource.getRealmRoleComposites();
    }

    public Set<RoleRepresentation> searchClientRoleRealmComposites(String realmName, String roleClientId, String roleName) {
        RoleResource roleResource = loadClientRole(realmName, roleClientId, roleName);
        return roleResource.getRealmRoleComposites();
    }

    public Set<RoleRepresentation> searchRealmRoleClientComposites(String realmName, String roleName, String compositeClientId) {
        return findClientComposites(
                realmName,
                compositeClientId,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public Map<String, List<String>> searchRealmRoleClientComposites(String realmName, String roleName) {
        return findClientComposites(
                realmName,
                () -> loadRealmRole(realmName, roleName)
        ).entrySet()
                .stream()
                .collect(
                        Collectors.toMap(
                                Map.Entry::getKey,
                                e -> e.getValue().stream()
                                        .map(RoleRepresentation::getName)
                                        .collect(Collectors.toList())
                        )
                );
    }

    public Set<RoleRepresentation> searchClientRoleClientComposites(
            String realmName,
            String roleClientId,
            String roleName,
            String compositeClientId
    ) {
        return findClientComposites(
                realmName,
                compositeClientId,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    public Map<String, List<String>> searchClientRoleClientComposites(String realmName, String roleClientId, String roleName) {
        return findClientComposites(
                realmName,
                () -> loadClientRole(realmName, roleClientId, roleName)
        ).entrySet()
                .stream()
                .collect(
                        Collectors.toMap(
                                Map.Entry::getKey,
                                e -> e.getValue().stream().map(RoleRepresentation::getName).collect(Collectors.toList())
                        )
                );
    }

    public void addRealmRoleRealmComposites(String realmName, String roleName, Set<String> realmComposites) {
        addRealmComposites(
                realmName,
                realmComposites,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public void addClientRoleRealmComposites(
            String realmName,
            String roleClientId,
            String roleName,
            Set<String> realmComposites
    ) {
        addRealmComposites(
                realmName,
                realmComposites,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    public void addRealmRoleClientComposites(String realmName, String roleName, String compositeClientId, Collection<String> clientRoles) {
        addClientComposites(
                realmName,
                compositeClientId,
                clientRoles,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public void addClientRoleClientComposites(
            String realmName,
            String roleClientId,
            String roleName,
            String compositeClientId,
            Collection<String> clientComposites
    ) {
        addClientComposites(
                realmName,
                compositeClientId,
                clientComposites,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    public void removeRealmRoleRealmComposites(String realmName, String roleName, Set<String> realmComposites) {
        removeRealmComposites(
                realmName,
                realmComposites,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public void removeClientRoleRealmComposites(String realmName, String roleClientId, String roleName, Set<String> realmComposites) {
        removeRealmComposites(
                realmName,
                realmComposites,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    public void removeRealmRoleClientComposites(String realmName, String roleName, Map<String, List<String>> clientCompositesToRemove) {
        removeClientComposites(
                realmName,
                clientCompositesToRemove,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public void removeRealmRoleClientComposites(String realmName, String roleName, String compositeClientId, Collection<String> clientRoleNames) {
        removeClientComposites(
                realmName,
                compositeClientId,
                clientRoleNames,
                () -> loadRealmRole(realmName, roleName)
        );
    }

    public void removeClientRoleClientComposites(String realmName, String roleClientId, String roleName, Map<String, List<String>> clientCompositesToRemove) {
        removeClientComposites(
                realmName,
                clientCompositesToRemove,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    public void removeClientRoleClientComposites(String realmName, String roleClientId, String roleName, String compositeClientId, Collection<String> clientRoleNames) {
        removeClientComposites(
                realmName,
                compositeClientId,
                clientRoleNames,
                () -> loadClientRole(realmName, roleClientId, roleName)
        );
    }

    private void addRealmComposites(String realmName, Set<String> realmComposites, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();

        List<RoleRepresentation> realmRoles = realmComposites.stream()
                .map(realmRoleName -> roleRepository.getRealmRole(realmName, realmRoleName))
                .collect(Collectors.toList());

        roleResource.addComposites(realmRoles);
    }

    private void addClientComposites(String realmName, String compositeClientId, Collection<String> clientRoles, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();

        List<RoleRepresentation> realmRoles = clientRoles.stream()
                .map(clientRoleName -> roleRepository.getClientRole(realmName, compositeClientId, clientRoleName))
                .collect(Collectors.toList());

        roleResource.addComposites(realmRoles);
    }

    private void removeRealmComposites(String realmName, Set<String> realmComposites, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();

        List<RoleRepresentation> realmRoles = realmComposites.stream()
                .map(realmRoleName -> roleRepository.getRealmRole(realmName, realmRoleName))
                .collect(Collectors.toList());

        roleResource.deleteComposites(realmRoles);
    }

    private void removeClientComposites(String realmName, Map<String, List<String>> clientCompositesToRemove, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();
        List<RoleRepresentation> clientRolesToRemove = findAllClientRoles(realmName, clientCompositesToRemove);

        roleResource.deleteComposites(clientRolesToRemove);
    }

    private void removeClientComposites(String realmName, String compositeClientId, Collection<String> clientRoleNames, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();

        List<RoleRepresentation> clientRoles = clientRoleNames.stream()
                .map(clientRoleName -> roleRepository.getClientRole(realmName, compositeClientId, clientRoleName))
                .collect(Collectors.toList());

        roleResource.deleteComposites(clientRoles);
    }

    private MultivaluedHashMap<String, RoleRepresentation> findClientComposites(String realmName, Supplier<RoleResource> roleSupplier) {
        MultivaluedHashMap<String, RoleRepresentation> clientComposites = new MultivaluedHashMap<>();

        List<ClientRepresentation> clients = clientRepository.getAll(realmName);

        for (ClientRepresentation client : clients) {
            Set<RoleRepresentation> clientRoleComposites = findClientComposites(realmName, client.getClientId(), roleSupplier);
            clientComposites.addAll(client.getClientId(), new ArrayList<>(clientRoleComposites));
        }

        return clientComposites;
    }

    private Set<RoleRepresentation> findClientComposites(String realmName, String clientId, Supplier<RoleResource> roleSupplier) {
        RoleResource roleResource = roleSupplier.get();
        ClientRepresentation client = clientRepository.getByClientId(realmName, clientId);

        return roleResource.getClientRoleComposites(client.getId());
    }

    private List<RoleRepresentation> findAllClientRoles(String realmName, Map<String, List<String>> clientCompositesToRemove) {
        List<RoleRepresentation> clientRolesToRemove = new ArrayList<>();

        for (Map.Entry<String, List<String>> clientCompositeToRemove : clientCompositesToRemove.entrySet()) {
            String clientId = clientCompositeToRemove.getKey();

            for (String role : clientCompositeToRemove.getValue()) {
                clientRolesToRemove.add(roleRepository.getClientRole(realmName, clientId, role));
            }
        }

        return clientRolesToRemove;
    }

    private RoleResource loadRealmRole(String realmName, String roleName) {
        return roleRepository.loadRealmRole(realmName, roleName);
    }

    private RoleResource loadClientRole(String realmName, String clientId, String roleName) {
        return roleRepository.loadClientRole(realmName, clientId, roleName);
    }
}
