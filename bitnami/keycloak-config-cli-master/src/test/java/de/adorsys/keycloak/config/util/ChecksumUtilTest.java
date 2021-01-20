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
import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(GithubActionsExtension.class)
class ChecksumUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, ChecksumUtil::new);
    }

    @Test
    void shouldThrowOnNullString() {
        String nullString = null;

        assertThrows(IllegalArgumentException.class, () -> ChecksumUtil.checksum(nullString));
    }

    @Test
    void shouldThrowOnNullBytes() {
        byte[] nullBytes = null;

        assertThrows(IllegalArgumentException.class, () -> ChecksumUtil.checksum(nullBytes));
    }

    @Test
    void shouldReturnChecksumForEmptyString() {
        String checksum = ChecksumUtil.checksum("");
        assertThat(checksum, is("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"));
    }

    @Test
    void shouldReturnChecksumForABC() {
        String checksum = ChecksumUtil.checksum("ABC");
        assertThat(checksum, is("b5d4045c3f466fa91fe2cc6abe79232a1a57cdf104f7a26e716e0a1e2789df78"));
    }

    @Test
    void shouldReturnChecksumForABCasBytes() {
        String checksum = ChecksumUtil.checksum(new byte[]{65, 66, 67});
        assertThat(checksum, is("b5d4045c3f466fa91fe2cc6abe79232a1a57cdf104f7a26e716e0a1e2789df78"));
    }

    @Test
    void shouldReturnChecksumForJson() {
        String checksum = ChecksumUtil.checksum("{\"property\":\"value\"}");
        assertThat(checksum, is("d7a04cbabf75c2d00df128c13c2b716a69597217351f54e3f3d8b715a28a9395"));
    }
}
