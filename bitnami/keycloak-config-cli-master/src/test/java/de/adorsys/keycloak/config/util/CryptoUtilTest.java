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

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsNot.not;
import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(GithubActionsExtension.class)
class CryptoUtilTest {
    private static final String salt = "8488890B3D6473AE1B6BF0829DA959B3";

    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, CryptoUtil::new);
    }

    @Test
    void encryptDecrypt() {
        String data = "secure data";
        String key = "secure key";

        String encryptedData = CryptoUtil.encrypt(data, key, salt);
        assertThat(encryptedData, not(is(data)));

        String decryptedData = CryptoUtil.decrypt(encryptedData, key, salt);
        assertThat(decryptedData, is(data));
    }

    @Test
    void encryptDecryptWrong() {
        String encryptedData = CryptoUtil.encrypt("data", "key1", salt);
        assertThrows(IllegalStateException.class, () -> CryptoUtil.decrypt(encryptedData, "key2", salt));
    }
}
