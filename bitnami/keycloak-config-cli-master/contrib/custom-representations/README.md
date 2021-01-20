# Custom Representation

This is an example how it extends this Representation, like RealmRepresentation. See [#163](https://github.com/adorsys/keycloak-config-cli/issues/163) for more information.

## How to use

First, copy an existing Representation from [keycloak/keycloak](https://github.com/keycloak/keycloak/blob/master/core/src/main/java/org/keycloak/representations/idm/) repository.

Ensure that you are using the correct tag, e.g. if you are using Keycloak 11.0.1, select v11.0.1 from the tag drop-down menu. Do not modify class or package name.

Copy the file to `src/main/java/org/keycloak/representations/idm/` and modify the schema as required. Any new class property need a java getter and setter.

If you're done, run `mvn clean package`. Your jar is build inside the `target` directory.

## Integrate

You could load the additional jar file by `-Dloader.path`.

### Example
```bash
java -Dloader.path=./custom-representations.jar -jar target/keycloak-config-cli.jar
```

### Verify
To verify that the representation is used from the provided jar, run:

```bash
$ java -verbose:class -Dloader.path=./custom-representations.jar -jar target/keycloak-config-cli.jar |& grep RealmRepresentation
[Loaded org.keycloak.representations.idm.RealmRepresentation from file:.../custom-representations.jar]
```

You check if the `org.keycloak.representations.idm.RealmRepresentation` is loaded from `custom-representations.jar`.
