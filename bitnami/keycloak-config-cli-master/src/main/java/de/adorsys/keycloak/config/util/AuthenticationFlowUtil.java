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

package de.adorsys.keycloak.config.util;

import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.model.RealmImport;
import org.keycloak.representations.idm.AbstractAuthenticationExecutionRepresentation;
import org.keycloak.representations.idm.AuthenticationExecutionExportRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class AuthenticationFlowUtil {
    AuthenticationFlowUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static AuthenticationFlowRepresentation getNonTopLevelFlow(RealmImport realmImport, String alias) {
        Optional<AuthenticationFlowRepresentation> maybeNonTopLevelFlow = tryToGetNonTopLevelFlow(realmImport, alias);

        if (!maybeNonTopLevelFlow.isPresent()) {
            throw new ImportProcessingException("Non-toplevel flow not found: " + alias);
        }

        return maybeNonTopLevelFlow.get();
    }

    private static Optional<AuthenticationFlowRepresentation> tryToGetNonTopLevelFlow(RealmImport realmImport, String alias) {
        return getNonTopLevelFlows(realmImport)
                .stream()
                .filter(f -> Objects.equals(f.getAlias(), alias))
                .findFirst();
    }

    private static List<AuthenticationFlowRepresentation> getNonTopLevelFlows(RealmImport realmImport) {
        return realmImport.getAuthenticationFlows().stream()
                .filter(f -> !f.isTopLevel())
                .collect(Collectors.toList());
    }

    public static List<AuthenticationFlowRepresentation> getTopLevelFlows(RealmImport realmImport) {
        return realmImport.getAuthenticationFlows().stream()
                .filter(AuthenticationFlowRepresentation::isTopLevel)
                .collect(Collectors.toList());
    }


    public static List<AuthenticationFlowRepresentation> getNonTopLevelFlowsForTopLevelFlow(RealmImport realmImport, AuthenticationFlowRepresentation topLevelFlow) {
        return topLevelFlow.getAuthenticationExecutions()
                .stream()
                .filter(AbstractAuthenticationExecutionRepresentation::isAutheticatorFlow)
                .map(AuthenticationExecutionExportRepresentation::getFlowAlias)
                .map(alias -> getNonTopLevelFlow(realmImport, alias))
                .collect(Collectors.toList());
    }
}
