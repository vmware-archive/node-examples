# Getting Started with Node.js Client
This is a getting started example for the GemFire / Pivotal Cloud Cache Node.js client.

It demonstrates use of the Node.js client with a simple Next.js web-app. 

The site displays a simple page-counter backed either locally by GemFire or by Pivotal Cloud Cache service.

## Prerequisites

1. [npm](https://www.npmjs.com/get-npm)
1. [Node.js v10.0+](https://nodejs.org/)
1. Download the [Node.js Client](https://network.pivotal.io/products/pivotal-gemfire/) from Pivnet
1. Download [Pivotal GemFire v9.8](https://network.pivotal.io/products/pivotal-gemfire/) from Pivnet
1. [Cloud Foundry Command Line Interface](https://docs.cloudfoundry.org/cf-cli/)
1. Pivotal Cloud Cache v1.8

## Run the Example Locally

1. Start a GemFire locator and server:

    ```bash
    $ gfsh
    gfsh>start locator
    gfsh>start server
    gfsh>create region --name=exampleRegion --type=REPLICATE_PERSISTENT
    ```

1. Install and run via npm: 

    ```bash
    $ npm install ~/Downloads/gemfire-nodejs-client-2.0.0-beta.tgz 
    $ npm update
    $ npm run dev
    ```

1. View the page served at http://localhost:3000.
Next.js renders the page on the web-server (see [Next.js Server-Side Rendering](https://nextjs.org/features/server-side-rendering)) before sending it to the browser. 
    - The initial page displays an empty count, `Count: `
    - Clicking `Re-render in browser` displays `Count: N/A`. An express api could be created to support user-side requests.
    - Clicking `Re-render on server` displays `Count: 1`. This is the updated count stored in GemFire.


## Run the Example With Pivotal Cloud Cache

1. After using the cf CLI to log in and target your org and space, create a Pivotal Cloud Cache service instance following the directions at [Create or Delete a Service Instance](https://docs.pivotal.io/p-cloud-cache/create-instance.html) that disables TLS encryption:
```
$ cf create-service p-cloudcache dev-plan mypcc  -c '{"tls": false}'
```
    - Name the service `mypcc` or modify `manifest.yml` with the appropriate service name

    - If not using the dev plan, create a region named `example_partition_region`. A dev plan will include the region by default. If the region does not exist, follow the directions at [access the service instance](https://docs.pivotal.io/p-cloud-cache/accessing-instance.html) and [create the region](https://docs.pivotal.io/p-cloud-cache/using-pcc.html#create-regions).
        
1. Build and push! Skip the `npm install` and `npm update` if you've already
done this to run the example locally.

    ```bash
    $ npm install ~/Downloads/gemfire-nodejs-client-2.0.0-beta.tgz
    $ npm update
    $ npm run build
    $ cf push
    ```
1. View the page served at the route returned from the `cf push` command.

