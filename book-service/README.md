# The Book-Serving Example App

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

- Node.js, minimum version of 10.0

- `npm`, the Node.js package manager

- Cloud Foundry Command Line Interface (cf CLI).  See [Installing the cf CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html).

- Examples source code.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- Node.js client library. Acquire the Node.js client library from PivNet.
Find and download the current version of the  Node.JS Client, for example:
`gemfire-nodejs-client-2.0.0.tgz`,
under [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).

- Pivotal GemFire (to have gfsh, the command line interface for GemFire).
Acquire Pivotal GemFire from PivNet at [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).
Choose your GemFire version based on the version of Cloud Cache in your PAS environment.
See the [Product Snapshot](https://docs.pivotal.io/p-cloud-cache/product-snapshot.html) for your Cloud Cache version.

- Configure GEODE\_HOME and PATH environment variables.
Set GEODE\_HOME to the GemFire installation directory and add $GEODE\_HOME/bin to your PATH. For example

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

```
$ export VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```

## Start a Cluster

There are bash scripts in the `book-service/scripts` directory.
The `startGemFire.sh` script starts up two locators and two cache servers.
The locators allow clients to find the cache servers.
To simplify local development,
the script also creates the single region that the app uses.

With a current working directory of `node-examples/book-service`:

```bash
$ ./scripts/startGemFire.sh
```

## Run the App

With the current working directory to `node-examples/book-service` and run the app:

```
$ node src/server.js
```

## Add a Book to the Book Service

To add a book to the data service, open a separate shell and issue a curl command:

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

    ```bash
    $ cd scripts
    $ ./shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/book-service`:

    ```bash
    $ cd scripts
    $ ./clearGemFireData.sh
    ```

- Unset the `VCAP_SERVICES` environment variable
to avoid interference with running other examples that would
reference this environment variable if it continues to exist.

    ```
    $ unset VCAP_SERVICES
    ```

# Run the App with Cloud Cache as the Data Service

## Create and Configure a Cloud Cache Service Instance

- After using the cf CLI to log in and target your org and space,
create a Cloud Cache service instance that disables TLS encryption: 

    ```
    $ cf create-service p-cloudcache dev-plan PCC-noTLS  -c '{"tls": false}'
    ```

- Create a Service Key

   ```
   $ cf create-service-key PCC-noTLS PCC-noTLS-service-key
   ```

- Output the service key, and make note of the gfsh connect command 
labeled as `gfsh_login_string`:

    ```
    $ cf service-key PCC-noTLS PCC-noTLS-service-key
    ```

    The `gfsh_login_string` will be of the form:

    ```
    connect --url=https://PAS-name.cf-app.com/gemfire/v1 --user=cluster_operator_XXXXXXXXX --password=XXXXXXXX --skip-ssl-validation
    ```

## Create the Region Used by the Book Service

- Run gfsh.

- Use the captured gfsh connect command to connect to the Cloud Cache service instance.
Use the return key when prompted for keystore and truststore values.

- Once connected, create the region that the book service expects to find:

    ```
    gfsh> create region --name=test --type=PARTITION
    ```

## Push and Run the App

- Edit the `manifest.yml` file to identify the service instance
that the app will be bound to.
Prior to editing, the service instance is called `cloudcache-dev`.

- With a current working directory of `node-examples/book-service`,
push the app and make note of the route assigned for the app:

    ```
    $ cf push
    ```

## Add a Book to the Book Service

To add a book to the data service, use a curl command similar to the one
used when running with a local cluster.
Replace `localhost:8080` with the app route:

```
$ curl -X PUT \
  'https://PAS-name.cf-app.com/book/put?isbn=0525565329' \
  -H 'Content-Type: application/json' \
  -d '{
  "FullTitle": "The Shining",
  "ISBN": "0525565329",
  "MSRP": "9.99",
  "Publisher": "Anchor",
  "Authors": "Stephen King"
}'
```

## Look Up a Book

To look up a book in the data service,
use a curl command similar to the one
used when running with a local cluster.
Replace `localhost:8080` with the app route,
specifying the ISBN as a key:

```
$ curl -X GET \
  'https://PAS-name.cf-app.com/book/get?isbn=0525565329' 
```

## Clean Up the Cloud Cache Environment

When done running the app, tear down the app and the Cloud Cache service instance:

1. Stop the running app:

    ```
    $ cf stop cloudcache-node-sample
    ```

1. Delete the app and its route:

    ```
    $ cf delete cloudcache-node-sample -r -f
    ```

1. If the Cloud Cache service instance is no longer needed,
    delete it,
    replacing `INSTANCE-NAME` with your service instance's name:

    ```
    $ cf delete-service INSTANCE-NAME
    ```
