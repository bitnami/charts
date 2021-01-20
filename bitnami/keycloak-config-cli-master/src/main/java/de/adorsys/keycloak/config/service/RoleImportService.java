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

import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.properties.ImportConfigProperties;
import de.adorsys.keycloak.config.repository.RoleRepository;
import de.adorsys.keycloak.config.service.rolecomposites.client.ClientRoleCompositeImportService;
import de.adorsys.keycloak.config.service.rolecomposites.realm.RealmRoleCompositeImportService;
import de.adorsys.keycloak.config.service.state.StateService;
import de.adorsys.keycloak.config.util.CloneUtil;
import de.adorsys.keycloak.config.util.KeycloakUtil;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.RolesRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Collectors;

@Service
public class RoleImportService {
    private static final Logger logger = LoggerFactory.getLogger(RoleImportService.class);

    private final RealmRoleCompositeImportService realmRoleCompositeImport;
    private final ClientRoleCompositeImportService clientRoleCompositeImport;

    private final RoleRepository roleRepository;
    private final ImportConfigProperties importConfigProperties;
    private final StateService stateService;

    @Autowired
    public RoleImportService(
            RealmRoleCompositeImportService realmRoleCompositeImportService,
            ClientRoleCompositeImportService clientRoleCompositeImportService,
            RoleRepository roleRepository,
            ImportConfigProperties importConfigProperties, StateService stateService) {
        this.realmRoleCompositeImport = realmRoleCompositeImportService;
        this.clientRoleCompositeImport = clientRoleCompositeImportService;
        this.roleRepository = roleRepository;
        this.importConfigProperties = importConfigProperties;
        this.stateService = stateService;
    }

    public void doImport(RealmImport realmImport) {
        RolesRepresentation roles = realmImport.getRoles();
        if (roles == null) return;

        String realmName = realmImport.getRealm();

        boolean realmRoleInImport = roles.getRealm() != null;
        boolean clientRoleInImport = roles.getClient() != null;

        List<RoleRepresentation> existingRealmRoles = null;
        Map<String, List<RoleRepresentation>> existingClientRoles = null;

        if (realmRoleInImport) {
            existingRealmRoles = roleRepository.getRealmRoles(realmName);
        }
        if (clientRoleInImport) {
            existingClientRoles = roleRepository.getClientRoles(realmName);
        }

        if (importConfigProperties.getManaged().getRole() == ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues.FULL) {
            if (realmRoleInImport) {
                deleteRealmRolesMissingInImport(realmName, roles.getRealm(), existingRealmRoles);
            }
            if (clientRoleInImport) {
                deleteClientRolesMissingInImport(realmName, roles.getClient(), existingClientRoles);
            }
        }


        if (realmRoleInImport) {
            createOrUpdateRealmRoles(realmName, roles.getRealm(), existingRealmRoles);
        }
        if (clientRoleInImport) {
            createOrUpdateClientRoles(realmName, roles.getClient(), existingClientRoles);
        }


        if (realmRoleInImport) {
            realmRoleCompositeImport.update(realmName, roles.getRealm());
        }
        if (clientRoleInImport) {
            clientRoleCompositeImport.update(realmName, roles.getClient());
        }
    }

    private void createOrUpdateRealmRoles(
            String realmName,
            List<RoleRepresentation> rolesToImport,
            List<RoleRepresentation> existingRealmRoles
    ) {
        Consumer<RoleRepresentation> loop = role -> createOrUpdateRealmRole(realmName, role, existingRealmRoles);
        if (importConfigProperties.isParallel()) {
            rolesToImport.parallelStream().forEach(loop);
        } else {
            rolesToImport.forEach(loop);
        }
    }

    private void createOrUpdateRealmRole(
            String realmName,
            RoleRepresentation roleToImport,
            List<RoleRepresentation> existingRoles
    ) {
        String roleName = roleToImport.getName();

        RoleRepresentation existingRole = existingRoles.stream()
                .filter(r -> Objects.equals(r.getName(), roleToImport.getName()))
                .findFirst().orElse(null);

        if (existingRole != null) {
            updateClientIfNeeded(realmName, existingRole, roleToImport);
        } else {
            logger.debug("Create realm-level role '{}' in realm '{}'", roleName, realmName);
            roleRepository.createRealmRole(realmName, roleToImport);
        }
    }

    private void createOrUpdateClientRoles(
            String realmName,
            Map<String, List<RoleRepresentation>> rolesToImport,
            Map<String, List<RoleRepresentation>> existingRoles
    ) {
        for (Map.Entry<String, List<RoleRepresentation>> client : rolesToImport.entrySet()) {
            String clientId = client.getKey();
            List<RoleRepresentation> clientRoles = client.getValue();

            for (RoleRepresentation role : clientRoles) {
                createOrUpdateClientRole(realmName, clientId, role, existingRoles);
            }
        }
    }

