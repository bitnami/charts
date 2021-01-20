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
import de.adorsys.keycloak.config.repository.GroupRepository;
import de.adorsys.keycloak.config.util.CloneUtil;
import org.keycloak.representations.idm.GroupRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Collectors;

@Service
public class GroupImportService {
    private static final Logger logger = LoggerFactory.getLogger(GroupImportService.class);

    private final GroupRepository groupRepository;
    private final ImportConfigProperties importConfigProperties;

    public GroupImportService(GroupRepository groupRepository, ImportConfigProperties importConfigProperties) {
        this.groupRepository = groupRepository;
        this.importConfigProperties = importConfigProperties;
    }

    public void importGroups(RealmImport realmImport) {
        List<GroupRepresentation> groups = realmImport.getGroups();
        String realmName = realmImport.getRealm();

        if (groups == null) {
            return;
        }

        List<GroupRepresentation> existingGroups = groupRepository.getAll(realmName);

        createOrUpdateGroups(groups, realmName);

        if (importConfigProperties.getManaged().getGroup() == ImportManagedPropertiesValues.FULL) {
            deleteGroupsMissingInImport(realmName, groups, existingGroups);
        }
    }

    public void createOrUpdateGroups(List<GroupRepresentation> groups, String realmName) {
        Consumer<GroupRepresentation> loop = group -> createOrUpdateRealmGroup(realmName, group);
        if (importConfigProperties.isParallel()) {
            groups.parallelStream().forEach(loop);
        } else {
            groups.forEach(loop);
        }
    }

    private void deleteGroupsMissingInImport(
            String realmName,
            List<GroupRepresentation> importedGroups,
            List<GroupRepresentation> existingGroups
    ) {
        Set<String> importedGroupNames = importedGroups.stream()
                .map(GroupRepresentation::getName)
                .collect(Collectors.toSet());

        for (GroupRepresentation existingGroup : existingGroups) {
            if (importedGroupNames.contains(existingGroup.getName())) continue;

            logger.debug("Delete group '{}' in realm '{}'", existingGroup.getName(), realmName);
            groupRepository.deleteGroup(realmName, existingGroup.getId());
        }
    }

    private void createOrUpdateRealmGroup(String realmName, GroupRepresentation group) {
        String groupName = group.getName();

        Optional<GroupRepresentation> maybeGroup = groupRepository.searchByName(realmName, groupName);

        if (maybeGroup.isPresent()) {
            updateGroupIfNecessary(realmName, group);
        } else {
            logger.debug("Create group '{}' in realm '{}'", groupName, realmName);
            createGroup(realmName, group);
        }
    }

    private void createGroup(String realmName, GroupRepresentation group) {
        groupRepository.createGroup(realmName, group);

        GroupRepresentation existingGroup = groupRepository.getGroupByName(realmName, group.getName());
        GroupRepresentation patchedGroup = CloneUtil.patch(existingGroup, group);

        addRealmRoles(realmName, patchedGroup);
        addClientRoles(realmName, patchedGroup);
        addSubGroups(realmName, patchedGroup);
    }

    private void addRealmRoles(String realmName, GroupRepresentation existingGroup) {
        List<String> realmRoles = existingGroup.getRealmRoles();

        if (realmRoles != null && !realmRoles.isEmpty()) {
            groupRepository.addRealmRoles(realmName, existingGroup.getId(), realmRoles);
        }
    }

    private void addClientRoles(String realmName, GroupRepresentation existingGroup) {
        Map<String, List<String>> existingClientRoles = existingGroup.getClientRoles();
        String groupId = existingGroup.getId();

        if (existingClientRoles != null && !existingClientRoles.isEmpty()) {
            for (Map.Entry<String, List<String>> existingClientRolesEntry : existingClientRoles.entrySet()) {
                String clientId = existingClientRolesEntry.getKey();
                List<String> clientRoleNames = existingClientRolesEntry.getValue();

                groupRepository.addClientRoles(realmName, groupId, clientId, clientRoleNames);
            }
        }
    }

    private void addSubGroups(String realmName, GroupRepresentation existingGroup) {
        List<GroupRepresentation> subGroups = existingGroup.getSubGroups();
        String groupId = existingGroup.getId();

        if (subGroups != null && !subGroups.isEmpty()) {
            for (GroupRepresentation subGroup : subGroups) {
                addSubGroup(realmName, groupId, subGroup);
            }
        }
    }

    public void addSubGroup(String realmName, String parentGroupId, GroupRepresentation subGroup) {
        groupRepository.addSubGroup(realmName, parentGroupId, subGroup);

        GroupRepresentation existingSubGroup = groupRepository.getSubGroupByName(realmName, parentGroupId, subGroup.getName());
        GroupRepresentation patchedGroup = CloneUtil.patch(existingSubGroup, subGroup);

        addRealmRoles(realmName, patchedGroup);
        addClientRoles(realmName, patchedGroup);
        addSubGroups(realmName, patchedGroup);
    }

