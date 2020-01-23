# The Book Service Example

This Node.js example provides a simple book-serving app
which uses the data service as a system of record.
REST endpoints allow an app user to look up books by ISBN
or put new books into the service.

This app can be run with a local Apache Geode or Pivotal GemFire cluster,
or with a Cloud Cache service instance.
A common development path runs locally first to iterate quickly on feature
development prior to pushing the app to a PAS environment to run with
Cloud Cache.
This app has been tested with Cloud Cache version 1.8.1.

# Prerequisites

- **Node.js**, minimum version of 10.0

- **npm**, the Node.js package manager

- **Cloud Foundry Command Line Interface (cf CLI)**.  See [Installing the cf CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html).

- **Examples source code**.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- **Node.js client library**. Acquire the Node.js client library from PivNet under [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).
The file is a compressed tar archive (suffix `.tgz`), and the filename contains the client library version number.
For example:
`gemfire-nodejs-client-2.0.0.tgz`.


- **Pivotal GemFire** (to have gfsh, the command line interface for GemFire).
Acquire Pivotal GemFire from PivNet at [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).
Choose your GemFire version based on the version of Cloud Cache in your PAS environment.
See the [Product Snapshot](https://docs.pivotal.io/p-cloud-cache/product-snapshot.html) for your Cloud Cache version.

- **Configure environment variables**.
Set `GEODE_HOME` to the GemFire installation directory and add `$GEODE_HOME/bin` to your `PATH`. For example

    ```bash
    export GEODE_HOME=/Users/MyGemFire
    export PATH=$GEODE_HOME/bin:$PATH
    ```

# Build the App

With a current working directory of `node-examples/book-service`,
build the app:

```bash
$ npm install gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

# Run the App Locally

The local environment mocks the services binding that would exist
for a PAS environment.
A PAS environment injects the services binding through a `VCAP_SERVICES`
environment variable.
Set this environment variable:

(MacOS, Linux)
```bash
$ export VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```
<br/><br/>

(Windows)
```
C:\node-examples\book-service>$env:VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```

## Start a Cluster

There are shell scripts in the `book-service/scripts` directory.
The `startGemFire` script starts up two locators and two cache servers.
The locators allow clients to find the cache servers.
To simplify local development,
the script also creates the single region that the app uses.

With a current working directory of `node-examples/book-service`:

(MacOS/Linux)
```bash
$ ./scripts/startGemFire.sh
```

(Windows)
```
C:\node-examples\book-service>.\scripts\startGemFire.ps1
```

## Run the App

With a current working directory of `node-examples/book-service` and run the app:

(MacOS/Linux)
```
$ node src/server.js
```

<br/><br/>
(Windows)
```
C:\node-examples\book-service>node .\src\server.js
```

## Add a Book to the Book Service

To add a book to the data service, open a separate shell and issue a curl command:

(MacOS/Linux)
```
$ curl -X PUT \
  'http://localhost:8080/book/put?isbn=0525565329' \
  -H 'Content-Type: application/json' \
  -d '{
  "FullTitle": "The Shining",
  "ISBN": "0525565329",
  "MSRP": "9.99",
  "Publisher": "Anchor",
  "Authors": "Stephen King"
}'
```
<br/><br/>
(Windows)
```
C:\node-examples\book-service>curl -X PUT  "http://localhost:8080/book/put?isbn=0525565329"  -H "Content-Type: application/json"  -d "{\"FullTitle\": \"The Shining\", \"ISBN\": \"0525565329\", \"MSRP\": \"9.99\", \"Publisher\": \"Anchor\", \"Authors\": \"Stephen King\"}"
```

## Look Up a Book

To look up a book in the data service, use a curl command,
specifying the ISBN as a key:

```
$ curl -X GET \
  'http://localhost:8080/book/get?isbn=0525565329'
```

## Clean Up the Local Development Environment

- When finished with running the example locally, use a control-C in the shell running `node` to stop running the app.

- When finished with running the example locally, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/book-service`:

(MacOS/Linux)
    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```
<br/><br/>
(Windows)
```
C:\node-examples\book-service>.\scripts\shutdownGemFire.ps1
```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/book-service`:

    ```bash
    $ ./scripts/clearGemFireData.sh
    ```

- Unset the `VCAP_SERVICES` environment variable
to avoid interference with running other examples that would
reference this environment variable if it continues to exist.

    ```
    $ unset VCAP_SERVICES
    ```

# Run the App with Cloud Cache as the Data Service

This section uses the following names - if your Cloud Cache instance uses different names, substitute as appropriate for these:

- **service-name**: PCC-noTLS
- **service-key**: PCC-noTLS-service-key
- **PAS-name**: cloudcache-999-persianplum
- **app-name**: cloudcache-node-sample

## Create and Configure a Cloud Cache Service Instance

- Use the cf CLI to log in and target your org and space.

- Create a Cloud Cache service instance that disables TLS encryption. For example:

    ```
    $ cf create-service p-cloudcache dev-plan PCC-noTLS  -c '{"tls": false}'
    ```

- Create a Service Key

   ```
   $ cf create-service-key PCC-noTLS PCC-noTLS-service-key
   ```

