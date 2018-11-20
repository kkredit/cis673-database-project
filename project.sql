SPOOL project.out
WHENEVER SQLERROR EXIT FAILURE
SET ECHO ON
--
/*
CIS 673 - Database Design Project
Team 4:
- Akshay Kumar Khandgonda
- Kevin Kredit
- Vineet James
- Sanil Apte
- Brian Mbeere
*/
--
-- --------------------------------------------------------------------
-- CLEAN UP LAST RUN
-- --------------------------------------------------------------------
SET ECHO OFF
@_drop
SET ECHO ON
--
--
-- --------------------------------------------------------------------
-- CREATE THE TABLES
-- --------------------------------------------------------------------
CREATE TABLE App_User (
userName    VARCHAR(64) PRIMARY KEY,
fullName    VARCHAR(64) NOT NULL,
phone       INTEGER,
email       VARCHAR(64),
userType    VARCHAR(64),
CONSTRAINT App_User_1A_2     CHECK (userType IN ('Customer', 'Provider')),
CONSTRAINT App_User_2A_1     CHECK (NOT (phone is NULL AND email is NULL))
);
--
CREATE TABLE Customer (
cUserName   VARCHAR(64) PRIMARY KEY,
custAddr    VARCHAR(64) NOT NULL,
cType       VARCHAR(64) NOT NULL,
custBio     VARCHAR(64),
CONSTRAINT Customer_FK1     FOREIGN KEY(cUserName) REFERENCES App_User(userName),
CONSTRAINT Customer_1A_2    CHECK(cType IN('Professional', 'Personal'))
);
--
CREATE TABLE Provider (
pUserName   VARCHAR(64) PRIMARY KEY
);
--
CREATE TABLE Service_Order (
orderNo         INT PRIMARY KEY,
ocUserName      VARCHAR(64),
desiredPrice    INT,
orderDesc       VARCHAR(64) NOT NULL,
orderLoc        VARCHAR(64) NOT NULL,
datePosted      DATE,
bidcloseTime    DATE,
CONSTRAINT Service_Order_FK_1  FOREIGN KEY(ocUserName) REFERENCES Customer(cUserName)
);
--
CREATE TABLE Provider_Branch (
pUserName       VARCHAR(64),
branchAddress   VARCHAR(64),
CONSTRAINT P_Branch_Key     PRIMARY KEY(pUserName, branchAddress),
CONSTRAINT P_Branch_FK_1    FOREIGN KEY(pUserName) REFERENCES Provider(pUserName)
);
--
CREATE TABLE Service_Order_Photos (
orderNo     INT,
photo       VARCHAR(64),
CONSTRAINT Service_Order_Photos_Key      PRIMARY KEY(orderNo, photo),
CONSTRAINT Service_Order_Photos_FK_1     FOREIGN KEY(orderNo) REFERENCES Service_Order(orderNo)
-- Service_Order_Photos_2R_1: An Service_Order limits maximum of 5 photo uploads.
--<<CONSTRAINT Service_Order_Photos_2R_1 DOUBT>>
);
--
CREATE TABLE Task (
taskName    VARCHAR(64) PRIMARY KEY,
taskDesc    VARCHAR(256) NOT NULL
);
--
CREATE TABLE Provider_Specialized_Task (
pUserName   VARCHAR(64),
taskName    VARCHAR(64),
CONSTRAINT P_Specialized_TaskKey    PRIMARY KEY(pUserName, taskName),
CONSTRAINT P_Specialized_TaskFK_1   FOREIGN KEY(pUserName) REFERENCES Provider(pUserName),
CONSTRAINT P_Specialized_TaskFK_2   FOREIGN KEY(taskName) REFERENCES Task(taskName)
);
--
CREATE TABLE Reviews (
cUserName   VARCHAR(64),
pUserName   VARCHAR(64),
revDate     VARCHAR(64) NOT NULL,
revRating   INT NOT NULL,
revDesc     VARCHAR(256),
CONSTRAINT Reviews_Key      PRIMARY KEY(cUserName, pUserName),
CONSTRAINT Reviews_1A_2     CHECK( NOT(revRating < 0 OR revRating > 5) ),
CONSTRAINT Reviews_FK_1     FOREIGN KEY(cUserName) REFERENCES Customer(cUserName),
CONSTRAINT Reviews_FK_2     FOREIGN KEY(pUserName) REFERENCES Provider(pUserName)
);
--
CREATE TABLE Task_In_Service_Order (
orderNo     INT,
taskName    VARCHAR(64),
CONSTRAINT TaskService_OrderKey      PRIMARY KEY(orderNo, taskName),
CONSTRAINT TaskService_Order_FK_1    FOREIGN KEY(orderNo) REFERENCES Service_Order(orderNo),
CONSTRAINT TaskService_Order_FK_2    FOREIGN KEY(taskName) REFERENCES Task(taskName)
);
--
--
-- --------------------------------------------------------------------
-- POPULATE THE TABLES
-- --------------------------------------------------------------------
SET FEEDBACK OFF
-- < The INSERT statements that populate the tables >
-- Important: Keep the number of rows in each table small enough so that the results of your
-- queries can be verified by hand. See the Sailors database as an example.
--
SET FEEDBACK ON
COMMIT;
--
--
-- --------------------------------------------------------------------
-- PRINT OUT DATABASE
-- --------------------------------------------------------------------
SELECT * FROM App_User;
SELECT * FROM Customer;
SELECT * FROM Provider;
SELECT * FROM Provider_Branch;
SELECT * FROM Service_Order;
SELECT * FROM Service_Order_Photos;
SELECT * FROM Task;
SELECT * FROM Provider_Specialized_Task;
SELECT * FROM Task_In_Service_Order;
SELECT * FROM Reviews;
--
--
-- --------------------------------------------------------------------
-- EXECUTE QUERIES
-- --------------------------------------------------------------------
-- < The SQL queries >
-- Include the following for each query:
--   1. A comment line stating the query number and the feature(s) it demonstrates
--      (e.g. -- Q25: correlated subquery ).
--   2. A comment line stating the query in English.
--   3. The SQL code for the query.
--
--
-- --------------------------------------------------------------------
-- TEST INTEGRITY CONSTRAINTS
-- --------------------------------------------------------------------
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
