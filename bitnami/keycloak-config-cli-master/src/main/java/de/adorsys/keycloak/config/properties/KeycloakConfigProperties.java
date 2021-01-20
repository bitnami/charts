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

package de.adorsys.keycloak.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.ConstructorBinding;
import org.springframework.validation.annotation.Validated;

import java.net.URL;
import java.time.Duration;
import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@ConfigurationProperties(prefix = "keycloak")
@ConstructorBinding
@Validated
public class KeycloakConfigProperties {

    @NotBlank
    private final String loginRealm;

    @NotBlank
    private final String clientId;

    @NotNull
    private final URL url;

    @NotBlank
    private final String user;

    @NotBlank
    private final String password;

    @NotNull
    private final boolean sslVerify;

    private final URL httpProxy;

    @Valid
    private final KeycloakAvailabilityCheck availabilityCheck;

    public KeycloakConfigProperties(String loginRealm, String clientId, URL url, String user, String password, boolean sslVerify, URL httpProxy, KeycloakAvailabilityCheck availabilityCheck) {
        this.loginRealm = loginRealm;
        this.clientId = clientId;
        this.url = url;
        this.user = user;
        this.password = password;
        this.sslVerify = sslVerify;
        this.httpProxy = httpProxy;
        this.availabilityCheck = availabilityCheck;
    }

    public String getLoginRealm() {
        return loginRealm;
    }

    public String getClientId() {
        return clientId;
    }

    public URL getUrl() {
        return url;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public boolean isSslVerify() {
        return sslVerify;
    }

    public URL getHttpProxy() {
        return httpProxy;
    }

    public KeycloakAvailabilityCheck getAvailabilityCheck() {
        return availabilityCheck;
    }

    public static class KeycloakAvailabilityCheck {
        @NotNull
        private final boolean enabled;

        @NotNull
        private final Duration timeout;

        @NotNull
        private final Duration retryDelay;

        @SuppressWarnings("unused")
        public KeycloakAvailabilityCheck(boolean enabled, Duration timeout, Duration retryDelay) {
            this.enabled = enabled;
            this.timeout = timeout;
            this.retryDelay = retryDelay;
        }

        public boolean isEnabled() {
            return enabled;
        }

        public Duration getTimeout() {
            return timeout;
        }

        public Duration getRetryDelay() {
            return retryDelay;
        }
    }
}
