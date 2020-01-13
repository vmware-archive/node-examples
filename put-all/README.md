# The PutAll & GetAll Example

This Node.js example provides a simple Javascript application, which demonstrates
basic putAll and getAll operations on a Pivotal GemFire cluster. This application leverages the put-get-remove example and should be reviewed prior starting. This example client works with
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

With a current working directory of `node-examples/put-all`,
build the app:

```bash
$ npm install gemfire-nodejs-client-2.0.0-beta.tgz
$ npm update
```

## Start a GemFire Cluster

There is bash script in the `put-all/scripts` directory for creating a GemFire cluster. The `startGemFire.sh` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single Region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A Region is similar to a hashmap and stores all data as
key/value pairs.

The startup script depends on gfsh the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/put-all`:

```bash
$ cd scripts
$ ./startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/put-all/data`.

Example output:

```bash
$  ./startGemFire.sh
~/workspace/node-examples/put-all/data/locator ~/workspace/node-examples/put-all/scripts
~/workspace/node-examples/put-all/scripts
.
(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/put-all/data/locator

.....
Locator in /Users/pivotal/workspace/node-examples/put-all/data/locator on 10.0.0.177[10337] as locator is currently online.
Process ID: 47975
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/put-all/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.0.0.177, port=1099]

Cluster configuration service is up and running.

~/workspace/node-examples/put-all/data/server ~/workspace/node-examples/put-all/scripts
~/workspace/node-examples/put-all/scripts

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.0.0.177, port=1099] ..
Successfully connected to: [host=10.0.0.177, port=1099]


(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/put-all/data/server

...
Server in /Users/pivotal/workspace/node-examples/put-all/data/server on 10.0.0.177[40404] as server is currently online.
Process ID: 48079
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/put-all/data/server/server.log
JVM Arguments: -Dgemfire.locators=localhost[10337] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

~/workspace/node-examples/put-all/data/server ~/workspace/node-examples/put-all/scripts

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
To exit: CTRL-C
```

## Review of the Example Code

### Configuration & Region

The configuration client is identical to the put-get-remove example. The region configuration also is identical and uses the 'test' region for managing the data
connection with the server.

### putAll
The putAll operation is similar to a put in that it updates the region entries with a key/value pair. But unlike a standard put which updates a single entry, the putAll takes a collection of key/value pairs updating multiple entries. In the code snippet, the three keys foo, boo and spam will be created in the cache with their associated values.  The putAll operation is typically used for batch data imports into the cache.  

```javascript
await region.putAll({'foo': 'bar','boo':'candy','spam':'musubi'})
```

### getAll
Similar to a get operation, the getAll will fetch values from the server. But instead of using and single key, an array of keys is used to fetch multiple
values from the server as a collection. In the example the array of keys ['foo','boo','spam'] which will return the associated values. The getAll is typically used when doing batch update cycles of existing data in such cases doing a getAll, modify data then a putAll of the updated values.

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
There is no general method for aggregated deletions of data in a region. The region.clean() method can delete all data in a replicated server region but is limited and does not work with server partitioned regions. As such region.clear() for most use cases will not be appropriate.     

```javascript
await region.clear()
```

For more complex use cases deleting of data from regions, many users will use the GemFire Function Service and develop a server side function to handle these cases. Optionally server side regions can configure expiration as another method from deleting data automatically.   


## Clean Up the Local Development Environment

- When finished with running the example, use a control-C in the shell running `node` to stop running the application.

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/put-all`:

    ```bash
    $ cd scripts
    $ ./shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/put-all`:

    ```bash
    $ cd scripts
    $ ./clearGemFireData.sh
    ```
