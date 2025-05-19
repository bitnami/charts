#!/bin/sh
CONFIG_FILE="/streampark/conf/config.yaml"

cp /tmp/config.yaml /streampark/conf/config.yaml
cp /tmp/logback-spring.xml /streampark/conf/logback-spring.xml

# Remove any "datasource:" related field and its sub-fields
if [ -f "$CONFIG_FILE" ]; then
    sed -i '/^datasource:/,/^[^[:space:]]/d' "$CONFIG_FILE"
    echo "Removed existing 'datasource:' block from $CONFIG_FILE"
else
    echo "Destination file $CONFIG_FILE does not exist."
    exit 1
fi

# Append a new "datasource:" block
if [ "$DATASOURCE_DIALECT" = "h2" ]; then
    cat <<EOL >> "$CONFIG_FILE"
datasource:
  dialect: $DATASOURCE_DIALECT
EOL
else
    cat <<EOL >> "$CONFIG_FILE"
datasource:
  dialect: $DATASOURCE_DIALECT
  username: $DATASOURCE_USERNAME
  password: $DATASOURCE_PASSWORD
  url: $DATASOURCE_URL
EOL
fi