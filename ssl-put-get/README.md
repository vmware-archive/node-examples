# The SSL-Put-Get Example

This Node.js example demonstrates basic authentication of a user with a GemFire
 Cache cluster. This application leverages the put-get-remove example and should
 be reviewed prior starting. The example works with either a local Apache Geode
 or Pivotal GemFire cluster.

# Prerequisites

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

- Java JDK 1.8.X  is a dependency for GemFire and gfsh

- Node.js, minimum version of 10.0

- `npm`, the Node.js package manager


# Install GemFire Node.js Client Module

With a current working directory of `node-examples/authenticate`,
 install the module:

```bash
$ npm install gemfire-nodejs-client-2.0.0-beta.tgz
$ npm update
```
## Create Certificates
Certificate generation
https://jamielinux.com/docs/openssl-certificate-authority/introduction.html

jks keystore import
https://blog.codecentric.de/en/2013/01/how-to-use-self-signed-pem-client-certificates-in-java/

## Start a GemFire Cluster

There is bash script in the `authenticate/scripts` directory for creating a GemFire cluster. The `startGemFire.sh` script starts up the simplest cluster of one locator and one cache server. The locator provides administration services for the cluster and a discovery service allowing clients and servers to find each other. The server provides storage for data along with computation services.

The script builds and deploys a security manager to the GemFire cluster, so clients must now authenticate prior to accessing or performing any operations on the cluster. The startup script also creates a single Region called "test" that the application uses for storing data in the server (similar to a table in relational databases). A Region is similar to a hashmap and stores all data as key/value pairs.

The startup script depends on gfsh the administrative utility provided by the GemFire product.  

With a current working directory of `node-examples/authenticate`:

```bash
$ cd scripts
$ ./startGemFire.sh
```

If you encounter script issues with gfsh, validate that the GEODE_HOME environmental variable is configured and pointing to the GemFire install directory and that the PATH variable includes the bin directory of the GemFire install. Logs and other data for the cluster is stored in directory `node-examples/authenticate/data`

Example output:

```bash
$ ./startGemFire.sh
*** Build SimpleSecurityManager ***
~/workspace/node-examples/authenticate/src ~/workspace/node-examples/authenticate/scripts
added manifest
adding: securitymanager/(in = 0) (out= 0)(stored 0%)
adding: securitymanager/SimpleSecurityManager.java(in = 2851) (out= 1026)(deflated 64%)
adding: securitymanager/SimpleSecurityManager.class(in = 2267) (out= 1103)(deflated 51%)
~/workspace/node-examples/authenticate/scripts
*** Start Locator ***
~/workspace/node-examples/authenticate/data/locator ~/workspace/node-examples/authenticate/scripts
~/workspace/node-examples/authenticate/scripts
..
(1) Executing - start locator --connect=false --name=locator --port=10337 --dir=/Users/pivotal/workspace/node-examples/authenticate/data/locator --classpath=/Users/pivotal/workspace/node-examples/authenticate/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager

.....
Locator in /Users/pivotal/workspace/node-examples/authenticate/data/locator on 10.118.33.177[10337] as locator is currently online.
Process ID: 59026
Uptime: 4 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/authenticate/data/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.security-manager=securitymanager.SimpleSecurityManager -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4//lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/node-examples/authenticate/src/security.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

*** Start Server ***
~/workspace/node-examples/authenticate/data/server ~/workspace/node-examples/authenticate/scripts
~/workspace/node-examples/authenticate/scripts

(1) Executing - connect --locator=localhost[10337] --user=root --password=*****

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - start server --user=root --password=***** --locators=localhost[10337] --server-port=40404 --name=server --dir=/Users/pivotal/workspace/node-examples/authenticate/data/server  --classpath=/Users/pivotal/workspace/node-examples/authenticate/src/security.jar --J=-Dgemfire.security-manager=securitymanager.SimpleSecurityManager

...
Server in /Users/pivotal/workspace/node-examples/authenticate/data/server on 10.118.33.177[40404] as server is currently online.
Process ID: 59142
Uptime: 2 seconds
Geode Version: 9.8.4
Java Version: 1.8.0_222
Log File: /Users/pivotal/workspace/node-examples/authenticate/data/server/server.log
JVM Arguments: -Dgemfire.locators=localhost[10337] -Dgemfire.security-username=root -Dgemfire.start-dev-rest-api=false -Dgemfire.security-password=******** -Dgemfire.use-cluster-configuration=true -Dgemfire.security-manager=securitymanager.SimpleSecurityManager -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /Users/pivotal/workspace/pivotal-gemfire-9.8.4//lib/geode-core-9.8.4.jar:/Users/pivotal/workspace/node-examples/authenticate/src/security.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/lib/geode-dependencies.jar:/Users/pivotal/workspace/pivotal-gemfire-9.8.4/extensions/gemfire-greenplum-3.4.1.jar

*** Create Region \'test\' on server ***
~/workspace/node-examples/authenticate/data/server ~/workspace/node-examples/authenticate/scripts

(1) Executing - connect --locator=localhost[10337] --user=root --password=*****

Connecting to Locator at [host=localhost, port=10337] ..
Connecting to Manager at [host=10.118.33.177, port=1099] ..
Successfully connected to: [host=10.118.33.177, port=1099]

(2) Executing - create region --name=test --type=PARTITION

Member | Status | Message
------ | ------ | ----------------------------------
server | OK     | Region "/test" created on "server"

Changes to configuration for group 'cluster' are persisted.

~/workspace/node-examples/authenticate/scripts
```

