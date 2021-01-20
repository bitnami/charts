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

package de.adorsys.keycloak.config.factory;

import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.repository.AuthenticationFlowRepository;
import de.adorsys.keycloak.config.repository.IdentityProviderRepository;
import de.adorsys.keycloak.config.repository.RealmRepository;
import org.apache.logging.log4j.util.Strings;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.keycloak.representations.idm.IdentityProviderRepresentation;
import org.keycloak.representations.idm.RealmRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UsedAuthenticationFlowWorkaroundFactory {

    private final RealmRepository realmRepository;
    private final IdentityProviderRepository identityProviderRepository;
    private final AuthenticationFlowRepository authenticationFlowRepository;

    @Autowired
    public UsedAuthenticationFlowWorkaroundFactory(RealmRepository realmRepository, IdentityProviderRepository identityProviderRepository, AuthenticationFlowRepository authenticationFlowRepository) {
        this.realmRepository = realmRepository;
        this.identityProviderRepository = identityProviderRepository;
        this.authenticationFlowRepository = authenticationFlowRepository;
    }

    public UsedAuthenticationFlowWorkaround buildFor(RealmImport realmImport) {
        return new UsedAuthenticationFlowWorkaround(realmImport);
    }

    /**
     * There is no possibility to update a top-level-flow and it's not possible to recreate a top-level-flow
     * which is currently in use.
     * So we have to disable our top-level-flow by use a temporary created flow as long as updating the considered flow.
     * This code could be maybe replace by a better update-algorithm of top-level-flows
     */
    public class UsedAuthenticationFlowWorkaround {
        private static final String TEMPORARY_CREATED_AUTH_FLOW = "TEMPORARY_CREATED_AUTH_FLOW";
        private final Logger logger = LoggerFactory.getLogger(UsedAuthenticationFlowWorkaround.class);
        private final RealmImport realmImport;
        private final Map<String, String> resetFirstBrokerLoginFlow = new HashMap<>();
        private String browserFlow;
        private String directGrantFlow;
        private String clientAuthenticationFlow;
        private String dockerAuthenticationFlow;
        private String registrationFlow;
        private String resetCredentialsFlow;

        private UsedAuthenticationFlowWorkaround(RealmImport realmImport) {
            this.realmImport = realmImport;
        }

        public void disableTopLevelFlowIfNeeded(String topLevelFlowAlias) {
            RealmRepresentation existingRealm = realmRepository.get(realmImport.getRealm());

            disableBrowserFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableDirectGrantFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableClientAuthenticationFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableDockerAuthenticationFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableRegistrationFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableResetCredentialsFlowIfNeeded(topLevelFlowAlias, existingRealm);
            disableFirstBrokerLoginFlowsIfNeeded(topLevelFlowAlias, existingRealm);
        }

        private void disableBrowserFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getBrowserFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable browser-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableBrowserFlow(existingRealm);
            }
        }

        private void disableDirectGrantFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getDirectGrantFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable direct-grant-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableDirectGrantFlow(existingRealm);
            }
        }

        private void disableClientAuthenticationFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getClientAuthenticationFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable client-authentication-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableClientAuthenticationFlow(existingRealm);
            }
        }

        private void disableDockerAuthenticationFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getDockerAuthenticationFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable docker-authentication-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableDockerAuthenticationFlow(existingRealm);
            }
        }

        private void disableRegistrationFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getRegistrationFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable registration-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableRegistrationFlow(existingRealm);
            }
        }

        private void disableResetCredentialsFlowIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            if (Objects.equals(existingRealm.getResetCredentialsFlow(), topLevelFlowAlias)) {
                logger.debug("Temporary disable reset-credentials-flow in realm '{}' which is '{}'", realmImport.getRealm(), topLevelFlowAlias);
                disableResetCredentialsFlow(existingRealm);
            }
        }

        private void disableFirstBrokerLoginFlowsIfNeeded(String topLevelFlowAlias, RealmRepresentation existingRealm) {
            List<IdentityProviderRepresentation> identityProviders = existingRealm.getIdentityProviders();
            if (identityProviders != null) {
                for (IdentityProviderRepresentation identityProvider : identityProviders) {
                    if (Objects.equals(identityProvider.getFirstBrokerLoginFlowAlias(), topLevelFlowAlias)) {
                        logger.debug("Temporary disable first-broker-login-flow for identity-provider '{}' in realm '{}' which is '{}'", identityProvider.getAlias(), realmImport.getRealm(), topLevelFlowAlias);
                        disableFirstBrokerLoginFlow(existingRealm.getRealm(), identityProvider);
                    }
                }
            }
        }

        private void disableBrowserFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            browserFlow = existingRealm.getBrowserFlow();

            existingRealm.setBrowserFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableDirectGrantFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            directGrantFlow = existingRealm.getDirectGrantFlow();

            existingRealm.setDirectGrantFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableClientAuthenticationFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            clientAuthenticationFlow = existingRealm.getClientAuthenticationFlow();

            existingRealm.setClientAuthenticationFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableDockerAuthenticationFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            dockerAuthenticationFlow = existingRealm.getDockerAuthenticationFlow();

            existingRealm.setDockerAuthenticationFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableRegistrationFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            registrationFlow = existingRealm.getRegistrationFlow();

            existingRealm.setRegistrationFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableResetCredentialsFlow(RealmRepresentation existingRealm) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            resetCredentialsFlow = existingRealm.getResetCredentialsFlow();

            existingRealm.setResetCredentialsFlow(otherFlowAlias);
            realmRepository.update(existingRealm);
        }

        private void disableFirstBrokerLoginFlow(String realmName, IdentityProviderRepresentation identityProvider) {
            String otherFlowAlias = searchTemporaryCreatedTopLevelFlowForReplacement();

            resetFirstBrokerLoginFlow.put(identityProvider.getAlias(), identityProvider.getFirstBrokerLoginFlowAlias());

            identityProvider.setFirstBrokerLoginFlowAlias(otherFlowAlias);
            identityProviderRepository.update(realmName, identityProvider);
        }

        private String searchTemporaryCreatedTopLevelFlowForReplacement() {
            AuthenticationFlowRepresentation otherFlow;

            Optional<AuthenticationFlowRepresentation> maybeTemporaryCreatedFlow = searchForTemporaryCreatedFlow();

            if (maybeTemporaryCreatedFlow.isPresent()) {
                otherFlow = maybeTemporaryCreatedFlow.get();
            } else {
                logger.debug("Create top-level-flow '{}' in realm '{}' to be used temporarily", realmImport.getRealm(), TEMPORARY_CREATED_AUTH_FLOW);

                AuthenticationFlowRepresentation temporaryCreatedFlow = setupTemporaryCreatedFlow();
                authenticationFlowRepository.createTopLevel(realmImport.getRealm(), temporaryCreatedFlow);

                otherFlow = temporaryCreatedFlow;
            }

            return otherFlow.getAlias();
        }

        private Optional<AuthenticationFlowRepresentation> searchForTemporaryCreatedFlow() {
            List<AuthenticationFlowRepresentation> existingTopLevelFlows = authenticationFlowRepository.getTopLevelFlows(realmImport.getRealm());
            return existingTopLevelFlows.stream()
                    .filter(f -> Objects.equals(f.getAlias(), TEMPORARY_CREATED_AUTH_FLOW))
                    .findFirst();
        }

        public void resetFlowIfNeeded() {
            if (hasToResetFlows()) {
                RealmRepresentation existingRealm = realmRepository.get(realmImport.getRealm());

                resetFlows(existingRealm);
                realmRepository.update(existingRealm);

                if (!flowInUse()) {
                    deleteTemporaryCreatedFlow();
                }
            }
        }

        private boolean flowInUse() {
            RealmRepresentation existingRealm = realmRepository.get(realmImport.getRealm());
            return existingRealm.getBrowserFlow().equals(TEMPORARY_CREATED_AUTH_FLOW)
                    || existingRealm.getDirectGrantFlow().equals(TEMPORARY_CREATED_AUTH_FLOW)
                    || existingRealm.getClientAuthenticationFlow().equals(TEMPORARY_CREATED_AUTH_FLOW)
                    || existingRealm.getDockerAuthenticationFlow().equals(TEMPORARY_CREATED_AUTH_FLOW)
                    || existingRealm.getRegistrationFlow().equals(TEMPORARY_CREATED_AUTH_FLOW)
                    || existingRealm.getResetCredentialsFlow().equals(TEMPORARY_CREATED_AUTH_FLOW);
        }

        private boolean hasToResetFlows() {
            return Strings.isNotBlank(browserFlow)
                    || Strings.isNotBlank(directGrantFlow)
                    || Strings.isNotBlank(clientAuthenticationFlow)
                    || Strings.isNotBlank(dockerAuthenticationFlow)
                    || Strings.isNotBlank(registrationFlow)
                    || Strings.isNotBlank(resetCredentialsFlow)
                    || !resetFirstBrokerLoginFlow.isEmpty();
        }

        private void resetFlows(RealmRepresentation existingRealm) {
            resetBrowserFlowIfNeeded(existingRealm);
            resetDirectGrantFlowIfNeeded(existingRealm);
            resetClientAuthenticationFlowIfNeeded(existingRealm);
            resetDockerAuthenticationFlowIfNeeded(existingRealm);
            resetRegistrationFlowIfNeeded(existingRealm);
            resetCredentialsFlowIfNeeded(existingRealm);
            resetFirstBrokerLoginFlowsIfNeeded(existingRealm);
        }

        private void resetBrowserFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(browserFlow)) {
                logger.debug("Reset browser-flow in realm '{}' to '{}'", realmImport.getRealm(), browserFlow);

                existingRealm.setBrowserFlow(browserFlow);
            }
        }

        private void resetDirectGrantFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(directGrantFlow)) {
                logger.debug("Reset direct-grant-flow in realm '{}' to '{}'", realmImport.getRealm(), directGrantFlow);

                existingRealm.setDirectGrantFlow(directGrantFlow);
            }
        }

        private void resetClientAuthenticationFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(clientAuthenticationFlow)) {
                logger.debug("Reset client-authentication-flow in realm '{}' to '{}'", realmImport.getRealm(), clientAuthenticationFlow);

                existingRealm.setClientAuthenticationFlow(clientAuthenticationFlow);
            }
        }

        private void resetDockerAuthenticationFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(dockerAuthenticationFlow)) {
                logger.debug("Reset docker-authentication-flow in realm '{}' to '{}'", realmImport.getRealm(), dockerAuthenticationFlow);

                existingRealm.setDockerAuthenticationFlow(dockerAuthenticationFlow);
            }
        }

        private void resetRegistrationFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(registrationFlow)) {
                logger.debug("Reset registration-flow in realm '{}' to '{}'", realmImport.getRealm(), registrationFlow);

                existingRealm.setRegistrationFlow(registrationFlow);
            }
        }

        private void resetCredentialsFlowIfNeeded(RealmRepresentation existingRealm) {
            if (Strings.isNotBlank(resetCredentialsFlow)) {
                logger.debug("Reset reset-credentials-flow in realm '{}' to '{}'", realmImport.getRealm(), resetCredentialsFlow);

                existingRealm.setResetCredentialsFlow(resetCredentialsFlow);
            }
        }

        private void resetFirstBrokerLoginFlowsIfNeeded(RealmRepresentation existingRealm) {
            for (Map.Entry<String, String> entry : resetFirstBrokerLoginFlow.entrySet()) {
                logger.debug("Reset first-broker-login-flow for identity-provider '{}' in realm '{}' to '{}'", entry.getKey(), realmImport.getRealm(), resetCredentialsFlow);

                IdentityProviderRepresentation identityProviderRepresentation = identityProviderRepository.getByAlias(existingRealm.getRealm(), entry.getKey());
                identityProviderRepresentation.setFirstBrokerLoginFlowAlias(entry.getValue());
                identityProviderRepository.update(existingRealm.getRealm(), identityProviderRepresentation);
            }
        }

        private void deleteTemporaryCreatedFlow() {
            logger.debug("Delete temporary created top-level-flow '{}' in realm '{}'", TEMPORARY_CREATED_AUTH_FLOW, realmImport.getRealm());

            AuthenticationFlowRepresentation existingTemporaryCreatedFlow = authenticationFlowRepository.getByAlias(realmImport.getRealm(), TEMPORARY_CREATED_AUTH_FLOW);
            authenticationFlowRepository.delete(realmImport.getRealm(), existingTemporaryCreatedFlow.getId());
        }

        private AuthenticationFlowRepresentation setupTemporaryCreatedFlow() {
            AuthenticationFlowRepresentation temporaryCreatedAuthenticationFlow = new AuthenticationFlowRepresentation();

            temporaryCreatedAuthenticationFlow.setAlias(TEMPORARY_CREATED_AUTH_FLOW);
            temporaryCreatedAuthenticationFlow.setTopLevel(true);
            temporaryCreatedAuthenticationFlow.setBuiltIn(false);
            temporaryCreatedAuthenticationFlow.setProviderId(TEMPORARY_CREATED_AUTH_FLOW);

            return temporaryCreatedAuthenticationFlow;
        }
    }
}
