var gemfire = require('gemfire');

async function function_execution_example() {

    //configure and create client cache
    console.log('Configuring and creating a cache')
    cacheFactory = gemfire.createCacheFactory()
    cacheFactory.set("log-file","data/nodeClient.log")
    cacheFactory.set("log-level","config")
    cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
    cache = await cacheFactory.create()
    poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.addLocator('localhost', 10337)
    poolFactory.create('pool')

    //create region for data
    region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })

    // Put data in Region test on server
    console.log("Put data into server")
    await region.put('one', 1)
    await region.put('two', 2)
    console.log("Call server side function")
    //Execute function on server
    let data = await region.executeFunction('com.vmware.example.SumRegion')
    console.log("Sum of data on server: " + data )

    //done with cache, so close it
    cache.close()
    process.exit(0)
}

function_execution_example()
