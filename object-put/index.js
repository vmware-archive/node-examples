// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
var gemfire = require('gemfire');

async function object_put_example() {

    //configure and create client cache
    cacheFactory = gemfire.createCacheFactory()
    cacheFactory.set("log-file","data/nodeClient.log")
    cacheFactory.set("log-level","config")
    cacheFactory.set("statistic-archive-file","data/clientStatArchive.gfs")
    cache = await cacheFactory.create()
    poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.addLocator('localhost', 10337)
    poolFactory.create('pool')

    //create two regions for data
    region = await cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
    otherRegion = await cache.createRegion("othertest", { type: 'CACHING_PROXY', poolName: 'pool' })

    //rarely used api for listing regions defined in cache
    //used in example to print out region names and attributes
    await cache.rootRegions().forEach( async function(region){
      attributes=await region.attributes()
      console.log('************************** Defined region: '+region.name()+' **************************')
      console.log(' Region attributes: ', attributes)
    })

    //Configure objects
    var key={funk:'foo', doom:'gloom', cloud:'rain'}
    var value={foo:'bar'}

    //put key object 'key' and value object 'value' into cache
    await region.put(key,value)
    //get value object with object key 'key'
    var result = await region.get(key)
    console.log('************ Put key into region test ********************')
    console.log('Get value with key: ',key)
    console.log("Value from Region test: ",result)

    //put a value in a different region using the key 'key'
    //data put in each region is independent of the other region
    value.foo='bbq'
    await otherRegion.put(key, value)
    otherResult = await otherRegion.get(key)
    result = await region.get(key)
    console.log('************** Put key in two different regions ******************')
    console.log('Get value from each region with key: ',key)
    console.log("Value from Region othertest: ",otherResult)
    console.log("Value from Region test: ",result)

    //order of fields in key object has no impact
    key={cloud:'rain', funk:'foo', doom:'gloom'}
    result = await region.get(key)
    console.log('************** Do get with key with different field order ******************')
    console.log('Get value from each region with key: ',key)
    console.log('Value from region test: ',result)

    //create a new key and do a put
    await region.put({doom:'gloom',funk:'foo',cloud:'snow'}, {bar:'candy'})
    //fetch value with key
    result = await region.get({funk:'foo', doom:'gloom',cloud:'snow'})
    console.log('*************** Insert new key into test *****************')
    console.log('Get value from each region with key: ',{funk:'foo', doom:'gloom',cloud:'snow'})
    console.log('Value from region test: ',result)

    //fetch key that doesn't exist in region
    result = await region.get({doom:'gloom',funk:'foo',cloud:'sunny'})
    console.log('************* Null value returned for non-existent data *******************')
    console.log('Not existent data fetch with key:',{doom:'gloom',funk:'foo',cloud:'sunny'})
    console.log('Value from region test: ',result)

    //create a new key with a number and do a put
    var numberkey = 0
    await region.put(numberkey, {bar:'mars'})
    //fetch value with key
    result = await region.get(numberkey)
    console.log('*************** Insert new key into test *****************')
    console.log('Get value from each region with key: ',numberkey)
    console.log('Value from region test: ',result)

    //create a new key with a number and do a put
    var stringkey = 'mykey'
    await region.put(stringkey, {bar:'hershey'})
    //fetch value with key
    result = await region.get(stringkey)
    console.log('*************** Insert new key into test *****************')
    console.log('Get value from each region with key: ',stringkey)
    console.log('Value from region test: ',result)

    //done with cache, so close it
    cache.close()
    process.exit(0)
}

object_put_example()
