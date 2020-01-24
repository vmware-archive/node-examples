# The query Example

This Node.js example provides a simple Javascript application, which demonstrates
basic calling a server side function on a Pivotal GemFire cluster. This app can
be run with either a local Apache Geode cluster or with a Pivotal GemFire cluster.

## Prerequisites

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

## Start a GemFire Cluster

There is bash script in the `query/scripts` directory for creating a GemFire cluster. The `startGemFire.sh` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The startup script also creates a single Region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A Region is similar to a hashmap and stores all data as
key/value pairs.

The startup script depends on gfsh the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/query`:

```bash
$ ./scripts/startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/query/data`.

Example output:

```bash
$  ./scripts/startGemFire.sh

*** Start Locator ***

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/query/data/locator

....
Locator in /Users/pivotal/workspace/node-examples/query/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 10797
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/query/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.118.33.177, port=1099]

Cluster configuration service is up and running.

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - configure pdx --read-serialized=true

read-serialized = true
ignore-unread-fields = false
persistent = false
Changes to configuration for group 'cluster' are persisted.

*** Launch Server ***

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/query/data/server

...
Server in /Users/pivotal/workspace/node-examples/query/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 10911
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/query/data/server/server.log
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

## Run the example application

With a current working directory of `node-examples/query`:

```bash
$ node index.js
```

The application demonstrates call a server side function with the Node.js
GemFire client. The client does two puts then calls the server side function
which will sum the two entries and return the sum to the client.  The
application is not interactive.

Example output:

```
$ node index.js
Configuring and creating a cache
Put data into server
Call server side query
 List of values returned by query: select * from /test
 Values: 6,3,8,7,10,9,4,2,1,5
Call server side query
 List of keys returned by query: select * from /test.keySet
 Keys: ten,two,five,seven,nine,one,three,four,eight,six
Call server side query
 List of values greater than five returned by query: select * from /test x where x.bar >5
 Values greater than 5: 8,9,10,7,6
```

## Review of the Example Code

### Server Configuration

After start up of servers and before the servers are started, the PDX read-serialized
setting is configured to true.

Example from startGemFire.sh script:

```
gfsh -e "connect --locator=localhost[10337]" -e "configure pdx --read-serialized=true"
```

See GemFire documentation for additional details.

### Client Configuration

The Node.js client configuration is similar to other client examples. The test
Region is used and two putAll operations add data to the server.

```javascript
await region.putAll({'one': {bar:1},'two': {bar:2},'three': {bar:3},'four':{bar:4},'five': {bar:5}})
await region.putAll({'six': {bar:6},'seven': {bar:7},'eight': {bar:8},'nine': {bar:9},'ten': {bar:10}})
```

Queries are server side operations and use a form of the Object Query Language or
 OQL for short. See GemFire documentation for additional details on using OQL for queries.  

### Calling server side query

The example demonstrates three simple queries that run on the server and return an
array of results to the client application.

Query and return all entries in the region. This simple query can consume
significant resources with large datasets and should be used with caution.

```javascript
data = await region.query("select * from /test")
```
Query and return all keys in the region keyset. This simple query can consume
significant resources with large datasets and should be used with caution.

```javascript
data = await region.query("select * from /test.keySet")
```

Query and filter entries based on a field of each entry.

```javascript
data = await region.query("select * from /test x where x.bar >5")
```

The results of the query are returned as an unsorted array of objects. So in the query
 "select * from /test x where x.bar >5", the results are the five entry values
 like '{bar:7}' where bar > 5. The result set doesn't contain the keys unless
 querying against the keyset itself.

Process the result set into a string for display.

 ```javascript
 text=""
 for(i=0; i<data.length-1;i++){
   text+= (data[i].bar + ",")
 }
 text+= (data[i].bar)
 ```

These examples are very simple queries against a minimal dataset, imagine if this was thousands
 or tens of thousands of entries. Queries over large datasets will consume
 significant server and client resources. In some cases a client may not have the necessary
 resources such as memory or CPU to process a large result set returned from the server. As
 such queries should be reviewed by the development and operations team prior to use
 in production.    


## Clean Up the Local Development Environment

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/query`:

    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/query`:

    ```bash
    $ ./scripts/clearGemFireData.sh
    ```
