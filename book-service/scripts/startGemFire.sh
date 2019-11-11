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

DEFAULT_LOCATOR_MEMORY="128m"

DEFAULT_SERVER_MEMORY="1024m"

DEFAULT_JVM_OPTS=" --J=-XX:+UseParNewGC"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-Djava.net.preferIPv4Stack=true"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+UseConcMarkSweepGC"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:CMSInitiatingOccupancyFraction=50"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+CMSParallelRemarkEnabled"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+UseCMSInitiatingOccupancyOnly"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+ScavengeBeforeFullGC"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+CMSScavengeBeforeRemark"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --J=-XX:+UseCompressedOops"
DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS --mcast-port=0"

HOSTNAME=localhost
LOCATORS="${HOSTNAME}[10334],${HOSTNAME}[10335]"


export MY_CLASSPATH=${APP_HOME}/etc


STD_SERVER_ITEMS=" "
STD_SERVER_ITEMS="${STD_SERVER_ITEMS} --rebalance"
STD_SERVER_ITEMS="${STD_SERVER_ITEMS} --classpath=${MY_CLASSPATH}"

STD_LOCATOR_ITEM=""

firstTimeLocator=true

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

    mkdir -p ${APP_HOME}/data/locator$1
    pushd ${APP_HOME}/data/locator$1

    gfsh -e "start locator --security-properties-file=${APP_HOME}/etc/gfsecurity.properties --initial-heap=${DEFAULT_LOCATOR_MEMORY} --max-heap=${DEFAULT_LOCATOR_MEMORY} ${DEFAULT_JVM_OPTS} --name=locator$1_`hostname` --port=1033$1 --dir=${APP_HOME}/data/locator$1 --locators=${LOCATORS} --classpath=${APP_HOME}/etc --J=-Dgemfire.security-manager=org.apache.geode.examples.security.ExampleSecurityManager" &

    popd
}

function launchServer() {

    mkdir -p ${APP_HOME}/data/server${1}
    pushd ${APP_HOME}/data/server${1}

    gfsh -e "connect --locator=${LOCATORS}  --security-properties-file=${APP_HOME}/etc/gfsecurity.properties" -e "start server --locators=${LOCATORS} --security-properties-file=${APP_HOME}/etc/gfsecurity.properties --server-port=4040${1} --J=-Xmx${DEFAULT_SERVER_MEMORY} --J=-Xms${DEFAULT_SERVER_MEMORY} ${DEFAULT_JVM_OPTS} --name=server${1}_`hostname` --dir=${APP_HOME}/data/server${1} ${STD_SERVER_ITEMS} " &

    popd

}


for i in {4..5}
do
    launchLocator ${i}
    # Stagger the launch so the first locator is the membership coordinator.
    sleep 1
done

# Only need to wait for one locator
waitForPort 10334
waitForPort 10335

sleep 10

pushd ${APP_HOME}/data/locator4

gfsh -e "connect --locator=${LOCATORS}  --security-properties-file=${APP_HOME}/etc/gfsecurity.properties" -e "configure pdx --read-serialized=true --disk-store=DEFAULT"

popd

for i in {1..2}
do
    launchServer ${i}
done

wait

pushd ${APP_HOME}/data/server1

gfsh -e "connect --locator=${LOCATORS} --security-properties-file=${APP_HOME}/etc/gfsecurity.properties" -e "create region --name=test --type=PARTITION"

popd