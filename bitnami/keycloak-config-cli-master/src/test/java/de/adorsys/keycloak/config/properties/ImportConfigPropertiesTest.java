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

import de.adorsys.keycloak.config.extensions.GithubActionsExtension;
import de.adorsys.keycloak.config.properties.ImportConfigProperties.ImportManagedProperties.ImportManagedPropertiesValues;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

// From: https://tuhrig.de/testing-configurationproperties-in-spring-boot/
@ExtendWith(SpringExtension.class)
@ExtendWith(GithubActionsExtension.class)
@SpringBootTest(classes = {ImportConfigPropertiesTest.TestConfiguration.class})
@TestPropertySource(properties = {
        "spring.main.log-startup-info=false",
        "import.cache-key=custom",
        "import.var-substitution=true",
        "import.var-substitution-in-variables=false",
        "import.var-substitution-undefined-throws-exceptions=false",
        "import.force=true",
        "import.path=other",
        "import.state=false",
        "import.state-encryption-key=password",
        "import.state-encryption-salt=0123456789ABCDEFabcdef",
        "import.file-type=yaml",
        "import.parallel=true",
        "import.managed.authentication-flow=no-delete",
        "import.managed.group=no-delete",
        "import.managed.required-action=no-delete",
        "import.managed.client-scope=no-delete",
        "import.managed.scope-mapping=no-delete",
        "import.managed.component=no-delete",
        "import.managed.sub-component=no-delete",
        "import.managed.identity-provider=no-delete",
        "import.managed.identity-provider-mapper=no-delete",
        "import.managed.role=no-delete",
        "import.managed.client=no-delete",
})
class ImportConfigPropertiesTest {

    @Autowired
    private ImportConfigProperties properties;

    @Test
    void shouldPopulateConfigurationProperties() {
        assertThat(properties.getPath(), is("other"));
        assertThat(properties.isVarSubstitution(), is(true));
        assertThat(properties.isVarSubstitutionInVariables(), is(false));
        assertThat(properties.isVarSubstitutionUndefinedThrowsExceptions(), is(false));
        assertThat(properties.isForce(), is(true));
        assertThat(properties.getCacheKey(), is("custom"));
        assertThat(properties.isState(), is(false));
        assertThat(properties.getStateEncryptionKey(), is("password"));
        assertThat(properties.getStateEncryptionSalt(), is("0123456789ABCDEFabcdef"));
        assertThat(properties.getFileType(), is(ImportConfigProperties.ImportFileType.YAML));
        assertThat(properties.isParallel(), is(true));
        assertThat(properties.getManaged().getAuthenticationFlow(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getGroup(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getRequiredAction(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getClientScope(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getScopeMapping(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getComponent(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getSubComponent(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getIdentityProvider(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getIdentityProviderMapper(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getRole(), is(ImportManagedPropertiesValues.NO_DELETE));
        assertThat(properties.getManaged().getClient(), is(ImportManagedPropertiesValues.NO_DELETE));
    }

    @EnableConfigurationProperties(ImportConfigProperties.class)
    public static class TestConfiguration {
        // nothing
    }
}
