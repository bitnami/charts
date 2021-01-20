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

package de.adorsys.keycloak.config.model;

import org.keycloak.representations.idm.AuthenticationExecutionExportRepresentation;
import org.keycloak.representations.idm.AuthenticationFlowRepresentation;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Comparator;
import java.util.List;

/**
 * Represents a {@link AuthenticationFlowRepresentation} with authenticationExecutions which are sorted by its priority
 */

@Component
public class AuthenticationFlowImport extends AuthenticationFlowRepresentation {
    private static final Comparator<AuthenticationExecutionExportRepresentation> COMPARATOR = new AuthenticationExecutionExportRepresentationComparator();

    @Override
    public List<AuthenticationExecutionExportRepresentation> getAuthenticationExecutions() {
        return authenticationExecutions;
    }

    @Override
    public void setAuthenticationExecutions(List<AuthenticationExecutionExportRepresentation> authenticationExecutions) {
        authenticationExecutions.sort(COMPARATOR);
        super.setAuthenticationExecutions(authenticationExecutions);
    }

    /**
     * Comparator to sort {@link AuthenticationExecutionExportRepresentation} objects by its priority
     */
    private static class AuthenticationExecutionExportRepresentationComparator implements Comparator<AuthenticationExecutionExportRepresentation>, Serializable {

        @Override
        public int compare(
                AuthenticationExecutionExportRepresentation first,
                AuthenticationExecutionExportRepresentation second
        ) {
            return first.getPriority() - second.getPriority();
        }
    }
}
