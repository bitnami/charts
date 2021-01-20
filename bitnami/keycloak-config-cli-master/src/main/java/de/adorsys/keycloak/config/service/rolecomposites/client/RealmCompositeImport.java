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

import de.adorsys.keycloak.config.repository.RoleCompositeRepository;
import org.keycloak.representations.idm.RoleRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service("clientRoleRealmCompositeImport")
public class RealmCompositeImport {
    private static final Logger logger = LoggerFactory.getLogger(RealmCompositeImport.class);

    private final RoleCompositeRepository roleCompositeRepository;

    @Autowired
    public RealmCompositeImport(RoleCompositeRepository roleCompositeRepository) {
        this.roleCompositeRepository = roleCompositeRepository;
    }

    public void update(String realmName, String roleClientId, RoleRepresentation clientRole, Set<String> realmComposites) {
        String roleName = clientRole.getName();
        Set<String> existingRealmCompositeNames = findClientRoleRealmCompositeNames(realmName, roleClientId, roleName);

        if (Objects.equals(realmComposites, existingRealmCompositeNames)) {
            logger.debug("No need to update client-level role '{}'s composites realm-roles in realm '{}'", roleName, realmName);
        } else {
            logger.debug("Update client-level role '{}'s composites realm-roles in realm '{}'", roleName, realmName);
            updateClientRoleRealmComposites(realmName, roleClientId, roleName, realmComposites, existingRealmCompositeNames);
        }
    }

    private Set<String> findClientRoleRealmCompositeNames(String realmName, String roleClientId, String roleName) {
        Set<RoleRepresentation> existingRealmComposites = roleCompositeRepository.searchClientRoleRealmComposites(realmName, roleClientId, roleName);

        return existingRealmComposites.stream()
                .map(RoleRepresentation::getName)
                .collect(Collectors.toSet());
    }

    private void updateClientRoleRealmComposites(String realmName, String roleClientId, String roleName, Set<String> realmComposites, Set<String> existingRealmCompositeNames) {
        removeClientRoleRealmComposites(realmName, roleClientId, roleName, existingRealmCompositeNames, realmComposites);
        addClientRoleRealmComposites(realmName, roleClientId, roleName, existingRealmCompositeNames, realmComposites);
    }

    private void removeClientRoleRealmComposites(String realmName, String roleClientId, String roleName, Set<String> existingRealmCompositeNames, Set<String> realmComposites) {
        Set<String> realmCompositesToRemove = existingRealmCompositeNames.stream()
                .filter(name -> !realmComposites.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.removeClientRoleRealmComposites(realmName, roleClientId, roleName, realmCompositesToRemove);
    }

    private void addClientRoleRealmComposites(String realmName, String roleClientId, String roleName, Set<String> existingRealmCompositeNames, Set<String> realmComposites) {
        Set<String> realmCompositesToAdd = realmComposites.stream()
                .filter(name -> !existingRealmCompositeNames.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.addClientRoleRealmComposites(
                realmName,
                roleClientId,
                roleName,
                realmCompositesToAdd
        );
    }
}
