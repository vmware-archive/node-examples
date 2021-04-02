# The Book Service Example

This Node.js example provides a simple book-serving app
which uses the data service as a system of record.
REST endpoints allow an app user to look up books by ISBN
or put new books into the service.

This app can be run with a local Apache Geode or Tanzu GemFire cluster,
or with a Tanzu GemFire for VMs service instance.
A common development path runs locally first to iterate quickly on feature
development prior to pushing the app to a TAS environment to run with
Tanzu GemFire for VMs cluster.
This app has been tested with Tanzu GemFire for VMs version 1.13.

## Prerequisites

- **Node.js**, minimum version of 10.16.3

- **npm**, the Node.js package manager

- **Cloud Foundry Command Line Interface (cf CLI)**.  See [Installing the cf CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html).

- **This examples source code repository**.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- **Node.js client library**. Acquire the Node.js client library (NodeJS-Client-2.0.1) from Tanzu Network at [VMware Tanzu GemFire for VMs](https://network.pivotal.io/products/tanzu-gemfire-for-vms/).
The file is a compressed tar archive (suffix `.tgz`), and the file name contains the client library version number.
For example:
`gemfire-nodejs-client-2.0.1-build.33.tgz`.


- **Apache Geode**.
Apache Geode is preferred for development that will run an app
with a Tanzu GemFire for VMs cluster.
Acquire the most recent Geode compressed TAR file from [https://geode.apache.org/releases/](https://geode.apache.org/releases/). Be sure to install Geode's prerequisite Java JDK 1.8.X, which is needed to support gfsh, the command line interface.
Uncompress and untar the file. 

- **Configure environment variables**.
Set `GEODE_HOME` to the Geode installation directory and add `$GEODE_HOME/bin` to your `PATH`. For example

    On Mac and Linux:

    ```bash
    export GEODE_HOME=/Users/MyGeode
    export PATH=$GEODE_HOME/bin:$PATH
    ```

    On Windows (standard command prompt):

    ```cmd
    set GEODE_HOME=c:\Users\MyGeode
    set PATH=%GEODE_HOME%\bin;%PATH%
    ```

## Install the Node.js Client Module

With a current working directory of `node-examples/book-service`,
install the Node.js client module:

```bash
$ npm install PATH/TO/gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

At this point, you can choose to *Run the Example Locally* or *Run the Example with Tanzu GemFire for VMs as the Data Service*.

## Run the Example Locally

The local environment mocks the services binding that would exist
for a Tanzu Application Service (TAS) environment.
A TAS environment injects the services binding through a `VCAP_SERVICES`
environment variable.
Set this environment variable:

On Mac and Linux:

```bash
$ export VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```

On Windows (standard command prompt):

```
C:\node-examples\book-service>$env:VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```

### Start a Cluster

There are scripts in the `book-service/scripts` directory.
The `startGemFire` script starts up a cluster with two locators
and two cache servers.
The locators allow clients to find the cache servers.
To simplify local development,
the script also creates the single region (called 'test') that the app uses.

With a current working directory of `node-examples/book-service`:

On Mac and Linux:

```bash
$ ./scripts/startGemFire.sh
```

On Windows (standard command prompt):

```
C:\node-examples\book-service>.\scripts\startGemFire.ps1
```

### Run the Example App

With a current working directory of `node-examples/book-service`, run the app:

On Mac and Linux:

```
$ node src/server.js
```

On Windows (standard command prompt):

```
C:\node-examples\book-service>node .\src\server.js
```

### Add a Book to the Book Service

To add a book to the data service,
open a separate shell and issue a curl command:

On Mac and Linux:

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

On Windows (standard command prompt):

```
C:\node-examples\book-service>curl -X PUT  "http://localhost:8080/book/put?isbn=0525565329"  -H "Content-Type: application/json"  -d "{\"FullTitle\": \"The Shining\", \"ISBN\": \"0525565329\", \"MSRP\": \"9.99\", \"Publisher\": \"Anchor\", \"Authors\": \"Stephen King\"}"
```

### Look Up a Book

To look up a book in the data service, use a curl command,
specifying the ISBN as a key:

```
$ curl -X GET \
  'http://localhost:8080/book/get?isbn=0525565329'
```

### Clean Up the Local Development Environment

When finished running the example locally,  shut down the app and the cluster:

1. In the shell running `node`, type `control-C` to stop the example app.

1. Use a script to
tear down the cluster.
With a current working directory of `node-examples/book-service`:

 On Mac and Linux:

    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```

 On Windows (standard command prompt):

  ```
  C:\node-examples\book-service>.\scripts\shutdownGemFire.ps1
  ```

1. Use a script to remove the directories and files containing
logs created for the cluster.
With a current working directory of `node-examples/book-service`:

    ```bash
    $ ./scripts/clearGemFireData.sh
    ```

1. Unset the `VCAP_SERVICES` environment variable
to avoid interference with running other examples that would
reference this environment variable if it continues to exist.

    ```
    $ unset VCAP_SERVICES
    ```

## Run the Example with Tanzu GemFire for VMs as the Data Service

This section uses the following names - use appropriate substitutes for
your Tanzu GemFire for VMs service instance:

- **service-name**: PCC-TLS
- **service-key**: PCC-TLS-service-key
- **PAS-name**: cloudcache-999-persianplum
- **app-name**: cloudcache-node-sample

### Create and Configure a Tanzu GemFire for VMs Service Instance

1. Use the cf CLI to log in and target your org and space.

1. Create a Tanzu GemFire for VMs service instance that enables TLS encryption.
For example:

    On Mac and Linux:

    ```
    $ cf create-service p-cloudcache dev-plan PCC-TLS  -c '{"tls": true}'
    ```

    On Windows (standard command prompt) you must escape the inner quotes:

    ```
    $ cf create-service p-cloudcache dev-plan PCC-TLS  -c "{\"tls\": true}"
    ```

1. Create a Service Key

   ```
   $ cf create-service-key PCC-TLS PCC-TLS-service-key
   ```

1. Display the service key, and make note of the gfsh connect command labeled as `gfsh_login_string`:

    ```
    $ cf service-key PCC-TLS PCC-TLS-service-key
    ```

    The `gfsh_login_string` will be of the form:

    ```
    connect --url=https://TAS-name.cf-app.com/gemfire/v1 --user=cluster_operator_XXX --password=YYY --skip-ssl-validation
    ```

### Create the Region Used by the Book Service

1. Run gfsh.

1. Use the captured gfsh connect command to connect to the Tanzu GemFire for VMs service instance.
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

1. Once connected, create the region that the book service expects to find:

    ```
    gfsh> create region --name=test --type=PARTITION
                 Member                      | Status | Message
    ---------------------------------------- | ------ | ------------------------------------------------
    cacheserver-a75d6fcc                     | OK     | Region "/test" created on "cacheserver-a75d6fcc"

    Cluster configuration for group 'cluster' is updated.

    ```

1. Quit gfsh

### Push and Run the App

1. View the `manifest.yml` file to verify that the service instance matches the one specified in
the `cf create-service` command above.  If you have been following these instructions,
it is `PCC-TLS`. Edit manifest.yml, if necessary, to make sure it specifies the
service instance you created.

    ```
    services:
     - PCC-TLS
    ```

1. With a current working directory of `node-examples/book-service`,
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

### Add a Book to the Book Service

To add a book to the data service, use a curl command similar to the one
used when running with a local cluster, specifying the app route assigned
in the `cf push` step, above.

On Mac and Linux:

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

On Windows (standard command prompt):

```
C:\node-examples\book-service>curl -X PUT  "http://localhost:8080/book/put?isbn=0525565329"  -H "Content-Type: application/json"  -d "{\"FullTitle\": \"The Shining\", \"ISBN\": \"0525565329\", \"MSRP\": \"9.99\", \"Publisher\": \"Anchor\", \"Authors\": \"Stephen King\"}"
```

The curl command responds with a confirmation: `{"initialized":true}`.


### Look Up a Book

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

### Clean Up the Tanzu GemFire Environment

When done running the app, tear down the app and the Tanzu GemFire for VMs service instance:

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

1. If the Tanzu GemFire for VMs service instance is no longer needed, delete the service:

    ```
    $ cf delete-service PCC-TLS

    Really delete the service PCC-TLS?> y
    Deleting service PCC-TLS in org test_org / space test_space as admin...
    OK

    Delete in progress. Use 'cf services' or 'cf service PCC-TLS' to check operation status.
    ```
