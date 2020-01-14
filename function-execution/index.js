var gemfire = require('gemfire');

async function function_execution_example() {

    //configure and create client cache
    console.log('Creating a cache factory')
    cacheFactory = gemfire.createCacheFactory()
    cacheFactory.set("log-file","data/nodeClient.log")
    cacheFactory.set("log-level","config")
    cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
    console.log('Creating a cache')
    cache = await cacheFactory.create()
    console.log('Creating a pool factory')
    poolFactory = await cache.getPoolManager().createFactory()
    console.log('Configuring the pool factory to find a locator at localhost:10337')
    poolFactory.addLocator('localhost', 10337)
    console.log('Creating a pool')
    poolFactory.create('pool')

    //create region for data
    console.log('Creating a region called \'test\' of type \'PROXY\' connected to the pool named \'pool\'')
    region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })

    // Do region operations
    await region.put('one', 1)
    await region.put('two', 2)
    let data = await region.executeFunction('com.vmware.example.SumRegion')
    console.log("Sum of data: "+data)
    //done with cache, so close it
    cache.close()

    process.exit(0)
}

function_execution_example()
