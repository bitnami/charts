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

import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.properties.ImportConfigProperties;
import de.adorsys.keycloak.config.properties.ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues;
import de.adorsys.keycloak.config.repository.RequiredActionRepository;
import de.adorsys.keycloak.config.service.state.StateService;
import de.adorsys.keycloak.config.util.CloneUtil;
import org.keycloak.representations.idm.RequiredActionProviderRepresentation;
import org.keycloak.representations.idm.RequiredActionProviderSimpleRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Creates and updates required-actions in your realm
 */
@Service
public class RequiredActionsImportService {
    private static final Logger logger = LoggerFactory.getLogger(RequiredActionsImportService.class);

    private final RequiredActionRepository requiredActionRepository;
    private final ImportConfigProperties importConfigProperties;
    private final StateService stateService;

    public RequiredActionsImportService(
            RequiredActionRepository requiredActionRepository,
            ImportConfigProperties importConfigProperties, StateService stateService) {
        this.requiredActionRepository = requiredActionRepository;
        this.importConfigProperties = importConfigProperties;
        this.stateService = stateService;
    }

    public void doImport(RealmImport realmImport) {
        List<RequiredActionProviderRepresentation> requiredActions = realmImport.getRequiredActions();
        if (requiredActions == null) return;

        String realmName = realmImport.getRealm();

        List<RequiredActionProviderRepresentation> existingRequiredActions = requiredActionRepository.getAll(realmName);

        if (importConfigProperties.getManaged().getClientScope() == ImportManagedPropertiesValues.FULL) {
            deleteRequiredActionsMissingInImport(realmName, requiredActions, existingRequiredActions);
        }

        for (RequiredActionProviderRepresentation requiredActionToImport : requiredActions) {
            createOrUpdateRequireAction(realmName, requiredActionToImport);
        }
    }

    private void createOrUpdateRequireAction(
            String realmName,
            RequiredActionProviderRepresentation requiredActionToImport
    ) {
        RequiredActionProviderRepresentation existingRequiredAction = requiredActionRepository
                .getByAlias(realmName, requiredActionToImport.getAlias());

        if (existingRequiredAction != null) {
            updateRequiredActionIfNeeded(realmName, requiredActionToImport, existingRequiredAction);
        } else {
            logger.debug("Creating required action: {}", requiredActionToImport.getAlias());
            createAndConfigureRequiredAction(realmName, requiredActionToImport);
        }
    }

    private void updateRequiredActionIfNeeded(
            String realmName,
            RequiredActionProviderRepresentation requiredActionToImport,
            RequiredActionProviderRepresentation existingRequiredAction
    ) {
        if (hasToBeUpdated(requiredActionToImport, existingRequiredAction)) {
            // Keycloak does not allow to update provider id
            // https://github.com/keycloak/keycloak/blob/eb002c7ecde6ebefeafb7828a582b5f185bcbc86/services/src/main/java/org/keycloak/services/resources/admin/AuthenticationManagementResource.java#L1016
            if (checkIfRecreateIsRequired(requiredActionToImport, existingRequiredAction)) {
                logger.debug("Re-create required action: {}", requiredActionToImport.getAlias());
                deleteRequiredAction(realmName, existingRequiredAction);
                createAndConfigureRequiredAction(realmName, requiredActionToImport);
            } else {
                logger.debug("Updating required action: {}", requiredActionToImport.getAlias());
                updateRequiredAction(realmName, requiredActionToImport, existingRequiredAction);
            }
        } else {
            logger.debug("No need to update required action: {}", requiredActionToImport.getAlias());
        }
    }

    private boolean checkIfRecreateIsRequired(RequiredActionProviderRepresentation requiredActionToImport, RequiredActionProviderRepresentation existingRequiredAction) {
        return !requiredActionToImport.getProviderId().equals(existingRequiredAction.getProviderId());
    }

