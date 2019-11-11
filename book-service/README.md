# The Book Service Example

This Node.js example provides a simple book service,
which uses REST endpoints to allow a user to look up books by ISBN
or put new books into the service.

This app may be run a local Apache Geode/Pivotal GemFire cluster,
or with a PCC service instance.
A common development path runs locally first to iterate quickly on feature
development prior to pushing the app to a PAS environment to run with
Pivotal Cloud Cache.

# Prerequisites

- Examples source code.  Acquire this repository:

```
$ git clone git@github.com:gemfire/node-examples.git
```

- Node.js client library. Acquire the Node.js client library from PivNet.
Find and download the Node.JS Client 2.0.0 Beta version, 
`gemfire-nodejs-client-2.0.0-beta.tgz`,
under [Pivotal GemFire](https://network.pivotal.io/products/pivotal-gemfire/).
or [Pivotal Cloud Cache](https://network.pivotal.io/products/p-cloudcache/).

- `npm`, minimum version of xx.x

# Build the App
 
With a current working directory of `node-examples/book-service`
```bash
$ npm install gemfire-nodejs-client-2.0.0-beta.tgz 
$ npm install
```


# Run the App Locally

The local environment mocks the services binding that would exist
for a PAS environment.
A PAS environment injects the services binding through a `VCAP_SERVICES`
environment varible.
This is the one that the app assumes:

```
export VCAP_SERVICES='{"p-cloudcache":[{"label":"p-cloudcache","provider":null,"plan":"dev-plan","name":"pcc-dev","tags":["gemfire","cloudcache","database","pivotal"],"instance_name":"pcc-dev","binding_name":null,"credentials":{"distributed_system_id":"0","gfsh_login_string":"connect --url=https://localhost:7070/gemfire/v1 --user=super-user --password=1234567 --skip-ssl-validation","locators":["localhost[10334]"],"urls":{"gfsh":"https://localhost:7070/gemfire/v1","pulse":"https://localhost:7070/pulse"},"users":[{"password":"1234567","roles":["cluster_operator"],"username":"super-user"},{"password":"1234567","roles":["developer"],"username":"app"}],"wan":{"sender_credentials":{"active":{"password":"no-password","username":"no-user"}}}},"syslog_drain_url":null,"volume_mounts":[]}]}'
```

Bash scripts in the `book-service/scripts` directory 

```bash
$ cd <project>/scripts
$ ./startGemFire.sh
```

## Run some servers 

The `startGemFire.sh` script starts up two locators and two cache servers.
The locators allow clients to find the cache servers.
To simplify local development, script also creates the single
region that the app uses.

## Run the NodeJS server 

```
$ node src/server.js
```

## Add a book locally 

```
curl -X PUT \
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
## Lookup a book locally

```
curl -X GET \
  'http://localhost:8080/book/get?isbn=0525565329' 
```

# Push the app

Edit the `manifest.yml` file to update the service instance
that the app will be bound to.
Prior to editing, the service instance is called `cloudcache-dev`.

Push the app:

```
$ cf push
```

## Create the Cloud Cache service instance

1 -  Create a cloud cache instance in Pivotal Cloud Foundry.   The manifest assumes that the cloud cache instance is called `cloudcache-dev`.
```
$ cf create-service p-cloudcache dev-plan cloudcache-dev
```
2 - Create the service key 
```
$ cf create-service-key cloudcache-dev cloudcache-dev_service_key
```
3 - Using the GemFire command line tool ``gfsh`` create the region with the policy that we want for the data.

```
voltron:gemfire cblack$ gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/  

Monitor and Manage Pivotal GemFire
gfsh>connect --use-http=true --url=https://somehost/gemfire/v1 --user=cluster_operator --password=*****

Successfully connected to: GemFire Manager HTTP service @ https://somehost/gemfire/v1
gfsh>create region --name=test --type=PARTITION
                     Member                      | Status
------------------------------------------------ | -----------------------------------------------------------------------------------
cacheserver-7541bb25-71b2-4ae7-ad80-9d518e18facd | Region "/test" created on "cacheserver-7541bb25-71b2-4ae7-ad80-9d518e18facd"

Cluster-0 gfsh>exit
```
Note: The version of Cloud Cache I am using is backed by GemFire version 9.8.3 - make sure you are using the same versions of GemFire as your cloud cache instance.

4 -`cf push` the application and give it a try using postman or curl.

## Add a book 
```
curl -X PUT \
  'https://cloudcache-node-sample.apps.pcfone.io/book/put?isbn=0525565329' \
  -H 'Content-Type: application/json' \
  -d '{
  "FullTitle": "The Shining",
  "ISBN": "0525565329",
  "MSRP": "9.99",
  "Publisher": "Anchor",
  "Authors": "Stephen King"
}'
```

## Get a book by ISBN

```
curl -X GET \
  'https://cloudcache-node-sample.apps.pcfone.io/book/get?isbn=0525565329' 
```
