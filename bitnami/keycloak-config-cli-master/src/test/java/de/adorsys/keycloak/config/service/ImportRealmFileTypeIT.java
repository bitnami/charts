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
import de.adorsys.keycloak.config.exception.InvalidImportException;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.test.context.TestPropertySource;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ImportRealmFileTypeIT extends AbstractImportTest {
    private static final String REALM_NAME = "realm-file-type-auto";

    ImportRealmFileTypeIT() {
        this.resourcePath = "import-files/realm-file-type/auto";
    }

    @Test
    @Order(0)
    void shouldCreateRealm() {
        doImport("0_create_realm.yaml");
        doImport("1_update_realm.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is("moped"));
    }
}

class ImportRealmFileTypeInvalidIT extends AbstractImportTest {
    ImportRealmFileTypeInvalidIT() {
        this.resourcePath = "import-files/realm-file-type/invalid";
    }

    @Test
    @Order(0)
    void shouldThrow() {
        InvalidImportException thrown = assertThrows(InvalidImportException.class, () -> doImport("0_create_realm"));

        assertThat(thrown.getMessage(), is("Unknown file extension: "));
    }
}

class ImportRealmFileTypeSyntaxErrorIT extends AbstractImportTest {
    ImportRealmFileTypeSyntaxErrorIT() {
        this.resourcePath = "import-files/realm-file-type/syntax-error";
    }

    @Test
    @Order(0)
    void shouldThrow() {
        assertThrows(InvalidImportException.class, () -> doImport("0_create_realm"));
    }
}

@TestPropertySource(properties = {
        "import.file-type=yaml",
})
class ImportRealmYamlIT extends AbstractImportTest {
    private static final String REALM_NAME = "realm-file-type-yaml";

    ImportRealmYamlIT() {
        this.resourcePath = "import-files/realm-file-type/yaml";
    }

    @Test
    @Order(0)
    void shouldCreateRealm() {
        doImport("0_create_realm.yaml");
        doImport("1_update_realm.yml");
        doImport("2_update_realm.json");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is("moped"));
        assertThat(createdRealm.getDisplayName(), is("Realm YAML"));
    }
}

@TestPropertySource(properties = {
        "import.file-type=json",
})
class ImportRealmJsonIT extends AbstractImportTest {
    private static final String REALM_NAME = "realm-file-type-json";

    ImportRealmJsonIT() {
        this.resourcePath = "import-files/realm-file-type/json";
    }

    @Test
    @Order(0)
    void shouldCreateRealm() {
        doImport("0_create_realm.json");
        doImport("1_update_realm.yml");

        RealmRepresentation createdRealm = keycloakProvider.getInstance().realm(REALM_NAME).toRepresentation();

        assertThat(createdRealm.getRealm(), is(REALM_NAME));
        assertThat(createdRealm.isEnabled(), is(true));
        assertThat(createdRealm.getLoginTheme(), is("moped"));
    }
}
