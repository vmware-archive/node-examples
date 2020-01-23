# The SSL-Put-Get Example

This Node.js example demonstrates basic SSL connection of a client with a GemFire
 Cache cluster. This application leverages the put-get-remove example and should
 be reviewed prior starting. The example works with either a local Apache Geode
 or Pivotal GemFire cluster.

# Prerequisites

- Examples source code.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- OpenSSL Version 1.1.1
- Node.js client library. Acquire the Node.js client library from PivNet.
Find and download the Node.js Client 2.0.0 Beta version,
`gemfire-nodejs-client-2.0.0-beta.tgz`,
under [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).

- Pivotal GemFire (to have gfsh, the command line interface for GemFire).
Acquire Pivotal GemFire from PivNet
at [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/). Configure GEODE_HOME and PATH as required by GemFire.

- Java JDK 1.8.X  is a dependency for GemFire and gfsh

- Node.js, minimum version of 10.0

- `npm`, the Node.js package manager


# Install GemFire Node.js Client Module

With a current working directory of `node-examples/ssl`,
 install the module:

```bash
$ npm install gemfire-nodejs-client-2.0.0-beta.tgz
$ npm update
```
## Certificates
There are provided certificates for this example under the keys directory. For additional details on creating certificates the 
following links may be helpful. 

Certificate generation
https://jamielinux.com/docs/openssl-certificate-authority/introduction.html

JKS keystore import
https://blog.codecentric.de/en/2013/01/how-to-use-self-signed-pem-client-certificates-in-java/

## Start a GemFire Cluster

There is bash script in the `ssl/scripts` directory for creating a GemFire cluster. The `startGemFire.sh` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

 The startup script creates a single Region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A Region is similar to a hashmap and stores all data as key/value pairs.

The startup script depends on gfsh the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/ssl`:

```bash
$ ./scripts/startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/ssl/data`

Example output:

```bash
$ ./startGemFire.sh
Geode home= /Users/pivotal/Downloads/pivotal-gemfire-9.8.3

PATH = /Users/pivotal/.nvm/versions/node/v10.17.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public:/usr/local/share/dotnet:~/.dotnet/tools:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/bin:/usr/local/share/dotnet:/usr/local/opt:/usr/local/opt/nvm:/Users/pivotal/.nvm:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/bin:/usr/local/share/dotnet 

Java version:
java version "1.8.0_192"
Java(TM) SE Runtime Environment (build 1.8.0_192-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.192-b12, mixed mode)

*** Start Locator ***

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/Workspace/node-examples/ssl-put-get/data/locator --connect=false --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks --J=-Dgemfire.ssl-keystore-password=apachegeode --J=-Dgemfire.ssl-truststore-password=apachegeode

...
*** Start Server ***
.
Locator in /Users/pivotal/Workspace/node-examples/ssl-put-get/data/locator on 10.118.33.176[10337] as locator is currently online.
Process ID: 69078
Uptime: 7 seconds
Geode Version: 9.8.3
Java Version: 1.8.0_192
Log File: /Users/pivotal/Workspace/node-examples/ssl-put-get/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.ssl-enabled-components=all -Dgemfire.ssl-keystore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 -Dgemfire.ssl-truststore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks -Dgemfire.ssl-keystore-password=******** -Dgemfire.ssl-truststore-password=******** -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/Downloads/pivotal-gemfire-9.8.3/lib/geode-core-9.8.3.jar:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/lib/geode-dependencies.jar:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/extensions/gemfire-greenplum-3.4.1.jar

(1) Executing - connect --locator=localhost[10337] --use-ssl=true --key-store=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 --trust-store=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks --trust-store-password=***** --key-store-password=*****

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.176, port=1099] ..
Successfully connected to: [host=10.118.33.176, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/Workspace/node-examples/ssl-put-get/data/server --J=-Dgemfire.ssl-enabled-components=all --J=-Dgemfire.ssl-keystore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 --J=-Dgemfire.ssl-truststore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks --J=-Dgemfire.ssl-truststore-password=apachegeode --J=-Dgemfire.ssl-keystore-password=apachegeode

...
Server in /Users/pivotal/Workspace/node-examples/ssl-put-get/data/server on 10.118.33.176[40404] as server is currently online.
Process ID: 69201
Uptime: 7 seconds
Geode Version: 9.8.3
Java Version: 1.8.0_192
Log File: /Users/pivotal/Workspace/node-examples/ssl-put-get/data/server/server.log
JVM Arguments: -Dgemfire.locators=localhost[10337] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.ssl-enabled-components=all -Dgemfire.ssl-keystore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 -Dgemfire.ssl-truststore=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks -Dgemfire.ssl-truststore-password=******** -Dgemfire.ssl-keystore-password=******** -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/Downloads/pivotal-gemfire-9.8.3/lib/geode-core-9.8.3.jar:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/lib/geode-dependencies.jar:/Users/pivotal/Downloads/pivotal-gemfire-9.8.3/extensions/gemfire-greenplum-3.4.1.jar

*** Create Partition Region "test" ***

(1) Executing - connect --locator=localhost[10337] --use-ssl=true --key-store=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_keystore.p12 --trust-store=/Users/pivotal/Workspace/node-examples/ssl-put-get/keys/server_truststore.jks --trust-store-password=***** --key-store-password=*****

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.176, port=1099] ..
Successfully connected to: [host=10.118.33.176, port=1099]

(2) Executing - create region --name=test --type=PARTITION

Member | Status | Message
------ | ------ | ----------------------------------
server | OK     | Region "/test" created on "server"

Changes to configuration for group 'cluster' are persisted.
```

## Run the example application

With a current working directory of `node-examples/ssl`:

On Mac and Linux:
```bash
$ node index.js
```

On Windows:
```cmd
c:\node-modules\ssl> set PATH=%PATH%;.\node_modules\gemfire\build\Release
c:\node-modules\ssl> node index.js
```

The application demonstrates configuring the Node.js GemFire client to use a local cluster. Doing a put of a key/value pair, fetching the value with a get using the key and finally deleting the key/value pair from GemFire. The application is not interactive.

Example output:

```bash
$ node index.js
Creating a cache factory
Create Cache
Create Pool
Create Region
Do put and get operations
  Putting key 'foo' with value 'bar'
  Getting value with key 'foo'. Expected value: 'bar'
  Value retrieved is: 'bar'
Update operation:
  Updating key 'foo' with value 'candy'
  Getting value with key 'foo'. Expected value: 'candy'
  Value retrieved is: 'candy'
Delete operation:
  Removing key 'foo' from region 'test'
  Getting value with key 'foo'. Expected value: null
  Value retrieved is: 'null'
Finished
```

## Review example code
    
### Configuration

This block of code configures the client cache to use SSL for connecting to . The log location and metrics are written to the data directory. The PoolFactory configures a connection pool which uses the locator to lookup the servers.

There is a small change from the put-get-remove example configuration. We add the following lines which turn on SSL and configure the location of the keys files and keystores. The keystore requires a password as well which is also configured. 

```javascript
    cacheFactory.set("ssl-enabled", "true")
    cacheFactory.set('ssl-keystore', sslKeyPath + '/client_keystore.pem')
    cacheFactory.set('ssl-keystore-password', 'apachegeode')
    cacheFactory.set('ssl-truststore', sslKeyPath + '/client_truststore.pem')
```

The example should behave in a similar manner as the CRUD example with secure connections enabled.

## Clean Up the Local Development Environment

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/ssl`:

    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/ssl`:

    ```bash
    $ ./script/clearGemFireData.sh
    ```
