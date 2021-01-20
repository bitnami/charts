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

import org.apache.commons.codec.digest.DigestUtils;

public class ChecksumUtil {
    ChecksumUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static String checksum(String text) {
        if (text == null) {
            throw new IllegalArgumentException("Cannot calculate checksum of null");
        }

        return DigestUtils.sha256Hex(text);
    }

    public static String checksum(byte[] textInBytes) {
        if (textInBytes == null) {
            throw new IllegalArgumentException("Cannot calculate checksum of null");
        }

        return DigestUtils.sha256Hex(textInBytes);
    }
}
