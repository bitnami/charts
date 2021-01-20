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
import de.adorsys.keycloak.config.exception.KeycloakRepositoryException;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.RealmRepresentation;

import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.matchesPattern;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsNull.nullValue;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportSimpleRealmIT extends AbstractImportTest {
    private static final String REALM_NAME = "simple";

    ImportSimpleRealmIT() {
        this.resourcePath = "import-files/simple-realm";
    }

    @Test
    @Order(0)
    void shouldCreateSimpleRealm() {
        doImport("0_create_simple-realm.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is(nullValue()));
        assertThat(
                createdRealm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("6292be0628c50ff8fc02bd4092f48a731133e4802e158e7bc2ba174524b4ccf1")
        );
    }

    @Test
    @Order(1)
    void shouldNotUpdateSimpleRealm() {
        doImport("0.1_update_simple-realm_with_same_config.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is(nullValue()));
        assertThat(
                createdRealm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("6292be0628c50ff8fc02bd4092f48a731133e4802e158e7bc2ba174524b4ccf1")
        );
    }

    @Test
    @Order(2)
    void shouldUpdateSimpleRealm() {
        doImport("1_update_login-theme_to_simple-realm.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));
        assertThat(updatedRealm.getLoginTheme(), is("moped"));
        assertThat(
                updatedRealm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("4ac94d3adb91122979e80816a8a355a01f9c7c90a25b6b529bf2a572e1158b1c")
        );
    }

    @Test
    @Order(3)
    void shouldCreateSimpleRealmWithLoginTheme() {
        doImport("2_create_simple-realm_with_login-theme.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm("simpleWithLoginTheme").toRepresentation();

        assertThat(createdRealm.getRealm(), is("simpleWithLoginTheme"));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is("moped"));
        assertThat(
                createdRealm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("9362cc7d2e91e9b9eee39d0b9306de0f7857f9d6326133335fc2d5cf767f7018")
        );
    }

    @Test
    @Order(4)
    void shouldNotCreateSimpleRealmWithInvalidName() {
        KeycloakRepositoryException thrown = assertThrows(
                KeycloakRepositoryException.class,
                () -> doImport("4_create_simple-realm_with_invalid_name.json")
        );

        assertThat(thrown.getMessage(), matchesPattern("^Cannot create realm '.+': .+$"));
    }

    @Test
    @Order(5)
    void shouldUpdateBruteForceProtection() {
        doImport("5_update_simple-realm_with_brute-force-protected.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm("simple").toRepresentation();

        assertThat(updatedRealm.getRealm(), is("simple"));
        assertThat(updatedRealm.isEnabled(), is(true));
        assertThat(updatedRealm.isBruteForceProtected(), is(true));
        assertThat(updatedRealm.isPermanentLockout(), is(false));
        assertThat(updatedRealm.getMaxFailureWaitSeconds(), is(900));
        assertThat(updatedRealm.getMinimumQuickLoginWaitSeconds(), is(60));
        assertThat(updatedRealm.getWaitIncrementSeconds(), is(3600));
        assertThat(updatedRealm.getQuickLoginCheckMilliSeconds(), is(1000L));
        assertThat(updatedRealm.getMaxDeltaTimeSeconds(), is(43200));
        assertThat(updatedRealm.getFailureFactor(), is(5));
    }

    @Test
    @Order(6)
    void shouldUpdateSmtpSettings() {
        doImport("6_update_simple-realm_with_smtp-settings.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm("simple").toRepresentation();

        assertThat(updatedRealm.getRealm(), is("simple"));
        assertThat(updatedRealm.isEnabled(), is(true));

        Map<String, String> config = updatedRealm.getSmtpServer();

        assertThat(config.get("from"), is("keycloak-config-cli@example.com"));
        assertThat(config.get("fromDisplayName"), is("keycloak-config-cli"));
        assertThat(config.get("host"), is("mta"));
        assertThat(config.get("auth"), is("true"));
        assertThat(config.get("envelopeFrom"), is("keycloak-config-cli@example.com"));
        assertThat(config.get("user"), is("username"));
        assertThat(config.get("password"), is("**********"));
    }

    @Test
    @Order(7)
    void shouldUpdateWebAuthnSettings() {
        doImport("7_update_simple-realm_with_web-authn-settings.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm("simple").toRepresentation();

        assertThat(updatedRealm.getRealm(), is("simple"));
        assertThat(updatedRealm.isEnabled(), is(true));
        assertThat(updatedRealm.getWebAuthnPolicyPasswordlessUserVerificationRequirement(), is("required"));
    }
}
