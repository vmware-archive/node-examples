# The Cache-Aside Example

This Node.js example is designed to demonstrate the performance improvement of adding Apache Geode as a side cache to a MySQL databaseup when looking up books.
REST endpoints allow an app user to look up books by ISBN or put new books into the cache and back-end MySQL database.

To remove network variability, this app will be run on your local machine using a local Apache Geode and a local MySQL server.

This app has been tested with Tanzu GemFire for VMs version 1.13.

## Prerequisites

- **Node.js**, minimum version of 10.16.3

- **npm**, the Node.js package manager

- **MySQL Server**, minimum version 8.0.15.  See [MySQL Installation Guide](https://dev.mysql.com/doc/mysql-installation-excerpt/5.7/en/).

- **This examples source code repository**.  Acquire the repository:

    ```
    $ git clone git@github.com:gemfire/node-examples.git
    ```

- **Node.js client library**. Acquire the Node.js client library (NodeJS-Client-2.0.1) from Tanzu Network at [VMware Tanzu GemFire for VMs](https://network.pivotal.io/products/tanzu-gemfire-for-vms/).
The file is a compressed tar archive (suffix `.tgz`), and the file name contains the client library version number.
For example:
`gemfire-nodejs-client-2.0.1.tgz`.


- **Tanzu GemFire**.
Acquire Tanzu GemFire from Tanzu Network at [Tanzu GemFire](https://network.pivotal.io/products/pivotal-gemfire/). Be sure to install GemFire's prerequisite Java JDK 1.8.X, which is needed to support gfsh, the command line interface.
Choose your GemFire version based on the version of Tanzu GemFire for VMs in your TAS environment.
See the [Product Snapshot](https://docs.pivotal.io/p-cloud-cache/product-snapshot.html) for your Tanzu GemFire for VMs version.

- **Configure environment variables**.
Set `GEODE_HOME` to the GemFire installation directory and add `$GEODE_HOME/bin` to your `PATH`. For example

    On Mac and Linux:

    ```bash
    export GEODE_HOME=/Users/MyGemFire
    export PATH=$GEODE_HOME/bin:$PATH
    ```

    On Windows (standard command prompt):

    ```cmd
    set GEODE_HOME=c:\Users\MyGemFire
    set PATH=%GEODE_HOME%\bin;%PATH%
    ```

## Create MySQL database and load data

Once MySQL is installed and running on your local machine, login to the MySQL server and source the small-bookstore.sql script to setup the table of books:

	mysql -u <user> -p <password>
	mysql> source small-bookstore.sql;
	
Verify the table was successfully loaded.

	mysql> SELECT * from books;
		
## Install the Node.js Client Modules

With a current working directory of `node-examples/cache-aside`,
install the Node.js client modules for both MySQL and GemFire:

```bash
$ npm install mysql
$ npm install gemfire-nodejs-client-2.0.0.tgz
$ npm update
```

## Running the Example

### Start a GemFire Cluster

There are scripts in the `cache-aside/scripts` directory.
The `startGemFire` script starts up two locators and two cache servers.
The locators allow clients to find the cache servers.
To simplify local development,
the script also creates the single region that the app uses.

With a current working directory of `node-examples/cache-aside`:

On Mac and Linux:

```bash
$ ./scripts/startGemFire.sh
```

On Windows (standard command prompt):

```
C:\node-examples\book-service>.\scripts\startGemFire.ps1
```

### Run the Example App

With a current working directory of `node-examples/cache-aside`, run the app:

On Mac and Linux:

```
$ node app.js
```

On Windows (standard command prompt):

```
C:\node-examples\cache-aside>node app.js
```

### Measure caching speed improvement - Look Up a Book

The first time you look up a book, it is not yet stored in the GemFire cache (a cache miss), so the app will look it up in MySQL database. The second time the same book is found in the cache, which will be much faster.

To look up a book, time the curl command,
specifying the ISBN as a key:

```
$ time curl -X GET \
  'http://localhost:8080/book/get?isbn=0345339681'
```

Now look up the same book again to see how GemFire improves the read performance:

```
$ time curl -X GET \
  'http://localhost:8080/book/get?isbn=0345339681'
```

### Clean Up the Local Development Environment

When finished running the example locally,  shut down the app and the cluster:

1. In the shell running `node`, type `control-C` to stop the example app.

1. Use a script to
tear down the GemFire cluster.
With a current working directory of `node-examples/book-service`:

 On Mac and Linux:

    ```bash
    $ ./scripts/shutdownGemFire.sh
    ```

 On Windows (standard command prompt):

  ```
  C:\node-examples\book-service>.\scripts\shutdownGemFire.ps1
  ```

1. Use a script to remove the directories and files containing
logs created for the cluster.
With a current working directory of `node-examples/book-service`:

    ```bash
    $ ./scripts/clearGemFireData.sh
    ```