## Run the example application

With a current working directory of `node-examples/authenticate`:

```bash
$ node index.js
```

The application demonstrates configuring the Node.js GemFire client to use a local cluster. Doing a put of a key/value pair, fetching the value with a get using the key and finally deleting the key/value pair from GemFire. The application is not interactive.

Example output:

```bash
$ node index.js
Creating a cache factory
Set Authentication
Create Cache
Create Pool
Create Region
Do put and get CRUD operations
Finished
To exit: CTRL-C
```

## Review example code
Snippets of the example code index.js are captured below.

### Configuration

This block of code configures the client cache. The log location and metrics are written to the data directory. The PoolFactory configures a connection pool which uses the locator to lookup the servers.

There is a small change from the put-get-remove example configuration, we add the following lines
which adds a username and password used by the GemFire cluster to authenticate the client. The
credentials are sent to the cluster with authenticating and authorization handled on the server side.

```javascript
cacheFactory.setAuthentication((properties, server) => {
  properties['security-username'] = 'root'
  properties['security-password'] = 'root-password'
}, () => {
})
```

The full configuration with the username and password added.

```javascript
cacheFactory = gemfire.createCacheFactory()
cacheFactory.set("log-file","data/nodeClient.log")
cacheFactory.set("log-level","config")
cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
//Configure a username and password for Authentication
console.log('Set Authentication')
cacheFactory.setAuthentication((properties, server) => {
  properties['security-username'] = 'root'
  properties['security-password'] = 'root-password'
}, () => {
})
cache = await cacheFactory.create()
poolFactory = await cache.getPoolManager().createFactory()
poolFactory.addLocator('localhost', 10337)
poolFactory.create('pool')
```

### Security Manager
The provided example security manager (node-examples/authenticate/src/securitymanager/SimpleSecurityManager.java) is very simple and should not be used for production applications. The security manager provides both authentication of the user and authorization of the user actions.  This example security manager supplies three user profiles with different authorization options that can be tried.

#### Bad username or password
Try changing the client application "security-password" property from "root-password"
to "root-passwordabc" in the index.js file. This is will cause an authentication
error with the cluster and the client will not be able to connect or perform
any actions.  

Example output:
```
$ node index.js
Creating a cache factory
Set Authentication
Create Cache
Create Pool
Create Region
Do put and get CRUD operations
: not connected to Geode
Finished
To exit: CTRL-C
```

