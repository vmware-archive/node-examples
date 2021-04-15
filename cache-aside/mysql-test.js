const mysql = require('mysql');

// Establish connection to MySQL
const con = mysql.createConnection({
	host: 'localhost',
	user: 'diane',
  	password: 'easypass',
  	database: 'bookstore'
});
con.connect((err) => {
	if (err) {
		console.log('Error connecting to MySQL');
		return;
	}
  	console.log('Connected to MySQL!');
});

con.query('select * from books where isbn = ?', ['0345339681'], (err,result) => {
   if(err) throw err;

   console.log('Data received from Db:');
   console.log(result);
});

con.end((err) => {
	//Terminate connection to MySQL gracefully
	console.log('Terminating MySQL connection');
});

