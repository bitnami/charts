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

import de.adorsys.keycloak.config.AbstractImportTest;
import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.exception.InvalidImportException;
import de.adorsys.keycloak.config.model.RealmImport;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.representations.AccessTokenResponse;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.keycloak.representations.idm.UserRepresentation;

import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportUsersIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithUsers";

    ImportUsersIT() {
        this.resourcePath = "import-files/users";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithUser() {
        doImport("00_create_realm_with_user.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        UserRepresentation createdUser = keycloakRepository.getUser(REALM_NAME, "myuser");
        assertThat(createdUser.getUsername(), is("myuser"));
        assertThat(createdUser.getEmail(), is("myuser@mail.de"));
        assertThat(createdUser.isEnabled(), is(true));
        assertThat(createdUser.getFirstName(), is("My firstname"));
        assertThat(createdUser.getLastName(), is("My lastname"));

        Map<String, List<String>> createdUserAttributes = createdUser.getAttributes();
        assertThat(createdUserAttributes, notNullValue());
        assertThat(createdUserAttributes.get("locale"), contains("de"));
    }

    @Test
    @Order(1)
    void shouldUpdateRealmWithAddingClientUser() {
        doImport("01_update_realm_add_clientuser.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        UserRepresentation updatedUser = keycloakRepository.getUser(REALM_NAME, "myuser");
        assertThat(updatedUser.getUsername(), is("myuser"));
        assertThat(updatedUser.getEmail(), is("myuser@mail.de"));
        assertThat(updatedUser.isEnabled(), is(true));
        assertThat(updatedUser.getFirstName(), is("My firstname"));
        assertThat(updatedUser.getLastName(), is("My lastname"));

        Map<String, List<String>> updatedUserAttributes = updatedUser.getAttributes();
        assertThat(updatedUserAttributes, notNullValue());
        assertThat(updatedUserAttributes.get("locale"), contains("de"));

        UserRepresentation createdUser = keycloakRepository.getUser(REALM_NAME, "myclientuser");
        assertThat(createdUser.getUsername(), is("myclientuser"));
        assertThat(createdUser.getEmail(), is("myclientuser@mail.de"));
        assertThat(createdUser.isEnabled(), is(true));
        assertThat(createdUser.getFirstName(), is("My clientuser's firstname"));
        assertThat(createdUser.getLastName(), is("My clientuser's lastname"));

        // check if login with password is successful
        AccessTokenResponse token = keycloakAuthentication.login(
                REALM_NAME,
                "moped-client",
                "my-special-client-secret",
                "myclientuser",
                "myclientuser123"
        );

        assertThat(token.getToken(), notNullValue());
        assertThat(token.getRefreshToken(), notNullValue());
        assertThat(token.getExpiresIn(), greaterThan(0L));
        assertThat(token.getRefreshExpiresIn(), greaterThan(0L));
        assertThat(token.getTokenType(), equalToIgnoringCase("Bearer"));
    }

    @Test
    @Order(2)
    void shouldUpdateRealmWithChangedClientUserPassword() {
        doImport("02_update_realm_change_clientusers_password.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        UserRepresentation updatedUser = keycloakRepository.getUser(REALM_NAME, "myuser");
        assertThat(updatedUser.getUsername(), is("myuser"));
        assertThat(updatedUser.getEmail(), is("myuser@mail.de"));
        assertThat(updatedUser.isEnabled(), is(true));
        assertThat(updatedUser.getFirstName(), is("My firstname"));
        assertThat(updatedUser.getLastName(), is("My lastname"));

        Map<String, List<String>> updatedUserAttributes = updatedUser.getAttributes();
        assertThat(updatedUserAttributes, notNullValue());
        assertThat(updatedUserAttributes.get("locale"), contains("de"));

        UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "myclientuser");

        assertThat(user.getUsername(), is("myclientuser"));
        assertThat(user.getEmail(), is("myclientuser@mail.de"));
        assertThat(user.isEnabled(), is(true));
        assertThat(user.getFirstName(), is("My clientuser's firstname"));
        assertThat(user.getLastName(), is("My clientuser's lastname"));

        // check if login with old password fails
        assertThrows(javax.ws.rs.NotAuthorizedException.class, () ->
                keycloakAuthentication.login(
                        REALM_NAME,
                        "moped-client",
                        "my-special-client-secret",
                        "myclientuser",
                        "myclientuser123"
                )
        );

        // check if login with new password is successful
        AccessTokenResponse token = keycloakAuthentication.login(
                REALM_NAME,
                "moped-client",
                "my-special-client-secret",
                "myclientuser",
                "changedclientuser123"
        );

        assertThat(token.getToken(), notNullValue());
        assertThat(token.getRefreshToken(), notNullValue());
        assertThat(token.getExpiresIn(), greaterThan(0L));
        assertThat(token.getRefreshExpiresIn(), greaterThan(0L));
        assertThat(token.getTokenType(), equalToIgnoringCase("Bearer"));
    }

    /**
     * https://github.com/adorsys/keycloak-config-cli/issues/51
     */

    @Test
    @Order(3)
    void shouldUpdateRealmWithUserThatUsernameMatchExisting() {
        doImport("03_update_realm_with_new_user.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "myuser");

        assertThat(user.getUsername(), is("myuser"));
        assertThat(user.getEmail(), is("myuser@mail.de"));
        assertThat(user.isEnabled(), is(true));
        assertThat(user.getFirstName(), is("My firstname"));
        assertThat(user.getLastName(), is("My lastname"));

        UserRepresentation createdUser = keycloakRepository.getUser(REALM_NAME, "my");

        assertThat(createdUser.getUsername(), is("my"));
        assertThat(createdUser.getEmail(), is("my@mail.de"));
        assertThat(createdUser.isEnabled(), is(true));
        assertThat(createdUser.getFirstName(), is("My firstname"));
        assertThat(createdUser.getLastName(), is("My lastname"));
    }

    /**
     * https://github.com/adorsys/keycloak-config-cli/issues/51
     */

    @Test
    @Order(4)
    void shouldCreateRealmWithUsersAndUpdateSingleUserCorrect() {

        doImport("04_1_create_realm_with_users_to_check_update.json");

        RealmResource realmResource = keycloakProvider.getInstance().realm(REALM_NAME);
        final RealmRepresentation createdRealm = realmResource.toRepresentation();
        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(realmResource.users().list(), is(hasSize(5)));

        // act -> update realm with a single user to change
        doImport("04_2_create_realm_with_users_to_check_update.json");

        realmResource = keycloakProvider.getInstance().realm(REALM_NAME);
        assertThat(realmResource.users().list(), is(hasSize(6)));

        // assert -> check whether only the "user1" was updated or not
        final UserRepresentation updatedUser = keycloakRepository.getUser(REALM_NAME, "user");
        assertThat(updatedUser.getEmail(), is("user@mail.de"));
        assertThat(updatedUser.getLastName(), is("lastName"));
        assertThat(updatedUser.getFirstName(), is("firstName"));

        final UserRepresentation updatedUser1 = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(updatedUser1.getEmail(), is("user1@mail.de"));
        assertThat(updatedUser1.getLastName(), is("lastName1"));
        assertThat(updatedUser1.getFirstName(), is("firstName1"));

        final UserRepresentation updatedUser2 = keycloakRepository.getUser(REALM_NAME, "user2");
        assertThat(updatedUser2.getEmail(), is("user2@mail.de"));
        assertThat(updatedUser2.getLastName(), is("lastName2"));
        assertThat(updatedUser2.getFirstName(), is("firstName2"));
    }

    /**
     * https://github.com/adorsys/keycloak-config-cli/issues/68
     */

    @Test
    @Order(5)
    void coverGitHubIssue68() {
        // Create Users
        doImport("05_1_issue_gh_68.json");
        // Update Users
        doImport("05_2_issue_gh_68.json");

        RealmResource realmResource = keycloakProvider.getInstance().realm(REALM_NAME);
        final RealmRepresentation createdRealm = realmResource.toRepresentation();
        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
    }

    @Test
    @Order(6)
    void shouldUpdateRealmAndNotRemoveUsers() {
        // Create Users
        doImport("06_update_realm_and_not_remove_user.json");

        RealmResource realmResource = keycloakProvider.getInstance().realm(REALM_NAME);
        final RealmRepresentation createdRealm = realmResource.toRepresentation();
        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(realmResource.users().list(), is(hasSize(8)));
    }

    @Test
    @Order(7)
    void shouldNotUpdateRealmUserWithNonExistsRole() {
        RealmImport foundImport = getImport("07_update_realm_try_to_create_user_invalid_role.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Could not find role 'not_exists' in realm 'realmWithUsers'!"));
    }

    @Test
    @Order(8)
    void shouldNotUpdateRealmUserWithNonExistsGroup() {
        RealmImport foundImport = getImport("08_update_realm_try_to_create_user_invalid_group.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Could not find group '/not_exists' in realm 'realmWithUsers'!"));
    }

    @Test
    @Order(9)
    void shouldUpdateRealmUpdateUserAddGroup() {
        // Create Users
        doImport("09_update_realm_update_user_add_group.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(1));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1");
        assertThat(group1.getName(), is("group1"));
    }

    @Test
    @Order(10)
    void shouldUpdateRealmUpdateUserChangeGroup() {
        // Create Users
        doImport("10_update_realm_update_user_change_group.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(2));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1");
        assertThat(group1.getName(), is("group1"));

        GroupRepresentation group2 = getGroupsByPath(userGroups, "/group2");
        assertThat(group2.getName(), is("group2"));
    }

    @Test
    @Order(11)
    void shouldUpdateRealmUpdateUserRemoveGroup() {
        // Create Users
        doImport("11_update_realm_update_user_remove_group.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(1));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1");
        assertThat(group1, nullValue());

        GroupRepresentation group2 = getGroupsByPath(userGroups, "/group2");
        assertThat(group2.getName(), is("group2"));
    }

    @Test
    @Order(12)
    void shouldUpdateRealmUpdateUserAddSubGroup() {
        // Create Users
        doImport("12_update_realm_update_user_add_subgroup.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(1));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1/subgroup1");
        assertThat(group1.getName(), is("subgroup1"));
    }

    @Test
    @Order(13)
    void shouldUpdateRealmUpdateUserChangeSubGroup() {
        // Create Users
        doImport("13_update_realm_update_user_change_subgroup.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(2));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1/subgroup1");
        assertThat(group1.getName(), is("subgroup1"));

        GroupRepresentation group2 = getGroupsByPath(userGroups, "/group2/subgroup2");
        assertThat(group2.getName(), is("subgroup2"));
    }

    @Test
    @Order(14)
    void shouldUpdateRealmUpdateUserRemoveSubGroup() {
        doImport("14_update_realm_update_user_remove_subgroup.json");

        final RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        final UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "user1");
        assertThat(user.getEmail(), is("user1@mail.de"));
        assertThat(user.getLastName(), is("lastName1"));
        assertThat(user.getFirstName(), is("firstName1"));

        List<GroupRepresentation> userGroups = getGroupsByUser(user);
        assertThat(userGroups, hasSize(1));

        GroupRepresentation group1 = getGroupsByPath(userGroups, "/group1/subgroup1");
        assertThat(group1, nullValue());

        GroupRepresentation group2 = getGroupsByPath(userGroups, "/group2/subgroup2");
        assertThat(group2.getName(), is("subgroup2"));
    }

    @Test
    @Order(50)
    void shouldUpdateUserWithEmailAsRegistration() {
        doImport("50.1_create_realm_with_email_as_username_without_username.json");
        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));
        assertThat(realm.isRegistrationAllowed(), is(true));
        assertThat(realm.isRegistrationEmailAsUsername(), is(true));

        UserRepresentation user = keycloakRepository.getUser(REALM_NAME, "otheruser@mail.de");
        assertThat(user.getUsername(), is("otheruser@mail.de"));
        assertThat(user.getEmail(), is("otheruser@mail.de"));
        assertThat(user.getFirstName(), is("My firstname"));
        assertThat(user.getLastName(), is("My lastname"));

        doImport("50.2_update_realm_with_email_as_username_without_username.json");
        user = keycloakRepository.getUser(REALM_NAME, "otheruser@mail.de");
        assertThat(user.getUsername(), is("otheruser@mail.de"));
        assertThat(user.getEmail(), is("otheruser@mail.de"));
        assertThat(user.getFirstName(), is("My firstname 1"));
        assertThat(user.getLastName(), is("My lastname 1"));


        InvalidImportException thrown = assertThrows(InvalidImportException.class, () -> doImport("50.3_update_realm_with_email_as_username_with_invalid_username.json"));
        assertThat(thrown.getMessage(), is("Invalid user 'otheruser' in realm 'realmWithUsers': username (otheruser) and email (otheruser@mail.de) is different while 'email as username' is enabled on realm."));

        doImport("50.4_update_realm_with_email_as_username_with_correct_username.json");
        user = keycloakRepository.getUser(REALM_NAME, "otheruser@mail.de");
        assertThat(user.getUsername(), is("otheruser@mail.de"));
        assertThat(user.getEmail(), is("otheruser@mail.de"));
        assertThat(user.getFirstName(), is("My firstname 2"));
        assertThat(user.getLastName(), is("My lastname 2"));
    }

    private List<GroupRepresentation> getGroupsByUser(UserRepresentation user) {
        return keycloakProvider.getInstance().realm(REALM_NAME).users().get(user.getId()).groups();
    }

    private GroupRepresentation getGroupsByPath(List<GroupRepresentation> groups, String groupPath) {
        return groups.stream().filter(group -> group.getPath().equals(groupPath)).findFirst().orElse(null);
    }
}
