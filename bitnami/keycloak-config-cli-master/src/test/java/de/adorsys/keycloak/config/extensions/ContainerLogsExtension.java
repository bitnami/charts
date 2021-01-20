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

package de.adorsys.keycloak.config.extensions;

import org.junit.jupiter.api.extension.BeforeAllCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.TestWatcher;

import static de.adorsys.keycloak.config.AbstractImportTest.KEYCLOAK_CONTAINER_LOGS;

public class ContainerLogsExtension implements TestWatcher, BeforeAllCallback, ExtensionContext.Store.CloseableResource {
    private static boolean outputLog = false;
    private static boolean started = false;

    @Override
    public void testAborted(ExtensionContext context, Throwable cause) {
        outputLog = true;
    }

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        outputLog = true;
    }

    @Override
    // https://stackoverflow.com/a/62504238/8087167
    public void beforeAll(ExtensionContext extensionContext) {
        synchronized (ContainerLogsExtension.class) {
            if (!started) {
                started = true;

                // register a callback hook for when the root test context is shut down
                extensionContext
                        .getRoot()
                        .getStore(ExtensionContext.Namespace.GLOBAL)
                        .put("close", this);
            }
        }
    }

    @Override
    public void close() {
        synchronized (ContainerLogsExtension.class) {
            if (outputLog) {
                outputLog = false;

                String logs = KEYCLOAK_CONTAINER_LOGS.toUtf8String();
                System.out.println("\n\nKeycloak Container Logs:");
                // Remove double newlines
                // See: https://github.com/testcontainers/testcontainers-java/issues/1763
                System.out.println(logs.replaceAll("\n\n", "\n"));
            }
        }
    }
}
