#!/bin/bash

cd "$(git rev-parse --show-toplevel)/.vib/nats/goss/testfiles/"
curl -Ls https://api.github.com/repos/nats-io/natscli/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | xargs curl -L -o /tmp/nats-cli.zip
unzip -jo /tmp/nats-cli.zip '*/nats'
rm -rf /tmp/nats-cli.zip
