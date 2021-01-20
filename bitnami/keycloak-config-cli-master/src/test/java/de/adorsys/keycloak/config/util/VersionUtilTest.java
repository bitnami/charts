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

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(GithubActionsExtension.class)
class VersionUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, VersionUtil::new);
    }

    @Test
    void gt() {
        assertFalse(VersionUtil.gt("10.1", "11"));
        assertFalse(VersionUtil.gt("10.1", "10.1"));
        assertTrue(VersionUtil.gt("10.1", "9.2.1"));
    }

    @Test
    void ge() {
        assertFalse(VersionUtil.ge("10.1", "11"));
        assertTrue(VersionUtil.ge("10.1", "10.1"));
        assertTrue(VersionUtil.ge("10.1", "9.2.1"));
    }

    @Test
    void lt() {
        assertTrue(VersionUtil.lt("10.1", "11"));
        assertFalse(VersionUtil.lt("10.1", "10.1"));
        assertFalse(VersionUtil.lt("10.1", "9.2.1"));
    }

    @Test
    void le() {
        assertTrue(VersionUtil.le("10.1", "11"));
        assertTrue(VersionUtil.le("10.1", "10.1"));
        assertFalse(VersionUtil.le("10.1", "9.2.1"));
    }

    @Test
    void eq() {
        assertFalse(VersionUtil.eq("10.1", "11"));
        assertTrue(VersionUtil.eq("10.1", "10.1"));
        assertFalse(VersionUtil.eq("10.1", "9.2.1"));

        assertFalse(VersionUtil.eq("10.1", "10.1.1"));
        assertFalse(VersionUtil.eq("10.1", "10"));
    }

    @Test
    void eqPrefix() {
        assertTrue(VersionUtil.eqPrefix("10.1", "10.1"));
        assertFalse(VersionUtil.eqPrefix("10.1", "9.2.1"));
    }
}
