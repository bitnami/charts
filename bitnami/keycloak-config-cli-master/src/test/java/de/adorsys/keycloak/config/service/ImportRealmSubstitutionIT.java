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
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junitpioneer.jupiter.SetSystemProperty;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.test.context.TestPropertySource;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

@TestPropertySource(properties = {
        "import.var-substitution=true"
})

class ImportRealmSubstitutionIT extends AbstractImportTest {
    private static final String REALM_NAME = "realm-substitution";

    ImportRealmSubstitutionIT() {
        this.resourcePath = "import-files/realm-substitution";
    }

    @Test
    @Order(0)
    @SetSystemProperty(key = "kcc.junit.display-name", value = "<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>")
    @SetSystemProperty(key = "kcc.junit.verify-email", value = "true")
    @SetSystemProperty(key = "kcc.junit.not-before", value = "1200")
    @SetSystemProperty(key = "kcc.junit.browser-security-headers", value = "{\"xRobotsTag\":\"noindex\"}")
    void shouldCreateRealm() {
        assertThat(System.getProperty("kcc.junit.display-name"), is("<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>"));

        doImport("0_create_realm.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(realm.getDisplayName(), is("<div class=\"kc-logo-text\"><span>Keycloak</span></div>"));
        assertThat(realm.getDisplayNameHtml(), is("<div class=\"kc-logo-text\"><span>Keycloak</span></div>"));
        assertThat(realm.isVerifyEmail(), is(Boolean.valueOf(System.getProperty("kcc.junit.verify-email"))));
        assertThat(realm.getNotBefore(), is(Integer.valueOf(System.getProperty("kcc.junit.not-before"))));
        assertThat(realm.getBrowserSecurityHeaders().get("xRobotsTag"), is("noindex"));

        assertThat(
                realm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("e132c1c6d01dc8e0002e2fe31acff99dda1eda404005fc5fed75382897b9d1a6")
        );
    }

    @Test
    @Order(1)
    @SetSystemProperty(key = "kcc.junit.display-name", value = "<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>")
    @SetSystemProperty(key = "kcc.junit.verify-email", value = "false")
    @SetSystemProperty(key = "kcc.junit.not-before", value = "600")
    @SetSystemProperty(key = "kcc.junit.browser-security-headers", value = "{\"xRobotsTag\":\"noindex\"}")
    void shouldUpdateRealm() {
        assertThat(System.getProperty("kcc.junit.display-name"), is("<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>"));

        doImport("1_update_realm.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(realm.getDisplayName(), is("<div class=\"kc-logo-text\"><span>Keycloak</span></div>"));
        assertThat(realm.getDisplayNameHtml(), is("<div class=\"kc-logo-text\"><span>Keycloak</span></div>"));
        assertThat(realm.isVerifyEmail(), is(Boolean.valueOf(System.getProperty("kcc.junit.verify-email"))));
        assertThat(realm.getNotBefore(), is(Integer.valueOf(System.getProperty("kcc.junit.not-before"))));
        assertThat(realm.getBrowserSecurityHeaders().get("xRobotsTag"), is("noindex"));

        assertThat(
                realm.getAttributes().get("de.adorsys.keycloak.config.import-checksum-default"),
                is("5e03aab8c5cb0472e5ab432429f25a23f1bb4eebdbb8c8797c149b6670493860")
        );
    }

    @Test
    @Order(2)
    @SetSystemProperty(key = "kcc.junit.display-name", value = "<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>")
    @SetSystemProperty(key = "kcc.junit.verify-email", value = "false")
    @SetSystemProperty(key = "kcc.junit.not-before", value = "300")
    @SetSystemProperty(key = "kcc.junit.browser-security-headers", value = "{\"xRobotsTag\":\"noindex\"}")
    void shouldUpdateRealmWithEnv() {
        assertThat(System.getProperty("kcc.junit.display-name"), is("<div class=\\\"kc-logo-text\\\"><span>Keycloak</span></div>"));

        doImport("2_update_realm_with_env.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(realm.getDisplayName(), is("<div class=\"kc-logo-text\"><span>Keycloak</span></div>"));
        assertThat(realm.getDisplayNameHtml(), is(System.getenv("JAVA_HOME")));
        assertThat(realm.isVerifyEmail(), is(Boolean.valueOf(System.getProperty("kcc.junit.verify-email"))));
        assertThat(realm.getNotBefore(), is(Integer.valueOf(System.getProperty("kcc.junit.not-before"))));
        assertThat(realm.getBrowserSecurityHeaders().get("xRobotsTag"), is("noindex"));
    }

    @Test
    @Order(3)
    void shouldUnknownVariableFailRealmCreation() {
        IllegalArgumentException thrown = assertThrows(IllegalArgumentException.class,
                () -> doImport("3_update_realm.json"),
                "Unknown variables should cause realm creation to fail"
        );

        assertThat(thrown.getMessage(), is("Cannot resolve variable 'sys:kcc.junit.display-name' (enableSubstitutionInVariables=true)."));
    }
}
