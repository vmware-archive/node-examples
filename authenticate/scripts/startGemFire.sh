#!/bin/bash


APP_HOME="`pwd -P`"

function build_security_jar() {
  echo ""
  echo "*** Build SimpleSecurityManager ***"
  export CLASSPATH=$GEODE_HOME/lib/*
  echo "CLASSPATH=${CLASSPATH}"
  pushd ${APP_HOME}/src > /dev/null
    javac securitymanager/SimpleSecurityManager.java
    jar -vcf security.jar *
  popd > /dev/null
}

function launchLocator() {
    echo ""
    echo "*** Start Locator ***"
    mkdir -p ${APP_HOME}/data/locator
    pushd ${APP_HOME}/data/locator > /dev/null

      gfsh -e "start locator --connect=false --name=locator --port=10337 --dir=${APP_HOME}/data/locator --classpath=${APP_HOME}/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager" &

    popd > /dev/null
}

function launchServer() {
    echo ""
    echo "*** Start Server ***"
    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server > /dev/null

      gfsh -e "connect --locator=localhost[10337] --user=root --password=root-password" -e "start server --user=root --password=root-password --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server  --classpath=${APP_HOME}/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager" &

    popd > /dev/null
}

function createRegion(){
  echo ""
  echo "*** Create Partition Region \"test\" ***"
  pushd ${APP_HOME}/data/server > /dev/null

  gfsh -e "connect --locator=localhost[10337] --user=root --password=root-password " -e "create region --name=test --type=PARTITION"

  popd > /dev/null
}

echo ""
echo "Geode home= ${GEODE_HOME}"
echo ""
echo "PATH = ${PATH} "
echo ""
echo "Java version:"
java -version

build_security_jar

launchLocator

sleep 10

launchServer

wait

createRegion