    private void updateGroupIfNecessary(String realmName, GroupRepresentation group) {
        GroupRepresentation existingGroup = groupRepository.getGroupByName(realmName, group.getName());
        GroupRepresentation patchedGroup = CloneUtil.patch(existingGroup, group);
        String groupName = existingGroup.getName();

        if (isGroupEqual(existingGroup, patchedGroup)) {
            logger.debug("No need to update group '{}' in realm '{}'", groupName, realmName);
        } else {
            logger.debug("Update group '{}' in realm '{}'", groupName, realmName);
            updateGroup(realmName, group, patchedGroup);
        }
    }

    private boolean isGroupEqual(GroupRepresentation existingGroup, GroupRepresentation patchedGroup) {
        if (!CloneUtil.deepEquals(existingGroup, patchedGroup, "subGroups")) {
            return false;
        }

        List<GroupRepresentation> importedSubGroups = patchedGroup.getSubGroups();
        List<GroupRepresentation> existingSubGroups = existingGroup.getSubGroups();

        if (importedSubGroups.isEmpty() && existingSubGroups.isEmpty()) {
            return true;
        }

        if (importedSubGroups.size() != existingSubGroups.size()) {
            return false;
        }

        return areSubGroupsEqual(existingSubGroups, importedSubGroups);
    }

    private boolean areSubGroupsEqual(List<GroupRepresentation> existingSubGroups, List<GroupRepresentation> importedSubGroups) {
        for (GroupRepresentation importedSubGroup : importedSubGroups) {
            GroupRepresentation existingSubGroup = existingSubGroups.stream()
                    .filter(group -> Objects.equals(group.getName(), importedSubGroup.getName()))
                    .findFirst().orElse(null);

            if (existingSubGroup == null) {
                return false;
            }

            GroupRepresentation patchedSubGroup = CloneUtil.patch(existingSubGroup, importedSubGroup);

            if (!CloneUtil.deepEquals(existingSubGroup, patchedSubGroup, "id")) {
                return false;
            }
        }

        return true;
    }

    private void updateGroup(String realmName, GroupRepresentation group, GroupRepresentation patchedGroup) {
        groupRepository.update(realmName, patchedGroup);

        String groupId = patchedGroup.getId();

        List<String> realmRoles = group.getRealmRoles();
        if (realmRoles != null) {
            updateGroupRealmRoles(realmName, groupId, realmRoles);
        }

        Map<String, List<String>> clientRoles = group.getClientRoles();
        if (clientRoles != null) {
            updateGroupClientRoles(realmName, groupId, clientRoles);
        }

        List<GroupRepresentation> subGroups = group.getSubGroups();
        if (subGroups != null) {
            updateSubGroups(realmName, patchedGroup.getId(), subGroups);
        }
    }

    private void updateGroupRealmRoles(String realmName, String groupId, List<String> realmRoles) {
        GroupRepresentation existingGroup = groupRepository.getGroupById(realmName, groupId);

        List<String> existingRealmRolesNames = existingGroup.getRealmRoles();

        List<String> realmRoleNamesToAdd = estimateRealmRolesToAdd(realmRoles, existingRealmRolesNames);
        List<String> realmRoleNamesToRemove = estimateRealmRolesToRemove(realmRoles, existingRealmRolesNames);

        groupRepository.addRealmRoles(realmName, groupId, realmRoleNamesToAdd);
        groupRepository.removeRealmRoles(realmName, groupId, realmRoleNamesToRemove);
    }

    private List<String> estimateRealmRolesToRemove(List<String> realmRoles, List<String> existingRealmRolesNames) {
        List<String> realmRoleNamesToRemove = new ArrayList<>();

        for (String existingRealmRolesName : existingRealmRolesNames) {
            if (!realmRoles.contains(existingRealmRolesName)) {
                realmRoleNamesToRemove.add(existingRealmRolesName);
            }
        }

        return realmRoleNamesToRemove;
    }

    private List<String> estimateRealmRolesToAdd(List<String> realmRoles, List<String> existingRealmRolesNames) {
        List<String> realmRoleNamesToAdd = new ArrayList<>();

        for (String realmRoleName : realmRoles) {
            if (!existingRealmRolesNames.contains(realmRoleName)) {
                realmRoleNamesToAdd.add(realmRoleName);
            }
        }

        return realmRoleNamesToAdd;
    }

    private void updateGroupClientRoles(String realmName, String groupId, Map<String, List<String>> groupClientRoles) {
        GroupRepresentation existingGroup = groupRepository.getGroupById(realmName, groupId);

        Map<String, List<String>> existingClientRoleNames = existingGroup.getClientRoles();

        deleteClientRolesMissingInImport(realmName, groupId, existingClientRoleNames, groupClientRoles);
        updateClientRoles(realmName, groupId, existingClientRoleNames, groupClientRoles);
    }

