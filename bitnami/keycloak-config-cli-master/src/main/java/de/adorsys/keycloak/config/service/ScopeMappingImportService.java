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
import de.adorsys.keycloak.config.properties.ImportConfigProperties;
import de.adorsys.keycloak.config.properties.ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues;
import de.adorsys.keycloak.config.repository.RealmRepository;
import de.adorsys.keycloak.config.repository.ScopeMappingRepository;
import org.keycloak.representations.idm.RealmRepresentation;
import org.keycloak.representations.idm.ScopeMappingRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ScopeMappingImportService {
    private static final Logger logger = LoggerFactory.getLogger(ScopeMappingImportService.class);

    private final RealmRepository realmRepository;
    private final ScopeMappingRepository scopeMappingRepository;
    private final ImportConfigProperties importConfigProperties;

    @Autowired
    public ScopeMappingImportService(
            RealmRepository realmRepository,
            ScopeMappingRepository scopeMappingRepository,
            ImportConfigProperties importConfigProperties
    ) {
        this.realmRepository = realmRepository;
        this.scopeMappingRepository = scopeMappingRepository;
        this.importConfigProperties = importConfigProperties;
    }

    public void doImport(RealmImport realmImport) {
        createOrUpdateScopeMappings(realmImport);
    }

    private void createOrUpdateScopeMappings(RealmImport realmImport) {
        List<ScopeMappingRepresentation> scopeMappingsToImport = realmImport.getScopeMappings();
        if (scopeMappingsToImport == null) return;

        String realmName = realmImport.getRealm();
        RealmRepresentation existingRealm = realmRepository.partialExport(realmName, true, true);
        List<ScopeMappingRepresentation> existingScopeMappings = existingRealm.getScopeMappings();

        createOrUpdateRolesInScopeMappings(realmName, scopeMappingsToImport, existingScopeMappings);

        if (importConfigProperties.getManaged().getScopeMapping() == ImportManagedPropertiesValues.FULL) {
            cleanupRolesInScopeMappingsIfNecessary(realmName, scopeMappingsToImport, existingScopeMappings);
        }
    }

    private void createOrUpdateRolesInScopeMappings(
            String realmName,
            List<ScopeMappingRepresentation> scopeMappingsToImport, List<ScopeMappingRepresentation> existingScopeMappings
    ) {
        for (ScopeMappingRepresentation scopeMappingToImport : scopeMappingsToImport) {
            Optional<ScopeMappingRepresentation> maybeExistingScopeMapping = tryToFindExistingScopeMapping(existingScopeMappings, scopeMappingToImport);

            if (maybeExistingScopeMapping.isPresent()) {
                updateScopeMappings(realmName, scopeMappingToImport, maybeExistingScopeMapping.get());
            } else {
                logger.debug("Adding scope-mapping with roles '{}' for {} '{}' in realm '{}'",
                        scopeMappingToImport.getRoles(),
                        scopeMappingToImport.getClient() == null ? "client-scope" : "client",
                        scopeMappingToImport.getClient() == null ? scopeMappingToImport.getClientScope() : scopeMappingToImport.getClient(),
                        realmName
                );

                scopeMappingRepository.addScopeMapping(realmName, scopeMappingToImport);
            }
        }
    }

    private void cleanupRolesInScopeMappingsIfNecessary(
            String realmName,
            List<ScopeMappingRepresentation> scopeMappingsToImport, List<ScopeMappingRepresentation> existingScopeMappings
    ) {
        if (existingScopeMappings != null) {
            cleanupRolesInScopeMappings(realmName, scopeMappingsToImport, existingScopeMappings);
        }
    }

    private void cleanupRolesInScopeMappings(
            String realmName,
            List<ScopeMappingRepresentation> scopeMappingsToImport, List<ScopeMappingRepresentation> existingScopeMappings
    ) {
        for (ScopeMappingRepresentation existingScopeMapping : existingScopeMappings) {
            if (hasToBeDeleted(scopeMappingsToImport, existingScopeMapping)) {
                cleanupRolesInScopeMapping(realmName, existingScopeMapping);
            }
        }
    }

    private void cleanupRolesInScopeMapping(String realmName, ScopeMappingRepresentation existingScopeMapping) {
        String client = existingScopeMapping.getClient();
        String clientScope = existingScopeMapping.getClientScope();

        if (client != null) {
            logger.debug("Remove all roles from scope-mapping for client '{}' in realm '{}'", client, realmName);
            scopeMappingRepository.removeScopeMappingRolesForClient(realmName, client, existingScopeMapping.getRoles());
        } else if (clientScope != null) {
            logger.debug("Remove all roles from scope-mapping for client-scope '{}' in realm '{}'", clientScope, realmName);
            scopeMappingRepository.removeScopeMappingRolesForClientScope(realmName, clientScope, existingScopeMapping.getRoles());
        }
    }

    private boolean hasToBeDeleted(List<ScopeMappingRepresentation> scopeMappingsToImport, ScopeMappingRepresentation existingScopeMapping) {
        return !existingScopeMapping.getRoles().isEmpty()
                && scopeMappingsToImport.stream()
                .filter(scopeMappingToImport -> areScopeMappingsEqual(scopeMappingToImport, existingScopeMapping))
                .count() < 1;
    }

    private void updateScopeMappings(String realmName, ScopeMappingRepresentation scopeMappingToImport, ScopeMappingRepresentation existingScopeMapping) {
        Set<String> scopeMappingRolesToImport = scopeMappingToImport.getRoles();

        addRoles(realmName, existingScopeMapping, scopeMappingRolesToImport);
        removeRoles(realmName, existingScopeMapping, scopeMappingRolesToImport);
    }

    private void removeRoles(String realmName, ScopeMappingRepresentation existingScopeMapping, Set<String> scopeMappingRolesToImport) {
        Set<String> existingScopeMappingRoles = existingScopeMapping.getRoles();

        List<String> rolesToBeRemoved = existingScopeMappingRoles.stream()
                .filter(role -> !scopeMappingRolesToImport.contains(role))
                .collect(Collectors.toList());

        String client = existingScopeMapping.getClient();
        String clientScope = existingScopeMapping.getClientScope();

        removeRolesFromScopeMappingIfNecessary(realmName, rolesToBeRemoved, client, clientScope);
    }

    private void addRoles(String realmName, ScopeMappingRepresentation existingScopeMapping, Set<String> scopeMappingRolesToImport) {
        String client = existingScopeMapping.getClient();
        String clientScope = existingScopeMapping.getClientScope();

        Set<String> existingScopeMappingRoles = existingScopeMapping.getRoles();

        List<String> rolesToBeAdded = scopeMappingRolesToImport.stream()
                .filter(role -> !existingScopeMappingRoles.contains(role))
                .collect(Collectors.toList());

        addRolesToScopeMappingIfNecessary(realmName, client, clientScope, rolesToBeAdded);
    }

    private void addRolesToScopeMappingIfNecessary(String realmName, String client, String clientScope, List<String> rolesToBeAdded) {
        if (!rolesToBeAdded.isEmpty()) {
            if (client != null) {
                logger.debug("Add roles '{}' to scope-mapping for client '{}' in realm '{}'", rolesToBeAdded, client, realmName);
                scopeMappingRepository.addScopeMappingRolesForClient(realmName, client, rolesToBeAdded);
            } else if (clientScope != null) {
                logger.debug("Add roles '{}' to scope-mapping for client-scope '{}' in realm '{}'", rolesToBeAdded, clientScope, realmName);
                scopeMappingRepository.addScopeMappingRolesForClientScope(realmName, clientScope, rolesToBeAdded);
            }
        } else {
            if (client != null) {
                logger.trace("No need to add roles to scope-mapping for client '{}' in realm '{}'", client, realmName);
            } else if (clientScope != null) {
                logger.trace("No need to add roles to scope-mapping for client-scope '{}' in realm '{}'", clientScope, realmName);
            }
        }
    }

    private void removeRolesFromScopeMappingIfNecessary(String realmName, List<String> rolesToBeRemoved, String client, String clientScope) {
        if (!rolesToBeRemoved.isEmpty()) {
            if (client != null) {
                logger.debug("Remove roles '{}' from scope-mapping for client '{}' in realm '{}'", rolesToBeRemoved, client, realmName);
                scopeMappingRepository.removeScopeMappingRolesForClient(realmName, client, rolesToBeRemoved);
            } else if (clientScope != null) {
                logger.debug("Remove roles '{}' from scope-mapping for client-scope '{}' in realm '{}'", rolesToBeRemoved, clientScope, realmName);
                scopeMappingRepository.removeScopeMappingRolesForClientScope(realmName, clientScope, rolesToBeRemoved);
            }
        } else {
            if (client != null) {
                logger.trace("No need to remove roles to scope-mapping for client '{}' in realm '{}'", client, realmName);
            } else if (clientScope != null) {
                logger.trace("No need to remove roles to scope-mapping for client-scope '{}' in realm '{}'", clientScope, realmName);
            }
        }
    }

    private Optional<ScopeMappingRepresentation> tryToFindExistingScopeMapping(List<ScopeMappingRepresentation> scopeMappings, ScopeMappingRepresentation scopeMappingToBeFound) {
        if (scopeMappings == null) {
            return Optional.empty();
        }

        return scopeMappings.stream()
                .filter(scopeMapping -> areScopeMappingsEqual(scopeMapping, scopeMappingToBeFound))
                .findFirst();
    }

    public boolean areScopeMappingsEqual(ScopeMappingRepresentation first, ScopeMappingRepresentation second) {
        if (Objects.equals(first, second)) {
            return true;
        }

        if (first == null || second == null) {
            return false;
        }

        String client = first.getClient();
        String clientScope = first.getClientScope();

        return Objects.equals(second.getClient(), client) && Objects.equals(second.getClientScope(), clientScope);
    }
}
