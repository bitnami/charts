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

import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.util.ResponseUtil;
import org.keycloak.admin.client.resource.*;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import javax.ws.rs.core.Response;

@Service
public class GroupRepository {

    private final RealmRepository realmRepository;
    private final RoleRepository roleRepository;
    private final ClientRepository clientRepository;
    private final UserRepository userRepository;

    @Autowired
    public GroupRepository(
            RealmRepository realmRepository,
            RoleRepository roleRepository,
            ClientRepository clientRepository,
            UserRepository userRepository) {
        this.realmRepository = realmRepository;
        this.roleRepository = roleRepository;
        this.clientRepository = clientRepository;
        this.userRepository = userRepository;
    }

    public List<GroupRepresentation> getAll(String realmName) {
        GroupsResource groupsResource = realmRepository.getResource(realmName)
                .groups();

        return groupsResource.groups();
    }

    public List<GroupRepresentation> findGroupsByGroupPath(String realmName, List<String> groupPaths) {
        List<GroupRepresentation> groups = new ArrayList<>();

        for (String groupPath : groupPaths) {
            try {
                GroupRepresentation group = getGroupByPath(realmName, groupPath);
                groups.add(group);
            } catch (Exception e) {
                throw new ImportProcessingException("Could not find group '" + groupPath + "' in realm '" + realmName + "'!");
            }
        }

        return groups;
    }

    public Optional<GroupRepresentation> searchByName(String realmName, String groupName) {
        GroupsResource groupsResource = realmRepository.getResource(realmName)
                .groups();

        return groupsResource.groups()
                .stream()
                .filter(g -> Objects.equals(g.getName(), groupName))
                .findFirst();
    }

    public void createGroup(String realmName, GroupRepresentation group) {
        Response response = realmRepository.getResource(realmName)
                .groups()
                .add(group);

        ResponseUtil.validate(response);
    }

    public void addSubGroup(String realmName, String parentGroupId, GroupRepresentation subGroup) {
        GroupResource groupResource = getResourceById(realmName, parentGroupId);
        Response response = groupResource.subGroup(subGroup);

        ResponseUtil.validate(response);
    }

    public GroupRepresentation getSubGroupByName(String realmName, String parentGroupId, String name) {
        GroupRepresentation existingGroup = getResourceById(realmName, parentGroupId).toRepresentation();

        return existingGroup.getSubGroups()
                .stream()
                .filter(subgroup -> Objects.equals(subgroup.getName(), name))
                .findFirst()
                .orElse(null);
    }

    public void addRealmRoles(String realmName, String groupId, List<String> roleNames) {
        GroupResource groupResource = getResourceById(realmName, groupId);
        RoleMappingResource groupRoles = groupResource.roles();
        RoleScopeResource groupRealmRoles = groupRoles.realmLevel();

        List<RoleRepresentation> existingRealmRoles = roleNames.stream()
                .map(realmRole -> roleRepository.getRealmRole(realmName, realmRole))
                .collect(Collectors.toList());

        groupRealmRoles.add(existingRealmRoles);
    }

    public void removeRealmRoles(String realmName, String groupId, List<String> roleNames) {
        GroupResource groupResource = getResourceById(realmName, groupId);
        RoleMappingResource groupRoles = groupResource.roles();
        RoleScopeResource groupRealmRoles = groupRoles.realmLevel();

        List<RoleRepresentation> existingRealmRoles = roleNames.stream()
                .map(realmRole -> roleRepository.getRealmRole(realmName, realmRole))
                .collect(Collectors.toList());

        groupRealmRoles.remove(existingRealmRoles);
    }

    public void deleteGroup(String realmName, String id) {
        GroupResource groupResource = getResourceById(realmName, id);
        groupResource.remove();
    }

    public void addGroupsToUser(String realmName, String username, List<GroupRepresentation> groups) {
        UserResource userResource = userRepository.getResource(realmName, username);
        for (GroupRepresentation group : groups) {
            userResource.joinGroup(group.getId());
        }
    }

    public void removeGroupsFromUser(String realmName, String username, List<GroupRepresentation> groups) {
        UserResource userResource = userRepository.getResource(realmName, username);
        for (GroupRepresentation group : groups) {
            userResource.leaveGroup(group.getId());
        }
    }


    public void addClientRoles(String realmName, String groupId, String clientId, List<String> roleNames) {
        GroupResource groupResource = getResourceById(realmName, groupId);
        RoleMappingResource rolesResource = groupResource.roles();

        ClientRepresentation client = clientRepository.getByClientId(realmName, clientId);
        RoleScopeResource groupClientRolesResource = rolesResource.clientLevel(client.getId());

        List<RoleRepresentation> clientRoles = roleRepository.getClientRolesByName(realmName, clientId, roleNames);
        groupClientRolesResource.add(clientRoles);
    }

    public void removeClientRoles(String realmName, String groupId, String clientId, List<String> roleNames) {
        GroupResource groupResource = getResourceById(realmName, groupId);
        RoleMappingResource rolesResource = groupResource.roles();

        ClientRepresentation client = clientRepository.getByClientId(realmName, clientId);
        RoleScopeResource groupClientRolesResource = rolesResource.clientLevel(client.getId());

        List<RoleRepresentation> clientRoles = roleRepository.getClientRolesByName(realmName, clientId, roleNames);
        groupClientRolesResource.remove(clientRoles);
    }

    public void update(String realmName, GroupRepresentation group) {
        GroupResource groupResource = getResourceById(realmName, group.getId());
        groupResource.update(group);
    }

    public GroupRepresentation getGroupByName(String realmName, String groupName) {
        GroupResource groupResource = getResourceByName(realmName, groupName);

        if (groupResource == null) {
            return null;
        }

        return groupResource.toRepresentation();
    }

    public GroupRepresentation getGroupById(String realmName, String groupId) {
        GroupResource groupResource = getResourceById(realmName, groupId);
        return groupResource.toRepresentation();
    }

    public GroupRepresentation getGroupByPath(String realmName, String groupPath) {
        return realmRepository.getResource(realmName).getGroupByPath(groupPath);
    }

    private GroupResource getResourceByName(String realmName, String groupName) {
        Optional<GroupRepresentation> maybeGroup = searchByName(realmName, groupName);

        GroupRepresentation existingGroup = maybeGroup.orElse(null);

        if (existingGroup == null) {
            return null;
        }

        return getResourceById(realmName, existingGroup.getId());
    }

    private GroupResource getResourceById(String realmName, String groupId) {
        return realmRepository.getResource(realmName)
                .groups()
                .group(groupId);
    }
}