    private void updateClientRoles(
            String realmName,
            String groupId,
            Map<String, List<String>> existingClientRoleNames,
            Map<String, List<String>> groupClientRoles
    ) {
        for (Map.Entry<String, List<String>> clientRole : groupClientRoles.entrySet()) {
            String clientId = clientRole.getKey();
            List<String> clientRoleNames = clientRole.getValue();

            List<String> existingClientRoleNamesForClient = existingClientRoleNames.get(clientId);

            List<String> clientRoleNamesToAdd = estimateClientRolesToAdd(existingClientRoleNamesForClient, clientRoleNames);
            List<String> clientRoleNamesToRemove = estimateClientRolesToRemove(existingClientRoleNamesForClient, clientRoleNames);

            groupRepository.addClientRoles(realmName, groupId, clientId, clientRoleNamesToAdd);
            groupRepository.removeClientRoles(realmName, groupId, clientId, clientRoleNamesToRemove);
        }
    }

    private void deleteClientRolesMissingInImport(
            String realmName,
            String groupId,
            Map<String, List<String>> existingClientRoleNames,
            Map<String, List<String>> groupClientRoles
    ) {
        for (Map.Entry<String, List<String>> existingClientRoleNamesEntry : existingClientRoleNames.entrySet()) {
            String clientId = existingClientRoleNamesEntry.getKey();
            List<String> clientRoleNames = existingClientRoleNamesEntry.getValue();

            if (!clientRoleNames.isEmpty() && !groupClientRoles.containsKey(clientId)) {
                groupRepository.removeClientRoles(realmName, groupId, clientId, clientRoleNames);
            }
        }
    }

    private List<String> estimateClientRolesToRemove(List<String> existingClientRoleNamesForClient, List<String> clientRoleNamesFromImport) {
        List<String> clientRoleNamesToRemove = new ArrayList<>();

        if (existingClientRoleNamesForClient != null) {
            for (String existingClientRoleNameForClient : existingClientRoleNamesForClient) {
                if (!clientRoleNamesFromImport.contains(existingClientRoleNameForClient)) {
                    clientRoleNamesToRemove.add(existingClientRoleNameForClient);
                }
            }
        }

        return clientRoleNamesToRemove;
    }

    private List<String> estimateClientRolesToAdd(List<String> existingClientRoleNamesForClient, List<String> clientRoleNamesFromImport) {
        List<String> clientRoleNamesToAdd = new ArrayList<>();

        for (String clientRoleName : clientRoleNamesFromImport) {
            if (existingClientRoleNamesForClient == null || !existingClientRoleNamesForClient.contains(clientRoleName)) {
                clientRoleNamesToAdd.add(clientRoleName);
            }
        }

        return clientRoleNamesToAdd;
    }

    private void updateSubGroups(String realmName, String parentGroupId, List<GroupRepresentation> subGroups) {
        GroupRepresentation existingGroup = groupRepository.getGroupById(realmName, parentGroupId);
        List<GroupRepresentation> existingSubGroups = existingGroup.getSubGroups();

        deleteAllSubGroupsMissingInImport(realmName, subGroups, existingSubGroups);

        Set<String> existingSubGroupNames = existingSubGroups.stream()
                .map(GroupRepresentation::getName)
                .collect(Collectors.toSet());

        for (GroupRepresentation subGroup : subGroups) {
            if (existingSubGroupNames.contains(subGroup.getName())) {
                updateSubGroupIfNecessary(realmName, parentGroupId, subGroup);
            } else {
                addSubGroup(realmName, parentGroupId, subGroup);
            }
        }
    }

    private void deleteAllSubGroupsMissingInImport(
            String realmName,
            List<GroupRepresentation> importedSubGroups,
            List<GroupRepresentation> existingSubGroups
    ) {
        Set<String> importedSubGroupNames = importedSubGroups.stream()
                .map(GroupRepresentation::getName)
                .collect(Collectors.toSet());

        for (GroupRepresentation existingSubGroup : existingSubGroups) {
            if (importedSubGroupNames.contains(existingSubGroup.getName())) continue;

            groupRepository.deleteGroup(realmName, existingSubGroup.getId());
        }
    }

    public void updateSubGroupIfNecessary(String realmName, String parentGroupId, GroupRepresentation subGroup) {
        String subGroupName = subGroup.getName();
        GroupRepresentation existingSubGroup = groupRepository.getSubGroupByName(realmName, parentGroupId, subGroupName);

        GroupRepresentation patchedSubGroup = CloneUtil.patch(existingSubGroup, subGroup);

        if (CloneUtil.deepEquals(existingSubGroup, patchedSubGroup)) {
            logger.debug("No need to update subGroup '{}' in group with id '{}' in realm '{}'", subGroupName, parentGroupId, realmName);
        } else {
            logger.debug("Update subGroup '{}' in group with id '{}' in realm '{}'", subGroupName, parentGroupId, realmName);

            updateGroup(realmName, subGroup, patchedSubGroup);
        }
    }
}
