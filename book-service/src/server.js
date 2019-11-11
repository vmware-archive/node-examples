var gemfire = require('gemfire');
const {JSONPath} = require('jsonpath-plus');
var express = require('express');
var app = express();
var region = null;

app.use(express.json())

const vcap = JSON.parse(process.env.VCAP_SERVICES)

// The queries for PCF to grab connection details
const jsonPathLocators = "$.p-cloudcache[0].credentials.locators";
const jsonPathPassword = "$.p-cloudcache[0].credentials.users[?(@.roles == 'developer')].password";
const jsonPathUsername = "$.p-cloudcache[0].credentials.users[?(@.roles == 'developer')].username";

async function init(){
    var username = JSONPath({path: jsonPathUsername, json: vcap});
    var password = JSONPath({path: jsonPathPassword, json: vcap});
    var locators = JSONPath({path: jsonPathLocators, json: vcap})[0];

    console.log("username - >" + username + "< password - >" + password + "<")
    console.log("locators - " + locators)

    cacheFactory = gemfire.createCacheFactory("", "workaround.xml");
    cacheFactory.setAuthentication((properties, server) => {
        console.log("Set auth called!")
        console.log("username - >" + username + "< password - >" + password + "<")
        properties['security-username'] = username
        properties['security-password'] = password
    }, () => {
        console.log("Set auth done called!")
    })

    var cache = await cacheFactory.create();

    var poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.setPRSingleHopEnabled(false);
    for (i = 0; i < locators.length; i++) {
        console.log(locators[i])
        var serverPort = locators[i].split(/[[\]]/);
        console.log("server " + serverPort[1] + " port - " + serverPort[1])
       poolFactory.addLocator(serverPort[0], parseInt(serverPort[1]));
    }
    poolFactory.create("pool")

    region = cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
}

app.get("/book/get", async (req, res) => {
    var result = await region.get(req.query.isbn);
    res.json(result);
});

app.put(['/book/put'], async (req, res) => {

    console.log("isbn = " + req.query.isbn);
    console.log("body " + JSON.stringify(req.body));
    await region.put(req.query.isbn, req.body)
    res.json({
        initialized: true
    });
});
app.put(['/book/removeall'], async (req, res) => {

    var keys = await region.keys();
    await region.removeAll(keys)
    res.json({
        initialized: true
    });
});
app.get('/env', (req, res) => {
    res.json(process.env);
});

app.set("port", process.env.PORT || 8080);

init();

app.listen(app.get("port"), () => {
    console.log(`Hello from NodeFire test app.`);
});