In the client log file (node-examples/authenticate/data/nodeClient.log), a Java
exception stack will be logged from the GemFire cluster that shows the full error.
The log shows that the client failed to get authenticated.

```Java
[warning 2019/12/19 10:33:18.672628 PST minbari.pivotal.io:63391 123145597251584] Authentication failed in handshake with endpoint[10.118.33.177:40404]: org.apache.geode.security.AuthenticationFailedException: Authentication error. Please check your credentials.
	at org.apache.geode.internal.security.IntegratedSecurityService.login(IntegratedSecurityService.java:144)
	at org.apache.geode.internal.cache.tier.sockets.Handshake.verifyCredentials(Handshake.java:486)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.setCredentials(ServerConnection.java:1092)
	at org.apache.geode.internal.cache.tier.sockets.command.PutUserCredentials.cmdExecute(PutUserCredentials.java:53)
	at org.apache.geode.internal.cache.tier.sockets.BaseCommand.execute(BaseCommand.java:183)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.doNormalMessage(ServerConnection.java:852)
	at org.apache.geode.internal.cache.tier.sockets.OriginalServerConnection.doOneMessage(OriginalServerConnection.java:75)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.run(ServerConnection.java:1230)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at org.apache.geode.internal.cache.tier.sockets.AcceptorImpl.lambda$initializeServerConnectionThreadPool$3(AcceptorImpl.java:616)
	at org.apache.geode.internal.logging.LoggingThreadFactory.lambda$newThread$0(LoggingThreadFactory.java:121)
	at java.lang.Thread.run(Thread.java:748)
Caused by: org.apache.shiro.authc.AuthenticationException: Authentication failed for token submission [org.apache.geode.internal.security.shiro.GeodeAuthenticationToken - root, rememberMe=false].  Possible unexpected error? (Typical or expected login exceptions should extend from AuthenticationException).
	at org.apache.shiro.authc.AbstractAuthenticator.authenticate(AbstractAuthenticator.java:214)
	at org.apache.shiro.mgt.AuthenticatingSecurityManager.authenticate(AuthenticatingSecurityManager.java:106)
	at org.apache.shiro.mgt.DefaultSecurityManager.login(DefaultSecurityManager.java:274)
	at org.apache.shiro.subject.support.DelegatingSubject.login(DelegatingSubject.java:260)
	at org.apache.geode.internal.security.IntegratedSecurityService.login(IntegratedSecurityService.java:141)
	... 12 more
Caused by: org.apache.geode.security.AuthenticationFailedException: Non-authenticated user: root
	at securitymanager.SimpleSecurityManager.authenticate(SimpleSecurityManager.java:42)
	at org.apache.geode.internal.security.shiro.CustomAuthRealm.doGetAuthenticationInfo(CustomAuthRealm.java:53)
	at org.apache.shiro.realm.AuthenticatingRealm.getAuthenticationInfo(AuthenticatingRealm.java:571)
	at org.apache.shiro.authc.pam.ModularRealmAuthenticator.doSingleRealmAuthentication(ModularRealmAuthenticator.java:180)
	at org.apache.shiro.authc.pam.ModularRealmAuthenticator.doAuthenticate(ModularRealmAuthenticator.java:267)
	at org.apache.shiro.authc.AbstractAuthenticator.authenticate(AbstractAuthenticator.java:198)
	... 16 more
```

#### Using a user with insufficient permissions

Lets try changing the "security-username" to "writer" and the "security-password"
to "writer-password" in file index.js. The user "writer" will be authenticated but
and can put data into the cache. But user "writer" is not authorized to get data
from the cache and is blocked trying to get the key "foo".

Example output:

