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

Function Get-Locators-String
{
	param($Hostname)
	return "$Hostname[10334],$Hostname[10335]"
}

Function Destroy-Region
{
	param($SecurityPropertiesFile, $RegionName)
	$LOCATORS = Get-Locators-String("localhost")
	$PROPS = "$PSScriptRoot/../etc/$SecurityPropertiesFile"
	$CONNECT_COMMAND = "connect --locator=$LOCATORS --security-properties-file=$PROPS"
	$DESTROY_COMMAND = "destroy region --name=$RegionName"
	$COMMAND = "$GFSH_PATH -e '$CONNECT_COMMAND' -e '$DESTROY_COMMAND'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Destroy-Region"
}

Function Stop-Server
{
	param($ServerNumber, $SecurityPropertiesFile)

	$LOCATORS = Get-Locators-String("localhost")
	$PROPS = "$PSScriptRoot/../etc/$SecurityPropertiesFile"
	$CONNECT_COMMAND = "connect --locator=$LOCATORS --security-properties-file=$PROPS"
	$STOP_COMMAND="stop server --name=server$ServerNumber"
	$COMMAND = "$GFSH_PATH -e '$CONNECT_COMMAND' -e '$STOP_COMMAND'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Stop-Server"
}

function Stop-Locator
{
	param($LocatorNumber, $LocatorPort, $SecurityPropertiesFile) 
	$PROPS = "$PSScriptRoot/../etc/$SecurityPropertiesFile"
	$CONNECT_COMMAND = "connect --locator=localhost[$LocatorPort] --security-properties-file=$PROPS"
	$STOP_COMMAND="stop locator --name=locator$LocatorNumber"
	$COMMAND = "$GFSH_PATH -e '$CONNECT_COMMAND' -e '$STOP_COMMAND'"
	Write-Debug $COMMAND
	Invoke-Expression $COMMAND
	Write-Debug "Leaving Stop-Locator"
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

if ($GFSH_PATH -ne "")
{
	$PROPFILE = "gfsecurity.properties"
	Destroy-Region -SecurityPropertiesFile $PROPFILE -RegionName "test"
	Stop-Server -ServerNumber 1 -SecurityPropertiesFile $PROPFILE
	Stop-Server -ServerNumber 2 -SecurityPropertiesFile $PROPFILE
	Stop-Locator -LocatorNumber 1 -LocatorPort 10334 -SecurityPropertiesFile $PROPFILE
	Stop-Locator -LocatorNumber 2 -LocatorPort 10335 -SecurityPropertiesFile $PROPFILE
}

