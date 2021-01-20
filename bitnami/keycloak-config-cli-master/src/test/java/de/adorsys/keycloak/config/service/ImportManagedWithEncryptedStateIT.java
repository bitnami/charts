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

package de.adorsys.keycloak.config.service;

import de.adorsys.keycloak.config.AbstractImportTest;
import de.adorsys.keycloak.config.properties.ImportConfigProperties;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.TestPropertySource;

import java.text.MessageFormat;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.core.Is.is;

@TestPropertySource(properties = {
        "import.state-encryption-key=password",
        "import.managed.role=full"
})
public class ImportManagedWithEncryptedStateIT extends AbstractImportTest {
    private static final String REALM_NAME = "realmWithManagedEncryptedSate";

    @Autowired
    public ImportConfigProperties importConfigProperties;

    ImportManagedWithEncryptedStateIT() {
        this.resourcePath = "import-files/managed-encrypted-state";
    }

    @Test
    @Order(0)
    void shouldCreateEncryptedState() {
        doImport("0_create_realm.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        String attributeKey = MessageFormat.format(
                ImportConfigProperties.REALM_STATE_ATTRIBUTE_PREFIX_KEY,
                importConfigProperties.getCacheKey(),
                "roles-realm"
        ) + "-0";

        assertThat(realm.getAttributes().get(attributeKey), not(containsString("role")));
    }

    @Test
    @Order(1)
    void shouldUpdateEncryptedState() {
        doImport("1_update_realm.json");

        RealmRepresentation realm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();
        assertThat(realm.getRealm(), is(REALM_NAME));
        assertThat(realm.isEnabled(), is(true));

        String attributeKey = MessageFormat.format(
                ImportConfigProperties.REALM_STATE_ATTRIBUTE_PREFIX_KEY,
                importConfigProperties.getCacheKey(),
                "roles-realm"
        ) + "-0";

        assertThat(realm.getAttributes().get(attributeKey), not(containsString("role")));
    }
}
