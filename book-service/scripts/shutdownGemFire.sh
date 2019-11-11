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

HOSTNAME=localhost
LOCATORS="${HOSTNAME}[10334]"

# --J=-Dlog4j.configurationFile=${APP_HOME}/etc/log4j.xml
pushd ${APP_HOME}/data/locator4 > /dev/null

gfsh -e "connect --locator=${LOCATORS} --security-properties-file=${APP_HOME}/etc/gfsecurity.properties" -e "shutdown --include-locators=true --time-out=15"

popd > /dev/null
