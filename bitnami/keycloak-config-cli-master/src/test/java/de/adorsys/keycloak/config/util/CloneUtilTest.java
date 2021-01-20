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

import de.adorsys.keycloak.config.assets.OtherTestObject;
import de.adorsys.keycloak.config.assets.TestObject;
import de.adorsys.keycloak.config.extensions.GithubActionsExtension;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(GithubActionsExtension.class)
class CloneUtilTest {
    @Test
    void shouldThrowOnNew() {
        assertThrows(IllegalStateException.class, CloneUtil::new);
    }

    @Test
    void shouldBeEqualAfterClone() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(object);

        assertEquals(cloned, object);
    }

    @Test
    void shouldNotBeModifiedIfOriginIsModified() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(object);

        object.setStringProperty("my string 2");

        assertNotEquals(cloned, object);
    }

    @Test
    void shouldNotBeModifiedIfInnerObjectIsModified() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(object);

        object.getInnerTestObjectProperty().setStringProperty("my string 2");

        assertNotEquals(cloned, object);
    }

    @Test
    void shouldCloneDifferentTypes() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        OtherTestObject cloned = CloneUtil.deepClone(object, OtherTestObject.class);

        assertEquals(cloned.getStringProperty(), object.getStringProperty());
        assertEquals(cloned.getIntegerProperty(), object.getIntegerProperty());
        assertEquals(cloned.getDoubleProperty(), object.getDoubleProperty());
        assertEquals(cloned.getLongProperty(), object.getLongProperty());

        assertEquals(cloned.getLocalDateProperty(), object.getLocalDateProperty());
        assertEquals(cloned.getLocalDateTimeProperty(), object.getLocalDateTimeProperty());

        TestObject.InnerTestObject innerTestObject = object.getInnerTestObjectProperty();
        OtherTestObject.InnerTestObject clonedInnerTestObject = cloned.getInnerTestObjectProperty();

        assertEquals(clonedInnerTestObject.getStringProperty(), innerTestObject.getStringProperty());
        assertEquals(clonedInnerTestObject.getIntegerProperty(), innerTestObject.getIntegerProperty());
        assertEquals(clonedInnerTestObject.getDoubleProperty(), innerTestObject.getDoubleProperty());
    }

    @Test
    void shouldIgnorePropertyWhileCloning() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(object, "stringProperty");

        assertNull(cloned.getStringProperty());
    }

    @Test
    void shouldIgnoreDeepPropertyWhileCloning() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(object, "innerTestObjectProperty.stringProperty");

        assertNull(cloned.getInnerTestObjectProperty().getStringProperty());
        assertEquals(4321, cloned.getInnerTestObjectProperty().getIntegerProperty());
        assertEquals(52.72, cloned.getInnerTestObjectProperty().getDoubleProperty());
        assertNull(cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty());
    }

    @Test
    void shouldIgnoreDeeperPropertyWhileCloning() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        new TestObject.InnerTestObject.InnerInnerTestObject(
                                "my deeper string",
                                654,
                                87.32
                        ),
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(
                object,
                "innerTestObjectProperty.innerInnerTestObjectProperty.stringProperty"
        );

        assertNull(cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getStringProperty());
        assertEquals(654, cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getIntegerProperty());
        assertEquals(87.32, cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getDoubleProperty());
    }

    @Test
    void shouldIgnoreDeeperPropertyWhileCloningInnerListObjects() {
        ArrayList<TestObject.InnerTestObject.InnerInnerTestObject> innerInnerTestList = new ArrayList<>();
        TestObject.InnerTestObject.InnerInnerTestObject innerInnerTestObject = new TestObject.InnerTestObject.InnerInnerTestObject(
                "my deeper string",
                9875,
                91.82
        );
        innerInnerTestList.add(innerInnerTestObject);

        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        innerInnerTestList
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(
                object,
                "innerTestObjectProperty.innerInnerTestListProperty.stringProperty"
        );

        List<TestObject.InnerTestObject.InnerInnerTestObject> clonedInnerTestList = cloned.getInnerTestObjectProperty().getInnerInnerTestListProperty();
        assertThat(clonedInnerTestList, hasSize(1));

        TestObject.InnerTestObject.InnerInnerTestObject clonedInnerInnerTestObject = clonedInnerTestList.get(0);

        assertNull(clonedInnerInnerTestObject.getStringProperty());
        assertEquals(9875, clonedInnerInnerTestObject.getIntegerProperty());
        assertEquals(91.82, clonedInnerInnerTestObject.getDoubleProperty());
    }

    @Test
    void shouldIgnoreTwoDeeperPropertiesWhileCloning() {
        TestObject object = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        new TestObject.InnerTestObject.InnerInnerTestObject(
                                "my deeper string",
                                654,
                                87.32
                        ),
                        null
                ),
                null
        );


        TestObject cloned = CloneUtil.deepClone(
                object,
                "innerTestObjectProperty.innerInnerTestObjectProperty.stringProperty",
                "innerTestObjectProperty.innerInnerTestObjectProperty.integerProperty"
        );

        assertNull(cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getStringProperty());
        assertNull(cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getIntegerProperty());
        assertEquals(87.32, cloned.getInnerTestObjectProperty().getInnerInnerTestObjectProperty().getDoubleProperty());
    }


    @Test
    void shouldPatch() {
        TestObject origin = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );

        TestObject patch = new TestObject(
                "my string 1",
                null,
                null,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string 1",
                        4322,
                        null,
                        null,
                        null
                ),
                null
        );

        TestObject cloned = CloneUtil.deepClone(origin);

        TestObject patched = CloneUtil.deepPatch(origin, patch);

        assertEquals(patch.getStringProperty(), patched.getStringProperty());
        assertEquals(origin.getIntegerProperty(), patched.getIntegerProperty());
        assertEquals(origin.getDoubleProperty(), patched.getDoubleProperty());
        assertEquals(patch.getLongProperty(), patched.getLongProperty());
        assertNull(patched.getLocalDateProperty());
        assertNull(patched.getLocalDateTimeProperty());

        TestObject.InnerTestObject patchedInnerObject = patched.getInnerTestObjectProperty();
        assertEquals(patch.getInnerTestObjectProperty().getStringProperty(), patchedInnerObject.getStringProperty());
        assertEquals(patch.getInnerTestObjectProperty().getIntegerProperty(), patchedInnerObject.getIntegerProperty());
        assertEquals(origin.getInnerTestObjectProperty().getDoubleProperty(), patchedInnerObject.getDoubleProperty());

        assertEquals(cloned, origin);
    }

    @Test
    void shouldDeepEqual() {
        TestObject origin = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );

        TestObject other = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );

        assertTrue(CloneUtil.deepEquals(origin, other));
    }

    @Test
    void shouldNotDeepEqual() {
        TestObject origin = new TestObject(
                "my string",
                1234,
                123.123,
                1234L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );

        TestObject other = new TestObject(
                "my string",
                1234,
                123.123,
                1235L,
                null,
                null,
                new TestObject.InnerTestObject(
                        "my other string",
                        4321,
                        52.72,
                        null,
                        null
                ),
                null
        );

        assertFalse(CloneUtil.deepEquals(origin, other));
    }

    @Test
    @SuppressWarnings("ConstantConditions")
    void shouldReturnNull() {
        Object deepClone = CloneUtil.deepClone(null);
        assertThat(deepClone, nullValue());

        Object deepCloneClass = CloneUtil.deepClone(null, TestObject.class);
        assertThat(deepCloneClass, nullValue());

        Object deepPatch = CloneUtil.deepPatch(null, null);
        assertThat(deepPatch, nullValue());

        Object patch = CloneUtil.patch(null, null);
        assertThat(patch, nullValue());

        Object deepPatchFieldsOnly = CloneUtil.deepPatchFieldsOnly(null, null);
        assertThat(deepPatchFieldsOnly, nullValue());

        boolean deepEquals = CloneUtil.deepEquals(null, null);
        assertThat(deepEquals, is(true));
    }
}
