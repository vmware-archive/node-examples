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

Function Start-Locator 
{
	param($LocatorNumber, $LocatorPort, $SecurityPropertiesFile)
	Write-Debug "Starting locator $LocatorNumber"
	$COMMAND = "$GFSH_PATH -e 'start locator --name=locator$LocatorNumber --port=$LocatorPort --security-properties-file=$PSScriptRoot/../etc/$SecurityPropertiesFile --dir=$PSScriptRoot/../data/locator$LocatorNumber --connect=false'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Start-Locator"
}

Function Get-Locators-String
{
	param($Hostname)
	return "$Hostname[10334],$Hostname[10335]"
}

Function Start-server
{
	param($ServerNumber, $ServerPort, $SecurityPropertiesFile)
	Write-Debug "Starting server $ServerNumber"
	
	$LOCATORS = Get-Locators-String("localhost")
	$PROPS = "$PSScriptRoot/../etc/$SecurityPropertiesFile"
	$CONNECT_COMMAND = "connect --locator=$LOCATORS --security-properties-file=$PROPS"
	$START_COMMAND = "start server --locators=$LOCATORS --security-properties-file=$PROPS --server-port=$ServerPort --name=server$ServerNumber --dir=$PSScriptRoot/../data/server$ServerNumber"
	$COMMAND = "$GFSH_PATH -e '$CONNECT_COMMAND' -e '$START_COMMAND'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Start-Server"
}

Function Create-Region
{
	param($SecurityPropertiesFile, $RegionName)
	$LOCATORS = Get-Locators-String("localhost")
	$PROPS = "$PSScriptRoot/../etc/$SecurityPropertiesFile"
	$CONNECT_COMMAND = "connect --locator=$LOCATORS --security-properties-file=$PROPS"
	$CREATE_COMMAND = "create region --name=$RegionName --type=PARTITION"
	$COMMAND = "$GFSH_PATH -e '$CONNECT_COMMAND' -e '$CREATE_COMMAND'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Create-Region"
}

$GFSH_PATH = ""
if (Get-Command gfsh -ErrorAction SilentlyContinue)
{
    $GFSH_PATH = "gfsh"
}
else
{
    if (-not (Test-Path env:GEODE_HOME))
    {
        Write-Host "Could not find gfsh.  Please set the GEODE_HOME path. e.g. "
        Write-Host "(Powershell) `$env:GEODE_HOME = <path to Geode>"
        Write-Host " OR"
        Write-Host "(Command-line) set %GEODE_HOME% = <path to Geode>"
    }
    else
    {
        $GFSH_PATH = "$env:GEODE_HOME\bin\gfsh.bat"
    }
}

Write-Debug "GFSH_PATH == $GFSH_PATH"
if ($GFSH_PATH -ne "")
{
	$PROPS = "gfsecurity.properties"
	Start-Locator -LocatorNumber 1 -LocatorPort 10334 -SecurityPropertiesFile $PROPS
	Start-Locator -LocatorNumber 2 -LocatorPort 10335 -SecurityPropertiesFile $PROPS

	Start-Server -ServerNumber 1 -ServerPort 40401 -SecurityPropertiesFile $PROPS
	Start-Server -ServerNumber 2 -ServerPort 40402 -SecurityPropertiesFile $PROPS
	Create-Region -SecurityPropertiesFile $PROPS -RegionName "test"
}
