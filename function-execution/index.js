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
