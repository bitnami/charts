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
import de.adorsys.keycloak.config.repository.IdentityProviderMapperRepository;
import de.adorsys.keycloak.config.repository.IdentityProviderRepository;
import de.adorsys.keycloak.config.util.CloneUtil;
import org.keycloak.representations.idm.IdentityProviderMapperRepresentation;
import org.keycloak.representations.idm.IdentityProviderRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class IdentityProviderImportService {
    private static final Logger logger = LoggerFactory.getLogger(IdentityProviderImportService.class);

    private final IdentityProviderRepository identityProviderRepository;
    private final IdentityProviderMapperRepository identityProviderMapperRepository;
    private final ImportConfigProperties importConfigProperties;

    @Autowired
    public IdentityProviderImportService(IdentityProviderRepository identityProviderRepository, IdentityProviderMapperRepository identityProviderMapperRepository, ImportConfigProperties importConfigProperties) {
        this.identityProviderRepository = identityProviderRepository;
        this.identityProviderMapperRepository = identityProviderMapperRepository;
        this.importConfigProperties = importConfigProperties;
    }

    public void doImport(RealmImport realmImport) {
        createOrUpdateOrDeleteIdentityProviders(realmImport);
        createOrUpdateOrDeleteIdentityProviderMappers(realmImport);
    }

    private void createOrUpdateOrDeleteIdentityProviders(RealmImport realmImport) {
        String realmName = realmImport.getRealm();
        List<IdentityProviderRepresentation> identityProviders = realmImport.getIdentityProviders();
        List<IdentityProviderRepresentation> existingIdentityProviders = identityProviderRepository.getAll(realmName);

        if (identityProviders == null) return;

        if (importConfigProperties.getManaged().getIdentityProvider() == ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues.FULL) {
            deleteIdentityProvidersMissingInImport(realmName, identityProviders, existingIdentityProviders);
        }

        for (IdentityProviderRepresentation identityProvider : identityProviders) {
            createOrUpdateIdentityProvider(realmImport, identityProvider);
        }
    }

    private void deleteIdentityProvidersMissingInImport(String realmName, List<IdentityProviderRepresentation> identityProviders, List<IdentityProviderRepresentation> existingIdentityProviders) {
        for (IdentityProviderRepresentation identityProvider : existingIdentityProviders) {
            if (!hasIdentityProviderWithAlias(identityProviders, identityProvider.getAlias())) {
                logger.debug("Delete identityProvider '{}' in realm '{}'", identityProvider.getAlias(), realmName);
                identityProviderRepository.delete(realmName, identityProvider);
            }
        }
    }

    private void createOrUpdateIdentityProvider(RealmImport realmImport, IdentityProviderRepresentation identityProvider) {
        String identityProviderName = identityProvider.getAlias();
        String realmName = realmImport.getRealm();

        Optional<IdentityProviderRepresentation> maybeIdentityProvider = identityProviderRepository.search(realmName, identityProviderName);

        if (maybeIdentityProvider.isPresent()) {
            updateIdentityProviderIfNecessary(realmName, identityProvider);
        } else {
            logger.debug("Create identityProvider '{}' in realm '{}'", identityProviderName, realmName);
            identityProviderRepository.create(realmName, identityProvider);
        }
    }

    private void updateIdentityProviderIfNecessary(String realmName, IdentityProviderRepresentation identityProvider) {
        IdentityProviderRepresentation existingIdentityProvider = identityProviderRepository.getByAlias(realmName, identityProvider.getAlias());
        IdentityProviderRepresentation patchedIdentityProvider = CloneUtil.patch(existingIdentityProvider, identityProvider);
        String identityProviderAlias = existingIdentityProvider.getAlias();

        if (isIdentityProviderEqual(existingIdentityProvider, patchedIdentityProvider)) {
            logger.debug("No need to update identityProvider '{}' in realm '{}'", identityProviderAlias, realmName);
        } else {
            logger.debug("Update identityProvider '{}' in realm '{}'", identityProviderAlias, realmName);
            identityProviderRepository.update(realmName, patchedIdentityProvider);
        }
    }

    private boolean isIdentityProviderEqual(IdentityProviderRepresentation existingIdentityProvider, IdentityProviderRepresentation patchedIdentityProvider) {
        return CloneUtil.deepEquals(existingIdentityProvider, patchedIdentityProvider);
    }

    private boolean hasIdentityProviderWithAlias(List<IdentityProviderRepresentation> identityProviders, String identityProviderAlias) {
        return identityProviders.stream().anyMatch(idp -> Objects.equals(idp.getAlias(), identityProviderAlias));
    }

    private void createOrUpdateOrDeleteIdentityProviderMappers(RealmImport realmImport) {
        String realmName = realmImport.getRealm();
        List<IdentityProviderMapperRepresentation> identityProviderMappers = realmImport.getIdentityProviderMappers();
        List<IdentityProviderMapperRepresentation> existingIdentityProviderMappers = identityProviderMapperRepository.getAll(realmName);

        if (identityProviderMappers == null) return;

        if (importConfigProperties.getManaged().getIdentityProviderMapper() == ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues.FULL) {
            deleteIdentityProviderMappersMissingInImport(realmName, identityProviderMappers, existingIdentityProviderMappers);
        }

        for (IdentityProviderMapperRepresentation identityProviderMapper : identityProviderMappers) {
            createOrUpdateIdentityProviderMapper(realmImport, identityProviderMapper);
        }
    }

    private void createOrUpdateIdentityProviderMapper(RealmImport realmImport, IdentityProviderMapperRepresentation identityProviderMapper) {
        String identityProviderMapperName = identityProviderMapper.getName();
        String realmName = realmImport.getRealm();

        Optional<IdentityProviderMapperRepresentation> maybeIdentityProviderMapper = identityProviderMapperRepository.search(realmName, identityProviderMapper.getIdentityProviderAlias(), identityProviderMapperName);

        if (maybeIdentityProviderMapper.isPresent()) {
            updateIdentityProviderMapperIfNecessary(realmName, identityProviderMapper);
        } else {
            logger.debug("Create identityProviderMapper '{}' in realm '{}'", identityProviderMapperName, realmName);
            identityProviderMapperRepository.create(realmName, identityProviderMapper);
        }
    }

    private void updateIdentityProviderMapperIfNecessary(String realmName, IdentityProviderMapperRepresentation identityProviderMapper) {
        IdentityProviderMapperRepresentation existingIdentityProviderMapper = identityProviderMapperRepository.get(realmName, identityProviderMapper.getIdentityProviderAlias(), identityProviderMapper.getName());
        IdentityProviderMapperRepresentation patchedIdentityProviderMapper = CloneUtil.patch(existingIdentityProviderMapper, identityProviderMapper, "id");
        String identityProviderMapperName = existingIdentityProviderMapper.getName();
        String identityProviderAlias = existingIdentityProviderMapper.getIdentityProviderAlias();

        if (isIdentityProviderMapperEqual(existingIdentityProviderMapper, patchedIdentityProviderMapper)) {
            logger.debug("No need to update identityProviderMapper for identityProvider '{}' in realm '{}' in realm '{}'", identityProviderMapperName, identityProviderAlias, realmName);
        } else {
            logger.debug("Update identityProviderMapper '{}' for identityProvider '{}' in realm '{}'", identityProviderMapperName, identityProviderAlias, realmName);
            identityProviderMapperRepository.update(realmName, patchedIdentityProviderMapper);
        }
    }

    private boolean isIdentityProviderMapperEqual(IdentityProviderMapperRepresentation existingIdentityProviderMapper, IdentityProviderMapperRepresentation patchedIdentityProviderMapper) {
        return CloneUtil.deepEquals(existingIdentityProviderMapper, patchedIdentityProviderMapper);
    }


    private void deleteIdentityProviderMappersMissingInImport(String realmName, List<IdentityProviderMapperRepresentation> identityProviderMappers, List<IdentityProviderMapperRepresentation> existingIdentityProviderMappers) {
        for (IdentityProviderMapperRepresentation identityProviderMapper : existingIdentityProviderMappers) {
            if (!hasIdentityProviderMapperWithNameForAlias(identityProviderMappers, identityProviderMapper)) {
                logger.debug("Delete identityProviderMapper '{}' in realm '{}'", identityProviderMapper.getName(), realmName);
                identityProviderMapperRepository.delete(realmName, identityProviderMapper);
            }
        }
    }

    private boolean hasIdentityProviderMapperWithNameForAlias(List<IdentityProviderMapperRepresentation> identityProviderMappers, IdentityProviderMapperRepresentation identityProviderMapper) {
        return identityProviderMappers.stream()
                .anyMatch(mapper ->
                        Objects.equals(mapper.getName(), identityProviderMapper.getName())
                                && Objects.equals(mapper.getIdentityProviderAlias(), identityProviderMapper.getIdentityProviderAlias())
                );
    }

}
