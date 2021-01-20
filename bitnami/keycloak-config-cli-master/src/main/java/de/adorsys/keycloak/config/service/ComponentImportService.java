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
import de.adorsys.keycloak.config.repository.ComponentRepository;
import de.adorsys.keycloak.config.service.state.StateService;
import de.adorsys.keycloak.config.util.CloneUtil;
import org.keycloak.common.util.MultivaluedHashMap;
import org.keycloak.representations.idm.ComponentExportRepresentation;
import org.keycloak.representations.idm.ComponentRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@Service
public class ComponentImportService {
    private static final Logger logger = LoggerFactory.getLogger(ComponentImportService.class);

    private final ComponentRepository componentRepository;
    private final ImportConfigProperties importConfigProperties;
    private final StateService stateService;

    @Autowired
    public ComponentImportService(ComponentRepository componentRepository, ImportConfigProperties importConfigProperties, StateService stateService) {
        this.componentRepository = componentRepository;
        this.importConfigProperties = importConfigProperties;
        this.stateService = stateService;
    }

    public void doImport(RealmImport realmImport) {
        MultivaluedHashMap<String, ComponentExportRepresentation> components = realmImport.getComponents();

        if (components == null) {
            return;
        }

        String realmName = realmImport.getRealm();
        importComponents(realmName, components);

        if (importConfigProperties.getManaged().getComponent() == ImportManagedPropertiesValues.FULL) {
            deleteComponentsMissingInImport(realmName, components, null);
        }
    }

    private void importComponents(String realmName, Map<String, List<ComponentExportRepresentation>> componentsToImport) {
        for (Map.Entry<String, List<ComponentExportRepresentation>> entry : componentsToImport.entrySet()) {
            createOrUpdateComponents(realmName, entry.getKey(), entry.getValue());
        }
    }

    private void createOrUpdateComponents(String realmName, String providerType, List<ComponentExportRepresentation> componentsToImport) {
        for (ComponentExportRepresentation componentToImport : componentsToImport) {
            createOrUpdateComponent(realmName, providerType, componentToImport);
        }
    }

    private void createOrUpdateComponent(String realmName, String providerType, ComponentExportRepresentation componentToImport) {
        Optional<ComponentRepresentation> existingComponent = componentRepository.search(
                realmName, providerType, componentToImport.getSubType(), componentToImport.getName()
        );

        if (existingComponent.isPresent()) {
            updateComponentIfNeeded(realmName, providerType, componentToImport, existingComponent.get());
        } else {
            logger.debug("Creating component: {}/{}", providerType, componentToImport.getName());
            createComponent(realmName, providerType, componentToImport);
        }
    }

    private void createComponent(String realmName, String providerType, ComponentExportRepresentation component) {
        createComponent(realmName, providerType, component, null);
    }

    private void createComponent(String realmName, String providerType, ComponentExportRepresentation component, String parentId) {
        ComponentRepresentation componentToCreate = CloneUtil.deepClone(component, ComponentRepresentation.class);

        if (componentToCreate.getProviderType() == null) {
            componentToCreate.setProviderType(providerType);
        }

        if (componentToCreate.getParentId() == null) {
            componentToCreate.setParentId(parentId);
        }

        componentRepository.create(realmName, componentToCreate);

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponents = component.getSubComponents();
        ComponentRepresentation exitingComponent = componentRepository.getByName(realmName, providerType, component.getName());

        if (!subComponents.isEmpty()) {
            createOrUpdateSubComponents(realmName, subComponents, exitingComponent.getId());
        }

        if (importConfigProperties.getManaged().getComponent() == ImportManagedPropertiesValues.FULL) {
            deleteComponentsMissingInImport(realmName, subComponents, exitingComponent);
        }
    }

    private void updateComponentIfNeeded(
            String realmName,
            String providerType,
            ComponentExportRepresentation componentToImport,
            ComponentRepresentation existingComponent
    ) {
        ComponentRepresentation patchedComponent = CloneUtil.patch(existingComponent, componentToImport, "id");

        if (!isComponentEqual(existingComponent, patchedComponent)) {
            updateComponent(realmName, providerType, componentToImport, patchedComponent);
        } else {
            logger.debug("No need to update component: {}/{}", existingComponent.getProviderType(), componentToImport.getName());
        }
    }

