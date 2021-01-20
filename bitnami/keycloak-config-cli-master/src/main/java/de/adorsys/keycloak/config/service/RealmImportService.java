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
import de.adorsys.keycloak.config.provider.KeycloakProvider;
import de.adorsys.keycloak.config.repository.RealmRepository;
import de.adorsys.keycloak.config.service.checksum.ChecksumService;
import de.adorsys.keycloak.config.service.state.StateService;
import de.adorsys.keycloak.config.util.CloneUtil;
import org.keycloak.representations.idm.RealmRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RealmImportService {
    static final String[] ignoredPropertiesForRealmImport = new String[]{
            "clients",
            "roles",
            "users",
            "groups",
            "identityProviders",
            "browserFlow",
            "directGrantFlow",
            "clientAuthenticationFlow",
            "dockerAuthenticationFlow",
            "registrationFlow",
            "resetCredentialsFlow",
            "components",
            "authenticationFlows",
            "scopeMappings",
            "clientScopeMappings",
            "clientScopes",
            "requiredActions"
    };

    static final String[] patchingPropertiesForFlowImport = new String[]{
            "browserFlow",
            "directGrantFlow",
            "clientAuthenticationFlow",
            "dockerAuthenticationFlow",
            "registrationFlow",
            "resetCredentialsFlow",
    };
    private static final Logger logger = LoggerFactory.getLogger(RealmImportService.class);
    private final KeycloakProvider keycloakProvider;
    private final RealmRepository realmRepository;

    private final UserImportService userImportService;
    private final RoleImportService roleImportService;
    private final ClientImportService clientImportService;
    private final ClientScopeImportService clientScopeImportService;
    private final GroupImportService groupImportService;
    private final ComponentImportService componentImportService;
    private final AuthenticationFlowsImportService authenticationFlowsImportService;
    private final AuthenticatorConfigImportService authenticatorConfigImportService;
    private final RequiredActionsImportService requiredActionsImportService;
    private final CustomImportService customImportService;
    private final ScopeMappingImportService scopeMappingImportService;
    private final ClientScopeMappingImportService clientScopeMappingImportService;
    private final IdentityProviderImportService identityProviderImportService;

    private final ImportConfigProperties importProperties;

    private final ChecksumService checksumService;
    private final StateService stateService;

    @Autowired
    public RealmImportService(
            ImportConfigProperties importProperties,
            KeycloakProvider keycloakProvider,
            RealmRepository realmRepository,
            UserImportService userImportService,
            RoleImportService roleImportService,
            ClientImportService clientImportService,
            GroupImportService groupImportService,
            ClientScopeImportService clientScopeImportService,
            ComponentImportService componentImportService,
            AuthenticationFlowsImportService authenticationFlowsImportService,
            AuthenticatorConfigImportService authenticatorConfigImportService,
            RequiredActionsImportService requiredActionsImportService,
            CustomImportService customImportService,
            ScopeMappingImportService scopeMappingImportService,
            ClientScopeMappingImportService clientScopeMappingImportService, IdentityProviderImportService identityProviderImportService,
            ChecksumService checksumService,
            StateService stateService) {
        this.importProperties = importProperties;
        this.keycloakProvider = keycloakProvider;
        this.realmRepository = realmRepository;
        this.userImportService = userImportService;
        this.roleImportService = roleImportService;
        this.clientImportService = clientImportService;
        this.groupImportService = groupImportService;
        this.clientScopeImportService = clientScopeImportService;
        this.componentImportService = componentImportService;
        this.authenticationFlowsImportService = authenticationFlowsImportService;
        this.authenticatorConfigImportService = authenticatorConfigImportService;
        this.requiredActionsImportService = requiredActionsImportService;
        this.customImportService = customImportService;
        this.scopeMappingImportService = scopeMappingImportService;
        this.clientScopeMappingImportService = clientScopeMappingImportService;
        this.identityProviderImportService = identityProviderImportService;
        this.checksumService = checksumService;
        this.stateService = stateService;
    }

    public void doImport(RealmImport realmImport) {
        boolean realmExists = realmRepository.exists(realmImport.getRealm());

        if (realmExists) {
            updateRealmIfNecessary(realmImport);
        } else {
            createRealm(realmImport);
        }

        keycloakProvider.close();
    }

    private void updateRealmIfNecessary(RealmImport realmImport) {
        if (importProperties.isForce() || checksumService.hasToBeUpdated(realmImport)) {
            updateRealm(realmImport);
        } else {
            logger.debug(
                    "No need to update realm '{}', import checksum same: '{}'",
                    realmImport.getRealm(),
                    realmImport.getChecksum()
            );
        }
    }

    private void createRealm(RealmImport realmImport) {
        logger.debug("Creating realm '{}' ...", realmImport.getRealm());

        RealmRepresentation realm = CloneUtil.deepClone(realmImport, RealmRepresentation.class, ignoredPropertiesForRealmImport);
        realmRepository.create(realm);

        configureRealm(realmImport);
    }

    private void updateRealm(RealmImport realmImport) {
        logger.debug("Updating realm '{}'...", realmImport.getRealm());

        RealmRepresentation realm = CloneUtil.deepClone(realmImport, RealmRepresentation.class, ignoredPropertiesForRealmImport);
        realmRepository.update(realm);

        configureRealm(realmImport);
    }

    private void configureRealm(RealmImport realmImport) {
        stateService.loadState(realmImport);

        clientScopeImportService.doImport(realmImport);
        clientImportService.doImport(realmImport);
        roleImportService.doImport(realmImport);
        groupImportService.importGroups(realmImport);
        userImportService.doImport(realmImport);
        requiredActionsImportService.doImport(realmImport);
        authenticationFlowsImportService.doImport(realmImport);
        authenticatorConfigImportService.doImport(realmImport);
        clientImportService.doImportDependencies(realmImport);
        componentImportService.doImport(realmImport);
        identityProviderImportService.doImport(realmImport);
        scopeMappingImportService.doImport(realmImport);
        clientScopeMappingImportService.doImport(realmImport);
        customImportService.doImport(realmImport);

        stateService.doImport(realmImport);
        checksumService.doImport(realmImport);
    }
}
