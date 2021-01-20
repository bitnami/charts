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
import org.keycloak.representations.idm.AuthenticatorConfigRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;

import java.util.Optional;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

class ImportAuthenticatorConfigIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithAuthConfig";

    ImportAuthenticatorConfigIT() {
        this.resourcePath = "import-files/auth-config";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithFlows() {
        doImport("0_create_realm_with_flow_auth_config.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> authConfig = getAuthenticatorConfig(createdRealm, "test auth config");
        assertThat(authConfig.isPresent(), is(true));
        assertThat(authConfig.get().getConfig().get("require.password.update.after.registration"), is("false"));

        authConfig = getAuthenticatorConfig(createdRealm, "create unique user config");
        assertThat(authConfig.isPresent(), is(true));
        assertThat(authConfig.get().getConfig().get("require.password.update.after.registration"), is("false"));

        authConfig = getAuthenticatorConfig(createdRealm, "review profile config");
        assertThat(authConfig.isPresent(), is(true));
        assertThat(authConfig.get().getConfig().get("update.profile.on.first.login"), is("missing"));
    }

    @Test
    @Order(1)
    void shouldAddExecutionToFlow() {
        doImport("1_update_realm_auth_config.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "test auth config");
        assertThat(changedAuthConfig.isPresent(), is(true));
        assertThat(changedAuthConfig.get().getConfig().get("require.password.update.after.registration"), is("true"));
    }

    @Test
    @Order(2)
    void shouldChangeExecutionRequirement() {
        doImport("2_remove_realm_auth_config.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> deletedAuthConfig = getAuthenticatorConfig(updatedRealm, "test auth config");
        assertThat(deletedAuthConfig.isPresent(), is(false));
    }

    @Test
    @Order(3)
    void shouldUpdateRealmCreateFlowAuthConfigInsideNonTopLevelFlow() {
        doImport("3_update_realm__create_flow_auth_config_inside_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "other test auth config");
        assertThat(changedAuthConfig.isPresent(), is(true));
        assertThat(changedAuthConfig.get().getConfig().get("require.password.update.after.registration"), is("false"));
    }

    @Test
    @Order(4)
    void shouldUpdateRealmUpdateFlowAuthConfigInsideNonTopLevelFlow() {
        doImport("4_update_realm__update_flow_auth_config_inside_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "other test auth config");
        assertThat(changedAuthConfig.isPresent(), is(true));
        assertThat(changedAuthConfig.get().getConfig().get("require.password.update.after.registration"), is("true"));
    }

    @Test
    @Order(5)
    void shouldUpdateRealmDeleteFlowAuthConfigInsideNonTopLevelFlow() {
        doImport("5_update_realm__delete_flow_auth_config_inside_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "other test auth config");
        assertThat(changedAuthConfig.isPresent(), is(false));
    }

    @Test
    @Order(6)
    void shouldUpdateRealmCreateFlowAuthConfigInsideBuiltinNonTopLevelFlow() {
        doImport("6_update_realm__create_flow_auth_config_inside_builtin_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "custom-recaptcha");
        assertThat(changedAuthConfig.isPresent(), is(true));
        assertThat(changedAuthConfig.get().getConfig().get("useRecaptchaNet"), is("false"));
    }

    @Test
    @Order(7)
    void shouldUpdateRealmUpdateFlowAuthConfigInsideBuiltinNonTopLevelFlow() {
        doImport("7_update_realm__update_flow_auth_config_inside_builtin_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "custom-recaptcha");
        assertThat(changedAuthConfig.isPresent(), is(true));
        assertThat(changedAuthConfig.get().getConfig().get("useRecaptchaNet"), is("true"));
    }

    @Test
    @Order(8)
    void shouldUpdateRealmDeleteFlowAuthConfigInsideBuiltinNonTopLevelFlow() {
        doImport("8_update_realm__delete_flow_auth_config_inside_builtin_non_top_level_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        Optional<AuthenticatorConfigRepresentation> changedAuthConfig = getAuthenticatorConfig(updatedRealm, "custom-recaptcha");
        assertThat(changedAuthConfig.isPresent(), is(false));
    }

    private Optional<AuthenticatorConfigRepresentation> getAuthenticatorConfig(RealmRepresentation updatedRealm, String configAlias) {
        return updatedRealm
                .getAuthenticatorConfig()
                .stream()
                .filter(x -> x.getAlias().equals(configAlias)).findAny();
    }
}
