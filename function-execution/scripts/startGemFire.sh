#!/bin/bash

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/.." >&-
APP_HOME="`pwd -P`"
cd "$SAVED" >&-

function waitForPort {

    (exec 6<>/dev/tcp/${HOSTNAME}/$1) &>/dev/null
    while [[ $? -ne 0 ]]
    do
        echo -n "."
        sleep 1
        (exec 6<>/dev/tcp/${HOSTNAME}/$1) &>/dev/null
    done
}

function launchLocator() {

    mkdir -p ${APP_HOME}/data/locator
    pushd ${APP_HOME}/data/locator

    gfsh -e "start locator --name=locator --port=10337 --dir=${APP_HOME}/data/locator" &

    popd
}

function launchServer() {

    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server

    gfsh -e "connect --locator=localhost[10337]" -e "start server --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server" &

    popd
}

function buildFunction() {

    export CLASSPATH=${GEODE_HOME}/lib/geode-core-9.9.0.jar:${GEODE_HOME}/lib/geode-common-9.9.0.jar
    pushd ${APP_HOME}/src
    echo ${GEODE_HOME}
    java -version
    javac com/vmware/example/SumRegion.java
    jar -cvf SumRegion.jar *
    popd
}

function deployFunction() {

    gfsh -e "connect --locator=localhost[10337]" -e "deploy --jar=${APP_HOME}/src/SumRegion.jar" &
}

buildFunction

launchLocator

waitForPort 10337

sleep 10

launchServer

wait

deployFunction

wait

pushd ${APP_HOME}/data/server

gfsh -e "connect --locator=localhost[10337]" -e "create region --name=test --type=PARTITION"

popd
