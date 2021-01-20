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

import de.adorsys.keycloak.config.assets.ReflectionTestObject;
import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.exception.KeycloakVersionUnsupportedException;
import de.adorsys.keycloak.config.extensions.GithubActionsExtension;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.core.Is.is;
import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(GithubActionsExtension.class)
class InvokeUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, InvokeUtil::new);
    }

    @Test
    void shouldThrowInvalidMethod() {
        List<Integer> list = new ArrayList<>(Arrays.asList(1, 2));

        assertThrows(KeycloakVersionUnsupportedException.class, () -> InvokeUtil.invoke(list, "invalid", null, null));
    }

    @Test
    void shouldThrowExceptionInMethod() {
        ReflectionTestObject object = new ReflectionTestObject();

        assertThrows(ImportProcessingException.class, () -> InvokeUtil.invoke(object, "privateMethod", null, null));
    }

    @Test
    void invokeMethod() throws InvocationTargetException {
        List<Integer> list = new ArrayList<>(Arrays.asList(1, 2));

        InvokeUtil.invoke(list, "clear", null, null);

        assertThat(list, is(empty()));
    }

    @Test
    void invokeMethodWithReturn() throws InvocationTargetException {
        List<Integer> list = new ArrayList<>(Arrays.asList(1, 2));

        Integer firstElement = InvokeUtil.invoke(list, "get", new Class[]{int.class}, new Object[]{0}, Integer.class);

        assertThat(firstElement, is(1));
    }

    @Test
    void invokeMethodWithReturnList() throws InvocationTargetException {
        List<Integer> list = new ArrayList<>(Arrays.asList(1, 2));

        List<Integer> clonedList = InvokeUtil.invoke(list, "subList",
                new Class[]{int.class, int.class},
                new Integer[]{0, 2},
                List.class, Integer.class
        );

        assertThat(clonedList, is(list));
    }
}
