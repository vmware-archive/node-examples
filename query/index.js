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
    await region.putAll({'one': {bar:1},'two': {bar:2},'three': {bar:3},'four':{bar:4},'five': {bar:5}})
    await region.putAll({'six': {bar:6},'seven': {bar:7},'eight': {bar:8},'nine': {bar:9},'ten': {bar:10}})

    console.log("Call server side query")
    //Execute query on server
    let data = await region.query("select * from /test a order by a.bar")
    console.log(" List of values returned by query: select * from /test ")
    var i,text
    text=""
    for(i=0; i<data.length-1;i++){
      text+= (data[i].bar + ",")
    }
    text+= (data[i].bar)
    console.log(" Values: "+text)

    //Execute query on server
    console.log("Call server side query")
    data = await region.query("select * from /test.keySet a order by a")
    console.log(" List of keys returned by query: select * from /test.keySet ")
    console.log(" Keys: " + data)

    //Execute query on server
    console.log("Call server side query")
    data = await region.query("select * from /test x where x.bar >5 order by x.bar")
    console.log(" List of values greater than five returned by query: select * from /test x where x.bar >5" )
    text=""
    for(i=0; i<data.length-1;i++){
      text+= (data[i].bar + ",")
    }
    text+= (data[i].bar)
    console.log(" Values greater than 5: "+text)

    //done with cache, so close it
    cache.close()
    process.exit(0)
}

function_execution_example()
