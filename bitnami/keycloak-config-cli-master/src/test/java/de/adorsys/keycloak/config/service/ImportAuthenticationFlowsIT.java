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
import de.adorsys.keycloak.config.util.VersionUtil;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.AuthenticationExecutionExportRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.keycloak.representations.idm.IdentityProviderRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportAuthenticationFlowsIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithFlow";

    ImportAuthenticationFlowsIT() {
        this.resourcePath = "import-files/auth-flows";
    }

    @Test
    @Order(0)
    void shouldCreateRealmWithFlows() {
        doImport("00_create_realm_with_flows.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation importedFlow = getAuthenticationFlow(createdRealm, "my auth flow");
        assertThat(importedFlow.getDescription(), is("My auth flow for testing"));
        assertThat(importedFlow.getProviderId(), is("basic-flow"));
        assertThat(importedFlow.isBuiltIn(), is(false));
        assertThat(importedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = importedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(1));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(importedFlow, "docker-http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("docker-http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(1)
    void shouldAddExecutionToFlow() {
        doImport("01_update_realm__add_execution_to_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(2));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "docker-http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("docker-http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
        importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(1));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(2)
    void shouldChangeExecutionRequirement() {
        doImport("02_update_realm__change_execution_requirement.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(2));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "docker-http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("docker-http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("REQUIRED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
        importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(1));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(3)
    void shouldChangeExecutionPriorities() {
        doImport("03_update_realm__change_execution_priorities.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(2));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "docker-http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("docker-http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("REQUIRED"));
        assertThat(importedExecution.getPriority(), is(1));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
        importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(4)
    void shouldAddFlowWithExecutionFlow() {
        doImport("04_update_realm__add_flow_with_execution_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My registration flow"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> executionFlows = topLevelFlow.getAuthenticationExecutions();
        assertThat(executionFlows, hasSize(1));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(topLevelFlow, "registration-page-form");
        assertThat(execution.getAuthenticator(), is("registration-page-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-user-creation");
        assertThat(execution.getAuthenticator(), is("registration-user-creation"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-profile-action");
        assertThat(execution.getAuthenticator(), is("registration-profile-action"));
        assertThat(execution.getRequirement(), is("DISABLED"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(5)
    void shouldFailWhenTryAddFlowWithDefectiveExecutionFlow() {
        RealmImport foundImport = getImport("05_try_to_update_realm__add_flow_with_defective_execution_flow.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create execution-flow 'my registration form' for top-level-flow 'my registration' in realm 'realmWithFlow':.*"));
    }

    @Test
    @Order(6)
    void shouldChangeFlowRequirementWithExecutionFlow() {
        doImport("10_update_realm__change_requirement_flow_with_execution_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My registration flow"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> executionFlows = topLevelFlow.getAuthenticationExecutions();
        assertThat(executionFlows, hasSize(1));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(topLevelFlow, "registration-page-form");
        assertThat(execution.getAuthenticator(), is("registration-page-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-user-creation");
        assertThat(execution.getAuthenticator(), is("registration-user-creation"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-profile-action");
        assertThat(execution.getAuthenticator(), is("registration-profile-action"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(7)
    void shouldFailWhenTryToUpdateDefectiveFlowRequirementWithExecutionFlow() {
        RealmImport foundImport = getImport("06_try_to_update_realm__change_requirement_in_defective_flow_with_execution_flow.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create execution-flow 'my registration form' for top-level-flow 'my registration' in realm 'realmWithFlow': .*"));
    }

    @Test
    @Order(8)
    void shouldFailWhenTryToUpdateFlowRequirementWithExecutionFlowWithNotExistingExecution() {
        RealmImport foundImport = getImport("07_try_to_update_realm__change_requirement_flow_with_execution_flow_with_not_existing_execution.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create execution 'not-existing-registration-user-creation' for non-top-level-flow 'my registration form' in realm 'realmWithFlow': .*"));
    }

    @Test
    @Order(9)
    void shouldFailWhenTryToUpdateFlowRequirementWithExecutionFlowWithDefectiveExecution() {
        RealmImport foundImport = getImport("08_try_to_update_realm__change_requirement_flow_with_execution_flow_with_defective_execution.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot update execution-flow 'registration-user-creation' for flow 'my registration form' in realm 'realmWithFlow': .*"));
    }

    @Test
    @Order(10)
    void shouldFailWhenTryToUpdateFlowRequirementWithDefectiveExecutionFlow() {
        RealmImport foundImport = getImport("09_try_to_update_realm__change_requirement_flow_with_defective_execution_flow.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Cannot create execution-flow 'docker-http-basic-authenticator' for top-level-flow 'my auth flow' in realm 'realmWithFlow'"));
    }

    @Test
    @Order(11)
    void shouldChangeFlowPriorityWithExecutionFlow() {
        doImport("11_update_realm__change_priority_flow_with_execution_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My registration flow"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> executionFlows = topLevelFlow.getAuthenticationExecutions();
        assertThat(executionFlows, hasSize(1));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(topLevelFlow, "registration-page-form");
        assertThat(execution.getAuthenticator(), is("registration-page-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-user-creation");
        assertThat(execution.getAuthenticator(), is("registration-user-creation"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-profile-action");
        assertThat(execution.getAuthenticator(), is("registration-profile-action"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(12)
    void shouldSetRegistrationFlow() {
        doImport("12_update_realm__set_registration_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getRegistrationFlow(), is("my registration"));
    }

    @Test
    @Order(13)
    void shouldChangeRegistrationFlow() {
        doImport("13_update_realm__change_registration_flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getRegistrationFlow(), is("my registration"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My changed registration flow"));
    }

    @Test
    @Order(14)
    void shouldAddAndSetResetCredentialsFlow() {
        doImport("14_update_realm__add_and_set_custom_reset-credentials-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getResetCredentialsFlow(), is("my reset credentials"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my reset credentials");
        assertThat(topLevelFlow.getDescription(), is("My reset credentials for a user if they forgot their password or something"));
    }

    @Test
    @Order(15)
    void shouldChangeResetCredentialsFlow() {
        doImport("15_update_realm__change_custom_reset-credentials-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getResetCredentialsFlow(), is("my reset credentials"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my reset credentials");
        assertThat(topLevelFlow.getDescription(), is("My changed reset credentials for a user if they forgot their password or something"));
    }

    @Test
    @Order(16)
    void shouldAddAndSetBrowserFlow() {
        doImport("16_update_realm__add_and_set_custom_browser-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getBrowserFlow(), is("my browser"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my browser");
        assertThat(topLevelFlow.getDescription(), is("My browser based authentication"));
    }

    @Test
    @Order(17)
    void shouldChangeBrowserFlow() {
        doImport("17.1_update_realm__change_custom_browser-flow.json");

        assertThatBrowserFlowIsUpdated(4);

        doImport("17.2_update_realm__change_custom_browser-flow_with_multiple_subflow.json");

        AuthenticationFlowRepresentation topLevelFlow = assertThatBrowserFlowIsUpdated(5);

        AuthenticationExecutionExportRepresentation myForms2 = getExecutionFlowFromFlow(topLevelFlow, "my forms 2");
        assertThat(myForms2, notNullValue());
        assertThat(myForms2.getRequirement(), is("ALTERNATIVE"));
        assertThat(myForms2.getPriority(), is(4));
        assertThat(myForms2.isUserSetupAllowed(), is(false));
        assertThat(myForms2.isAutheticatorFlow(), is(true));
    }

    AuthenticationFlowRepresentation assertThatBrowserFlowIsUpdated(int expectedNumberOfExecutionsInFlow) {
        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getBrowserFlow(), is("my browser"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my browser");
        assertThat(topLevelFlow.getDescription(), is("My changed browser based authentication"));

        assertThat(topLevelFlow.getAuthenticationExecutions().size(), is(expectedNumberOfExecutionsInFlow));

        AuthenticationExecutionExportRepresentation myForms = getExecutionFlowFromFlow(topLevelFlow, "my forms");
        assertThat(myForms, notNullValue());
        assertThat(myForms.getRequirement(), is("ALTERNATIVE"));
        assertThat(myForms.getPriority(), is(3));
        assertThat(myForms.isUserSetupAllowed(), is(false));
        assertThat(myForms.isAutheticatorFlow(), is(true));

        return topLevelFlow;
    }

    @Test
    @Order(18)
    void shouldAddAndSetDirectGrantFlow() {
        doImport("18_update_realm__add_and_set_custom_direct-grant-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getDirectGrantFlow(), is("my direct grant"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my direct grant");
        assertThat(topLevelFlow.getDescription(), is("My OpenID Connect Resource Owner Grant"));
    }

    @Test
    @Order(19)
    void shouldChangeDirectGrantFlow() {
        doImport("19_update_realm__change_custom_direct-grant-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getDirectGrantFlow(), is("my direct grant"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my direct grant");
        assertThat(topLevelFlow.getDescription(), is("My changed OpenID Connect Resource Owner Grant"));
    }

    @Test
    @Order(20)
    void shouldAddAndSetClientAuthenticationFlow() {
        doImport("20_update_realm__add_and_set_custom_client-authentication-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getClientAuthenticationFlow(), is("my clients"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my clients");
        assertThat(topLevelFlow.getDescription(), is("My Base authentication for clients"));
    }

    @Test
    @Order(21)
    void shouldChangeClientAuthenticationFlow() {
        doImport("21_update_realm__change_custom_client-authentication-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getClientAuthenticationFlow(), is("my clients"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my clients");
        assertThat(topLevelFlow.getDescription(), is("My changed Base authentication for clients"));
    }

    @Test
    @Order(22)
    void shouldAddAndSetDockerAuthenticationFlow() {
        doImport("22_update_realm__add_and_set_custom_docker-authentication-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getDockerAuthenticationFlow(), is("my docker auth"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my docker auth");
        assertThat(topLevelFlow.getDescription(), is("My Used by Docker clients to authenticate against the IDP"));
    }

    @Test
    @Order(23)
    void shouldChangeDockerAuthenticationFlow() {
        doImport("23_update_realm__change_custom_docker-authentication-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getDockerAuthenticationFlow(), is("my docker auth"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my docker auth");
        assertThat(topLevelFlow.getDescription(), is("My changed Used by Docker clients to authenticate against the IDP"));
    }

    @Test
    @Order(24)
    void shouldAddTopLevelFlowWithExecutionFlow() {
        doImport("24_update_realm__add-top-level-flow-with-execution-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my auth flow with execution-flows");
        assertThat(topLevelFlow.getDescription(), is("My authentication flow with authentication executions"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my execution-flow");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(nonTopLevelFlow, "auth-username-password-form");
        assertThat(execution.getAuthenticator(), is("auth-username-password-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "auth-otp-form");
        assertThat(execution.getAuthenticator(), is("auth-otp-form"));
        assertThat(execution.getRequirement(), is("CONDITIONAL"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(25)
    void shouldUpdateTopLevelFlowWithPseudoId() {
        doImport("25_update_realm__update-top-level-flow-with-pseudo-id.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(topLevelFlow.getDescription(), is("My auth flow for testing with pseudo-id"));
    }

    @Test
    @Order(26)
    void shouldUpdateNonTopLevelFlowWithPseudoId() {
        doImport("26_update_realm__update-non-top-level-flow-with-pseudo-id.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");
        assertThat(nonTopLevelFlow.getDescription(), is("My registration form with pseudo-id"));
    }

    @Test
    @Order(27)
    void shouldNotUpdateNonTopLevelFlowWithPseudoId() {
        RealmImport foundImport = getImport("27_update_realm__try-to-update-non-top-level-flow-with-pseudo-id.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create execution-flow 'my registration form' for top-level-flow 'my registration' in realm 'realmWithFlow': .*"));
    }

    @Test
    @Order(28)
    void shouldUpdateNonTopLevelFlowWithPseudoIdAndReUseTempFlow() {
        doImport("28_update_realm__update-non-top-level-flow-with-pseudo-id.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        assertThat(updatedRealm.getRegistrationFlow(), is("my registration"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("changed registration flow"));

        AuthenticationFlowRepresentation tempFlow = getAuthenticationFlow(updatedRealm, "TEMPORARY_CREATED_AUTH_FLOW");
        assertThat(tempFlow, nullValue());
    }

    @Test
    @Order(29)
    void shouldNotUpdateInvalidTopLevelFlow() {
        RealmImport foundImport = getImport("29_update_realm__try-to-update-invalid-top-level-flow.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), matchesPattern("Cannot create top-level-flow 'my auth flow' in realm 'realmWithFlow': .*"));
    }

    @Test
    @Order(40)
    void shouldFailWhenTryingToUpdateBuiltInFlow() {
        RealmImport foundImport = getImport("40_update_realm__try-to-update-built-in-flow.json");

        InvalidImportException thrown = assertThrows(InvalidImportException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Unable to update flow 'my auth flow with execution-flows' in realm 'realmWithFlow': Change built-in flag is not possible"));
    }

    @Test
    @Order(41)
    void shouldFailWhenTryingToUpdateWithNonExistingFlow() {
        RealmImport foundImport = getImport("41_update_realm__try-to-update-with-non-existing-flow.json");

        ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Non-toplevel flow not found: non existing sub flow"));
    }

    @Test
    @Order(42)
    void shouldUpdateTopLevelBuiltinFLow() {
        doImport("42_update_realm__update_builtin-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        AuthenticationFlowRepresentation flow = getAuthenticationFlow(updatedRealm, "saml ecp");
        assertThat(flow.getDescription(), is("SAML ECP Profile Authentication Flow"));
        assertThat(flow.isBuiltIn(), is(true));
        assertThat(flow.isTopLevel(), is(true));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(flow, "http-basic-authenticator");
        assertThat(execution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(execution.getRequirement(), is("CONDITIONAL"));
        assertThat(execution.getPriority(), is(10));
        assertThat(execution.isUserSetupAllowed(), is(false));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(43)
    void shouldUpdateNonTopLevelBuiltinFLow() {
        doImport("43_update_realm__update_builtin-non-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        AuthenticationFlowRepresentation flow = getAuthenticationFlow(updatedRealm, "registration form");
        if (VersionUtil.ge(KEYCLOAK_VERSION, "11")) {
            assertThat(flow.getDescription(), is("updated registration form"));
        } else {
            assertThat(flow.getDescription(), is("registration form"));
        }
        assertThat(flow.isBuiltIn(), is(true));
        assertThat(flow.isTopLevel(), is(false));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(flow, "registration-recaptcha-action");
        assertThat(execution.getAuthenticator(), is("registration-recaptcha-action"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(60));
        assertThat(execution.isUserSetupAllowed(), is(false));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(44)
    void shouldNotUpdateFlowWithBuiltInFalse() {
        RealmImport foundImport = getImport("44_update_realm__try-to-update-flow-set-builtin-false.json");

        InvalidImportException thrown = assertThrows(InvalidImportException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Unable to recreate flow 'saml ecp' in realm 'realmWithFlow': Deletion or creation of built-in flows is not possible"));
    }

    @Test
    @Order(45)
    void shouldNotUpdateFlowWithBuiltInTrue() {
        RealmImport foundImport = getImport("45_update_realm__try-to-update-flow-set-builtin-true.json");

        InvalidImportException thrown = assertThrows(InvalidImportException.class, () -> realmImportService.doImport(foundImport));

        assertThat(thrown.getMessage(), is("Unable to update flow 'my auth flow' in realm 'realmWithFlow': Change built-in flag is not possible"));
    }

    @Test
    @Order(46)
    void shouldNotCreateBuiltInFlow() {
        RealmImport foundImport = getImport("46_update_realm__try-to-create-builtin-flow.json");

        if (VersionUtil.ge(KEYCLOAK_VERSION, "11")) {
            ImportProcessingException thrown = assertThrows(ImportProcessingException.class, () -> realmImportService.doImport(foundImport));

            assertThat(thrown.getMessage(), is("Cannot update top-level-flow 'saml ecp' in realm 'realmWithFlow'."));
        }
    }

    @Test
    @Order(47)
    void shouldUpdateRealmUpdateBuiltInFlowWithPseudoId() {
        doImport("47_update_realm__update-builtin-flow-with-pseudo-id.json");
    }

    @Test
    @Order(50)
    void shouldRemoveNonTopLevelFlow() {
        doImport("50_update_realm__update-remove-non-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing with pseudo-id"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(1));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My registration flow"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> executionFlows = topLevelFlow.getAuthenticationExecutions();
        assertThat(executionFlows, hasSize(1));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(topLevelFlow, "registration-page-form");
        assertThat(execution.getAuthenticator(), is("registration-page-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-profile-action");
        assertThat(execution.getAuthenticator(), is("registration-profile-action"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-user-creation");
        assertThat(execution.getAuthenticator(), is("registration-user-creation"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(51)
    void shouldSkipRemoveTopLevelFlow() {
        doImport("51_update_realm__skip-remove-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing with pseudo-id"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(1));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(topLevelFlow.getDescription(), is("My registration flow"));
        assertThat(topLevelFlow.getProviderId(), is("basic-flow"));
        assertThat(topLevelFlow.isBuiltIn(), is(false));
        assertThat(topLevelFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> executionFlows = topLevelFlow.getAuthenticationExecutions();
        assertThat(executionFlows, hasSize(1));

        AuthenticationExecutionExportRepresentation execution = getExecutionFromFlow(topLevelFlow, "registration-page-form");
        assertThat(execution.getAuthenticator(), is("registration-page-form"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(true));

        AuthenticationFlowRepresentation nonTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration form");

        List<AuthenticationExecutionExportRepresentation> nonTopLevelFlowExecutions = nonTopLevelFlow.getAuthenticationExecutions();
        assertThat(nonTopLevelFlowExecutions, hasSize(2));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-profile-action");
        assertThat(execution.getAuthenticator(), is("registration-profile-action"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(0));
        assertThat(execution.isAutheticatorFlow(), is(false));

        execution = getExecutionFromFlow(nonTopLevelFlow, "registration-user-creation");
        assertThat(execution.getAuthenticator(), is("registration-user-creation"));
        assertThat(execution.getRequirement(), is("REQUIRED"));
        assertThat(execution.getPriority(), is(1));
        assertThat(execution.isAutheticatorFlow(), is(false));
    }

    @Test
    @Order(52)
    void shouldRemoveTopLevelFlow() {
        doImport("52_update_realm__update-remove-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation unchangedFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(unchangedFlow.getDescription(), is("My auth flow for testing with pseudo-id"));
        assertThat(unchangedFlow.getProviderId(), is("basic-flow"));
        assertThat(unchangedFlow.isBuiltIn(), is(false));
        assertThat(unchangedFlow.isTopLevel(), is(true));

        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();
        assertThat(importedExecutions, hasSize(1));

        AuthenticationExecutionExportRepresentation importedExecution = getExecutionFromFlow(unchangedFlow, "http-basic-authenticator");
        assertThat(importedExecution.getAuthenticator(), is("http-basic-authenticator"));
        assertThat(importedExecution.getRequirement(), is("DISABLED"));
        assertThat(importedExecution.getPriority(), is(0));
        assertThat(importedExecution.isAutheticatorFlow(), is(false));

        AuthenticationFlowRepresentation deletedTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");

        assertThat(deletedTopLevelFlow, is(nullValue()));

        deletedTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration from");
        assertThat(deletedTopLevelFlow, is(nullValue()));
    }

    @Test
    @Order(53)
    void shouldRemoveAllTopLevelFlow() {
        doImport("53_update_realm__update-remove-all-top-level-flow.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        AuthenticationFlowRepresentation deletedTopLevelFlow;
        deletedTopLevelFlow = getAuthenticationFlow(updatedRealm, "my auth flow");
        assertThat(deletedTopLevelFlow, is(nullValue()));

        deletedTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration");
        assertThat(deletedTopLevelFlow, is(nullValue()));

        deletedTopLevelFlow = getAuthenticationFlow(updatedRealm, "my registration from");
        assertThat(deletedTopLevelFlow, is(nullValue()));

        List<AuthenticationFlowRepresentation> allTopLevelFlow = updatedRealm.getAuthenticationFlows()
                .stream().filter(e -> !e.isBuiltIn())
                .collect(Collectors.toList());

        assertThat(allTopLevelFlow, is(empty()));
    }

    @Test
    @Order(61)
    void shouldAddAndSetFirstBrokerLoginFlowForIdentityProvider() {
        doImport("61_update_realm__add_and_set_custom_first-broker-login-flow_for_identity-provider.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        IdentityProviderRepresentation identityProviderRepresentation = updatedRealm.getIdentityProviders().stream()
                .filter(idp -> Objects.equals(idp.getAlias(), "keycloak-oidc")).findFirst().orElse(null);

        assertThat(identityProviderRepresentation, is(not(nullValue())));
        assertThat(identityProviderRepresentation.getFirstBrokerLoginFlowAlias(), is("my-first-broker-login"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my-first-broker-login");
        assertThat(topLevelFlow.getDescription(), is("custom first broker login"));
    }

    @Test
    @Order(62)
    void shouldChangeFirstBrokerLoginFlowForIdentityProvider() {
        doImport("62_update_realm__change_custom_first-broker-login-flow_for_identity-provider.json");

        RealmRepresentation updatedRealm = keycloakProvider.getInstance().realm(REALM_NAME).partialExport(true, true);

        assertThat(updatedRealm.getRealm(), is(REALM_NAME));
        assertThat(updatedRealm.isEnabled(), is(true));

        IdentityProviderRepresentation identityProviderRepresentation = updatedRealm.getIdentityProviders().stream()
                .filter(idp -> Objects.equals(idp.getAlias(), "keycloak-oidc")).findFirst().orElse(null);

        assertThat(identityProviderRepresentation, is(not(nullValue())));
        assertThat(identityProviderRepresentation.getFirstBrokerLoginFlowAlias(), is("my-first-broker-login"));

        AuthenticationFlowRepresentation topLevelFlow = getAuthenticationFlow(updatedRealm, "my-first-broker-login");
        assertThat(topLevelFlow.getDescription(), is("custom changed first broker login"));
    }

    private AuthenticationExecutionExportRepresentation getExecutionFromFlow(AuthenticationFlowRepresentation unchangedFlow, String executionAuthenticator) {
        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();

        return importedExecutions.stream()
                .filter(e -> e.getAuthenticator().equals(executionAuthenticator))
                .findFirst()
                .orElse(null);
    }

    private AuthenticationExecutionExportRepresentation getExecutionFlowFromFlow(AuthenticationFlowRepresentation unchangedFlow, String subFlow) {
        List<AuthenticationExecutionExportRepresentation> importedExecutions = unchangedFlow.getAuthenticationExecutions();

        return importedExecutions.stream()
                .filter(f -> f.getFlowAlias() != null && f.getFlowAlias().equals(subFlow))
                .findFirst()
                .orElse(null);
    }

    private AuthenticationFlowRepresentation getAuthenticationFlow(RealmRepresentation updatedRealm, String flowAlias) {
        List<AuthenticationFlowRepresentation> authenticationFlows = updatedRealm.getAuthenticationFlows();
        return authenticationFlows.stream()
                .filter(f -> f.getAlias().equals(flowAlias))
                .findFirst()
                .orElse(null);
    }
}
