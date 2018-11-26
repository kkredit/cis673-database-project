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
pUserName   VARCHAR(64) PRIMARY KEY,
pDesc       VARCHAR(64) NOT NULL
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
-- Service_Order_Photos_2R_1: See trigger below
);
--
CREATE TABLE Bid (
bidDate     DATE,
orderNo     INT,
pUserName   VARCHAR(64),
bidAmt      INT NOT NULL,
bidWon      CHAR(1) DEFAULT('F'),
CONSTRAINT Bid_PK       PRIMARY KEY(bidDate, orderNo, pUserName),
CONSTRAINT Bid_FK_1     FOREIGN KEY(orderNo) REFERENCES Service_Order(orderNo),
CONSTRAINT Bid_FK_2     FOREIGN KEY(pUserName) REFERENCES Provider(pUserName),
CONSTRAINT Bid_1A_1     CHECK( bidWon IN ('T', 'F') )
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
-- Trigger for Constraint Order_Photos_2R_1
CREATE OR REPLACE TRIGGER Service_Order_Photos_2R_1
BEFORE INSERT ON Service_Order_Photos
FOR EACH ROW
DECLARE
    numFound INTEGER;
BEGIN
    SELECT MAX(COUNT(*)) INTO numFound
    FROM Service_Order_Photos S
    WHERE s.orderNo = :NEW.orderNo
    GROUP BY S.orderNo
    HAVING COUNT(*) > 1;
--
    IF numFound > 4
    THEN
        RAISE_APPLICATION_ERROR(-20001, '+++++INSERT or UPDATE rejected. Order Number '||
                                :NEW.orderNo||' cannot allow more than 5 photo uploads');
    END IF;
END;
/
SHOW ERROR
--
-- --------------------------------------------------------------------
-- POPULATE THE TABLES
-- --------------------------------------------------------------------
SET FEEDBACK OFF
--
INSERT INTO App_User VALUES ('michaelb', 'Michael Benson', 6164254849, 'mbenson@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('dusty', 'Dustin Van Dyke', 6168893456, 'dustinvd89@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('SarahH', 'Sarah Han', 5355678409, 'hansarah@madeup.com', 'Customer');
INSERT INTO App_User VALUES ('Cbing','Chandler Bing', 2123457290, 'bing@mailsz.com', 'Customer');
INSERT INTO App_User VALUES ('BathPros', 'Andrew Gorski', 6163439732, 'service@bathpros.com', 'Provider');
INSERT INTO App_User VALUES ('RWBnGreen', 'George Washington', 6167041776, 'sales@greenusa.com', 'Provider');
INSERT INTO App_User VALUES ('MIFFLIN DUNDER','DWIGHT K. SCHRUTE', 2123457290, 'corporatesales@dundermiff.com', 'Provider');
--
INSERT INTO Customer VALUES ('michaelb', '1234 Evans Way, Grand Rapids MI', 'Personal',
                             'My name is Mike. I like me house to be clean :)' );
INSERT INTO Customer VALUES ('dusty', '9898 Aurora Ave, Caledonia MI', 'Personal',
                             'I am allergic to dust, so have high standards.' );
INSERT INTO Customer VALUES ('SarahH', '7889 116th St, Grand Rapids MI', 'Professional',
                             'I manage Sunny Day Apartments on 116th St. Looking for good landscapers.' );
INSERT INTO Customer VALUES ('Cbing', '890 Marsh Ridge, Grand Rapids MI', 'Personal',
                             'Looking for my house windows to be cleaned.' );
--
INSERT INTO Provider VALUES ('BathPros', 'We are the best in the biz of wiz!');
INSERT INTO Provider VALUES ('RWBnGreen', 'We make your green show off some Red, White, and Blue.');
INSERT INTO Provider VALUES ('MIFFLIN DUNDER', 'Helping you get your Scrant on since 2005');
--
INSERT INTO Provider_Branch VALUES ('BathPros', '3672 Division Ave, Grand Rapids MI');
INSERT INTO Provider_Branch VALUES ('BathPros', '9002 22nd St, Grandville MI');
INSERT INTO Provider_Branch VALUES ('RWBnGreen', '19 N Square, Grand Rapids MI');
INSERT INTO Provider_Branch VALUES ('MIFFLIN DUNDER', '300 Office street ave NW, Scranton MI');
--
INSERT INTO Task VALUES ('Dust', 'Clean dust from one or many rooms');
INSERT INTO Task VALUES ('Mow lawn', 'Cut grass or lawn to a specified length');
INSERT INTO Task VALUES ('Yard-general', 'Typical landscaping tasks; mowing, weeding, raking');
INSERT INTO Task VALUES ('Bathroom-general', 'Typical bathroom tasks; toilet, shower, floor, mirror');
INSERT INTO Task VALUES ('Window Cleaning', 'Expert bonded and insured window cleaners. Call for a free estimate Interior and Exterior');
INSERT INTO Task VALUES ('HVAC','Comprehensive air duct cleaning service for every part of the HVAC system');
--
INSERT INTO Provider_Specialized_Task VALUES ('BathPros', 'Bathroom-general');
INSERT INTO Provider_Specialized_Task VALUES ('RWBnGreen', 'Mow lawn');
INSERT INTO Provider_Specialized_Task VALUES ('RWBnGreen', 'Yard-general');
INSERT INTO Provider_Specialized_Task VALUES ('MIFFLIN DUNDER', 'Window Cleaning');
INSERT INTO Provider_Specialized_Task VALUES ('MIFFLIN DUNDER', 'HVAC');
--
INSERT INTO Service_Order VALUES (1, 'michaelb', NULL, 'Clean my 2 bathrooms each Wednesday',
                                  '1234 Evans Way, Grand Rapids MI', '19-NOV-18', '05-DEC-18');
INSERT INTO Service_Order VALUES (2, 'dusty', 50, 'Dust my whole apartment every day',
                                  '9898 Aurora Ave, Caledonia MI', '19-NOV-18', NULL);
INSERT INTO Service_Order VALUES (3, 'SarahH', 500, 'Maintain the apartment grounds',
                                  '7889 116th St, Grand Rapids MI', '20-NOV-18', NULL);
INSERT INTO Service_Order VALUES (4, 'Cbing', 750, 'Clean the interior and exterior windows of the building',
                                  '890 Marsh Ridge, Grand Rapids MI', '22-NOV-18', NULL);
--
INSERT INTO Task_In_Service_Order VALUES (1, 'Bathroom-general');
INSERT INTO Task_In_Service_Order VALUES (2, 'Dust');
INSERT INTO Task_In_Service_Order VALUES (3, 'Mow lawn');
INSERT INTO Task_In_Service_Order VALUES (3, 'Yard-general');
INSERT INTO Task_In_Service_Order VALUES (4, 'Window Cleaning');
--
INSERT INTO Service_Order_Photos VALUES (2, '<photo of my apartment>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 1>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 2>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 3>');
INSERT INTO Service_Order_Photos VALUES (3, '<photo of grounds 4>');
INSERT INTO Service_Order_Photos VALUES (4, '<photo of windows 1>');
INSERT INTO Service_Order_Photos VALUES (4, '<photo of windows 2>');
--
INSERT INTO Bid VALUES ('21-NOV-18', 3, 'RWBnGreen', 450, 'T');
INSERT INTO Bid VALUES ('21-NOV-18', 4, 'RWBnGreen', 650, 'F');
INSERT INTO Bid VALUES ('23-NOV-18', 4, 'MIFFLIN DUNDER', 700, 'T');
INSERT INTO Bid VALUES ('25-NOV-18', 2, 'MIFFLIN DUNDER', 50, 'F');
INSERT INTO Bid VALUES ('26-NOV-18', 2, 'RWBnGreen', 80, 'F');
INSERT INTO Bid VALUES ('27-NOV-18', 2, 'MIFFLIN DUNDER', 90, 'T');
--
INSERT INTO Reviews VALUES ('SarahH', 'RWBnGreen', '22-NOV-18', 4,
                            'Would rate them 5 stars, but they mowed an American flag pattern into the yard.');
INSERT INTO Reviews VALUES ('Cbing', 'MIFFLIN DUNDER', '26-NOV-18', 5,
                            'Great work done, windows looks real clean and shining.');
INSERT INTO Reviews VALUES ('dusty', 'MIFFLIN DUNDER', '28-NOV-18', 2,
                            'They were nice, but the one guy kept pranking the other so he stormed out.');
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
SELECT * FROM Task;
SELECT * FROM Provider_Specialized_Task;
SELECT * FROM Service_Order;
SELECT * FROM Task_In_Service_Order;
SELECT * FROM Service_Order_Photos;
SELECT * FROM Bid;
SELECT * FROM Reviews;
--
--
-- --------------------------------------------------------------------
-- EXECUTE QUERIES
-- --------------------------------------------------------------------
-- Query 1: A join involving at least four relations.
--  --> Find all users of the app that have requested cleaning to be done along with what they have
--      requested and when it was requested
SELECT DISTINCT A.fullName, C.cType, O.orderLoc, O.datePosted, O.orderDesc, T.taskName
FROM App_User A, Customer C, Service_Order O, Task_In_Service_Order T
WHERE A.userName = C.cUserName AND
      O.ocUserName = C.cUserName AND
      O.orderNo = T.orderNo;
--
-- Query 2: A self-join
--  --> 
--
-- Query 3: UNION, INTERSECT, and/or MINUS
--  --> MINUS: Find Providers that have not made any bids
SELECT pUserName
FROM Provider
MINUS
SELECT pUserName
FROM Bid;
--
-- Query 4: SUM, AVG, MAX, and/or MIN
--  --> MAX: Find the highest bid by each company
SELECT A.fullName, MAX(bidAmt) AS Top_Bid
FROM Bid B, Provider P, App_User A
WHERE B.pUserName = P.pUserName AND
      P.pUserName = A.userName
GROUP BY A.fullName;
--
-- Query 5: GROUP BY, HAVING, and ORDER BY, all appearing in the same query
--  --> Find the order numbers which have more than one bid on them
SELECT B.orderNo, COUNT(*)
FROM Bid B
HAVING COUNT(*) > 1
GROUP BY B.orderNo
ORDER BY B.orderNo;
--
-- Query 6: A correlated subquery
--  --> Find the bids that were greater than the average bid per order
SELECT B.bidDate, B.pUserName, B.orderNo, B.bidAmt, B.bidWon
FROM Bid B
WHERE B.bidAMT > (SELECT AVG(bidAmt)
                  FROM Bid
                  WHERE orderNo = B.orderNo);
--
-- Query 7: A non-correlated subquery
--  --> Find providers who do not have any reviews
SELECT P.pUserName
FROM Provider P
WHERE P.pUserName NOT IN (SELECT R.pUserName
                          FROM Reviews R);
--
-- Query 8: A relational DIVISION query
--  --> 
--
-- Query 9: An outer join
--  --> 
--
-- Query 10: A RANK query
--  --> Find the rank of 2 in the reviews table
SELECT RANK (2) WITHIN GROUP
(ORDER BY revRating DESC) "Rank of rating 2"
FROM Reviews;
--
-- Query 11: A Top-N query
--  --> Find the 3 highest bids
SELECT orderNo, pUserName, bidAmt, bidWon
FROM (SELECT orderNo, pUserName, bidAmt, bidWon
      FROM Bid
      ORDER BY bidAmt DESC)
WHERE ROWNUM < 4;
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
-- Testing: 
--
-- Testing: 
--
-- Testing: 
--
-- Testing: 
--
-- Testing: 
--
--
COMMIT;
SPOOL OFF
