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

package de.adorsys.keycloak.config.service.rolecomposites.realm;

import de.adorsys.keycloak.config.repository.RoleCompositeRepository;
import org.keycloak.representations.idm.RoleRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service("realmRoleRealmCompositeImport")
public class RealmCompositeImport {
    private static final Logger logger = LoggerFactory.getLogger(RealmCompositeImport.class);

    private final RoleCompositeRepository roleCompositeRepository;

    @Autowired
    public RealmCompositeImport(RoleCompositeRepository roleCompositeRepository) {
        this.roleCompositeRepository = roleCompositeRepository;
    }

    public void update(String realmName, RoleRepresentation realmRole, Set<String> realmComposites) {
        String roleName = realmRole.getName();

        Set<String> existingRealmCompositeNames = findRealmRoleRealmCompositeNames(realmName, roleName);

        if (Objects.equals(realmComposites, existingRealmCompositeNames)) {
            logger.debug("No need to update realm-level role '{}'s composites realm-roles in realm '{}'", roleName, realmName);
        } else {
            logger.debug("Update realm-level role '{}'s composites realm-roles in realm '{}'", roleName, realmName);

            updateRealmRoleRealmComposites(realmName, roleName, existingRealmCompositeNames, realmComposites);
        }
    }

    private Set<String> findRealmRoleRealmCompositeNames(String realmName, String roleName) {
        Set<RoleRepresentation> existingRealmComposites = roleCompositeRepository.searchRealmRoleRealmComposites(realmName, roleName);

        return existingRealmComposites.stream()
                .map(RoleRepresentation::getName)
                .collect(Collectors.toSet());
    }

    private void updateRealmRoleRealmComposites(String realmName, String roleName, Set<String> existingRealmCompositeNames, Set<String> realmComposites) {
        removeRealmRoleRealmComposites(realmName, roleName, existingRealmCompositeNames, realmComposites);
        addRealmRoleRealmComposites(realmName, roleName, existingRealmCompositeNames, realmComposites);
    }

    private void removeRealmRoleRealmComposites(String realmName, String roleName, Set<String> existingRealmCompositeNames, Set<String> realmComposites) {
        Set<String> realmCompositesToRemove = existingRealmCompositeNames.stream()
                .filter(name -> !realmComposites.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.removeRealmRoleRealmComposites(realmName, roleName, realmCompositesToRemove);
    }

    private void addRealmRoleRealmComposites(String realmName, String roleName, Set<String> existingRealmCompositeNames, Set<String> realmComposites) {
        Set<String> realmCompositesToAdd = realmComposites.stream()
                .filter(name -> !existingRealmCompositeNames.contains(name))
                .collect(Collectors.toSet());

        roleCompositeRepository.addRealmRoleRealmComposites(
                realmName,
                roleName,
                realmCompositesToAdd
        );
    }
}
