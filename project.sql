SPOOL project.out
SET ECHO ON
--
/*
CIS 673 - Database Design Project
Team 4:
- Akshay Kumar Khandgonda
- Kevin Kredit
- Vineet James
- Sanil Apte
-Brian Mbeere
*/
--
--
-- < The SQL/DDL code that creates your schema >

CREATE TABLE  Customer (
cuserName   varchar(255) NOT NULL,
custAddr     varchar(255)  NOT NULL, 
cType          varchar(100)  NOT NULL,
custBio        varchar(255),
IC    Customer_Key       PRIMARY KEY (cuserName) ,
IC    Customer_FK1      cuserName    FOREIGN KEY   REFERENCES User(userName),
IC    Customer_1A_2        CHECK (cType= Professional or Personal)

)

CREATE TABLE  Order(
ocUserName         varchar(255),
orderNo               int,
desiredPrice        int,
orderDesc           varchar(255) NOT NULL,
orderLoc             varchar (255) NOT NULL,
datePosted         datetime,
bidcloseTime      datetime,
    
IC  Order_FK_1   ocuserName FOREIGN KEY REFERENCES Customer(cuserName)

)
-- In the DDL, every IC must have a unique name; e.g. IC5, IC10, IC15, etc.
--
--
SET FEEDBACK OFF
--
--
-- < The INSERT statements that populate the tables >
-- Important: Keep the number of rows in each table small enough so that the results of your
-- queries can be verified by hand. See the Sailors database as an example.
--
--
SET FEEDBACK ON
COMMIT;
--
--
-- < One query (per table) of the form: SELECT * FROM table; in order to print out your database >
--
--
-- < The SQL queries >
-- Include the following for each query:
--   1. A comment line stating the query number and the feature(s) it demonstrates
--      (e.g. -- Q25 – correlated subquery ).
--   2. A comment line stating the query in English.
--   3. The SQL code for the query.
--
--
-- < The insert/delete/update statements to test the enforcement of ICs >
-- Include the following items for every IC that you test (Important: see the next section titled
-- "Submit your proposal" regarding which ICs to test).
--   1. A comment line stating: Testing: < IC name >
--   2. A SQL 'INSERT', 'DELETE', or 'UPDATE' that will test the IC
--
--
COMMIT;
--
SPOOL OFF