    private boolean hasToBeUpdated(
            RequiredActionProviderRepresentation requiredActionToImport,
            RequiredActionProviderRepresentation existingRequiredAction
    ) {
        return !CloneUtil.deepEquals(requiredActionToImport, existingRequiredAction);
    }

    private void createAndConfigureRequiredAction(
            String realmName,
            RequiredActionProviderRepresentation requiredActionToImport
    ) {
        RequiredActionProviderSimpleRepresentation requiredActionToCreate = CloneUtil
                .deepClone(requiredActionToImport, RequiredActionProviderSimpleRepresentation.class);

        requiredActionRepository.create(realmName, requiredActionToCreate);

        // See: https://github.com/keycloak/keycloak/blob/d266165f63013f0ea3480ddaa83108ff34da407e/services/src/main/java/org/keycloak/services/resources/admin/AuthenticationManagementResource.java#L932
        RequiredActionProviderRepresentation createdRequiredAction = requiredActionRepository
                .getNewlyCreated(realmName, requiredActionToImport.getName(), requiredActionToImport.getProviderId());

        /*
         we need to update the required-action after creation because the creation only accepts following properties to be set:
         - providerId
         - name
        */
        updateRequiredAction(realmName, createdRequiredAction.getAlias(), requiredActionToImport, createdRequiredAction);
    }

    private void updateRequiredAction(
            String realmName,
            RequiredActionProviderRepresentation requiredActionToImport,
            RequiredActionProviderRepresentation existingRequiredAction
    ) {
        updateRequiredAction(realmName, requiredActionToImport.getAlias(), requiredActionToImport, existingRequiredAction);
    }

    private void updateRequiredAction(
            String realmName,
            String requiredActionAlias,
            RequiredActionProviderRepresentation requiredActionToImport,
            RequiredActionProviderRepresentation existingRequiredAction
    ) {
        RequiredActionProviderRepresentation requiredActionToBeConfigured = CloneUtil.deepClone(existingRequiredAction);

        requiredActionToBeConfigured.setProviderId(requiredActionToImport.getProviderId());
        requiredActionToBeConfigured.setName(requiredActionToImport.getName());
        requiredActionToBeConfigured.setAlias(requiredActionToImport.getAlias());
        requiredActionToBeConfigured.setEnabled(requiredActionToImport.isEnabled());
        requiredActionToBeConfigured.setDefaultAction(requiredActionToImport.isDefaultAction());
        requiredActionToBeConfigured.setPriority(requiredActionToImport.getPriority());
        requiredActionToBeConfigured.setConfig(requiredActionToImport.getConfig());

        requiredActionRepository.update(realmName, requiredActionAlias, requiredActionToBeConfigured);
    }

    private void deleteRequiredActionsMissingInImport(
            String realmName,
            List<RequiredActionProviderRepresentation> importedRequiredActions,
            List<RequiredActionProviderRepresentation> existingRequiredActions
    ) {
        if (importConfigProperties.isState()) {
            List<String> requiredActionsInState = stateService.getRequiredActions();

            // ignore all object there are not in state
            existingRequiredActions = existingRequiredActions.stream()
                    .filter(requiredAction -> requiredActionsInState.contains(requiredAction.getAlias()))
                    .collect(Collectors.toList());
        }

        Set<String> importedRequiredActionAliases = importedRequiredActions.stream()
                .map(RequiredActionProviderRepresentation::getAlias)
                .collect(Collectors.toSet());

        for (RequiredActionProviderRepresentation existingRequiredAction : existingRequiredActions) {
            if (importedRequiredActionAliases.contains(existingRequiredAction.getAlias())) continue;

            logger.debug("Delete requiredAction '{}' in realm '{}'", existingRequiredAction.getAlias(), realmName);
            deleteRequiredAction(realmName, existingRequiredAction);
        }
    }

    private void deleteRequiredAction(String realmName, RequiredActionProviderRepresentation requiredAction) {
        requiredActionRepository.delete(realmName, requiredAction);
    }
}
