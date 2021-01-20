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

package de.adorsys.keycloak.config.provider;

import de.adorsys.keycloak.config.AbstractImportTest;
import de.adorsys.keycloak.config.model.KeycloakImport;
import de.adorsys.keycloak.config.test.util.ResourceLoader;
import org.junit.jupiter.api.Test;

import java.io.File;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.contains;

class KeycloakImportProviderIT extends AbstractImportTest {

    @Test
    void shouldReadFilesSorted() {
        File importPath = ResourceLoader.loadResource("import-files/sorted-import/");
        KeycloakImport keycloakImport = keycloakImportProvider.readRealmImportsFromDirectory(importPath);

        assertThat(keycloakImport.getRealmImports().keySet(), contains(
                "0_create_realm.json",
                "1_update_realm.json",
                "2_update_realm.json",
                "3_update_realm.json",
                "4_update_realm.json",
                "5_update_realm.json",
                "6_update_realm.json",
                "7_update_realm.json",
                "8_update_realm.json",
                "9_update_realm.json"
        ));
    }
}
