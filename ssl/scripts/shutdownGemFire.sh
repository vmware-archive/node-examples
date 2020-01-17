#!/bin/bash

APP_HOME="`pwd -P`"

pushd ${APP_HOME}/data/locator > /dev/null

gfsh -e "connect --locator=localhost[10337] --use-ssl=true --key-store=${APP_HOME}/keys/server_keystore.p12 --trust-store=${APP_HOME}/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode" -e "shutdown --include-locators=true --time-out=15"

popd > /dev/null
