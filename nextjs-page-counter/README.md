# Page Counting Node.js Client App

This example demonstrates use of the Node.js client with a simple Next.js web app. 

The rendered site displays a count of page renderings,
backed either by a local Pivotal GemFire cluster or
by a Pivotal Cloud Cache service instance.

## Prerequisites

1. [npm](https://www.npmjs.com/get-npm)
1. [Node.js v10.0+](https://nodejs.org/)
1. Download the [Node.js Client](https://network.pivotal.io/products/pivotal-gemfire/) from Pivnet
1. Download and install [Pivotal GemFire v9.8](https://network.pivotal.io/products/pivotal-gemfire/) from Pivnet
1. Pivotal Cloud Cache v1.8
1. [Cloud Foundry Command Line Interface](https://docs.cloudfoundry.org/cf-cli/)

## Run the Example Locally

1. Start a GemFire cluster with a single locator and a single server:

    ```
    $ gfsh
    gfsh>start locator
    gfsh>start server
    gfsh>create region --name=exampleRegion --type=REPLICATE_PERSISTENT
    ```

1. Install and run via npm: 

    ```
    $ npm install ~/Downloads/gemfire-nodejs-client-2.0.0-beta.tgz 
    $ npm update
    $ npm run dev
    ```

1. View the page served at http://localhost:3000 in a browser.
Next.js renders the page in the web server before sending it to the browser. 
See [Next.js Server-Side Rendering](https://nextjs.org/features/server-side-rendering) for more information on the rendering.

    - The initial page displays an empty count, `Count: `
    - Clicking on `Re-render in browser` displays `Count: N/A`. An express api could be created to support user-side requests.
    - Clicking on `Re-render on server` displays `Count: 1`. This is the updated count that is stored in the GemFire cluster.

1. When finished with running the example locally, tear down the
GemFire cluster with

    ```
    gfsh>shutdown --include-locators=true
    ```

## Run the Example with Pivotal Cloud Cache

1. After using the cf CLI to log in and target your org and space,
create a Pivotal Cloud Cache service instance
that disables TLS encryption,
replacing `INSTANCE-NAME` with your service instance's name.
Complete directions are available at [Create or Delete a Service Instance](https://docs.pivotal.io/p-cloud-cache/create-instance.html).

    ```
    $ cf create-service p-cloudcache dev-plan INSTANCE-NAME  -c '{"tls": false}'
    ```

1. Modify the `manifest.yml` file by replacing `INSTANCE-NAME` with you service instance's name.
1. If not using the dev plan, use gfsh to create a region named `example_partition_region`. A dev plan will include the region by default. If the region does not exist, follow the directions at [access the service instance](https://docs.pivotal.io/p-cloud-cache/accessing-instance.html) and [create the region](https://docs.pivotal.io/p-cloud-cache/using-pcc.html#create-regions).
        
1. Build and push the app to the PAS environment.
Skip the `npm install` and `npm update` if you have already
done this to run the example locally.

    ```
    $ npm install ~/Downloads/gemfire-nodejs-client-2.0.0-beta.tgz
    $ npm update
    $ npm run build
    $ cf push
    ```
1. View the page served at the route returned from the `cf push` command.

