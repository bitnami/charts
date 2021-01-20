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

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.type.MapType;
import de.adorsys.keycloak.config.exception.ImportProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.StreamSupport;

public class CloneUtil {
    private static final Logger logger = LoggerFactory.getLogger(CloneUtil.class);

    private static final ObjectMapper nonNullMapper;
    private static final ObjectMapper nonFailingMapper;

    static {
        nonNullMapper = new ObjectMapper();
        nonNullMapper.setSerializationInclusion(Include.NON_NULL);
        nonNullMapper.setDefaultMergeable(true);

        nonFailingMapper = new ObjectMapper();
        nonFailingMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    CloneUtil() {
        throw new IllegalStateException("Utility class");
    }

    public static <T, S> T deepClone(S object, Class<T> targetClass, String... ignoredProperties) {
        if (object == null) return null;

        Map<String, Object> objectAsMap = toMap(object, ignoredProperties);
        return fromMap(objectAsMap, targetClass);
    }

    @SuppressWarnings("unchecked")
    public static <T> T deepClone(T object, String... ignoredProperties) {
        if (object == null) return null;

        Map<String, Object> objectAsMap = toMap(object, ignoredProperties);
        return (T) fromMap(objectAsMap, object.getClass());
    }

    public static <T, S> S deepPatch(S origin, T patch, String... ignoredProperties) {
        if (origin == null) return null;

        Map<String, Object> patchAsMap = toMap(patch, ignoredProperties);
        return patchFromMap(origin, patchAsMap);
    }

    private static <T, P, C> C patch(T origin, P patch, Class<C> targetClass) {
        JsonNode patchAsNode = nonNullMapper.valueToTree(patch);

        try {
            nonFailingMapper.readerForUpdating(origin).readValue(patchAsNode);
            JsonNode originAsNode = nonNullMapper.valueToTree(origin);

            return nonFailingMapper.treeToValue(originAsNode, targetClass);
        } catch (IOException e) {
            throw new ImportProcessingException(e);
        }
    }

    /**
     * This patch will not merge list properties
     */
    @SuppressWarnings("unchecked")
    public static <T, S> S patch(S origin, T patch, String... ignoredProperties) {
        if (origin == null) return null;

        S clonedOrigin = CloneUtil.deepClone(origin);
        T patchWithoutIgnoredProperties = CloneUtil.deepClone(patch, ignoredProperties);

        return (S) patch(clonedOrigin, patchWithoutIgnoredProperties, origin.getClass());
    }

    public static <T, S> S deepPatchFieldsOnly(S origin, T patch, String... onlyThisFields) {
        if (origin == null) return null;

        Map<String, Object> patchAsMap = toMapFilteredBy(patch, onlyThisFields);
        return patchFromMap(origin, patchAsMap);
    }

    public static <S, T> boolean deepEquals(S origin, T other, String... ignoredProperties) {
        Map<String, Object> originAsMap = toMap(origin, ignoredProperties);
        Map<String, Object> otherAsMap = toMap(other, ignoredProperties);

        boolean ret = Objects.equals(originAsMap, otherAsMap);
        logger.trace("objects.deepEquals: ret: {} | origin: {} | other: {} | ignoredProperties: {}", ret, originAsMap, otherAsMap, ignoredProperties);
        return ret;
    }

    private static <S> Map<String, Object> toMap(S object, String... ignoredProperties) {
        JsonNode objectAsNode = toJsonNode(object, ignoredProperties);

        return jsonNodeToMap(objectAsNode);
    }

    private static Map<String, Object> jsonNodeToMap(JsonNode objectAsNode) {
        MapType typeRef = nonFailingMapper.getTypeFactory().constructMapType(Map.class, String.class, Object.class);
        Map<String, Object> objectAsMap;

        try {
            ObjectReader reader = nonFailingMapper.readerFor(typeRef);
            objectAsMap = reader.readValue(objectAsNode);
        } catch (IOException e) {
            throw new ImportProcessingException(e);
        }

        return objectAsMap;
    }

    private static <S> JsonNode toJsonNode(S object, String... ignoredProperties) {
        JsonNode objectAsNode = nonNullMapper.valueToTree(object);

        removeIgnoredProperties(objectAsNode, ignoredProperties);

        return objectAsNode;
    }

    private static <S> Map<String, Object> toMapFilteredBy(S object, String... allowedKeys) {
        JsonNode objectAsNode = nonNullMapper.valueToTree(object);
        Map<String, Object> objectAsMap = jsonNodeToMap(objectAsNode);

        // https://stackoverflow.com/a/43849125
        Map<String, Object> filteredMap = new HashMap<>(objectAsMap);
        filteredMap.keySet().retainAll(Arrays.asList(allowedKeys));
        return filteredMap;
    }

    private static <T> T fromMap(Map<String, Object> map, Class<T> targetClass) {
        JsonNode mapAsNode = nonNullMapper.valueToTree(map);
        try {
            return nonFailingMapper.treeToValue(mapAsNode, targetClass);
        } catch (JsonProcessingException e) {
            throw new ImportProcessingException(e);
        }
    }

    @SuppressWarnings("unchecked")
    private static <T> T patchFromMap(T origin, Map<String, Object> patchAsMap) {
        JsonNode patchAsNode = nonNullMapper.valueToTree(patchAsMap);
        JsonNode originAsNode = nonNullMapper.valueToTree(origin);

        try {
            nonNullMapper.readerForUpdating(originAsNode).readValue(patchAsNode);
            return (T) nonFailingMapper.treeToValue(originAsNode, origin.getClass());
        } catch (IOException e) {
            throw new ImportProcessingException(e);
        }
    }

    private static void removeIgnoredProperties(JsonNode jsonNode, String[] ignoredProperties) {
        if (jsonNode.isObject()) {
            removeIgnoredProperties((ObjectNode) jsonNode, ignoredProperties);
        } else if (jsonNode.isArray()) {
            removeIgnoredProperties((ArrayNode) jsonNode, ignoredProperties);
        }
    }

    private static void removeIgnoredProperties(ArrayNode arrayNode, String[] ignoredProperties) {
        StreamSupport
                .stream(arrayNode.spliterator(), true)
                .forEach((JsonNode childNode) -> removeIgnoredProperties(childNode, ignoredProperties));
    }

    private static void removeIgnoredProperties(ObjectNode objectNode, String[] ignoredProperties) {
        for (String ignoredProperty : ignoredProperties) {
            if (objectNode.has(ignoredProperty)) {
                objectNode.remove(ignoredProperty);
            } else {
                removeDeepPropertiesIfAny(objectNode, ignoredProperty);
            }
        }
    }

    private static void removeDeepPropertiesIfAny(JsonNode jsonNode, String ignoredProperty) {
        ObjectNode objectNode = (ObjectNode) jsonNode;
        String[] splitProperty = ignoredProperty.split("\\.");

        if (splitProperty.length > 1) {
            removeDeepProperties(objectNode, splitProperty);
        }
    }

    private static void removeDeepProperties(ObjectNode objectNode, String[] splitProperty) {
        String propertyKey = splitProperty[0];
        JsonNode originPropertyValue = objectNode.get(propertyKey);

        String[] removeFirstProperty = Arrays.copyOfRange(splitProperty, 1, splitProperty.length);
        String deepIgnoredProperties = String.join(".", removeFirstProperty);

        JsonNode propertyValue = toJsonNode(originPropertyValue, deepIgnoredProperties);

        objectNode.set(propertyKey, propertyValue);
    }
}
