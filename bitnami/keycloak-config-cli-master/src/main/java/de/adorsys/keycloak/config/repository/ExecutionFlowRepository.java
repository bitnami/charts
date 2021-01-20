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
import de.adorsys.keycloak.config.util.ResponseUtil;
import org.keycloak.admin.client.resource.AuthenticationManagementResource;
import org.keycloak.representations.idm.AuthenticationExecutionExportRepresentation;
import org.keycloak.representations.idm.AuthenticationExecutionInfoRepresentation;
import org.keycloak.representations.idm.AuthenticationExecutionRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;

@Service
public class ExecutionFlowRepository {
    private static final Logger logger = LoggerFactory.getLogger(ExecutionFlowRepository.class);

    private final AuthenticationFlowRepository authenticationFlowRepository;

    @Autowired
    public ExecutionFlowRepository(AuthenticationFlowRepository authenticationFlowRepository) {
        this.authenticationFlowRepository = authenticationFlowRepository;
    }

    public AuthenticationExecutionInfoRepresentation getExecutionFlow(String realmName, String topLevelFlowAlias, AuthenticationExecutionExportRepresentation execution) {
        Optional<AuthenticationExecutionInfoRepresentation> maybeExecution = search(realmName, topLevelFlowAlias, execution.getAuthenticator(), execution.getFlowAlias());

        if (maybeExecution.isPresent()) {
            return maybeExecution.get();
        }

        String withSubFlow = execution.getFlowAlias() != null ? "' or flow by alias '" + execution.getFlowAlias() : "";
        throw new KeycloakRepositoryException("Cannot find stored execution by authenticator '" + execution.getAuthenticator() + withSubFlow + "' in top-level flow '" + topLevelFlowAlias + "' in realm '" + realmName + "'");
    }

    public void createExecutionFlow(String realmName, String topLevelFlowAlias, Map<String, String> executionFlowData) {
        logger.trace("Create non-top-level-flow in realm '{}' and top-level-flow '{}'", realmName, topLevelFlowAlias);

        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.addExecutionFlow(topLevelFlowAlias, executionFlowData);
    }

    public void updateExecutionFlow(String realmName, String flowAlias, AuthenticationExecutionInfoRepresentation executionFlowToUpdate) {
        logger.trace("Update non-top-level-flow '{}' from realm '{}' and top-level-flow '{}'", executionFlowToUpdate.getAlias(), realmName, flowAlias);

        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.updateExecutions(flowAlias, executionFlowToUpdate);
    }

    public void createTopLevelFlowExecution(String realmName, AuthenticationExecutionRepresentation executionToCreate) {
        logger.trace("Create flow-execution '{}' in realm '{}' and top-level-flow '{}'...", executionToCreate.getAuthenticator(), realmName, executionToCreate.getParentFlow());

        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);

        try {
            Response response = flowsResource.addExecution(executionToCreate);
            ResponseUtil.validate(response);
        } catch (WebApplicationException error) {
            AuthenticationFlowRepresentation parentFlow = authenticationFlowRepository.getById(realmName, executionToCreate.getParentFlow());
            throw new ImportProcessingException(
                    "Cannot create execution-flow '" + executionToCreate.getAuthenticator()
                            + "' for top-level-flow '" + parentFlow.getAlias()
                            + "' in realm '" + realmName + "'",
                    error
            );
        }

        logger.trace("Created flow-execution '{}' in realm '{}' and top-level-flow '{}'", executionToCreate.getAuthenticator(), realmName, executionToCreate.getParentFlow());
    }

    public void createNonTopLevelFlowExecution(String realmName, String nonTopLevelFlowAlias, Map<String, String> executionData) {
        logger.trace("Create flow-execution in realm '{}' and non-top-level-flow '{}'...", realmName, nonTopLevelFlowAlias);

        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.addExecution(nonTopLevelFlowAlias, executionData);

        logger.trace("Created flow-execution in realm '{}' and non-top-level-flow '{}'", realmName, nonTopLevelFlowAlias);
    }

    private Optional<AuthenticationExecutionInfoRepresentation> search(String realmName, String topLevelFlowAlias, String executionProviderId, String subFlowAlias) {
        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);

        return flowsResource.getExecutions(topLevelFlowAlias)
                .stream()
                .filter(f -> Objects.equals(f.getProviderId(), executionProviderId))
                .filter(f -> {
                    if (subFlowAlias != null) {
                        return Objects.equals(f.getDisplayName(), subFlowAlias);
                    }
                    return true;
                })
                .findFirst();
    }
}
