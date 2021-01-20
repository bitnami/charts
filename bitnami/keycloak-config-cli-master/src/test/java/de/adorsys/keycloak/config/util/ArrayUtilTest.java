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
class ArrayUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, ArrayUtil::new);
    }

    @Test
    void concatStringArrays() {
        //noinspection RedundantArrayCreation
        String[] array = ArrayUtil.concat(new String[]{"A", "B"}, new String[]{"C", "D"});

        assertThat(array, is(new String[]{"A", "B", "C", "D"}));
    }

    @Test
    void concatStrings() {
        String[] array = ArrayUtil.concat(new String[]{"A", "B"}, "C", "D");

        assertThat(array, is(new String[]{"A", "B", "C", "D"}));
    }

    @Test
    void concatIntegerArrays() {
        //noinspection RedundantArrayCreation
        Integer[] array = ArrayUtil.concat(new Integer[]{1, 2}, new Integer[]{3, 4});

        assertThat(array, is(new Integer[]{1, 2, 3, 4}));
    }

    @Test
    void concatIntegers() {
        Integer[] array = ArrayUtil.concat(new Integer[]{1, 2}, 3, 4);

        assertThat(array, is(new Integer[]{1, 2, 3, 4}));
    }
}