```bash
$ node index.js
Creating a cache factory
Set Authentication
Create Cache
Create Pool
Create Region
Do put and get CRUD operations
org.apache.geode.security.NotAuthorizedException: writer not authorized for DATA:READ:test:foo
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:239)
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:221)
	at org.apache.geode.internal.cache.tier.sockets.command.Get70.cmdExecute(Get70.java:136)
	at org.apache.geode.internal.cache.tier.sockets.BaseCommand.execute(BaseCommand.java:183)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.doNormalMessage(ServerConnection.java:852)
	at org.apache.geode.internal.cache.tier.sockets.OriginalServerConnection.doOneMessage(OriginalServerConnection.java:75)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.run(ServerConnection.java:1230)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at org.apache.geode.internal.cache.tier.sockets.AcceptorImpl.lambda$initializeServerConnectionThreadPool$3(AcceptorImpl.java:616)
	at org.apache.geode.internal.logging.LoggingThreadFactory.lambda$newThread$0(LoggingThreadFactory.java:121)
	at java.lang.Thread.run(Thread.java:748)
Caused by: org.apache.shiro.authz.UnauthorizedException: Subject does not have permission [DATA:READ:test:foo]
	at org.apache.shiro.authz.ModularRealmAuthorizer.checkPermission(ModularRealmAuthorizer.java:334)
	at org.apache.shiro.mgt.AuthorizingSecurityManager.checkPermission(AuthorizingSecurityManager.java:141)
	at org.apache.shiro.subject.support.DelegatingSubject.checkPermission(DelegatingSubject.java:214)
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:235)
	... 11 more

Finished
To exit: CTRL-C
```
The client log file will show a Java exception stack trace from server which shows
details of the failure. In this case that the authorization of the get operation
which is a DATA:READ of the "test" region and key "foo" failed as the "writer" user
only has permissions to perform DATA:WRITE operators or puts.

```Java
[error 2019/12/19 10:42:33.528252 PST minbari.pivotal.io:63588 123145467691008] Region::get: An exception (org.apache.geode.security.NotAuthorizedException: writer not authorized for DATA:READ:test:foo
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:239)
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:221)
	at org.apache.geode.internal.cache.tier.sockets.command.Get70.cmdExecute(Get70.java:136)
	at org.apache.geode.internal.cache.tier.sockets.BaseCommand.execute(BaseCommand.java:183)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.doNormalMessage(ServerConnection.java:852)
	at org.apache.geode.internal.cache.tier.sockets.OriginalServerConnection.doOneMessage(OriginalServerConnection.java:75)
	at org.apache.geode.internal.cache.tier.sockets.ServerConnection.run(ServerConnection.java:1230)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at org.apache.geode.internal.cache.tier.sockets.AcceptorImpl.lambda$initializeServerConnectionThreadPool$3(AcceptorImpl.java:616)
	at org.apache.geode.internal.logging.LoggingThreadFactory.lambda$newThread$0(LoggingThreadFactory.java:121)
	at java.lang.Thread.run(Thread.java:748)
Caused by: org.apache.shiro.authz.UnauthorizedException: Subject does not have permission [DATA:READ:test:foo]
	at org.apache.shiro.authz.ModularRealmAuthorizer.checkPermission(ModularRealmAuthorizer.java:334)
	at org.apache.shiro.mgt.AuthorizingSecurityManager.checkPermission(AuthorizingSecurityManager.java:141)
	at org.apache.shiro.subject.support.DelegatingSubject.checkPermission(DelegatingSubject.java:214)
	at org.apache.geode.internal.security.IntegratedSecurityService.authorize(IntegratedSecurityService.java:235)
	... 11 more
) happened at remote server.
```
If one resets the security-username and security-password back to the origin "root"
and "root-password" the application should work again as it did initially.

## Clean Up the Local Development Environment

- When finished with running the example, use a control-C in the shell running `node` to stop running the application.

- When finished with running the example, use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/authenticate`:

    ```bash
    $ cd scripts
    $ ./shutdownGemFire.sh
    ```

- Use a script to remove the directories and files containing
GemFire logs created for the cluster.
With a current working directory of `node-examples/authenticate`:

    ```bash
    $ cd scripts
    $ ./clearGemFireData.sh
    ```
