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

import de.adorsys.keycloak.config.exception.KeycloakRepositoryException;
import org.keycloak.admin.client.resource.AuthenticationManagementResource;
import org.keycloak.representations.idm.RequiredActionProviderRepresentation;
import org.keycloak.representations.idm.RequiredActionProviderSimpleRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * Provides methods to retrieve and store required-actions in your realm
 */
@Service
public class RequiredActionRepository {

    private final AuthenticationFlowRepository authenticationFlowRepository;

    @Autowired
    public RequiredActionRepository(AuthenticationFlowRepository authenticationFlowRepository) {
        this.authenticationFlowRepository = authenticationFlowRepository;
    }

    public RequiredActionProviderRepresentation getNewlyCreated(String realmName, String name, String requiredActionProviderId) {
        RequiredActionProviderRepresentation requiredActions = getByAlias(realmName, requiredActionProviderId);

        if (requiredActions == null || !Objects.equals(requiredActions.getName(), name)) {
            throw new KeycloakRepositoryException("Can't find newly created required action: " + requiredActionProviderId);
        }

        return requiredActions;
    }

    public List<RequiredActionProviderRepresentation> getAll(String realmName) {
        AuthenticationManagementResource flows = authenticationFlowRepository.getFlowResources(realmName);

        return flows.getRequiredActions();
    }

    public RequiredActionProviderRepresentation getByAlias(String realmName, String requiredActionAlias) {
        try {
            AuthenticationManagementResource flows = authenticationFlowRepository.getFlowResources(realmName);
            return flows.getRequiredAction(requiredActionAlias);
        } catch (javax.ws.rs.NotFoundException e) {
            return null;
        }
    }

    public void create(String realmName, RequiredActionProviderSimpleRepresentation requiredAction) {
        AuthenticationManagementResource flows = authenticationFlowRepository.getFlowResources(realmName);
        flows.registerRequiredAction(requiredAction);
    }

    public void update(String realmName, String requiredActionAlias, RequiredActionProviderRepresentation requiredAction) {
        AuthenticationManagementResource flows = authenticationFlowRepository.getFlowResources(realmName);
        flows.updateRequiredAction(requiredActionAlias, requiredAction);
    }

    public void delete(String realmName, RequiredActionProviderRepresentation requiredAction) {
        AuthenticationManagementResource flows = authenticationFlowRepository.getFlowResources(realmName);
        flows.removeRequiredAction(requiredAction.getAlias());
    }
}
