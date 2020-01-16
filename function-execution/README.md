# The function-execution Example

This Node.js example provides a simple Javascript application, which demonstrates
basic calling a server side function on a Pivotal GemFire cluster. This app can
be run with either a local Apache Geode cluster or with a Pivotal GemFire cluster.

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
$ ./scripts/startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/function-execution/data`.

Example output:

```bash
$  ./scripts/startGemFire.sh

*** Build Function Jar ***
GEODE_HOME=/Users/pivotal/workspace/pivotal-gemfire-9.8.4
CLASSPATH=/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/*
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.222-b10, mixed mode)
Note: com/vmware/example/SumRegion.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
Note: com/vmware/example/SumRegion.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
added manifest
adding: com/(in = 0) (out= 0)(stored 0%)
adding: com/vmware/(in = 0) (out= 0)(stored 0%)
adding: com/vmware/example/(in = 0) (out= 0)(stored 0%)
adding: com/vmware/example/SumRegion.class(in = 1586) (out= 834)(deflated 47%)
adding: com/vmware/example/SumRegion.java(in = 876) (out= 345)(deflated 60%)

*** Start Locator ***

(1) Executing - start locator --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/function-execution/data/locator

....
Locator in /Users/pivotal/workspace/node-examples/function-execution/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 4006
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/function-execution/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

Successfully connected to: JMX Manager [host=10.118.33.177, port=1099]

Cluster configuration service is up and running.

*** Launch Server ***

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/function-execution/data/server

...
Server in /Users/pivotal/workspace/node-examples/function-execution/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 4121
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/function-execution/data/server/server.log
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

*** Deploy Function Jar ***

(1) Executing - connect --locator=localhost[10337]

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - deploy --jar=/Users/pivotal/workspace/node-examples/function-execution/src/SumRegion.jar

Member | Deployed JAR  | Deployed JAR Location
------ | ------------- | --------------------------------------------------------------------------------------
server | SumRegion.jar | /Users/pivotal/workspace/node-examples/function-execution/data/server/SumRegion.v1.jar
```

## Run the example application

With a current working directory of `node-examples/function-execution`:

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
Call server side function
Sum of data on server: 3
```

## Review of the Example Code

### Server Configuration
Prior to starting the Node.js GemFire client, a server side function is compiled
and deployed to the server. See startGemFire.sh script for example of building and deploying a function.

All server side functions are written in Java and must
follow the GemFire API.  The following example function is extremely simple, it
sums the data in the test region then returns the sum to the client.

Example function is at src/com/vmware/example/SumRegion.java

```java
package com.vmware.example;

import org.apache.geode.cache.Region;
import org.apache.geode.cache.execute.FunctionAdapter;
import org.apache.geode.cache.execute.FunctionContext;
import org.apache.geode.cache.execute.RegionFunctionContext;

import java.util.Map;
import java.util.Set;

public class SumRegion extends FunctionAdapter {

    public void execute(FunctionContext fc) {
        RegionFunctionContext regionFunctionContext = (RegionFunctionContext) fc;
        Region<Object, Object> dataSet = regionFunctionContext.getDataSet();

        Set<Map.Entry<Object, Object>> entries = dataSet.entrySet();

        Double sum = 0.0;
        for(Map.Entry<Object, Object> entry : entries) {
            sum += (Double) entry.getValue();
        }

        fc.getResultSender().lastResult(sum);
    }

    public String getId() {
        return getClass().getName();
    }
}
```

For additional details on writing and using server side functions see the
GemFire documentation. Functions are extremely powerful but also can introduce server side issues if not carefully written as they run in the server process and
have broad access to the server resources. Only well tested, vetted by the operations team and reviewed functions should be deployed in production servers.

### Client Configuration

The Node.js client configuration is similar to other client examples. The test
Region is used and two put operations add data to the server.

```javascript
await region.put('one', 1)
await region.put('two', 2)
```

### Call server side function
Call the server side function, which will sum the data in the test region.

```javascript
let data = await region.executeFunction('com.vmware.example.SumRegion')
```

Although this is a simple function, imagine if this was thousands or tens of
thousands of entries that needed to be summed or a even a more complex algorithm
used to compute a value based on the data. By doing the operations in the server we avoid having to fetch the data back over the network to the client. If the client is only interested in the final result of the computation, calling a function to do the work on the server can be significantly faster.  In some cases
a client may not have the necessary resources such as memory or CPU to complete a large task and so using a server side function makes this possible.   

## Clean Up the Local Development Environment

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/function-execution`:

    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/function-execution`:

    ```bash
    $ ./scripts/clearGemFireData.sh
    ```
