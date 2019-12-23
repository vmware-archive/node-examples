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

keystore="${APP_HOME}/keys/keystore.jks"
truststore="${APP_HOME}/keys/truststore.jks"
keystorePassword="mypassword"

function waitForPort {

    (exec 6<>/dev/tcp/${HOSTNAME}/$1) &>/dev/null
    while [[ $? -ne 0 ]]
    do
        echo -n "."
        sleep 1
        (exec 6<>/dev/tcp/${HOSTNAME}/$1) &>/dev/null
    done
}

function build_security_jar() {
  export CLASSPATH=$GEODE_HOME/lib/*
  pushd ${APP_HOME}/src
  javac securitymanager/SimpleSecurityManager.java
  jar -vcf security.jar *
  popd
}

function launchLocator() {

    mkdir -p ${APP_HOME}/data/locator
    pushd ${APP_HOME}/data/locator

    gfsh -e "start locator --connect=false --name=locator --port=10337 --dir=${APP_HOME}/data/locator --classpath=${APP_HOME}/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager --J=-Dgemfire.ssl-enabled-components=all --J=-Djavax.net.debug=all --J=-Dgemfire.ssl-keystore=${keystore} --J=-Dgemfire.ssl-truststore=${truststore} --J=-Dgemfire.ssl-keystore-password=${keystorePassword} --J=-Dgemfire.ssl-truststore-password=${keystorePassword} --J=-Dgemfire.ssl-require-authentication=false" &

    popd
}

function launchServer() {

    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server

    gfsh -e "connect --locator=localhost[10337] --user=root --password=root-password --use-ssl=true --key-store=${keystore} --trust-store=${truststore} --key-store-password=${keystorePassword} --trust-store-password=${keystorePassword} " -e "start server --user=root --password=root-password --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server  --classpath=${APP_HOME}/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager --J=-Dgemfire.ssl-enabled-components=all --J=-Djavax.net.debug=all --J=-Dgemfire.ssl-keystore=${keystore} --J=-Dgemfire.ssl-truststore=${truststore} --J=-Dgemfire.ssl-keystore-password=${keystorePassword} --J=-Dgemfire.ssl-truststore-password=${keystorePassword} --J=-Dgemfire.ssl-require-authentication=false " &

    popd
}

echo "*** Build SimpleSecurityManager ***"
build_security_jar
echo "*** Start Locator ***"
launchLocator

waitForPort 10337

sleep 10
echo "*** Start Server ***"
launchServer

wait
echo "*** Create Region \'test\' on server ***"
pushd ${APP_HOME}/data/server

gfsh -e "connect --locator=localhost[10337] --user=root --password=root-password --use-ssl=true --key-store=${keystore} --trust-store=${truststore} --key-store-password=${keystorePassword} --trust-store-password=${keystorePassword}" -e "create region --name=test --type=PARTITION"

popd
