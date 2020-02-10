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


APP_HOME="`pwd -P`"

function launchLocator() {
    echo ""
    echo "*** Start Locator ***"
    mkdir -p ${APP_HOME}/data/locator
    pushd ${APP_HOME}/data/locator > /dev/null

    gfsh -e "start locator --name=locator --port=10337 --dir=${APP_HOME}/data/locator --connect=false --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=${APP_HOME}/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=${APP_HOME}/keys/server_truststore.jks --J=-Dgemfire.ssl-keystore-password=apachegeode --J=-Dgemfire.ssl-truststore-password=apachegeode"
    gfsh -e "connect --locator=localhost[10337] --use-ssl=true --key-store=${APP_HOME}/keys/server_keystore.p12 --trust-store=${APP_HOME}/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode" -e "configure pdx --read-serialized=true"

    popd > /dev/null
}

function launchServer() {
    echo ""
    echo "*** Start Server ***"
    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server > /dev/null

    gfsh -e "connect --locator=localhost[10337] --use-ssl=true --key-store=${APP_HOME}/keys/server_keystore.p12 --trust-store=${APP_HOME}/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode" -e "start server --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=${APP_HOME}/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=${APP_HOME}/keys/server_truststore.jks --J=-Dgemfire.ssl-truststore-password=apachegeode --J=-Dgemfire.ssl-keystore-password=apachegeode"

    popd > /dev/null
}

function createRegion(){
  echo ""
  echo "*** Create Partition Region \"test\" ***"
  pushd ${APP_HOME}/data/server > /dev/null

  gfsh -e "connect --locator=localhost[10337] --use-ssl=true --key-store=${APP_HOME}/keys/server_keystore.p12 --trust-store=${APP_HOME}/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode" -e "create region --name=test --type=PARTITION"

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

sleep 10

launchServer

sleep 10

createRegion
