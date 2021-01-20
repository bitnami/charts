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

package de.adorsys.keycloak.config.repository;

import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.properties.ImportConfigProperties;
import de.adorsys.keycloak.config.util.CryptoUtil;
import org.keycloak.representations.idm.RealmRepresentation;
import org.springframework.stereotype.Component;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static de.adorsys.keycloak.config.util.JsonUtil.fromJson;
import static de.adorsys.keycloak.config.util.JsonUtil.toJson;

@Component
public class StateRepository {
    private static final int MAX_ATTRIBUTE_LENGTH = 250;

    private final RealmRepository realmRepository;
    private final ImportConfigProperties importConfigProperties;

    private Map<String, String> customAttributes;

    public StateRepository(RealmRepository realmRepository, ImportConfigProperties importConfigProperties) {
        this.realmRepository = realmRepository;
        this.importConfigProperties = importConfigProperties;
    }

    // https://stackoverflow.com/a/3760193/8087167
    private static List<String> splitEqually(String text) {
        // Give the list the right capacity to start with. You could use an array
        // instead if you wanted.

        int size = MAX_ATTRIBUTE_LENGTH;

        List<String> ret = new ArrayList<>((text.length() + size - 1) / size);

        for (int start = 0; start < text.length(); start += size) {
            ret.add(text.substring(start, Math.min(text.length(), start + size)));
        }
        return ret;
    }

    public void loadCustomAttributes(String realmName) {
        customAttributes = retrieveCustomAttributes(realmName);
    }

    public List<String> getState(String entity) {
        List<String> stateValues = new ArrayList<>();

        long attributeCount = customAttributes
                .entrySet()
                .stream()
                .filter(attribute -> attribute.getKey().startsWith(getCustomAttributeKey(entity) + "-"))
                .count();

        for (int index = 0; index < attributeCount; index++) {
            stateValues.add(customAttributes.get(getCustomAttributeKey(entity) + "-" + index));
        }

        if (stateValues.isEmpty()) {
            return Collections.emptyList();
        }

        String state = String.join("", stateValues);

        if (this.importConfigProperties.getStateEncryptionKey() != null) {
            state = CryptoUtil.decrypt(
                    state,
                    this.importConfigProperties.getStateEncryptionKey(),
                    this.importConfigProperties.getStateEncryptionSalt()
            );
        }

        return fromJson(state);
    }

    public void update(RealmImport realmImport) {
        RealmRepresentation existingRealm = realmRepository.get(realmImport.getRealm());
        Map<String, String> realmAttributes = existingRealm.getAttributes();
        realmAttributes.putAll(customAttributes);

        realmRepository.update(existingRealm);
    }

    private String getCustomAttributeKey(String entity) {
        return MessageFormat.format(
                ImportConfigProperties.REALM_STATE_ATTRIBUTE_PREFIX_KEY,
                importConfigProperties.getCacheKey(),
                entity
        );
    }

    private Map<String, String> retrieveCustomAttributes(String realmName) {
        RealmRepresentation existingRealm = realmRepository.get(realmName);
        return existingRealm.getAttributes();
    }

    public void setState(String entity, List<Object> values) {
        String valuesAsString = toJson(values);

        if (this.importConfigProperties.getStateEncryptionKey() != null) {
            valuesAsString = CryptoUtil.encrypt(
                    valuesAsString,
                    this.importConfigProperties.getStateEncryptionKey(),
                    this.importConfigProperties.getStateEncryptionSalt()
            );
        }

        List<String> valueList = splitEqually(valuesAsString);

        customAttributes.entrySet()
                .removeIf(attribute -> attribute.getKey().startsWith(getCustomAttributeKey(entity) + "-"));

        // split value into multiple attributes to avoid max length limit
        int index = 0;
        for (String value : valueList) {
            customAttributes.put(getCustomAttributeKey(entity) + "-" + index, value);
            index++;
        }
    }
}
