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

package de.adorsys.keycloak.config;

import de.adorsys.keycloak.config.exception.InvalidImportException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.matchesPattern;
import static org.junit.jupiter.api.Assertions.assertThrows;

@ContextConfiguration()
@TestPropertySource(properties = {
        "import.path=invalid"
})
class CommandLineImportNotExistsExceptionIT extends AbstractImportTest {
    @Autowired
    KeycloakConfigApplication keycloakConfigApplication;

    @Autowired
    KeycloakConfigRunner runner;

    @Test
    void testInvalidImportException() {
        InvalidImportException thrown = assertThrows(InvalidImportException.class, runner::run);

        assertThat(thrown.getMessage(), matchesPattern("import\\.path does not exists: .+invalid$"));
    }
}
