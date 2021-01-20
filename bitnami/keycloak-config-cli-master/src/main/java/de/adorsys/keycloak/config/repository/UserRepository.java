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
import de.adorsys.keycloak.config.exception.KeycloakRepositoryException;
import de.adorsys.keycloak.config.exception.KeycloakVersionUnsupportedException;
import de.adorsys.keycloak.config.util.InvokeUtil;
import de.adorsys.keycloak.config.util.ResponseUtil;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import javax.ws.rs.core.Response;

@Service
public class UserRepository {

    private final RealmRepository realmRepository;

    @Autowired
    public UserRepository(RealmRepository realmRepository) {
        this.realmRepository = realmRepository;
    }

    public Optional<UserRepresentation> search(String realmName, String username) {
        UsersResource usersResource = realmRepository.getResource(realmName).users();
        List<UserRepresentation> foundUsers;

        //TODO: drop reflection if we only support keycloak 11 or later
        try {
            foundUsers = InvokeUtil.invoke(
                    usersResource, "search",
                    new Class[]{String.class, Boolean.class},
                    new Object[]{username, true},
                    List.class, UserRepresentation.class
            );
        } catch (KeycloakVersionUnsupportedException error) {
            foundUsers = usersResource.search(username);
            foundUsers = foundUsers.stream()
                    .filter(u -> Objects.equals(u.getUsername(), username))
                    .collect(Collectors.toList());
        } catch (InvocationTargetException error) {
            throw new ImportProcessingException(error);
        }

        Optional<UserRepresentation> user;
        if (foundUsers.isEmpty()) {
            user = Optional.empty();
        } else {
            user = Optional.of(foundUsers.get(0));
        }

        return user;
    }

    final UserResource getResource(String realmName, String username) {
        UserRepresentation user = get(realmName, username);
        return realmRepository.getResource(realmName).users().get(user.getId());
    }

    public UserRepresentation get(String realmName, String username) {
        Optional<UserRepresentation> user = search(realmName, username);

        return user.orElseThrow(() -> new KeycloakRepositoryException("Cannot find user '" + username + "' in realm '" + realmName + "'"));
    }

    public void create(String realmName, UserRepresentation userToCreate) {
        RealmResource realmResource = realmRepository.getResource(realmName);
        UsersResource usersResource = realmResource.users();

        Response response = usersResource.create(userToCreate);

        ResponseUtil.validate(response);
    }

    public void updateUser(String realmName, UserRepresentation user) {
        UserResource userResource = getResource(realmName, user.getUsername());
        userResource.update(user);
    }

    public List<GroupRepresentation> getGroups(String realmName, UserRepresentation user) {
        UserResource userResource = getResource(realmName, user.getUsername());
        return userResource.groups();
    }
}
