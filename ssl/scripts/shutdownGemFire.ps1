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

pushd $APP_HOME/data/locator

Invoke-Expression "$GFSH_PATH -e 'connect --locator=localhost[10337] --use-ssl=true --key-store=$APP_HOME/keys/server_keystore.p12 --trust-store=$APP_HOME/keys/server_truststore.jks --trust-store-password=apachegeode --key-store-password=apachegeode' -e 'shutdown --include-locators=true --time-out=15'"

popd
