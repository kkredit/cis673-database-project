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
custBio     VARCHAR(256),
CONSTRAINT Customer_FK1     FOREIGN KEY(cUserName) REFERENCES App_User(userName),
CONSTRAINT Customer_1A_2    CHECK(cType IN('Professional', 'Personal'))
);
--
CREATE TABLE Provider (
pUserName   VARCHAR(64) PRIMARY KEY
);
--
CREATE TABLE Provider_Branch (
pUserName       VARCHAR(64),
branchAddress   VARCHAR(64),
CONSTRAINT P_Branch_Key     PRIMARY KEY(pUserName, branchAddress),
CONSTRAINT P_Branch_FK_1    FOREIGN KEY(pUserName) REFERENCES Provider(pUserName)
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
CREATE TABLE Task_In_Service_Order (
orderNo     INT,
taskName    VARCHAR(64),
CONSTRAINT TaskService_OrderKey      PRIMARY KEY(orderNo, taskName),
CONSTRAINT TaskService_Order_FK_1    FOREIGN KEY(orderNo) REFERENCES Service_Order(orderNo),
CONSTRAINT TaskService_Order_FK_2    FOREIGN KEY(taskName) REFERENCES Task(taskName)
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
--
-- --------------------------------------------------------------------
-- POPULATE THE TABLES
-- --------------------------------------------------------------------
SET FEEDBACK OFF
--
INSERT INTO App_User VALUES ('michaelb', 'Michael Benson', 6164254849, 'mbenson@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('dusty', 'Dustin Van Dyke', 6168893456, 'dustinvd89@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('SarahH', 'Sarah Han', 5355678409, 'hansarah@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('BathPros', 'Andrew Gorski', 6163439732, 'service@bathpros.com', 'Provider');
INSERT INTO App_User VALUES ('RWBnGreen', 'George Washington', 6167041776, 'sales@greenusa.com', 'Provider');
--
INSERT INTO Customer VALUES ('michaelb', '1234 Evans Way, Grand Rapids MI', 'Personal',
                             'My name is Mike. I like me house to be clean :)' );
INSERT INTO Customer VALUES ('dusty', '9898 Aurora Ave, Caledonia MI', 'Personal',
                             'I am allergic to dust, so have high standards.' );
INSERT INTO Customer VALUES ('SarahH', '7889 116th St, Grand Rapids MI', 'Professional',
                             'I manage Sunny Day Apartments on 116th St. Looking for good landscapers.' );
--
INSERT INTO Provider VALUES ('BathPros');
INSERT INTO Provider VALUES ('RWBnGreen');
--
INSERT INTO Provider_Branch VALUES ('BathPros', '3672 Division Ave, Grand Rapids MI');
INSERT INTO Provider_Branch VALUES ('BathPros', '9002 22nd St, Grandville MI');
INSERT INTO Provider_Branch VALUES ('RWBnGreen', '19 N Square, Grand Rapids MI');
--
INSERT INTO Task VALUES ('Dust', 'Clean dust from one or many rooms');
INSERT INTO Task VALUES ('Mow lawn', 'Cut grass or lawn to a specified length');
INSERT INTO Task VALUES ('Yard-general', 'Typical landscaping tasks; mowing, weeding, raking');
INSERT INTO Task VALUES ('Bathroom-general', 'Typical bathroom tasks; toilet, shower, floor, mirror');
--
INSERT INTO Provider_Specialized_Task VALUES ('BathPros', 'Bathroom-general');
INSERT INTO Provider_Specialized_Task VALUES ('RWBnGreen', 'Mow lawn');
INSERT INTO Provider_Specialized_Task VALUES ('RWBnGreen', 'Yard-general');
--
INSERT INTO Service_Order VALUES (1, 'michaelb', NULL, 'Clean my 2 bathrooms each Wednesday',
                                  '1234 Evans Way, Grand Rapids MI', '19-NOV-18', '05-DEC-18');
INSERT INTO Service_Order VALUES (2, 'dusty', 50, 'Dust my whole apartment every day',
                                  '9898 Aurora Ave, Caledonia MI', '19-NOV-18', NULL);
INSERT INTO Service_Order VALUES (3, 'SarahH', 500, 'Maintain the apartment grounds',
                                  '7889 116th St, Grand Rapids MI', '20-NOV-18', NULL);
--
INSERT INTO Task_In_Service_Order VALUES (1, 'Bathroom-general');
INSERT INTO Task_In_Service_Order VALUES (2, 'Dust');
INSERT INTO Task_In_Service_Order VALUES (3, 'Mow lawn');
INSERT INTO Task_In_Service_Order VALUES (3, 'Yard-general');
--
INSERT INTO Service_Order_Photos VALUES (2, '<photo of my apartment>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 1>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 2>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 3>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 4>');
--
INSERT INTO Reviews VALUES ('SarahH', 'RWBnGreen', '22-NOV-18', 4,
                            'Would rate them 5 stars, but they mowed an American flag pattern into the yard.');
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
SPOOL OFF
