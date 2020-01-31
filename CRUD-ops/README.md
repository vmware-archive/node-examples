# The CRUD-ops Example

This Node.js example provides a simple Javascript application that demonstrates
basic CRUD operations (create, read, update, delete) on a local Pivotal GemFire cluster. This app also can be run with
a local Apache Geode cluster.

## Prerequisites

 **Node.js**, minimum version of 10.16.3

- **npm**, the Node.js package manager

- **Examples source code**.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- **Node.js client library**. Acquire the Node.js client library from PivNet under [Cloud Cache](https://network.pivotal.io/products/p-cloudcache/).
The file is a compressed tar archive (suffix `.tgz`), and the filename contains the client library version number.
For example:
`gemfire-nodejs-client-2.0.0.tgz`.


- **Pivotal GemFire**.
Acquire Pivotal GemFire from PivNet at [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/). Be sure to install GemFire's prerequisite Java JDK 1.8.X, which is needed to support gfsh, the GemFire command line interface.
Choose your GemFire version based on the version of Cloud Cache in your PAS environment.
See the [Product Snapshot](https://docs.pivotal.io/p-cloud-cache/product-snapshot.html) for your Cloud Cache version.

- **Configure environment variables**.
Set `GEODE_HOME` to the GemFire installation directory and add `$GEODE_HOME/bin` to your `PATH`. For example

    On Mac and Linux:

    ```bash
    export GEODE_HOME=/Users/MyGemFire
    export PATH=$GEODE_HOME/bin:$PATH
    ```

    On Windows:
  
    ```cmd
    set GEODE_HOME=c:\Users\MyGemFire
    set PATH=%GEODE_HOME%\bin;%PATH%
    ```

## Install the Node.js Client Module

With a current working directory of `node-examples/CRUD-ops`,
 install the Node.js client module:

```bash
$ npm install gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

## Start a GemFire Cluster

There are scripts in the `CRUD-ops/scripts` directory for creating a GemFire cluster. The `startGemFire` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A region is similar to a hashmap and stores all data as
key/value pairs.

The startup scripts depend on gfsh, the administrative utility provided with the GemFire product.  

With a current working directory of `node-examples/CRUD-ops`, run the `startGemFire` script for your system:

On Mac and Linux:

```bash
$ ./scripts/startGemFire.sh
```

On Windows:

```cmd
$ powershell ./scripts/startGemFire.ps1
```

Logs and other data for the cluster are stored in directory `node-examples/CRUD-ops/data`.

Example output:

```bash
$  ./scripts/startGemFire.sh

Geode home= /Users/pivotal/workspace/pivotal-gemfire-9.8.4

PATH = /usr/local/opt/openssl@1.1/bin:/Users/pivotal/.nvm/versions/node/v10.17.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/bin

Java version:
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.222-b10, mixed mode)

*** Launch Locator ***

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/CRUD-ops/data/locator

....

*** Launch Server ***
Locator in /Users/pivotal/workspace/node-examples/CRUD-ops/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 6068
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/CRUD-ops/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.118.33.177, port=1099]

Cluster configuration service is up and running.

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/CRUD-ops/data/server

...
Server in /Users/pivotal/workspace/node-examples/CRUD-ops/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 6158
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/CRUD-ops/data/server/server.log
JVM Arguments: -Dgemfire.locators=localhost[10337] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

*** Create Partition Region "test" ***

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - create region --name=test --type=PARTITION

Member | Status | Message
------ | ------ | ----------------------------------
server | OK     | Region "/test" created on "server"

Changes to configuration for group 'cluster' are persisted.
```

## Run the Example Application

With a current working directory of `node-examples/CRUD-ops`:

```bash
$ node index.js
```

The application demonstrates configuring the Node.js GemFire client
to use a local cluster.
It performs each CRUD operation, printing expected and actual values along
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
```

## Review of the Example Code

The following code snippets are excerpts from the example source code in the `index.js` file in the example directory.

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

When finished running the example, use the shutdown script to
tear down the GemFire cluster.
With a current working directory of `node-examples/CRUD-ops`:

  On Mac and Linux:
  
  ```bash
    $ ./scripts/shutdownGemFire.sh
  ```
  
  On Windows:
  
  ```cmd
    c:\node-examples\CRUD-ops> powershell ./scripts/shutdownGemFire.ps1
  ```

Use the clean-up script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/CRUD-ops`:

  On Mac and Linux:
  
  ```bash
  $ ./scripts/clearGemFireData.sh
  ```

  On Windows:
    
  ```cmd
  c:\node-examples\CRUD-ops> powershell ./scripts/clearGemFireData.ps1
  ```
