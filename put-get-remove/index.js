var gemfire = require('gemfire');

async function put_get_remove_example() {
    console.log('Creating a cache factory')
    const cacheFactory = gemfire.createCacheFactory()
    console.log('Creating a cache')
    const cache = await cacheFactory.create()
    console.log('Creating a pool factory')
    const poolFactory = await cache.getPoolManager().createFactory()

    console.log('Configuring the pool factory to find a locator at localhost:10337')
    poolFactory.addLocator('localhost', 10337)
    console.log('Creating a pool')
    poolFactory.create("pool")

    console.log('Creating a region called \'test\' of type \'PROXY\' connected to the pool named \'pool\'')
    const region = cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })

    console.log('Putting key \'foo\' into region \'test\' with the value \'bar\'')
    await region.put('foo', 'bar')
    console.log('Getting value from region \'test\' with key \'foo\'. The expected value is going to be: \'bar\'')
    var result = await region.get('foo')
    console.log('The value retrieved is: \'' + value + '\'')
    console.log('Removing key \'foo\' from region \'test\'')
    await region.remove('foo')
    console.log('Getting value from region \'test\' with key \'foo\'. The expected value is going to be: undefined')
    result = await region.get('foo')
    console.log('The value retrieved is: \'' + value + '\'')
}

put_get_remove_example()