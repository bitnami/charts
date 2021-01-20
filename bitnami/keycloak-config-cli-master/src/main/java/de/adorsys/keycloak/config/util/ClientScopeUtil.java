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

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class ClientScopeUtil {
    ClientScopeUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static List<String> estimateClientScopesToRemove(
            List<String> clientScopes,
            List<String> existingClientScopes
    ) {
        if (clientScopes == null) {
            return new ArrayList<>();
        }

        List<String> clientScopesToRemove = new ArrayList<>();

        if (existingClientScopes == null) {
            return clientScopesToRemove;
        }

        for (String existingClientScope : existingClientScopes) {
            if (clientScopes.stream().noneMatch(scope -> Objects.equals(existingClientScope, scope))) {
                clientScopesToRemove.add(existingClientScope);
            }
        }

        return clientScopesToRemove;
    }

    public static List<String> estimateClientScopesToAdd(
            List<String> clientScopes,
            List<String> existingClientScopes
    ) {
        if (clientScopes == null) {
            return new ArrayList<>();
        }

        List<String> clientScopesToAdd = new ArrayList<>();

        if (existingClientScopes == null) {
            return clientScopes;
        }

        for (String clientScope : clientScopes) {
            if (existingClientScopes.stream().noneMatch(scope -> Objects.equals(clientScope, scope))) {
                clientScopesToAdd.add(clientScope);
            }
        }

        return clientScopesToAdd;
    }
}
