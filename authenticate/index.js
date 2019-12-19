var gemfire = require('gemfire');

async function authenticate_example() {

    //configure and create client cache
    console.log('Creating a cache factory')
    cacheFactory = gemfire.createCacheFactory()
    cacheFactory.set("log-file","data/nodeClient.log")
    cacheFactory.set("log-level","config")
    cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
    //Configure a username and password for Authentication
    console.log('Set Authentication')
    cacheFactory.setAuthentication((properties, server) => {
      properties['security-username'] = 'root'
      properties['security-password'] = 'root-password'
    }, () => {
    })
    console.log('Create Cache')
    cache = await cacheFactory.create()

    console.log('Create Pool')
    poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.addLocator('localhost', 10337)
    poolFactory.create('pool')

    console.log('Create Region')
    region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })

    //if the security-user and security-password are wrong
    //the following operations will fail to complete
    try {
      console.log("Do put and get CRUD operations")
      await region.put('foo', 'bar')
      var result = await region.get('foo')
      await region.put('foo', 'candy')
      result = await region.get('foo')
      await region.remove('foo')
      result = await region.get('foo')
    }
    catch (error){
      console.error(error)
    }

    //done with cache then close it
    cache.close()
    //exit nodejs
    console.log('Finished')
    console.log('To exit: CTRL-C')
}

authenticate_example()
