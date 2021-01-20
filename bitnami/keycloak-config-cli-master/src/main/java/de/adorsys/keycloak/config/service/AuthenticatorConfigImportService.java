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
import de.adorsys.keycloak.config.repository.AuthenticationFlowRepository;
import de.adorsys.keycloak.config.repository.AuthenticatorConfigRepository;
import org.keycloak.representations.idm.AbstractAuthenticationExecutionRepresentation;
import org.keycloak.representations.idm.AuthenticationExecutionExportRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.keycloak.representations.idm.AuthenticatorConfigRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class AuthenticatorConfigImportService {
    private static final Logger logger = LoggerFactory.getLogger(AuthenticatorConfigImportService.class);

    private final AuthenticationFlowRepository authenticationFlowRepository;
    private final AuthenticatorConfigRepository authenticatorConfigRepository;

    @Autowired
    public AuthenticatorConfigImportService(
            AuthenticationFlowRepository authenticationFlowRepository, AuthenticatorConfigRepository authenticatorConfigRepository) {
        this.authenticationFlowRepository = authenticationFlowRepository;
        this.authenticatorConfigRepository = authenticatorConfigRepository;
    }


    /**
     * How the import works:
     * - check the authentication flows:
     * -- if the flow is not present: create the authentication flow
     * -- if the flow is present, check:
     * --- if the flow contains any changes: update the authentication flow, which means: delete and recreate the authentication flow
     * --- if nothing of above: do nothing
     */
    public void doImport(RealmImport realmImport) {
        deleteUnused(realmImport);

        List<AuthenticatorConfigRepresentation> authenticatorConfigs = realmImport.getAuthenticatorConfig();
        if (authenticatorConfigs == null) return;

        for (AuthenticatorConfigRepresentation authenticatorConfig : authenticatorConfigs) {
            updateAuthenticatorConfig(realmImport, authenticatorConfig);
        }
    }

    private void deleteUnused(RealmImport realmImport) {
        List<AuthenticatorConfigRepresentation> unusedAuthenticatorConfigs = getUnusedAuthenticatorConfigs(realmImport);

        for (AuthenticatorConfigRepresentation unusedAuthenticatorConfig : unusedAuthenticatorConfigs) {
            logger.debug("Delete authenticator config: {}", unusedAuthenticatorConfig.getAlias());
            authenticatorConfigRepository.delete(realmImport.getRealm(), unusedAuthenticatorConfig.getId());
        }
    }

    /**
     * creates or updates only the top-level flow and its executions or execution-flows
     */
    private void updateAuthenticatorConfig(
            RealmImport realmImport,
            AuthenticatorConfigRepresentation authenticatorConfigRepresentation
    ) {

        AuthenticatorConfigRepresentation existingAuthConfig = authenticatorConfigRepository
                .get(realmImport.getRealm(), authenticatorConfigRepresentation.getAlias());

        authenticatorConfigRepresentation.setId(existingAuthConfig.getId());
        authenticatorConfigRepository.update(realmImport.getRealm(), authenticatorConfigRepresentation);
    }

    private List<AuthenticatorConfigRepresentation> getUnusedAuthenticatorConfigs(RealmImport realmImport) {
        List<AuthenticationFlowRepresentation> authenticationFlowsToImport = realmImport.getAuthenticationFlows();
        if (authenticationFlowsToImport == null) {
            return Collections.emptyList();
        }

        List<AuthenticationFlowRepresentation> authenticationFlows = mergeAuthenticationFlowsFromImportAndKeycloak(realmImport, authenticationFlowsToImport);

        List<AuthenticationExecutionExportRepresentation> authenticationExecutions = authenticationFlows
                .stream()
                .flatMap((Function<AuthenticationFlowRepresentation, Stream<AuthenticationExecutionExportRepresentation>>) x -> x.getAuthenticationExecutions().stream())
                .collect(Collectors.toList());

        List<AuthenticatorConfigRepresentation> authenticatorConfigs = authenticatorConfigRepository.getAll(realmImport.getRealm());

        List<String> authExecutionsWithAuthenticatorConfigs = authenticationExecutions
                .stream()
                .map(AbstractAuthenticationExecutionRepresentation::getAuthenticatorConfig)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        return authenticatorConfigs
                .stream()
                .filter(x -> !authExecutionsWithAuthenticatorConfigs.contains(x.getAlias()))
                .collect(Collectors.toList());
    }

    private List<AuthenticationFlowRepresentation> mergeAuthenticationFlowsFromImportAndKeycloak(RealmImport realmImport, List<AuthenticationFlowRepresentation> authenticationFlowsToImport) {
        List<AuthenticationFlowRepresentation> existingAuthenticationFlows = authenticationFlowRepository.getAll(realmImport.getRealm());
        List<AuthenticationFlowRepresentation> authenticationFlows = new ArrayList<>();

        // Merge authenticationFlows from keycloak and import
        for (AuthenticationFlowRepresentation existingAuthenticationFlow : existingAuthenticationFlows) {
            authenticationFlows.add(
                    authenticationFlowsToImport.stream()
                            .filter(flow -> Objects.equals(flow.getAlias(), existingAuthenticationFlow.getAlias()))
                            .findFirst()
                            .orElse(existingAuthenticationFlow)
            );
        }
        return authenticationFlows;
    }
}
