var gemfire = require('gemfire');

async function putAll_example() {

    //configure and create client cache
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

    // Do region operations

    // putAll operation: putAll multiple values into cache
    console.log('PutAll operation:')
    await region.putAll({'foo': 'bar','boo':'candy','spam':'musubi'})

    // Confirm putAll operation: get values from cache
    console.log('Validate putAll operation:')
    console.log('  Getting value with key \'foo\'. Expected value: \'bar\'')
    var result = await region.get('foo')
    console.log('  Value retrieved is: \'' + result + '\'')
    console.log('  Getting value with key \'boo\'. Expected value: \'candy\'')
    result = await region.get('boo')
    console.log('  Value retrieved is: \'' + result + '\'')
    console.log('  Getting value with key \'spam\'. Expected value: \'musubi\'')
    result = await region.get('spam')
    console.log('  Value retrieved is: \'' + result + '\'')

    //Update mutiple keys with new values
    await region.putAll({'foo': 'bungie','boo':'tophat','spam':'sushi'})

    //Confirm via getAll operation:
    console.log('Validate putAll operation with getAll:')
    let getresult = await region.getAll(['foo','boo','spam'])
    console.log('  Value retrieved is: \'' + getresult.foo + '\'')
    console.log('  Value retrieved is: \'' + getresult.boo + '\'')
    console.log('  Value retrieved is: \'' + getresult.spam + '\'')

    console.log('PutAll and GetALL')
    await region.putAll({'foo': {'bar':10},'boo':'candy','spam':'musubi'})
    result = await region.get('foo')
    console.log('  Value retrieved is: \'' + result.foo + '\'')
    getresult = await region.getAll(['foo','boo','spam'])
    console.log('  Value retrieved is: \'' + getresult.foo + '\'')
    console.log('  Value retrieved is: \'' + getresult.boo + '\'')
    console.log('  Value retrieved is: \'' + getresult.spam + '\'')
    // Update operation: put value into cache
    // console.log('Update operation:')
    // console.log('  Updating key \'foo\' with value \'candy\'')
    // await region.put('foo', 'candy')
    // console.log('  Getting value with key \'foo\'. Expected value: \'candy\'')
    // result = await region.get('foo')
    // console.log('  Value retrieved is: \'' + result + '\'')
    //
    // // Delete operation: delete value from cache
    // console.log('Delete operation:')
    // console.log('  Removing key \'foo\' from region \'test\'')
    // await region.remove('foo')
    // console.log('  Getting value with key \'foo\'. Expected value: null')
    // result = await region.get('foo')
    // console.log('  Value retrieved is: \'' + result + '\'')

    //done with cache, so close it
    cache.close()

    //exit nodejs
    console.log('To exit: CTRL-C')
}

putAll_example()
