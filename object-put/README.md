# The Object Usage Example

This Node.js example provides a simple Javascript application that demonstrates
basic object usage with a local Pivotal GemFire cluster. This app also can be run with
a local Apache Geode cluster.

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

# Install the Node.js Client Module

With a current working directory of `node-examples/object-put`,
install the Node.js client module:

```bash
$ npm install gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

## Start a GemFire Cluster

There are scripts in the `object-put/scripts` directory for creating a GemFire cluster. The `startGemFire` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A region is similar to a hashmap and stores all data as
key/value pairs.

The startup script depends on gfsh, the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/object-put`, run the `startGemFire` script for your system:

On Mac and Linux:

```bash
$ ./scripts/startGemFire.sh
```

On Windows:

```cmd
$ powershell ./scripts/startGemFire.ps1
```

Logs and other data for the cluster are stored in directory `node-examples/object-put/data`.

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

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/object-put/data/locator

....

*** Launch Server ***
Locator in /Users/pivotal/workspace/node-examples/object-put/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 6068
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/object-put/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.118.33.177, port=1099]

Cluster configuration service is up and running.

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/object-put/data/server

...
Server in /Users/pivotal/workspace/node-examples/object-put/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 6158
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/object-put/data/server/server.log
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

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - create region --name=othertest --type=PARTITION

Member | Status | Message
------ | ------ | ----------------------------------
server | OK     | Region "/othertest" created on "server"

Changes to configuration for group 'cluster' are persisted.

```

## Run the Example Application

With a current working directory of `node-examples/object-put`:

```bash
$ node index.js
```

The application demonstrates basic object usage. It creates two regions, then uses objects both as values and as keys to store and retrieve data.  The application is not interactive.

Example output:

```
$ node index.js
************************** Defined region: othertest **************************
 Region attributes:  { cachingEnabled: true,
  clientNotificationEnabled: false,
  concurrencyChecksEnabled: true,
  concurrencyLevel: 16,
  diskPolicy: 0,
  entryIdleTimeout: 0,
  entryTimeToLive: 0,
  initialCapacity: 10000,
  loadFactor: 0.75,
  lruEntriesLimit: 0,
  lruEvicationAction: 3,
  poolName: 'pool',
  regionIdleTimeout: 0,
  regionTimeToLive: 0 }
************************** Defined region: test **************************
 Region attributes:  { cachingEnabled: false,
  clientNotificationEnabled: false,
  concurrencyChecksEnabled: true,
  concurrencyLevel: 16,
  diskPolicy: 0,
  entryIdleTimeout: 0,
  entryTimeToLive: 0,
  initialCapacity: 10000,
  loadFactor: 0.75,
  lruEntriesLimit: 0,
  lruEvicationAction: 3,
  poolName: 'pool',
  regionIdleTimeout: 0,
  regionTimeToLive: 0 }
************ Put key into region test ********************
Get value with key:  { funk: 'foo', doom: 'gloom', cloud: 'rain' }
Value from Region test:  { foo: 'bar' }
************** Put key in two different regions ******************
Get value from each region with key:  { funk: 'foo', doom: 'gloom', cloud: 'rain' }
Value from Region othertest:  { foo: 'bbq' }
Value from Region test:  { foo: 'bar' }
************** Do get with key with different field order ******************
Get value from each region with key:  { cloud: 'rain', funk: 'foo', doom: 'gloom' }
Value from region test:  { foo: 'bar' }
*************** Insert new key into test *****************
Get value from each region with key:  { funk: 'foo', doom: 'gloom', cloud: 'snow' }
Value from region test:  { bar: 'candy' }
************* Null value returned for non-existent data *******************
Not existent data fetch with key: { doom: 'gloom', funk: 'foo', cloud: 'sunny' }
Value from region test:  null
*************** Insert new key into test *****************
Get value from each region with key:  0
Value from region test:  { bar: 'mars' }
*************** Insert new key into test *****************
Get value from each region with key:  mykey
Value from region test:  { bar: 'hershey' }

```

## Review of the Example Code

### Configuration

There are no significant configuration changes for this example as compared to
the CRUD-ops example.

### Region Configuration
In this example, two regions are created. The 'test' region is PROXY region and
 does not store a local copy of the data. The 'othertest' region is a  CACHING_PROXY and
 it stores a local copy of data that is put and fetched from the server. In most cases
 applications should just use the PROXY region, but if the data does not change
 frequently and will be used multiple times by the client, a CACHING_PROXY may
provide a performance advantage, but will increase the memory footprint of the
client application for the local storage of the cached server data.

```javascript

region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
otherRegion = await cache.createRegion("othertest", { type: 'CACHING_PROXY', poolName: 'pool' })
```

Although rarely done in applications, a user may want to perform an action on all the
regions created in the client application. The following demonstrates printing out
the configuration of the all the regions defined in the client by using the
rootRegions() function and querying each region for its attributes.

```javascript
await cache.rootRegions().forEach( async function(region){
  attributes=await region.attributes()
  console.log('************************** Defined region: '+region.name()+' **************************')
  console.log(' Region attributes: ', attributes)
})
```

### Put and Get objects
Pivotal Cloud Cache is a key/value and cache solution. The keys and values can be
strings, numbers or JSON objects. A region can be used like a hashmap with the added
ability to be distributed to a cluster of servers and redistributed to other
clients or across WAN connections to other clusters.


Using a JSON key and value

```javascript
var key={funk:'foo', doom:'gloom', cloud:'rain'}
var value={foo:'bar'}

await region.put(key,value)
var result = await region.get(key)
console.log('************ Put key into region test ********************')
console.log('Get value with key: ',key)
console.log("Value from Region test: ",result)
```
Using an integer key

```Javascript
var numberkey = 0
await region.put(numberkey, {bar:'mars'})
result = await region.get(numberkey)
console.log('*************** Insert new key into test *****************')
console.log('Get value from each region with key: ',numberkey)
console.log('Value from region test: ',result)
```
Using a string key

```javascript
var stringkey = 'mykey'
await region.put(stringkey, {bar:'hershey'})
result = await region.get(stringkey)
console.log('*************** Insert new key into test *****************')
console.log('Get value from each region with key: ',stringkey)
console.log('Value from region test: ',result)
```

### Best Practice
For simplicity, the example mixes different types of keys and data values in the same region, but
as best practice separate regions should be used to manage each different type and set of data. So in the example code, using a new region to store the data associated with the string or integer keys would be better practice. Best to think
"birds of a feather, flock together" when designing your data model; that
will help when using server side functionality such as functions, queries and indexes.     

## Clean Up the Local Development Environment

When finished running the example, use the shutdown script to
tear down the GemFire cluster.
With a current working directory of `node-examples/object-put`:

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
With a current working directory of `node-examples/object-put`:

  On Mac and Linux:
  
  ```bash
  $ ./scripts/clearGemFireData.sh
  ```

  On Windows:
    
  ```cmd
  c:\node-examples\CRUD-ops> powershell ./scripts/clearGemFireData.ps1
  ```
