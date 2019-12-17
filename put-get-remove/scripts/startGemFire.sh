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


launchLocator

waitForPort 10337

sleep 10

launchServer

wait

pushd ${APP_HOME}/data/server

gfsh -e "connect --locator=localhost[10337]" -e "create region --name=test --type=PARTITION"

popd
