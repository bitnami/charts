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

import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.repository.ClientRepository;
import de.adorsys.keycloak.config.repository.RealmRepository;
import de.adorsys.keycloak.config.repository.RoleRepository;
import org.keycloak.representations.idm.RealmRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.ScopeMappingRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class ClientScopeMappingImportService {
    private static final Logger logger = LoggerFactory.getLogger(ClientScopeMappingImportService.class);

    private final RealmRepository realmRepository;
    private final ClientRepository clientRepository;
    private final RoleRepository roleRepository;

    @Autowired
    public ClientScopeMappingImportService(
            RealmRepository realmRepository,
            ClientRepository clientRepository, RoleRepository roleRepository) {
        this.realmRepository = realmRepository;
        this.clientRepository = clientRepository;
        this.roleRepository = roleRepository;
    }

    public void doImport(RealmImport realmImport) {
        Map<String, List<ScopeMappingRepresentation>> clientScopeMappingsToImport = realmImport.getClientScopeMappings();
        if (clientScopeMappingsToImport == null) return;

        String realmName = realmImport.getRealm();
        RealmRepresentation existingRealm = realmRepository.partialExport(realmName, true, true);
        Map<String, List<ScopeMappingRepresentation>> existingClientScopeMappings = existingRealm.getClientScopeMappings();

        for (Map.Entry<String, List<ScopeMappingRepresentation>> scopeMappingToImport : clientScopeMappingsToImport.entrySet()) {
            updateClientScopeMapping(realmName, scopeMappingToImport.getKey(), scopeMappingToImport.getValue(), existingClientScopeMappings);
        }

        if (existingClientScopeMappings != null) {
            for (Map.Entry<String, List<ScopeMappingRepresentation>> existingClientScopeMapping : existingClientScopeMappings.entrySet()) {
                removeClientScopeMapping(realmName, existingClientScopeMapping.getKey(), existingClientScopeMapping.getValue(), clientScopeMappingsToImport);
            }
        }
    }

    private void updateClientScopeMapping(String realmName, String clientId, List<ScopeMappingRepresentation> clientScopeMappingsToImport,
                                          Map<String, List<ScopeMappingRepresentation>> existingClientScopeMappings) {
        String clientLevelUuid = clientRepository.getByClientId(realmName, clientId).getId();

        List<ScopeMappingRepresentation> existingClientScopeMapping = existingClientScopeMappings != null
                ? existingClientScopeMappings.getOrDefault(clientId, null)
                : null;

        addRoles(realmName, clientId, clientScopeMappingsToImport, existingClientScopeMapping, clientLevelUuid);
    }

    private void removeClientScopeMapping(String realmName, String clientId, List<ScopeMappingRepresentation> existingClientScopeMapping,
                                          Map<String, List<ScopeMappingRepresentation>> clientScopeMappingsToImport) {
        String clientLevelUuid = clientRepository.getByClientId(realmName, clientId).getId();

        List<ScopeMappingRepresentation> clientScopeMappingToImport = clientScopeMappingsToImport != null
                ? clientScopeMappingsToImport.getOrDefault(clientId, null)
                : null;

        removeRoles(realmName, clientId, existingClientScopeMapping, clientScopeMappingToImport, clientLevelUuid);
    }

    private void addRoles(String realmName,
                          String clientId,
                          List<ScopeMappingRepresentation> clientScopeMappingsToImport,
                          List<ScopeMappingRepresentation> existingClientScopes,
                          String clientLevelUuid
    ) {
        for (ScopeMappingRepresentation clientScopeMappingToImport : clientScopeMappingsToImport) {
            List<String> rolesToBeAdded = getRolesToBeAdded(clientScopeMappingToImport, existingClientScopes);
            if (rolesToBeAdded.isEmpty()) continue;

            logger.debug("Adding client-scope-mapping with roles '{}' from client level '{}' for client '{}' in realm '{}'",
                    clientId,
                    rolesToBeAdded,
                    clientScopeMappingToImport.getClient(),
                    realmName
            );

            List<RoleRepresentation> roles = roleRepository.getClientRolesByName(realmName, clientId, rolesToBeAdded);

            clientRepository.addScopeMapping(realmName, clientScopeMappingToImport.getClient(), clientLevelUuid, roles);
        }
    }

    private void removeRoles(String realmName,
                             String clientId,
                             List<ScopeMappingRepresentation> existingClientScopes,
                             List<ScopeMappingRepresentation> clientScopeMappingsToImport,
                             String clientLevelUuid
    ) {
        if (!clientRepository.searchByClientId(realmName, clientId).isPresent()) return;

        for (ScopeMappingRepresentation existingClientScope : existingClientScopes) {
            if (!clientRepository.searchByClientId(realmName, existingClientScope.getClient()).isPresent()) return;

            List<String> rolesToBeRemoved = getRolesToBeRemoved(clientScopeMappingsToImport, existingClientScope);
            if (rolesToBeRemoved.isEmpty()) continue;

            logger.debug("Remove client-scope-mapping with roles '{}' from client level '{}' for client '{}' in realm '{}'",
                    clientId,
                    rolesToBeRemoved,
                    existingClientScope.getClient(),
                    realmName
            );

            List<RoleRepresentation> roles = roleRepository.getClientRolesByName(realmName, clientId, rolesToBeRemoved);
            clientRepository.removeScopeMapping(realmName, existingClientScope.getClient(), clientLevelUuid, roles);
        }
    }

    private List<String> getRolesToBeAdded(ScopeMappingRepresentation clientScopeMappingToImport, List<ScopeMappingRepresentation> existingClientScopes) {
        if (existingClientScopes == null) {
            return new ArrayList<>(clientScopeMappingToImport.getRoles());
        }

        return clientScopeMappingToImport.getRoles().stream()
                .filter(clientScopeRoleToImport -> existingClientScopes.stream()
                        .noneMatch(existingClientScope -> Objects.equals(
                                clientScopeMappingToImport.getClient(),
                                existingClientScope.getClient()
                                ) && existingClientScope.getRoles().contains(clientScopeRoleToImport)
                        ))
                .collect(Collectors.toList());
    }

    private List<String> getRolesToBeRemoved(List<ScopeMappingRepresentation> clientScopeMappingsToImport, ScopeMappingRepresentation existingClientScope) {
        if (clientScopeMappingsToImport == null) {
            return new ArrayList<>(existingClientScope.getRoles());
        }

        return existingClientScope.getRoles().stream()
                .filter(existingRole -> clientScopeMappingsToImport.stream()
                        .noneMatch(clientScopeToImport -> Objects.equals(
                                clientScopeToImport.getClient(),
                                existingClientScope.getClient()
                                ) && clientScopeToImport.getRoles().contains(existingRole)
                        ))
                .collect(Collectors.toList());
    }
}
