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
--
-- < The SQL/DDL code that creates your schema >
--
CREATE TABLE  Customer (
cuserName   varchar(255) NOT NULL,
custAddr     varchar(255)  NOT NULL, 
cType          varchar(100)  NOT NULL,
custBio        varchar(255),
IC    Customer_Key       PRIMARY KEY (cuserName) ,
IC    Customer_FK1      cuserName    FOREIGN KEY   REFERENCES User(userName),
IC    Customer_1A_2        CHECK (cType IN("Professional","Personal")
)
--
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
-- CREATING THE TABLES
-- --------------------------------------------------------------------
CREATE TABLE  AppUser
(
userName     INTEGER,
fullName   VARCHAR2(20), 
phone  INTEGER,
email     VARCHAR2(30),
userType VARCHAR2(20),
--
-- AppUser_Key: UserNames are unique
CONSTRAINT AppUser_Key PRIMARY KEY (userName),
-- AppUser_1A_1: A user must provide their full names before being registered.
CONSTRAINT AppUser_1A_1 CHECK (fullName is not null),
-- AppUser_1A_2: A user's userType should be 'Customer' or 'Provider'.
CONSTRAINT AppUser_1A_2 CHECK (userType IN ('Customer', 'Provider')),
-- AppUser_2A_1: A user may at least have a phone or email (Both cannot be null).
CONSTRAINT AppUser_2A_1 CHECK (NOT (phone is NULL AND email is NULL))
);
--
-- -------------------------------------------------------------------
CREATE TABLE  Provider_Branch
(
pUserName         INTEGER,
branchAddress       VARCHAR2(30),
-- P_Branch_Key: Boat Ids are unique.
CONSTRAINT P_Branch_Key PRIMARY KEY (pUserName,branchAddress)
);
--
-- -------------------------------------------------------------------
CREATE TABLE  Order_Photos
(
orderNo     INTEGER,
photo       VARCHAR2(30),
-- Order_Photos_Key: A unique photo corresponding to an order is identified by its OrderNo and Photo.
CONSTRAINT Order_Photos_Key PRIMARY KEY (orderNo,photo),
-- Order_Photos_2R_1: An Order limits maximum of �5� photo uploads.
--<<CONSTRAINT Order_Photos_2R_1 DOUBT>>
);
--
-- -------------------------------------------------------------------

/*
--
--ADDING FOREIGN KEY CONSTRAINTS
--
Alter table Provider_Branch
-- P_Branch_FK_1: A Provider_Branch�s P_UserName refers to the pUserName in the Provider relation.
add CONSTRAINT P_Branch_FK_1 FOREIGN KEY (pUserName) REFERENCES Provider(pUserName);

Alter table Order_Photos
-- Order_Photos_FK_1: An Order_Photos�s OrderNo refers to the OrderNo in the Order relation.
add CONSTRAINT Order_Photos_FK_1 FOREIGN KEY (orderNo) REFERENCES Order(orderNo);
--
--
*/
--
-- -------------------------------------------------------------------
CREATE TABLE Provider_Specialized_Task
(
pUserName varchar2(50) not null,
taskName varchar2(50) not null,
-- P_Specialized_Task_Key: A specialized task corresponding to a Provider is identified by its P_UserName and TaskName
CONSTRAINT P_Specialized_TaskKey Primary Key (pUserName,taskName)
);
--
-- -------------------------------------------------------------------
CREATE TABLE Reviews
(
cUserName varchar2(50) not null,
pUserName varchar2(50) not null,
revDate varchar2(50),
rating integer,
desc varchar2(50),
-- Reviews_Key: A review is identified by its C_UserName and P_UserName.
CONSTRAINT Reviews_Key Primary Key (cUserName,pUserName),
-- Reviews_1A_1: A review's revDate may not be null
CONSTRAINT Reviews_1A_1 check (revDate is not null),
-- Reviews_1A_2: A review�s Rating is between 0 and 5 (inclusive)
CONSTRAINT Reviews_1A_2 check (not(rating<0 or rating>5))
);
--
-- -------------------------------------------------------------------
create Table Task_in_Order
(
orderNo varchar2(50),
taskName varchar2(50),
-- TaskOrder_Key: A task-order entry is identified by both its orderNum and TaskName An order can only have one task for every type of task. 
CONSTRAINT TaskOrderKey Primary Key (orderNo,taskName)
);
--
-- -------------------------------------------------------------------
/*
--
-- ADDING FOREIGN KEYS
--
ALTER Table Provider_Specialized_Task
-- P_Specialized_Task_FK_1: A Provider_Specialized_Task�s P_UserName refers to the P_UserName in the Provider relation.
ADD CONSTRAINT P_Specialized_TaskFK_1 Foreign Key (pUserName) References provider (pUserName),
-- P_Specialized_Task_FK_2: A Provider_Specialized_Task�s TaskName refers to the TaskName in the Task relation.
ADD CONSTRAINT P_Specialized_TaskFK_2 Foreign Key (taskName) References  task (taskName);

ALTER Table Reviews
-- Reviews_FK_1: A Reviews�s C_UserName refers to the  C_UserName in the Customer relation.
ADD CONSTRAINT Reviews_FK_1 Foreign Key (cUserName) References customer (cUserName),
-- Reviews_FK_2: A Reviews�s P_UserName refers to the  P_UserName in the Provider relation.
ADD CONSTRAINT Reviews_FK_2 Foreign Key (pUserName) References provider (pUserName);

ALTER Table Task_in_Order
-- TaskOrder_FK_1: A task-order�s orderNum refers to an orderNo in the Order relation.
ADD CONSTRAINT TaskOrder_FK_1 Foreign Key (orderNo) References order (orderNo),
-- TaskOrder_FK_2: A task-order�s TaskName refers to a TaskName in the Task relation.
ADD CONSTRAINT TaskOrder_FK_2 Foreign key (taskName) References task (taskName);
*/

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
--      (e.g. -- Q25 � correlated subquery ).
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
