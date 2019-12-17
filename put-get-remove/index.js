var gemfire = require('gemfire');

async function put_get_remove_example() {

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

    //put, get and remove data from region
    //put value into cache
    console.log('Putting key \'foo\' into region \'test\' with the value \'bar\'')
    await region.put('foo', 'bar')
    console.log('Getting value from region \'test\' with key \'foo\'. The expected value is going to be: \'bar\'')

    //get value from cache
    var result = await region.get('foo')
    console.log('The value retrieved is: \'' + result + '\'')

    //delete value from cache
    console.log('Removing key \'foo\' from region \'test\'')
    await region.remove('foo')
    console.log('Getting value from region \'test\' with key \'foo\'. The expected value is going to be: null')
    result = await region.get('foo')
    console.log('The value retrieved is: \'' + result + '\'')

    //done with cache then close it
    cache.close()

    //exit nodejs
    console.log('To exit: CTRL-C')
}

put_get_remove_example()
