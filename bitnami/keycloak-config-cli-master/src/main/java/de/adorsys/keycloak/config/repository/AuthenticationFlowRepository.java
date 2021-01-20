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
import org.keycloak.admin.client.resource.AuthenticationManagementResource;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.representations.idm.AuthenticationExecutionInfoRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import javax.ws.rs.ClientErrorException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;

@Service
public class AuthenticationFlowRepository {
    private static final Logger logger = LoggerFactory.getLogger(AuthenticationFlowRepository.class);

    private final RealmRepository realmRepository;

    @Autowired
    public AuthenticationFlowRepository(RealmRepository realmRepository) {
        this.realmRepository = realmRepository;
    }

    public Optional<AuthenticationFlowRepresentation> searchByAlias(String realmName, String alias) {
        logger.trace("Try to get top-level-flow '{}' from realm '{}'", alias, realmName);

        // with `AuthenticationManagementResource.getFlows()` keycloak is NOT returning all so-called top-level-flows so
        // we need a partial export
        RealmRepresentation realmExport = realmRepository.partialExport(realmName, false, false);
        return realmExport.getAuthenticationFlows()
                .stream()
                .filter(flow -> Objects.equals(flow.getAlias(), alias))
                .findFirst();
    }

    public AuthenticationFlowRepresentation getByAlias(String realmName, String alias) {
        Optional<AuthenticationFlowRepresentation> flow = searchByAlias(realmName, alias);

        if (!flow.isPresent()) {
            throw new KeycloakRepositoryException(
                    "Cannot find top-level-flow '" + alias + "' in realm '" + realmName + "'."
            );
        }

        return flow.get();
    }

    /**
     * creates only the top-level flow WITHOUT its executions or execution-flows
     */
    public void createTopLevel(String realmName, AuthenticationFlowRepresentation flow) {
        logger.trace("Create top-level-flow '{}' in realm '{}'", flow.getAlias(), realmName);

        AuthenticationManagementResource flowsResource = getFlowResources(realmName);
        try {
            Response response = flowsResource.createFlow(flow);
            ResponseUtil.validate(response);
        } catch (WebApplicationException error) {
            String errorMessage = ResponseUtil.getErrorMessage(error);

            throw new ImportProcessingException(
                    "Cannot create top-level-flow '" + flow.getAlias()
                            + "' in realm '" + realmName + "'"
                            + ": " + errorMessage,
                    error
            );
        }
    }

    public void update(String realmName, AuthenticationFlowRepresentation flow) {
        AuthenticationManagementResource flowsResource = getFlowResources(realmName);

        //TODO: drop if we only support keycloak 11 or later
        try {
            InvokeUtil.invoke(
                    flowsResource, "updateFlow",
                    new Class[]{String.class, AuthenticationFlowRepresentation.class},
                    new Object[]{flow.getId(), flow}
            );
        } catch (KeycloakVersionUnsupportedException error) {
            logger.debug("Updating description isn't supported.");
        } catch (InvocationTargetException error) {
            throw new ImportProcessingException(
                    "Cannot update top-level-flow '" + flow.getAlias()
                            + "' in realm '" + realmName + "'"
                            + ".",
                    error
            );
        }
    }

    public AuthenticationFlowRepresentation getById(String realmName, String id) {
        logger.trace("Get flow by id '{}' in realm '{}'", id, realmName);

        AuthenticationManagementResource flowsResource = getFlowResources(realmName);
        return flowsResource.getFlow(id);
    }

    public boolean exists(String realmName, String flowId) {
        try {
            return getById(realmName, flowId) != null;
        } catch (NotFoundException ex) {
            logger.debug("Flow with id '{}' in realm '{}' doesn't exists", flowId, realmName);
            return false;
        }
    }

    public void delete(String realmName, String flow) {
        AuthenticationManagementResource flowsResource = getFlowResources(realmName);

        try {
            flowsResource.deleteFlow(flow);
        } catch (ClientErrorException e) {
            throw new ImportProcessingException("Error occurred while trying to delete top-level-flow by id '" + flow + "' in realm '" + realmName + "'", e);
        }
    }

    AuthenticationManagementResource getFlowResources(String realmName) {
        logger.trace("Get flows-resource in realm '{}'...", realmName);

        RealmResource realmResource = realmRepository.getResource(realmName);
        AuthenticationManagementResource flows = realmResource.flows();

        logger.trace("Got flows-resource in realm '{}'", realmName);

        return flows;
    }

    public List<AuthenticationFlowRepresentation> getTopLevelFlows(String realmName) {
        return getFlowResources(realmName).getFlows();
    }

    public List<AuthenticationFlowRepresentation> getAll(String realmName) {
        RealmRepresentation realmExport = realmRepository.partialExport(realmName, false, false);
        return realmExport.getAuthenticationFlows();
    }

    public Optional<AuthenticationExecutionInfoRepresentation> searchSubFlow(String realmName, String topLevelFlowAlias, String nonTopLevelFlowAlias) {
        logger.trace("Search non-top-level-flow '{}' in realm '{}' and top-level-flow '{}'", nonTopLevelFlowAlias, realmName, topLevelFlowAlias);

        AuthenticationManagementResource flowsResource = getFlowResources(realmName);

        return flowsResource.getExecutions(topLevelFlowAlias)
                .stream()
                /* we have to compare the display name with the alias, because the alias property in
                 AuthenticationExecutionInfoRepresentation representations is always set to null. */
                .filter(flow -> Objects.equals(flow.getDisplayName(), nonTopLevelFlowAlias))
                .findFirst();
    }
}
