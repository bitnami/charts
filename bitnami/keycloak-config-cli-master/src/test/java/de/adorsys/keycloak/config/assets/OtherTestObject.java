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

package de.adorsys.keycloak.config.assets;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

public class OtherTestObject {
    private final String stringProperty;
    private final Integer integerProperty;
    private final Double doubleProperty;
    private final Long longProperty;
    private final LocalDate localDateProperty;
    private final LocalDateTime localDateTimeProperty;
    private final InnerTestObject innerTestObjectProperty;

    public OtherTestObject(
            @JsonProperty("stringProperty") String stringProperty,
            @JsonProperty("integerProperty") Integer integerProperty,
            @JsonProperty("doubleProperty") Double doubleProperty,
            @JsonProperty("longProperty") Long longProperty,
            @JsonProperty("localDateProperty") LocalDate localDateProperty,
            @JsonProperty("localDateTimeProperty") LocalDateTime localDateTimeProperty,
            @JsonProperty("innerTestObjectProperty") InnerTestObject innerTestObjectProperty
    ) {
        this.stringProperty = stringProperty;
        this.integerProperty = integerProperty;
        this.doubleProperty = doubleProperty;
        this.longProperty = longProperty;
        this.localDateProperty = localDateProperty;
        this.localDateTimeProperty = localDateTimeProperty;
        this.innerTestObjectProperty = innerTestObjectProperty;
    }

    public String getStringProperty() {
        return stringProperty;
    }

    public Integer getIntegerProperty() {
        return integerProperty;
    }

    public Double getDoubleProperty() {
        return doubleProperty;
    }

    public Long getLongProperty() {
        return longProperty;
    }

    public LocalDate getLocalDateProperty() {
        return localDateProperty;
    }

    public LocalDateTime getLocalDateTimeProperty() {
        return localDateTimeProperty;
    }

    public InnerTestObject getInnerTestObjectProperty() {
        return innerTestObjectProperty;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OtherTestObject that = (OtherTestObject) o;

        if (!Objects.equals(stringProperty, that.stringProperty))
            return false;
        if (!Objects.equals(integerProperty, that.integerProperty))
            return false;
        if (!Objects.equals(doubleProperty, that.doubleProperty))
            return false;
        if (!Objects.equals(longProperty, that.longProperty))
            return false;
        if (!Objects.equals(localDateProperty, that.localDateProperty))
            return false;
        if (!Objects.equals(localDateTimeProperty, that.localDateTimeProperty))
            return false;
        return Objects.equals(innerTestObjectProperty, that.innerTestObjectProperty);
    }

    @Override
    public int hashCode() {
        int result = stringProperty != null ? stringProperty.hashCode() : 0;
        result = 31 * result + (integerProperty != null ? integerProperty.hashCode() : 0);
        result = 31 * result + (doubleProperty != null ? doubleProperty.hashCode() : 0);
        result = 31 * result + (longProperty != null ? longProperty.hashCode() : 0);
        result = 31 * result + (localDateProperty != null ? localDateProperty.hashCode() : 0);
        result = 31 * result + (localDateTimeProperty != null ? localDateTimeProperty.hashCode() : 0);
        result = 31 * result + (innerTestObjectProperty != null ? innerTestObjectProperty.hashCode() : 0);
        return result;
    }

    static public class InnerTestObject {
        private final String stringProperty;
        private final Integer integerProperty;
        private final Double doubleProperty;


        public InnerTestObject(
                @JsonProperty("stringProperty") String stringProperty,
                @JsonProperty("integerProperty") Integer integerProperty,
                @JsonProperty("doubleProperty") Double doubleProperty
        ) {
            this.stringProperty = stringProperty;
            this.integerProperty = integerProperty;
            this.doubleProperty = doubleProperty;
        }

        public String getStringProperty() {
            return stringProperty;
        }

        public Integer getIntegerProperty() {
            return integerProperty;
        }

        public Double getDoubleProperty() {
            return doubleProperty;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            InnerTestObject that = (InnerTestObject) o;

            if (!Objects.equals(stringProperty, that.stringProperty))
                return false;
            if (!Objects.equals(integerProperty, that.integerProperty))
                return false;
            return Objects.equals(doubleProperty, that.doubleProperty);
        }

        @Override
        public int hashCode() {
            int result = stringProperty != null ? stringProperty.hashCode() : 0;
            result = 31 * result + (integerProperty != null ? integerProperty.hashCode() : 0);
            result = 31 * result + (doubleProperty != null ? doubleProperty.hashCode() : 0);
            return result;
        }
    }
}
