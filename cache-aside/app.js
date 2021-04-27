const mysql = require('mysql');
var gemfire = require('gemfire')
var express = require('express')
var app = express()
var region
var cache
var connection

app.use(express.json())

async function init(){

    // Establish connection to MySQL
	connection = mysql.createConnection({
  		host: 'localhost',
  		user: 'diane',
  		password: 'easypass',
  		database: 'bookstore'
	});
	connection.connect((err) => {
  		if (err){
     		console.log('Error connecting to Db');
     		throw err;
  		}
  	console.log('Connected to MySQL!');
	});

    // Establish connection to GemFire cluster
    cacheFactory = gemfire.createCacheFactory()
    cache = await cacheFactory.create()
    var poolFactory = await cache.getPoolManager().createFactory()
    poolFactory.setPRSingleHopEnabled(false)
    poolFactory.addLocator('localhost', 10334)
    poolFactory.create("pool")

	// Create region that connects to region on GemFire cluster
    region = cache.createRegion("test", { type: 'PROXY', poolName: 'pool' })
	console.log('Connected to GemFire!');
}

app.get("/book/get", async (req, res) => {
    var Isbn = req.query.isbn
    // Look up book in GemFire cache
   	var result = await region.get(Isbn)
	if(result) { 
		res.json(result)
	} else {
   		console.log('Cache miss');
		//If not in cache, get book from MySQL table
		//result = await connection.query('select * from books where ISBN = ?', [Isbn])

		await connection.query('select * from books where isbn = ?', [Isbn], (err,result) => {
   			if(err) throw err;

			// Convert row to JSON string
			result = JSON.stringify(result);
			console.log('Data received from Db:');
   			console.log(result);

			// Add book to GemFire cache
			region.put(Isbn, result)
   			console.log("Added to GemFire cache ISBN: " + Isbn);
			console.log("Body " + result);

			// Return the result
			res.json(result);
		});
    }
	// Send result
    //res.json(result)
})

app.set("port", process.env.PORT || 8080)

init()

app.listen(app.get("port"), () => {
    console.log(`Testing read performance between GemFire and MySQL`)
})

