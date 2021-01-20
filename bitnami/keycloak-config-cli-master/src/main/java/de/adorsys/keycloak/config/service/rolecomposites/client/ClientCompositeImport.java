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

package de.adorsys.keycloak.config.service.rolecomposites.client;

import de.adorsys.keycloak.config.repository.ClientRepository;
import de.adorsys.keycloak.config.repository.RoleCompositeRepository;
import org.keycloak.representations.idm.RoleRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service("clientRoleClientCompositeImport")
public class ClientCompositeImport {
    private static final Logger logger = LoggerFactory.getLogger(ClientCompositeImport.class);

    private final ClientRepository clientRepository;
    private final RoleCompositeRepository roleCompositeRepository;

    @Autowired
    public ClientCompositeImport(
            ClientRepository clientRepository,
            RoleCompositeRepository roleCompositeRepository
    ) {
        this.clientRepository = clientRepository;
        this.roleCompositeRepository = roleCompositeRepository;
    }

    public void update(String realmName, String roleClientId, String roleName, Map<String, List<String>> clientComposites) {
        for (Map.Entry<String, List<String>> clientCompositesByClients : clientComposites.entrySet()) {
            String clientId = clientCompositesByClients.getKey();
            List<String> clientCompositesByClient = clientCompositesByClients.getValue();

            updateClientComposites(realmName, roleClientId, roleName, clientId, clientCompositesByClient);
        }

        removeClientRoleClientComposites(realmName, roleClientId, roleName, clientComposites);
    }

    private void updateClientComposites(
            String realmName,
            String roleClientId,
            String roleName,
            String clientId,
            List<String> composites
    ) {
        List<String> existingClientCompositeNames = findClientRoleClientCompositeNames(realmName, roleClientId, roleName, clientId);

        if (Objects.equals(existingClientCompositeNames, composites)) {
            logger.debug("No need to update client-level role '{}'s composites client-roles for client '{}' in realm '{}'", roleName, clientId, realmName);
        } else {
            logger.debug("Update client-level role '{}'s composites client-roles for client '{}' in realm '{}'", roleName, clientId, realmName);

            removeClientRoleClientComposites(realmName, roleClientId, roleName, clientId, existingClientCompositeNames, composites);
            addClientRoleClientComposites(realmName, roleClientId, roleName, clientId, existingClientCompositeNames, composites);
        }
    }

    private List<String> findClientRoleClientCompositeNames(
            String realmName,
            String roleClientId,
            String realmRole,
            String clientId
    ) {
        Set<RoleRepresentation> existingClientComposites = roleCompositeRepository.searchClientRoleClientComposites(realmName, roleClientId, realmRole, clientId);

        return existingClientComposites.stream()
                .map(RoleRepresentation::getName)
                .collect(Collectors.toList());
    }

    private void removeClientRoleClientComposites(
            String realmName,
            String roleClientId,
            String realmRole,
            String clientId,
            Collection<String> existingClientCompositeNames,
            Collection<String> clientCompositesByClient
    ) {
        Set<String> clientRoleCompositesToRemove = existingClientCompositeNames.stream()
                .filter(name -> !clientCompositesByClient.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.removeClientRoleClientComposites(realmName, roleClientId, realmRole, clientId, clientRoleCompositesToRemove);
    }

    private void removeClientRoleClientComposites(
            String realmName,
            String roleClientId,
            String realmRole,
            Map<String, List<String>> clientComposites
    ) {
        Set<String> existingCompositeClients = clientRepository.getAllIds(realmName);

        Set<String> compositeClientsToRemove = existingCompositeClients.stream()
                .filter(name -> !clientComposites.containsKey(name))
                .collect(Collectors.toSet());

        Map<String, List<String>> clientCompositeRolesToBeRemoved = estimateClientCompositeRolesToBeRemoved(
                realmName,
                roleClientId,
                realmRole,
                compositeClientsToRemove
        );

        roleCompositeRepository.removeClientRoleClientComposites(realmName, roleClientId, realmRole, clientCompositeRolesToBeRemoved);
    }

    private void addClientRoleClientComposites(
            String realmName,
            String clientRoleId,
            String realmRole,
            String clientId,
            Collection<String> existingClientCompositeNames,
            Collection<String> clientCompositesByClient
    ) {
        Set<String> clientRoleCompositesToAdd = clientCompositesByClient.stream()
                .filter(name -> !existingClientCompositeNames.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.addClientRoleClientComposites(realmName, clientRoleId, realmRole, clientId, clientRoleCompositesToAdd);
    }

    private Map<String, List<String>> estimateClientCompositeRolesToBeRemoved(String realmName, String roleClientId, String roleName, Set<String> compositeClientsToRemove) {
        Map<String, List<String>> existingClientCompositeNames = roleCompositeRepository.searchClientRoleClientComposites(
                realmName,
                roleClientId,
                roleName
        );

        Map<String, List<String>> clientRolesToRemove = new HashMap<>();
        for (String clientId : compositeClientsToRemove) {
            if (existingClientCompositeNames.containsKey(clientId)) {
                clientRolesToRemove.put(clientId, existingClientCompositeNames.get(clientId));
            }
        }

        return clientRolesToRemove;
    }
}
