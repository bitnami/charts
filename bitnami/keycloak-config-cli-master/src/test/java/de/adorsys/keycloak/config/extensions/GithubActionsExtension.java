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

import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.api.extension.TestWatcher;

import java.net.URL;
import java.text.MessageFormat;

// More info: https://help.github.com/en/actions/reference/workflow-commands-for-github-actions
public class GithubActionsExtension implements TestWatcher {
    @Override
    public void testAborted(ExtensionContext context, Throwable cause) {
        formatError(context, cause);
    }

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        if (System.getenv("GITHUB_ACTIONS") != null && System.getenv("GITHUB_ACTIONS").equals("true")) {
            formatError(context, cause);
        }
    }

    @SuppressWarnings("unused")
    private void formatError(ExtensionContext context, Throwable cause) {
        StackTraceElement[] stackTrace = cause.getStackTrace();

        String file = stackTrace[2].getFileName();
        String line = String.valueOf(stackTrace[2].getLineNumber());
        String clazz = stackTrace[2].getClassName();
        String method = stackTrace[2].getMethodName();

        URL callerFilePath = getClass().getClassLoader().getResource(
                stackTrace[2].getClassName().replace('.', '/') + ".class"
        );

        String filePath = callerFilePath == null
                ? file
                : callerFilePath.getFile()
                .replace("target/test-classes/", "src/test/java/")
                .replace(".class", ".java");

        // https://github.com/actions/toolkit/issues/193#issuecomment-605394935
        String message = cause.getMessage() != null
                ? cause.getMessage().replace("\n", "%0A")
                : cause.getCause().getMessage().replace("\n", "%0A");

        String annotation = MessageFormat.format("::error file={0},line={1}::{2}#{3}: {4}", filePath, line, clazz, method, message);

        System.out.println(annotation);
    }
}
