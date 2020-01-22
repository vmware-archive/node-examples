$APP_HOME = pwd

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

Function launchLocator() {
    echo ""
    echo "*** Start Locator ***"
    mkdir -p $APP_HOME/data/locator
    pushd $APP_HOME/data/locator

    Invoke-Expression "$GFSH_PATH -e 'start locator --name=locator --port=10337 --dir=$APP_HOME/data/locator --connect=false --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=$APP_HOME/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=$APP_HOME/keys/server_truststore.jks --J=-Dgemfire.ssl-keystore-password=apachegeode --J=-Dgemfire.ssl-truststore-password=apachegeode'"
    Invoke-Expression "$GFSH_PATH -e 'connect --locator=localhost[10337] --use-ssl=true --key-store=$APP_HOME/keys/server_keystore.p12 --trust-store=$APP_HOME/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode' -e 'configure pdx --read-serialized=true'"

    popd
}

Function launchServer() {
    echo ""
    echo "*** Start Server ***"
    mkdir -p $APP_HOME/data/server
    pushd $APP_HOME/data/server

    Invoke-Expression "$GFSH_PATH -e 'connect --locator=localhost[10337] --use-ssl=true --key-store=$APP_HOME/keys/server_keystore.p12 --trust-store=$APP_HOME/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode' -e 'start server --locators=localhost[10337] --server-port=40404 --name=server --dir=$APP_HOME/data/server --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=$APP_HOME/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=$APP_HOME/keys/server_truststore.jks --J=-Dgemfire.ssl-truststore-password=apachegeode --J=-Dgemfire.ssl-keystore-password=apachegeode'"

    popd
}

Function createRegion() {
  echo ""
  echo "*** Create Partition Region \"test\" ***"
  pushd $APP_HOME/data/server

  Invoke-Expression "$GFSH_PATH -e 'connect --locator=localhost[10337] --use-ssl=true --key-store=$APP_HOME/keys/server_keystore.p12 --trust-store=$APP_HOME/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode' -e 'create region --name=test --type=PARTITION'"

  popd
}

echo ""
echo "Geode home =" $env:GEODE_HOME
echo ""
echo "PATH = " $env:PATH
echo ""
echo "Java version:"
java -version

launchLocator

Start-Sleep -Seconds 10

launchServer

Start-Sleep -Seconds 10

createRegion
