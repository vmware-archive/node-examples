# Getting Started with Node.js Client
This is a getting started example for the GemFire / Pivotal Cloud Cache Node.js client.

It demonstrates use of the Node.js client with a simple Next.js web-app.

The site displays a simple page-counter backed either locally by GemFire or by Pivotal Cloud Cache service.

## Local Development

#### Prerequisites:
1. [Node.js v10.0+](https://nodejs.org/)
1. [GemFire Node.js Client](https://network.pivotal.io/products/pivotal-gemfire/)
1. GemFire 9.8+

#### Running This Example:
1. Start a GemFire locator and server:
     ```bash
      gfsh
      > start locator
      > start server
      > create region --name=exampleRegion --type=REPLICATE_PERSISTENT
   ```
1. Install and run via npm:
    ```bash
    npm install ~/Downloads/gemfire-nodejs-client-v2.0.0-beta.tgz
    npm update
    npm run dev
   ```
1. View the site, http://localhost:3000
    - Next.js renders the page on the web-server (see [Next.js Server-Side Rendering](https://nextjs.org/features/server-side-rendering)) before sending it to the browser.
        - The initial page displays an empty count, `Count: `
        - Clicking `Re-render in browser` displays `Count: N/A`. An express api could be created to support user-side requests.
        - Clicking `Re-render on server` displays `Count: 1`. This is the updated count stored in GemFire.

## Using Pivotal Cloud Cache

#### Prerequisites:
1. [CloudFoundry Command Line Interface](https://docs.cloudfoundry.org/cf-cli/)
1. [npm](https://www.npmjs.com/get-npm)
1. [GemFire Node.js Client](https://network.pivotal.io/products/pivotal-gemfire/)
1. Pivotal Cloud Cache 1.8.1
    1. [Create a Pivotal Cloud Cache service](https://docs.pivotal.io/p-cloud-cache/1-4/create-instance.html)
          1. Name the service `mypcc` or modify `manifest.yml` with the appropriate service name
          1. You may need to create a region named `example_partition_region`. Dev plans, if available, will include the region by default. If it does not exist, [access the service instance](https://docs.pivotal.io/p-cloud-cache/accessing-instance.html) and [create the region](https://docs.pivotal.io/p-cloud-cache/using-pcc.html#create-regions).

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

1. When done running the app, tear down the app and the Cloud Cache service instance:

    1. Stop the running app:

        ```
        $ cf stop nextjs-page-counter
        ```

    1. Delete the app and its route:

        ```
        $ cf delete nextjs-page-counter -r -f
        ```

    1. If the Cloud Cache service instance is no longer needed,
    delete it,
    replacing `INSTANCE-NAME` with your service instance's name:

        ```
        $ cf delete-service INSTANCE-NAME
        ```

##### Example Site
![Pivotal Cloud Cache + Next.js Example Site](/screenshot.png)