    private void createOrUpdateClientRole(
            String realmName,
            String clientId,
            RoleRepresentation roleToImport,
            Map<String, List<RoleRepresentation>> existingRoles
    ) {
        String roleName = roleToImport.getName();

        if (!existingRoles.containsKey(clientId)) {
            throw new ImportProcessingException("Can't create role '" + roleName
                    + "' for non existing client '" + clientId + "' in realm '" + realmName + "'!");
        }

        RoleRepresentation existingClientRole = existingRoles.get(clientId).stream()
                .filter(r -> Objects.equals(r.getName(), roleToImport.getName()))
                .findFirst().orElse(null);

        if (existingClientRole != null) {
            updateClientRoleIfNecessary(realmName, clientId, existingClientRole, roleToImport);
        } else {
            logger.debug("Create client-level role '{}' for client '{}' in realm '{}'", roleName, clientId, realmName);
            roleRepository.createClientRole(realmName, clientId, roleToImport);
        }
    }

    private void updateClientIfNeeded(
            String realmName,
            RoleRepresentation existingRole,
            RoleRepresentation roleToImport
    ) {
        String roleName = roleToImport.getName();
        RoleRepresentation patchedRole = CloneUtil.deepPatch(existingRole, roleToImport);
        if (roleToImport.getAttributes() != null) {
            patchedRole.setAttributes(roleToImport.getAttributes());
        }

        if (!CloneUtil.deepEquals(existingRole, patchedRole)) {
            logger.debug("Update realm-level role '{}' in realm '{}'", roleName, realmName);
            roleRepository.updateRealmRole(realmName, patchedRole);
        } else {
            logger.debug("No need to update realm-level '{}' in realm '{}'", roleName, realmName);
        }
    }

    private void updateClientRoleIfNecessary(
            String realmName,
            String clientId,
            RoleRepresentation existingRole,
            RoleRepresentation roleToImport
    ) {
        RoleRepresentation patchedRole = CloneUtil.deepPatch(existingRole, roleToImport);
        String roleName = existingRole.getName();

        if (CloneUtil.deepEquals(existingRole, patchedRole)) {
            logger.debug("No need to update client-level role '{}' for client '{}' in realm '{}'", roleName, clientId, realmName);
        } else {
            logger.debug("Update client-level role '{}' for client '{}' in realm '{}'", roleName, clientId, realmName);
            roleRepository.updateClientRole(realmName, clientId, patchedRole);
        }
    }

    private void deleteRealmRolesMissingInImport(
            String realmName,
            List<RoleRepresentation> importedRoles,
            List<RoleRepresentation> existingRoles
    ) {
        if (importConfigProperties.isState()) {
            List<String> realmRolesInState = stateService.getRealmRoles();

            // ignore all object there are not in state
            existingRoles = existingRoles.stream()
                    .filter(role -> realmRolesInState.contains(role.getName()))
                    .collect(Collectors.toList());
        }

        Set<String> importedRealmRoles = importedRoles.stream()
                .map(RoleRepresentation::getName)
                .collect(Collectors.toSet());

        for (RoleRepresentation existingRole : existingRoles) {
            if (KeycloakUtil.isDefaultRole(existingRole) || importedRealmRoles.contains(existingRole.getName())) {
                continue;
            }

            logger.debug("Delete realm-level role '{}' in realm '{}'", existingRole.getName(), realmName);
            roleRepository.deleteRealmRole(realmName, existingRole);
        }
    }

    private void deleteClientRolesMissingInImport(
            String realmName,
            Map<String, List<RoleRepresentation>> importedClientsRoles,
            Map<String, List<RoleRepresentation>> existingRoles
    ) {
        if (importConfigProperties.isState()) {
            for (Map.Entry<String, List<RoleRepresentation>> client : existingRoles.entrySet()) {
                List<String> clientRolesInState = stateService.getClientRoles(client.getKey());

                // ignore all object there are not in state
                List<RoleRepresentation> clientRoles = client.getValue().stream()
                        .filter(role -> clientRolesInState.contains(role.getName()))
                        .collect(Collectors.toList());

                existingRoles.replace(client.getKey(), clientRoles);
            }
        }

        for (Map.Entry<String, List<RoleRepresentation>> client : existingRoles.entrySet()) {
            Set<String> importedClientRoles = importedClientsRoles.containsKey(client.getKey())
                    ? importedClientsRoles.get(client.getKey()).stream()
                    .map(RoleRepresentation::getName)
                    .collect(Collectors.toSet())
                    : null;

            for (RoleRepresentation existingRole : client.getValue()) {
                if (KeycloakUtil.isDefaultRole(existingRole)) continue;
                if (importedClientRoles != null && importedClientRoles.contains(existingRole.getName())) continue;

                logger.debug("Delete client-level role '{}' for client '{}' in realm '{}'", existingRole.getName(), client.getKey(), realmName);
                roleRepository.deleteClientRole(realmName, client.getKey(), existingRole);
            }
        }
    }
}
