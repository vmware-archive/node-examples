#!/bin/bash

APP_HOME="`pwd -P`"

pushd ${APP_HOME}/data/locator > /dev/null

  gfsh -e "connect --locator=localhost[10337] --user=root --password=root-password " -e "shutdown --include-locators=true --time-out=15"

popd > /dev/null
