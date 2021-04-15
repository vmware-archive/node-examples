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
var gemfire = require('gemfire')
var express = require('express')
var app = express()
var region
var cache

app.use(express.json())

async function init(){

    cacheFactory = gemfire.createCacheFactory()
    cache = await cacheFactory.create()
    var poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.setPRSingleHopEnabled(false)
    poolFactory.addLocator('localhost', 10334)
    poolFactory.create("pool")

    region = cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
    console.log('Connected to GemFire!');
}

app.get("/book/get", async (req, res) => {
    var result = await region.get(req.query.isbn)
    res.json(result)
})

app.put(['/book/put'], async (req, res) => {

    console.log("isbn = " + req.query.isbn)
    console.log("body " + JSON.stringify(req.body))
    await region.put(req.query.isbn, req.body)
    res.json({
        initialized: true
    })
})

app.put(['/book/removeall'], async (req, res) => {

    var keys = await region.keys()
    await region.removeAll(keys)
    res.json({
        initialized: true
    })
})

app.get('/env', (req, res) => {
    res.json(process.env)
})

app.set("port", process.env.PORT || 8080)

init()

app.listen(app.get("port"), () => {
    console.log(`Hello from NodeFire test app.`)
})
