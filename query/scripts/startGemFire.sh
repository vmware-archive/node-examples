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

    gfsh -e "start locator --name=locator --port=10337 --dir=${APP_HOME}/data/locator"
    gfsh -e "connect --locator=localhost[10337]" -e "configure pdx --read-serialized=true"

    popd > /dev/null
}

function launchServer() {
    echo ""
    echo "*** Launch Server ***"
    mkdir -p ${APP_HOME}/data/server
    pushd ${APP_HOME}/data/server > /dev/null

    gfsh -e "connect --locator=localhost[10337]" -e "start server --locators=localhost[10337] --server-port=40404 --name=server --dir=${APP_HOME}/data/server"

    popd > /dev/null
}

function createRegion(){
  echo ""
  echo "*** Create Partition Region \"test\" ***"
  pushd ${APP_HOME}/data/server > /dev/null

  gfsh -e "connect --locator=localhost[10337]" -e "create region --name=test --type=PARTITION"

  popd > /dev/null
}


launchLocator
sleep 10

launchServer
sleep 10

createRegion