- Display the service key, and make note of the gfsh connect command labeled as `gfsh_login_string`:

    ```
    $ cf service-key PCC-noTLS PCC-noTLS-service-key
    ```

    The `gfsh_login_string` will be of the form:

    ```
    connect --url=https://PAS-name.cf-app.com/gemfire/v1 --user=cluster_operator_XXX --password=YYY --skip-ssl-validation
    ```

## Create the Region Used by the Book Service

- Run gfsh.

- Use the captured gfsh connect command to connect to the Cloud Cache service instance.
Tap the return key to enter empty responses when prompted for keystore and truststore values.

    ```bash
    gfsh>connect --url=https://cloudcache-999-persianplum.cf-app.com/gemfire/v1 --user=cluster_operator_BhKM --password=xucZ --skip-ssl-validation
    key-store:
    key-store-password:
    key-store-type(default: JKS):
    trust-store:
    trust-store-password:
    trust-store-type(default: JKS):
    ssl-ciphers(default: any):
    ssl-protocols(default: any):
    ssl-enabled-components(default: all):
    Successfully connected to: GemFire Manager HTTP service @ https://cloudcache-999-persianplum.cf-app.com/gemfire/v1
    ```

- Once connected, create the region that the book service expects to find:

    ```
    gfsh> create region --name=test --type=PARTITION
                 Member                      | Status | Message
    ---------------------------------------- | ------ | ------------------------------------------------
    cacheserver-a75d6fcc                     | OK     | Region "/test" created on "cacheserver-a75d6fcc"

    Cluster configuration for group 'cluster' is updated.

    ```

- Quit gfsh

## Push and Run the App

- View the `manifest.yml` file to verify that the service instance matches the one specified in
the `cf create-service` command above.  If you have been following these instructions,
it is `PCC-noTLS`. Edit manifest.yml, if necessary, to make sure it specifies the
service instance you created.

    ```
  services:
   - PCC-noTLS
    ```

- With a current working directory of `node-examples/book-service`,
push the app and make note of the route assigned for the app:

    ```
    $ cf push
    Pushing from manifest to org test_org / space test_space as admin...
    Using manifest file /Users/dbarnes/Repo/node-examples/book-service/manifest.yml
    ...

    Waiting for app to start...

    name:              cloudcache-node-sample
    requested state:   started
    routes:            cloudcache-node-sample.apps.persianplum.cf-app.com
    ...
         state     since                  cpu    memory      disk      details
    #0   running   2020-01-22T18:40:54Z   0.0%   0 of 512M   0 of 1G
    ```

Note the app route (labeled "routes:") in the output of the `cf push` command. In the above example,
it is "cloudcache-node-sample.apps.persianplum.cf-app.com".

## Add a Book to the Book Service

To add a book to the data service, use a curl command similar to the one
used when running with a local cluster, specifying the app route assigned
in the `cf push` step, above.

(MacOS/Linux)

```
$ curl -k -X PUT \
  'https://cloudcache-node-sample.apps.persianplum.cf-app.com/book/put?isbn=0525565329' \
  -H 'Content-Type: application/json' \
  -d '{
  "FullTitle": "The Shining",
  "ISBN": "0525565329",
  "MSRP": "9.99",
  "Publisher": "Anchor",
  "Authors": "Stephen King"
}'
```
<br/><br/>
(Windows)

```
C:\node-examples\book-service>curl -X PUT  "http://localhost:8080/book/put?isbn=0525565329"  -H "Content-Type: application/json"  -d "{\"FullTitle\": \"The Shining\", \"ISBN\": \"0525565329\", \"MSRP\": \"9.99\", \"Publisher\": \"Anchor\", \"Authors\": \"Stephen King\"}"
```

The curl command responds with a confirmation: `{"initialized":true}`.


## Look Up a Book

To look up a book in the data service, use a curl command similar to the one
used when running with a local cluster, specifying the ISBN as a key.
Use the app route assigned in the `cf push` step, above.

```
$ curl -k -X GET \
  'https://cloudcache-node-sample.apps.persianplum.cf-app.com/book/get?isbn=0525565329'
```

The curl command responds with the requested data:

```
{"FullTitle":"The Shining","ISBN":"0525565329","MSRP":"9.99","Publisher":"Anchor","Authors":"Stephen King"}
```

## Clean Up the Cloud Cache Environment

When done running the app, tear down the app and the Cloud Cache service instance:

1. Stop the running app:

    ```
    $ cf stop cloudcache-node-sample
    Stopping app cloudcache-node-sample in org test_org / space test_space as admin...
    OK
    ```

1. Delete the app and its route:

    ```
    $ cf delete cloudcache-node-sample -r -f
    Deleting app cloudcache-node-sample in org test_org / space test_space as admin...
    OK
    ```

1. If the Cloud Cache service instance is no longer needed, first delete
   its service key, then delete the service itself:

    ```
    $ cf delete-service-key PCC-noTLS PCC-noTLS-service-key

    Really delete the service key PCC-noTLS-service-key?> y
    Deleting key PCC-noTLS-service-key for service instance PCC-noTLS as admin...
    OK
    $ cf delete-service PCC-noTLS

    Really delete the service PCC-noTLS?> y
    Deleting service PCC-noTLS in org test_org / space test_space as admin...
    OK

    Delete in progress. Use 'cf services' or 'cf service PCC-noTLS' to check operation status.
    ```
