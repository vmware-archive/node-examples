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

    // Do region operations

    // Create operation: put value into cache
    console.log('Create operation:')
    console.log('  Putting key \'foo\' with value \'bar\'')
    await region.put('foo', 'bar')

    // Read operation: get value from cache
    console.log('Read operation:')
    console.log('  Getting value with key \'foo\'. Expected value: \'bar\'')
    var result = await region.get('foo')
    console.log('  Value retrieved is: \'' + result + '\'')

    // Update operation: put value into cache
    console.log('Update operation:')
    console.log('  Updating key \'foo\' with value \'candy\'')
    await region.put('foo', 'candy')
    console.log('  Getting value with key \'foo\'. Expected value: \'candy\'')
    result = await region.get('foo')
    console.log('  Value retrieved is: \'' + result + '\'')

    // Delete operation: delete value from cache
    console.log('Delete operation:')
    console.log('  Removing key \'foo\' from region \'test\'')
    await region.remove('foo')
    console.log('  Getting value with key \'foo\'. Expected value: null')
    result = await region.get('foo')
    console.log('  Value retrieved is: \'' + result + '\'')

    //done with cache, so close it
    cache.close()

    //exit nodejs
    console.log('To exit: CTRL-C')
}

put_get_remove_example()
