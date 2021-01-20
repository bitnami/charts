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

import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.exception.KeycloakVersionUnsupportedException;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

public class InvokeUtil {
    InvokeUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static <T> T invoke(Object object, String methodName, Class<?>[] methodParams, Object[] params, Class<T> returnType)
            throws InvocationTargetException {
        try {
            return returnType.cast(
                    object.getClass()
                            .getDeclaredMethod(methodName, methodParams)
                            .invoke(object, params)
            );

        } catch (IllegalAccessException error) {
            throw new ImportProcessingException(error);
        } catch (NoSuchMethodError | NoSuchMethodException error) {
            throw new KeycloakVersionUnsupportedException(error);
        }
    }

    public static void invoke(Object object, String methodName, Class<?>[] methodParams, Object[] params)
            throws InvocationTargetException {
        invoke(object, methodName, methodParams, params, Object.class);
    }

    @SuppressWarnings({"unchecked", "rawtypes", "unused"})
    public static <T> List<T> invoke(Object object, String methodName, Class<?>[] methodParams, Object[] params, Class<List> returnType, Class<T> listType)
            throws InvocationTargetException {
        return invoke(object, methodName, methodParams, params, returnType);
    }
}
