#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

#gfsh -e "connect --locator=${LOCATORS} --security-properties-file=${APP_HOME}/etc/gfsecurity.properties" -e "shutdown --include-locators=true --time-out=15"

# Removed security settings
gfsh -e "connect --locator=${LOCATORS}" -e "shutdown --include-locators=true --time-out=15"

popd > /dev/null
