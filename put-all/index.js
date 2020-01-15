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
    //fetch data with getAll
    let getresult = await region.getAll(['foo','boo','spam'])
    console.log('  Getting value with key \'foo\'. Expected value: \'bungie\'')
    console.log('  Value retrieved is: \'' + getresult.foo + '\'')
    console.log('  Getting value with key \'boo\'. Expected value: \'tophat\'')
    console.log('  Value retrieved is: \'' + getresult.boo + '\'')
    console.log('  Getting value with key \'spam\'. Expected value: \'sushi\'')
    console.log('  Value retrieved is: \'' + getresult.spam + '\'')

    console.log('Use putAll and getAll with JSON Objects')
    await region.putAll({'foo': {'bar':10},'boo':{'bar':'candy'},'spam':{'bar':'musubi'}})
    //get object associated with key foo
    console.log("Do a regular get operation.")
    result = await region.get('foo')
    console.log('  Object retrieved is:\'' + result + '\'')
    console.log('  Value retrieved is: \'' + result.bar + '\'')
    //retrieve group of objects based on keys with GetAll
    console.log("Do a regular getAll operation.")
    getresult = await region.getAll(['foo','boo','spam'])
    console.log('  Getting object with key \'foo\'. Expected value: \'[object Object]\'')
    console.log('  Object retrieved is:\'' + getresult.foo + '\'')
    //print values of objects fetch via getAll
    console.log('  Getting value with key \'foo\'. Expected value of bar: \'10\'')
    console.log('  Value retrieved is: \'' + getresult.foo.bar + '\'')
    console.log('  Getting value with key \'boo\'. Expected value of bar: \'candy\'')
    console.log('  Value retrieved is: \'' + getresult.boo.bar + '\'')
    console.log('  Getting value with key \'spam\'. Expected value of bar: \'musubi\'')
    console.log('  Value retrieved is: \'' + getresult.spam.bar + '\'')

    //done with cache, so close it
    cache.close()

    //exit nodejs
    process.exit(0)
}

putAll_example()
