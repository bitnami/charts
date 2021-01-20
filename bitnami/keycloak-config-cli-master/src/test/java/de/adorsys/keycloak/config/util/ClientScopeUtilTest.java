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

import de.adorsys.keycloak.config.extensions.GithubActionsExtension;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(GithubActionsExtension.class)
class ClientScopeUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, ClientScopeUtil::new);
    }

    @Test
    void estimateClientScopesToAdd() {
        List<String> scopes = new ArrayList<>();
        scopes.add("1");
        scopes.add("2");
        scopes.add("3");

        List<String> scopesToAdd = ClientScopeUtil.estimateClientScopesToAdd(null, scopes);
        assertThat(scopesToAdd, empty());

        scopesToAdd = ClientScopeUtil.estimateClientScopesToAdd(scopes, null);
        assertThat(scopesToAdd, is(scopes));
    }

    @Test
    void estimateClientScopesToRemove() {
        List<String> scopes = new ArrayList<>();
        scopes.add("1");
        scopes.add("2");
        scopes.add("3");

        List<String> scopesToRemove;
        scopesToRemove = ClientScopeUtil.estimateClientScopesToRemove(scopes, null);
        assertThat(scopesToRemove, empty());

        scopesToRemove = ClientScopeUtil.estimateClientScopesToRemove(null, scopes);
        assertThat(scopesToRemove, empty());
    }
}
