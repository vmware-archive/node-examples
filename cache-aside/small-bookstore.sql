
-- CREATE DATABASE BOOKSTORE;

USE BOOKSTORE;


CREATE TABLE BOOKS(
        ISBN varchar(55) NOT NULL,
	Title varchar(55),
	Author varchar(55),
	Publisher varchar(55),
	Published_year varchar(55),
	MSRP varchar (55) NULL,
    Primary key (ISBN)
    )ENGINE = INNODB;

   
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345339681','The Hobbit','J.R.R Tolken',
    'Del Rey','1986','3.80');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345339703','The Lord of the Rings : Fellowship of the ring','J.R.R Tolken',
    'Del Rey','1986','3.79');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345339711','The Lord of the Rings : The two towers','J.R.R Tolken',
    'Del Rey','1986','3.79');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345339738','J.R.R Tolken','The Lord of the Rings : Return of the King',
    'Del Rey','1986','3.80');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0333247922','The Castle of Dark','Tanith Lee',
    'Macmillan','1978','13.54');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0099571404','The Winter Players','Tanith Lee',
    'Red Fox','1988','4.14');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345259602','Tarzan and the forbidden city','Edgar Rice Burroughs',
    'Ballantine Books','1977','3.70');
    
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0451531027','Tarzan of the Apes','Edgar Rice Burroughs',
    'Signet','2008','4.17');
   
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0440128595','The Gemini Contenders','Robert Ludlum',
    'Dell','1977','11.99');                     
   
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0385272537','Chancellor Manuscript','Robert Ludlum',
    'Doubleday','1977','10.99');
   
    INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0345335465','Dragonflight','Anne McCaffrey',
    'Del Rey','1986','16.95');    
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
   VALUES ('034538475X','The Tale of the Body Thief','Anne Rice',
   'Ballantine Books','1993','7.99');			
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('1948132117','The Prince and the Pauper','Mark Twain',
    'SeaWolf Press','2018','10.99'); 
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('1506717667','Alien: The Original Screenplay','Cris Seixas',
    'Dark Horse Books','2020','19.99');	
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0307588378','Gone Girl','Gillian Flynn',
    'Crown','2014','13.99');  
    
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('1501107976','All the Missing Girls','Megan Miranda',
    'Simon & Schuster','2017','18.40');  
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('1619636093','Empire of Storms','Sarah Mass',
    'Bloomsbury USA Childrens','2017','10.79'); 
    
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('9780062300546','Hillbilly Elegy','J.D Vance',
    'Harper','2016','11.15'); 
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('006220064X','The Fireman: A Novel','Joe Hill',
    'William Morrow Paperbacks','2017','16.99'); 
   
   INSERT INTO BOOKS (ISBN, Title, Author, Publisher, Published_year, MSRP) 
    VALUES ('0804178801','Night School','Lee Child',
    'Delacorte Press','2016','9.31'); 

