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
import org.keycloak.admin.client.resource.AuthenticationManagementResource;
import org.keycloak.representations.idm.AuthenticatorConfigRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class AuthenticatorConfigRepository {
    private final AuthenticationFlowRepository authenticationFlowRepository;
    private final RealmRepository realmRepository;

    @Autowired
    public AuthenticatorConfigRepository(
            AuthenticationFlowRepository authenticationFlowRepository,
            RealmRepository realmRepository
    ) {
        this.authenticationFlowRepository = authenticationFlowRepository;
        this.realmRepository = realmRepository;
    }

    public AuthenticatorConfigRepresentation get(String realmName, String alias) {
        RealmRepresentation realmExport = realmRepository.partialExport(realmName, false, false);
        return realmExport.getAuthenticatorConfig()
                .stream()
                .filter(flow -> Objects.equals(flow.getAlias(), alias))
                .findFirst()
                .orElseThrow(() -> new ImportProcessingException("Authenticator Config '" + alias + "' not found. Config must be used in execution"));
    }

    public void delete(String realmName, String id) {
        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.removeAuthenticatorConfig(id);
    }

    public void create(
            String realmName,
            String executionId,
            AuthenticatorConfigRepresentation authenticatorConfigRepresentation
    ) {
        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.newExecutionConfig(executionId, authenticatorConfigRepresentation);
    }

    public void update(
            String realmName,
            AuthenticatorConfigRepresentation authenticatorConfigRepresentation
    ) {
        AuthenticationManagementResource flowsResource = authenticationFlowRepository.getFlowResources(realmName);
        flowsResource.updateAuthenticatorConfig(authenticatorConfigRepresentation.getId(), authenticatorConfigRepresentation);
    }

    public List<AuthenticatorConfigRepresentation> getAll(String realmName) {
        RealmRepresentation realmExport = realmRepository.partialExport(realmName, false, false);
        return realmExport.getAuthenticatorConfig();
    }
}
