# The PutAll & GetAll Example

This Node.js example provides a simple Javascript application that demonstrates
basic putAll and getAll operations on Pivotal GemFire cluster. This application leverages the CRUD-ops example, which you should review prior starting. This example client works with
either a local Apache Geode cluster or with a Pivotal GemFire cluster.

## Prerequisites

- **Node.js**, minimum version of 10.0

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

With a current working directory of `node-examples/put-all`,
install the Node.js client module:

```bash
$ npm install gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

## Start a GemFire Cluster

There are scripts in the `put-all/scripts` directory for creating a GemFire cluster. The `startGemFire` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A region is similar to a hashmap and stores all data as
key/value pairs.

The startup script depends on gfsh, the administrative utility provided with the GemFire product.  

With a current working directory of `node-examples/put-all`, run the `startGemFire` script for your system:

On Mac and Linux:

```bash
$ ./scripts/startGemFire.sh
```

On Windows:

```cmd
$ powershell ./scripts/startGemFire.ps1
```

Logs and other data for the cluster are stored in directory `node-examples/put-all/data`.

Example output:

```bash
$  ./scripts/startGemFire.sh

Geode home= /Users/pivotal/workspace/pivotal-gemfire-9.8.4

PATH = /usr/local/opt/openssl@1.1/bin:/Users/pivotal/.nvm/versions/node/v10.17.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/bin

Java version:
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.222-b10, mixed mode)

*** Start Locator ***

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/put-all/data/locator

....

*** Start Server ***
Locator in /Users/pivotal/workspace/node-examples/put-all/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 8349
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/put-all/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.118.33.177, port=1099]

Cluster configuration service is up and running.

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/put-all/data/server

...
Server in /Users/pivotal/workspace/node-examples/put-all/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 8452
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/put-all/data/server/server.log
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

Changes to configuration for group 'cluster' are persisted
```

## Run the Example Application

With a current working directory of `node-examples/put-all`:

```bash
$ node index.js
```

The application demonstrates configuring the Node.js GemFire client
to use a local cluster.
The client does a set of putAll and getAll operations, printing the expected and actual values along
the way. The application is not interactive.

Example output:

```
$ node index.js
PutAll operation:
Validate putAll operation:
  Getting value with key 'foo'. Expected value: 'bar'
  Value retrieved is: 'bar'
  Getting value with key 'boo'. Expected value: 'candy'
  Value retrieved is: 'candy'
  Getting value with key 'spam'. Expected value: 'musubi'
  Value retrieved is: 'musubi'
Validate putAll operation with getAll:
  Getting value with key 'foo'. Expected value: 'bungie'
  Value retrieved is: 'bungie'
  Getting value with key 'boo'. Expected value: 'tophat'
  Value retrieved is: 'tophat'
  Getting value with key 'spam'. Expected value: 'sushi'
  Value retrieved is: 'sushi'
Use putAll and getAll with JSON Objects
Do a regular get operation.
  Object retrieved is:'[object Object]'
  Value retrieved is: '10'
Do a regular getAll operation.
  Getting object with key 'foo'. Expected value: '[object Object]'
  Object retrieved is:'[object Object]'
  Getting value with key 'foo'. Expected value of bar: '10'
  Value retrieved is: '10'
  Getting value with key 'boo'. Expected value of bar: 'candy'
  Value retrieved is: 'candy'
  Getting value with key 'spam'. Expected value of bar: 'musubi'
  Value retrieved is: 'musubi'
```

## Review of the Example Code

### Configuration & Region

The configuration client is identical to the put-get-remove example. The region configuration also is identical and uses the 'test' region for managing the data
connection with the server.

### putAll
The putAll operation is similar to a put in that it updates the region entries with a key/value pair. But unlike a standard put which updates a single entry, putAll takes a collection of key/value pairs, updating multiple entries in a single API call. In the code snippet, the three keys 'foo', 'boo', and 'spam' are created in the cache with their associated values.  The putAll operation is typically used for batch data imports into the cache.  

```javascript
await region.putAll({'foo': 'bar','boo':'candy','spam':'musubi'})
```

### getAll
Similar to a get operation, the getAll fetches values from the server. But instead of using a single key, an array of keys is used to fetch multiple
values from the server as a collection. In the example the array of keys ['foo','boo','spam'] returns the associated values. The getAll operation is typically used when doing batch update cycles of existing data, in such cases doing a getAll, modifying the data, then calling putAll to store the updated values.

```javascript
let getresult = await region.getAll(['foo','boo','spam'])
console.log('  Value retrieved is: \'' + getresult.foo + '\'')
console.log('  Value retrieved is: \'' + getresult.boo + '\'')
console.log('  Value retrieved is: \'' + getresult.spam + '\'')
```

### putAll and getAll with JSON objects
A putAll can insert a collection of objects with key:{object value} pairing being passed to the server for processing.  

```Javascript
await region.putAll({'foo':{'bar':10},'boo':{'bar':'candy'},'spam':{'bar':'musubi'}})
result = await region.get('foo')
console.log('  Object retrieved is:\'' + result + '\'')
console.log('  Value retrieved is: \'' + result.bar + '\'')
getallresult = await region.getAll(['foo','boo','spam'])
console.log('  Object retrieved is:\'' + getallresult.foo + '\'')
console.log('  Value retrieved is: \'' + getallresult.foo.bar + '\'')
```

### Delete (Remove)
There is no general method for aggregated deletions of data in a region. The region.clean() method can delete all data in a replicated server region, but is limited and does not work with server partitioned regions. Therefore, `region.clear()` for most use cases will not be appropriate.     

```javascript
await region.clear()
```

For more complex use cases of deleting data from regions, many users use the GemFire Function Service and develop a server-side function to handle these use cases. Optionally on the server side, regions can be configured with data expiration as another method for deleting keys and values automatically.


## Clean Up the Local Development Environment

When finished running the example, use the shutdown script to
tear down the GemFire cluster.
With a current working directory of `node-examples/put-all`:

  On Mac and Linux:
  
  ```bash
    $ ./scripts/shutdownGemFire.sh
  ```
  
  On Windows:
  
  ```cmd
    c:\node-examples\CRUD-ops> powershell ./scripts/shutdownGemFire.ps1
  ```

Use the cleanup script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/put-all`:

  On Mac and Linux:
  
  ```bash
  $ ./scripts/clearGemFireData.sh
  ```

  On Windows:
    
  ```cmd
  c:\node-examples\CRUD-ops> powershell ./scripts/clearGemFireData.ps1
  ```
