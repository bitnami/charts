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

public class VersionUtil {
    VersionUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static boolean gt(String a, String b) {
        return compareVersions(a, b) > 0;
    }

    public static boolean ge(String a, String b) {
        return compareVersions(a, b) >= 0;
    }

    public static boolean lt(String a, String b) {
        return compareVersions(a, b) < 0;
    }

    public static boolean le(String a, String b) {
        return compareVersions(a, b) <= 0;
    }

    public static boolean eq(String a, String b) {
        return compareVersions(a, b) == 0;
    }

    public static boolean eqPrefix(String version, String prefix) {
        return version.startsWith(prefix);
    }

    // https://stackoverflow.com/a/27891752/8087167
    public static int compareVersions(String version1, String version2) {
        int comparisonResult = 0;

        String[] version1Splits = version1.split("\\.");
        String[] version2Splits = version2.split("\\.");
        int maxLengthOfVersionSplits = Math.max(version1Splits.length, version2Splits.length);

        for (int i = 0; i < maxLengthOfVersionSplits; i++) {
            Integer v1 = i < version1Splits.length ? Integer.parseInt(version1Splits[i]) : 0;
            Integer v2 = i < version2Splits.length ? Integer.parseInt(version2Splits[i]) : 0;
            int compare = v1.compareTo(v2);
            if (compare != 0) {
                comparisonResult = compare;
                break;
            }
        }
        return comparisonResult;
    }
}
