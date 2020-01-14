# The function-execution Example

This Node.js example provides a simple Javascript application, which demonstrates
basic CRUD operations on a Pivotal GemFire cluster. This app can be run with
either a local Apache Geode cluster or with a Pivotal GemFire cluster.

## Prerequisites

- Examples source code.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- Node.js client library. Acquire the Node.js client library from PivNet.
Find and download the Node.js Client 2.0.0 Beta version,
`gemfire-nodejs-client-2.0.0-beta.tgz`,
under [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).

- Pivotal GemFire (to have gfsh, the command line interface for GemFire).
Acquire Pivotal GemFire from PivNet
at [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/). Configure GEODE_HOME and PATH as required by GemFire.

- Java JDK 1.8.X  is a dependency for Apache Geode/GemFire and gfsh

- Node.js, minimum version of 10.0

- `npm`, the Node.js package manager


## Build the App

With a current working directory of `node-examples/function-execution`,
build the app:

```bash
$ npm install gemfire-nodejs-client-2.0.0-beta.tgz
$ npm update
```

## Start a GemFire Cluster

There is bash script in the `function-execution/scripts` directory for creating a GemFire cluster. The `startGemFire.sh` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single Region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A Region is similar to a hashmap and stores all data as
key/value pairs.

The startup script depends on gfsh the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/function-execution`:

```bash
$ cd scripts
$ ./startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/function-execution/data`.

Example output:

```bash
$  ./startGemFire.sh
~/workspace/node-examples/function-execution/data/locator ~/workspace/node-examples/function-execution/scripts
~/workspace/node-examples/function-execution/scripts
.
(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/function-execution/data/locator

.....
Locator in /Users/pivotal/workspace/node-examples/function-execution/data/locator on 10.0.0.177[10337] as locator is currently online.
Process ID: 47975
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/function-execution/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.0.0.177, port=1099]

Cluster configuration service is up and running.

~/workspace/node-examples/function-execution/data/server ~/workspace/node-examples/function-execution/scripts
~/workspace/node-examples/function-execution/scripts

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.0.0.177, port=1099] ..
Successfully connected to: [host=10.0.0.177, port=1099]


(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/function-execution/data/server

...
Server in /Users/pivotal/workspace/node-examples/function-execution/data/server on 10.0.0.177[40404] as server is currently online.
Process ID: 48079
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/function-execution/data/server/server.log
JVM Arguments: -Dgemfire.locators=localhost[10337] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

~/workspace/node-examples/function-execution/data/server ~/workspace/node-examples/function-execution/scripts

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.0.0.177, port=1099] ..
Successfully connected to: [host=10.0.0.177, port=1099]

(2) Executing - create region --name=test --type=PARTITION

Member | Status | Message
------ | ------ | ----------------------------------
server | OK     | Region "/test" created on "server"

Changes to configuration for group 'cluster' are persisted.
```
Change back to application directory.
```bash
$ cd ..
```

## Run the example application

With a current working directory of `node-examples/function-execution`:

```bash
$ node index.js
```

The application demonstrates configuring the Node.js GemFire client
to use a local cluster.
It does each CRUD operation, printing expected and actual values along
the way. The application is not interactive.

Example output:

```
$ node index.js
Creating a cache factory
Creating a cache
Creating a pool factory
Configuring the pool factory to find a locator at localhost:10337
Creating a pool
Creating a region called 'test' of type 'PROXY' connected to the pool named 'pool'
Create operation:
  Putting key 'foo' with value 'bar'
Read operation:
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
To exit: CTRL-C
```

## Review of the Example Code

### Configuration

This block of code configures the client cache. The log location and metrics are written to the data directory. The PoolFactory configures a connection pool which uses the locator to lookup the servers.

```javascript
cacheFactory = gemfire.createCacheFactory()
cacheFactory.set("log-file","data/nodeClient.log")
cacheFactory.set("log-level","config")
cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
cache = await cacheFactory.create()
poolFactory = await cache.getPoolManager().createFactory()
poolFactory.addLocator('localhost', 10337)
poolFactory.create('pool')
```

### Region Configuration
Create a region in client called 'test' and connect it to the pool used to communicate with the server. A matching region on the server is required and was created by the server startup script.

```javascript
  region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
```

### Create (Put)
Insert/store data value 'bar' using key 'foo' into region 'test'

```javascript
await region.put('foo', 'bar')
```

### Read (Get)
Fetch a value from the server by getting it with key 'foo'

```javascript
var result = await region.get('foo')
```

### Update (Put)
A put is used to update a key-value pair that already has been added to the cache

```Javascript
await region.put('foo', 'candy')
```

### Delete (Remove)
Delete the data on the server. using key 'foo'

```javascript
await region.remove('foo')
```

Attempting to get a value that has been removed will result in a null value being returned.

```javascript
result = await region.get('foo') //null value
```

## Clean Up the Local Development Environment

- When finished with running the example, use a control-C in the shell running `node` to stop running the application.

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/function-execution`:

    ```bash
    $ cd scripts
    $ ./shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/function-execution`:

    ```bash
    $ cd scripts
    $ ./clearGemFireData.sh
    ```
