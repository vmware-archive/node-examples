#!/bin/bash

APP_HOME="`pwd -P`"

function launchLocator() {
    echo ""
    echo "*** Launch Locator ***"
    mkdir -p ${APP_HOME}/data/locator
    pushd ${APP_HOME}/data/locator > /dev/null

    gfsh -e "start locator --name=locator --port=10337 --dir=${APP_HOME}/data/locator" &

    popd > /dev/null
}

function launchServer() {
    echo ""
    echo "*** Launch Server ***"
    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server > /dev/null

    gfsh -e "connect --locator=localhost[10337]" -e "start server --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server" &

    popd > /dev/null
}

function createRegion(){
  echo ""
  echo "*** Create Partition Region \"test\" ***"
  pushd ${APP_HOME}/data/server > /dev/null

  gfsh -e "connect --locator=localhost[10337]" -e "create region --name=test --type=PARTITION"

  popd > /dev/null
}

echo ""
echo "Geode home= ${GEODE_HOME}"
echo ""
echo "PATH = ${PATH} "
echo ""
echo "Java version:"
java -version

launchLocator

# waitForPort 10337

sleep 10

launchServer

wait

createRegion
