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
import de.adorsys.keycloak.config.exception.KeycloakProviderException;
import org.junit.jupiter.api.Test;
import org.junitpioneer.jupiter.SetSystemProperty;
import org.springframework.test.context.TestPropertySource;

import javax.ws.rs.NotFoundException;
import javax.ws.rs.ProcessingException;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.matchesPattern;
import static org.junit.jupiter.api.Assertions.assertThrows;

@TestPropertySource(properties = {
        "keycloak.url=https://localhost:1",
        "keycloak.availability-check.enabled=true",
        "keycloak.availability-check.timeout=300ms",
        "keycloak.availability-check.retry-delay=100ms",
})
class KeycloakProviderTimeoutIT extends AbstractImportTest {
    @Test
    void testTimeout() {
        KeycloakProviderException thrown = assertThrows(KeycloakProviderException.class, keycloakProvider::getInstance);

        assertThat(thrown.getMessage(), matchesPattern("Could not connect to keycloak in 0 seconds: .*$"));
    }
}

@SetSystemProperty(key = "http.proxyHost", value = "localhost")
@SetSystemProperty(key = "http.proxyPort", value = "2")
@TestPropertySource(properties = {
        "keycloak.url=https://keycloak:8080/auth/",
})
class KeycloakProviderHttpProxySystemPropertyIT extends AbstractImportTest {
    @Test
    void testHttpProxy() {
        ProcessingException thrown = assertThrows(ProcessingException.class, keycloakProvider::getKeycloakVersion);

        assertThat(thrown.getMessage(), matchesPattern(".+ Connect to localhost:2 .+ failed: .+"));
    }
}

@TestPropertySource(properties = {
        "keycloak.url=https://keycloak:8080/auth/",
        "keycloak.http-proxy=http://localhost:2",
})
class KeycloakProviderHttpProxyIT extends AbstractImportTest {
    @Test
    void testHttpProxy() {
        ProcessingException thrown = assertThrows(ProcessingException.class, keycloakProvider::getKeycloakVersion);

        assertThat(thrown.getMessage(), matchesPattern(".+ Connect to localhost:2 .+ failed: .+"));
    }
}

@TestPropertySource(properties = {
        "keycloak.url=${keycloak.baseUrl}/z/"
})
class KeycloakProviderDeprecatedServerUrlInvalidIT extends AbstractImportTest {
    @Test
    void testDeprecatedServerUrlInvalid() {
        assertThrows(NotFoundException.class, keycloakProvider::getKeycloakVersion);
    }
}