    private boolean isComponentEqual(ComponentRepresentation existingComponent, ComponentRepresentation patchedComponent) {
        // compare component config
        MultivaluedHashMap<String, String> existingComponentConfig = existingComponent.getConfig();
        MultivaluedHashMap<String, String> patchedComponentConfig = patchedComponent.getConfig();

        // https://lists.jboss.org/pipermail/keycloak-user/2018-December/016706.html
        boolean isUserStorageProvider = Objects.equals(patchedComponent.getProviderType(), "org.keycloak.storage.ldap.mappers.UserStorageProvider");
        boolean looksEquals = CloneUtil.deepEquals(existingComponent, patchedComponent, "config");
        boolean componentConfigHaveSameKeys = Objects.equals(patchedComponentConfig.keySet(), existingComponentConfig.keySet());
        if (isUserStorageProvider || !looksEquals || !componentConfigHaveSameKeys) {
            return false;
        }

        for (Map.Entry<String, List<String>> config : patchedComponentConfig.entrySet()) {
            List<String> patchedComponentConfigValue = config.getValue();
            List<String> existingComponentConfigValue = existingComponentConfig.get(config.getKey());

            if (!patchedComponentConfigValue.containsAll(existingComponentConfigValue) || !existingComponentConfigValue.containsAll(patchedComponentConfigValue)) {
                return false;
            }
        }

        return true;
    }

    private void updateComponent(
            String realmName,
            String providerType,
            ComponentExportRepresentation componentToImport,
            ComponentRepresentation patchedComponent
    ) {
        logger.debug("Updating component: {}/{}", patchedComponent.getProviderType(), componentToImport.getName());

        if (patchedComponent.getProviderType() == null) {
            patchedComponent.setProviderType(providerType);
        }

        componentRepository.update(realmName, patchedComponent);

        MultivaluedHashMap<String, ComponentExportRepresentation> subComponents = componentToImport.getSubComponents();

        if (!subComponents.isEmpty()) {
            createOrUpdateSubComponents(realmName, subComponents, patchedComponent.getId());
        }

        if (importConfigProperties.getManaged().getSubComponent() == ImportManagedPropertiesValues.FULL) {
            deleteComponentsMissingInImport(realmName, subComponents, patchedComponent);
        }
    }

    private void createOrUpdateSubComponents(String realmName, Map<String, List<ComponentExportRepresentation>> subComponents, String parentId) {
        for (Map.Entry<String, List<ComponentExportRepresentation>> entry : subComponents.entrySet()) {
            createOrUpdateSubComponents(realmName, entry.getKey(), entry.getValue(), parentId);
        }
    }

    private void createOrUpdateSubComponents(String realmName, String providerType, List<ComponentExportRepresentation> subComponents, String parentId) {
        for (ComponentExportRepresentation subComponent : subComponents) {
            createOrUpdateSubComponent(realmName, parentId, providerType, subComponent);
        }
    }

    private void createOrUpdateSubComponent(String realmName, String parentId, String providerType, ComponentExportRepresentation subComponent) {
        Optional<ComponentRepresentation> maybeComponent = componentRepository.search(
                realmName, providerType, subComponent.getSubType(), subComponent.getName(), parentId
        );

        if (maybeComponent.isPresent()) {
            updateComponentIfNeeded(realmName, providerType, subComponent, maybeComponent.get());
        } else {
            createComponent(realmName, providerType, subComponent, parentId);
        }
    }

    private void deleteComponentsMissingInImport(String realmName, MultivaluedHashMap<String, ComponentExportRepresentation> componentsToImport, ComponentRepresentation parentComponent) {
        List<ComponentRepresentation> existingComponents = getAllComponentsFromState(realmName, parentComponent);

        for (ComponentRepresentation existingComponent : existingComponents) {
            if (checkIfComponentMissingImport(existingComponent, componentsToImport)) {
                logger.debug("Delete component: {}/{}", existingComponent.getProviderType(), existingComponent.getName());
                componentRepository.delete(realmName, existingComponent);
            }
        }
    }

    private List<ComponentRepresentation> getAllComponentsFromState(String realmName, ComponentRepresentation parentComponent) {
        String parentId = parentComponent != null ? parentComponent.getId() : null;

        List<ComponentRepresentation> existingComponents = componentRepository.getAll(realmName, parentId);
        if (!importConfigProperties.isState()) {
            return existingComponents;
        }

        String parentName = parentComponent != null ? parentComponent.getName() : null;

        // ignore all object there are not in state
        return stateService.getComponents(existingComponents, parentName);
    }

    private boolean checkIfComponentMissingImport(
            ComponentRepresentation existingComponent,
            MultivaluedHashMap<String, ComponentExportRepresentation> componentsToImport
    ) {
        String existingComponentProviderType = existingComponent.getProviderType();
        String existingComponentName = existingComponent.getName();

        for (Map.Entry<String, List<ComponentExportRepresentation>> entry : componentsToImport.entrySet()) {
            String providerType = entry.getKey();
            List<ComponentExportRepresentation> componentToImport = entry.getValue();

            if (!Objects.equals(existingComponentProviderType, providerType)) {
                continue;
            }

            boolean isInImport = componentToImport.stream().anyMatch(component -> Objects.equals(existingComponentName, component.getName()));

            if (isInImport) {
                return false;
            }
        }

        return true;
    }
}
