-- UDBP Project : Database design for Auto Insurance Company CRM Policy Management
-- DDL statements script file
-- Creation of Tables and Inserting Rows of Data

-- Section 1: Drop all relevant TABLES  : Goto Row 11
-- Section 2: CREATE tables             : Goto Row 39
-- Section 3: INSERT Data               : Goto Row 259
-- Section 4: ALTER tables to add Foreign Key Constraints: Goto Row 1780

-- ===========================================================================
-- SECTION 1:  Drop all Relevant TABLES
-- ===========================================================================

DROP TABLE customer CASCADE CONSTRAINTS;  
DROP TABLE license CASCADE CONSTRAINTS;  
DROP TABLE vehicle CASCADE CONSTRAINTS;  
DROP TABLE vehicle_driver CASCADE CONSTRAINTS; 
DROP TABLE vehicle_lien CASCADE CONSTRAINTS;  
DROP TABLE insu_agent CASCADE CONSTRAINTS;  
DROP TABLE Product_Type CASCADE CONSTRAINTS;  
DROP TABLE quote CASCADE CONSTRAINTS;  
DROP TABLE insu_policy CASCADE CONSTRAINTS; 
DROP TABLE Policy_Amend CASCADE CONSTRAINTS; 
DROP TABLE Policy_coverage CASCADE CONSTRAINTS; 
DROP TABLE bill CASCADE CONSTRAINTS; 
DROP TABLE payment_receipt CASCADE CONSTRAINTS; 
DROP TABLE incident_record CASCADE CONSTRAINTS; 
DROP TABLE claim CASCADE CONSTRAINTS;
DROP TABLE settlement CASCADE CONSTRAINTS; 

DROP TABLE payment_method CASCADE CONSTRAINTS; 
DROP TABLE credit_card CASCADE CONSTRAINTS;
DROP TABLE bank_account CASCADE CONSTRAINTS;

DROP TYPE payment_supertype FORCE;
DROP TYPE payment_subtype1 FORCE;
DROP TYPE payment_subtype2 FORCE;
-- ===========================================================================
-- SECTION 2:  Creating TABLES
-- ===========================================================================

CREATE  TYPE payment_supertype AS OBJECT (
      pay_method_id varchar2(200),
      Policy_No     varchar2(200)
) 
NOT FINAL 
NOT INSTANTIABLE;
/ 

--need to have this, or else getting error when runing script

CREATE TABLE payment_method OF payment_supertype;

CREATE OR REPLACE TYPE payment_subtype1 UNDER payment_supertype (
    Card_no          integer,
    Holder_name      varchar (200),
    Street_nm        varchar (200),
    apt_no           VARCHAR (20),
    city             varchar (200),
    State_nm         varchar (20),
    zip              VARCHAR (20),
    card_type        varchar (20),
    cvc              number,
    issue_bank       varchar2 (20),
    exp_detail       varchar2 (20)
);
/

--need to have this, or else getting error when runing script

CREATE TABLE credit_card OF payment_subtype1;

CREATE OR REPLACE TYPE payment_subtype2 UNDER payment_supertype (
    Account_no       varchar2(200),
    holder_nm        varchar2 (20),
    bank_name        varchar2 (20),
    routing_no       varchar2(200)
);
/ 

--need to have this, or else getting error when runing script

CREATE TABLE bank_account OF payment_subtype2;

CREATE TABLE Customer(
    Cust_id integer CONSTRAINT cust_pk PRIMARY KEY,
    Policy_no varchar(200),
    First_Nm varchar(200),
    Middle_Nm varchar(200),
    Last_Nm varchar(200),
    Address varchar(200),
    Apt_no varchar(20),
    City varchar(200),
    State_Nm varchar(200),
    Zip varchar(20),
    Phone varchar(20),
    Mobile varchar(20),
    Email varchar(200),
    SSN varchar (20),
    Gender varchar(200)
);

CREATE TABLE License(
    license_no INTEGER CONSTRAINT lic_pk PRIMARY KEY,
    cust_id INTEGER,
    first_Issue_Date DATE,
    latest_issue_Date DATE,
    expiry_Date DATE,
    DOB DATE,
    Violation_hist INTEGER,
    Issue_state VARCHAR2(10),
    Issue_country VARCHAR2(14)
);


 
CREATE TABLE Vehicle(
    VIN_no varchar2(200) CONSTRAINT vehicle_pk primary key,
    Policy_no varchar2(200),
    Car_Make varchar2(200),
    Car_Model varchar2(200),
    Car_Year INTEGER,
    Vehicle_type varchar2(200),
    Airbags INTEGER, 
    Color varchar2(200),
    Miles integer
);

CREATE TABLE Vehicle_Driver(
    License_no integer  constraint veh_driver_pk primary key, 
    VIN_no varchar2(200), 
    Registration_no integer,
    DMV_plate_no varchar2(200),
    Issue_date DATE,
    Expiry_date DATE,
    Purchase_date DATE
);


CREATE TABLE Vehicle_Lien(
    Lien_id varchar2(200) constraint veh_lien_pk primary key,
    VIN_no varchar2(200), 
    Lien_holder varchar(200),
    Record_date DATE

);


CREATE TABLE insu_Agent( 
    Agent_ID varchar2(200) primary key,
    Agent_Nm varchar2(200),
    off_Location varchar2(200), 
    Ratings number(4,2), 
    Salary number(10,2) 
);

CREATE TABLE Product_Type(
    Prod_type_id varchar2(200) primary key,
    Prod_type_name varchar2(100), 
    Bodily_Injury varchar2(200),
    Prop_damage integer,
    Comprehensive varchar2(200),
    Uninsured varchar2(200),
    Collison varchar2(200),
    Emergency varchar2(100) 
);


CREATE TABLE Quote(
    Quote_id integer primary key,
    Agent_ID varchar(200),
    Cust_ID integer,
    Prod_Type_ID varchar2(200),
    Amount number(6,2), 
    Issue_date DATE,
    Expiry_date DATE,
    Discount number(5,2)
);

CREATE TABLE insu_Policy( 
    Policy_No varchar2(200) primary key,
    VIN_no varchar2(200),
    Effective_Date DATE,
    Exp_date DATE,
    Premium_Amount NUMBER(8,2), 
    Agreement VARCHAR2 (200), 
    Safe_Driver VARCHAR2(200), 
    Amend_Id varchar2(200),
    Amend_date DATE,
    Amend_type varchar2(200)
);

CREATE TABLE Policy_Amend(
    Amend_Id varchar2(200) primary key,
    Policy_No varchar2(200),
    Amend_date DATE,
    Amend_type varchar2(200) 
);


CREATE TABLE Policy_coverage(
    Policy_No varchar2(200), 
    prod_type_id varchar2(200),
    policy_status varchar2(200),
    policy_start_date DATE,
    policy_end_date DATE 
);

CREATE TABLE Bill(
    Bill_no integer primary key,
    Policy_no varchar2(200),  
    Bill_Amount number(10,2),  
    Bill_cycle varchar2(100),
    Deductible number(10,2),  
    Bill_date DATE,
    Due_date DATE,
    Status varchar2(200)
);

CREATE TABLE Payment_Receipt(
    Pay_rcpt_ID integer primary key,
    Pay_method_id varchar2(200),
    Bill_No integer,
    Paid_Amount number(10,2), 
    Pay_Date DATE,
    Pay_method varchar2(200)  
);

CREATE TABLE Incident_Record(
    Incident_No integer primary key,
    VIN_no varchar2(200),
    License_No integer,
    Incident_Location varchar2(200), 
    Incident_date date,
    Incident_Time varchar2(200), 
    Incident_Type varchar2(200) 
);


CREATE TABLE Claim(
    Claim_no varchar2(200) PRIMARY KEY,
    Policy_no varchar2(200),
    Claim_Date date,
    Amount number(10,2), 
    Status varchar2(200) 
);


CREATE TABLE Settlement(
    Settlement_ID varchar2(200) PRIMARY KEY,
    Claim_No varchar2(200),
    Settle_date date,
    Amount number(10,2), 
    Status varchar2(200) 
);


-- ===========================================================================
-- Section 3: Insert Rows of Data into Various TABLES
-- ===========================================================================


-- ===========================================================================
-- 3.01 Insert data into CUSTOMER TABLE 
-- ===========================================================================




INSERT INTO Customer VALUES
('1501','89001','Tom',' Mathew','Cruise','47 W. Pulaski Rd',NULL,'Joliet',
'IL','60435','481-629-2343','466-647-4324','tcruise@hotmail.com','499-05-0979','Male');

INSERT INTO Customer VALUES 
('1502','89002','Angelia','Rachel','Green','2111 Barnes Street',NULL,'Orlando',
'FL','32810','407-287-7033','407-376-1649','agreen@yahoo.com','771-18-5685','Female');

INSERT INTO Customer VALUES 
('1503',NULL,'Amanda','Flower','Fisher','4172 Brooklyn Street','1E',
'Berryville','VA','22611','540-955-3503','757-662-5541','amanda@gmail.com','225-86-9885','Female');

INSERT INTO Customer VALUES 
('1604','89003','Edward',NULL,'Mills','1030 Douglas Dairy Road','1567',
'Gate City','VA','24251','276-452-0623','276-594-9430','emills@hotmail.com','230-92-3262','Male');

INSERT INTO Customer VALUES 
('1705',NULL,'Grace','Gabrielle','Garcia','1224 Blue Spruce Lane',
NULL,'Odenton','MD','21113','410-305-6002','443-277-5871','grace20@yahoo.com','216-37-0024','Female');

INSERT INTO Customer VALUES 
('1706',NULL,'Evelyn','Emily','Sanders','2494 Caldwell Road','7E','Rochester',
'NY','14608','585-309-7538','516-263-7391','sanders@outlook.com','061-30-7132','Female');

INSERT INTO Customer VALUES 
('1707',NULL,'Robert','Lawrence','Gross','2545 Maple Lane','8G','Huntsville',
'AL','35816','256-508-9037','256-337-8382','grossg@alabama.com','423-53-8790','Male');

INSERT INTO Customer VALUES 
('1708','89004','Heather','Gale','Urso','3803 Oak Street',NULL,
'Syracuse','NY','13202','315-333-9223','315-440-9802','yoe4mpunki8@hotmail.com','093-62-0995','Female');

INSERT INTO Customer VALUES 
('1809','89005','Robert','Smith','Bryson','3141 Coppel Street','2B','New York',
'NY','11361','718-819-7591','347-319-9576','bry03@gmail.com','111-09-1984','Male');

INSERT INTO Customer VALUES 
('1810','89005','Madelyn','Jacob','Bryson','3142 Coppel Street','2B',
'New York','NY','11361','718-819-7591','347-310-6336','madel19@gmail.com','552-15-4537','Female');

INSERT INTO Customer VALUES 
('1811',NULL,'Duane','Biggs','Lewis','3615 Sugar Camp Road',NULL,
'Owatonna','MN','55060','507-623-8123','507-475-5746','dlewis@yahoo.com','471-10-8455','Male');

INSERT INTO Customer VALUES 
('1912',NULL,'Curt','Jake','Brown','49 Heliport Loop',NULL,'Bloomington','IN',
'47404','812-652-2696','812-688-0402','04curt.b@hotmail.com','333-64-7419','Male');

INSERT INTO Customer VALUES 
('1913','89006','Julie','Harris','Wright','4374 Bagwell Avenue',NULL,'Morrisville',
'PA','19067','352-572-8362','215-932-9418','brown4418@yahoo.com','261-19-5471','Female');

INSERT INTO Customer VALUES 
('1914','89006','Sam','Hansen','Wright','4374 Bagwell Avenue',NULL,'Morrisville',
'PA','19067','352-572-8362','619-992-9425','sam11@gmail.com','623-04-6990','Male');

--SELECT * FROM customer;

/*================================================================*/
/*================================================================*/
/*==================      LICENSE TABLE   =======================*/

INSERT INTO License Values
('872904534','1501',
TO_DATE('09-23-2000','MM-DD-YYYY'),
TO_DATE('07-31-2019','MM-DD-YYYY'),
TO_DATE('07-31-2024','MM-DD-YYYY'),
TO_DATE('06-11-1982','MM-DD-YYYY'),
0,'IL','USA');

INSERT INTO License Values
('430982367','1502',
TO_DATE('09-08-1989','MM-DD-YYYY'),
TO_DATE('03-01-2018','MM-DD-YYYY'),
TO_DATE('02-25-2023','MM-DD-YYYY'),
TO_DATE('01-01-1971','MM-DD-YYYY'),
'3','FL','USA');

INSERT INTO License Values
('615471827','1503',
TO_DATE('02-23-1991','MM-DD-YYYY'),
TO_DATE('05-06-2020','MM-DD-YYYY'),
TO_DATE('10-30-2022','MM-DD-YYYY'),
TO_DATE('12-16-1972','MM-DD-YYYY'),
0,'VA','USA');

INSERT INTO License Values
('639164064','1604',
TO_DATE('01-08-2011','MM-DD-YYYY'),
TO_DATE('10-25-2019','MM-DD-YYYY'),
TO_DATE('10-23-2024','MM-DD-YYYY'),
TO_DATE('09-25-1992','MM-DD-YYYY'),
'2','VA','USA');

INSERT INTO License Values
('120934874','1705',
TO_DATE('07-24-1983','MM-DD-YYYY'),
TO_DATE('03-27-2018','MM-DD-YYYY'),
TO_DATE('01-31-2024','MM-DD-YYYY'),
TO_DATE('01-27-1965','MM-DD-YYYY'),
0,'France','International');

INSERT INTO License Values
('763290487','1706',
TO_DATE('12-11-1998','MM-DD-YYYY'),
TO_DATE('09-11-2018','MM-DD-YYYY'),
TO_DATE('08-10-2021','MM-DD-YYYY'),
TO_DATE('07-12-1980','MM-DD-YYYY'),
'1','NY','USA');

INSERT INTO License Values
('912376536','1707',
TO_DATE('04-08-1988','MM-DD-YYYY'),
TO_DATE('11-24-2019','MM-DD-YYYY'),
TO_DATE('09-20-2023','MM-DD-YYYY'),
TO_DATE('12-25-1969','MM-DD-YYYY'),
0,'Costa Rica','International');

INSERT INTO License Values
('518221360','1708',
TO_DATE('01-13-1998','MM-DD-YYYY'),
TO_DATE('08-08-2018','MM-DD-YYYY'),
TO_DATE('01-12-2022','MM-DD-YYYY'),
TO_DATE('10-01-1978','MM-DD-YYYY'),
'1','NY','USA');

INSERT INTO License Values
('619852978','1809',
TO_DATE('11-20-2007','MM-DD-YYYY'),
TO_DATE('11-21-2018','MM-DD-YYYY'),
TO_DATE('11-30-2022','MM-DD-YYYY'),
TO_DATE('04-19-1988','MM-DD-YYYY'),
0,'NY','USA');

INSERT INTO License Values
('852978431','1810',
TO_DATE('03-17-2012','MM-DD-YYYY'),
TO_DATE('11-28-2019','MM-DD-YYYY'),
TO_DATE('02-16-2023','MM-DD-YYYY'),
TO_DATE('12-04-1991','MM-DD-YYYY'),
0,'NY','USA');

INSERT INTO License Values
('875465824','1811',
TO_DATE('01-09-1998','MM-DD-YYYY'),
TO_DATE('01-28-2019','MM-DD-YYYY'),
TO_DATE('07-25-2023','MM-DD-YYYY'),
TO_DATE('09-27-1978','MM-DD-YYYY'),
'3','MN','USA');

INSERT INTO License Values
('621567963','1912',
TO_DATE('10-25-1977','MM-DD-YYYY'),
TO_DATE('03-25-2018','MM-DD-YYYY'),
TO_DATE('09-17-2002','MM-DD-YYYY'),
TO_DATE('07-13-1959','MM-DD-YYYY'),
'2','IN','USA');

INSERT INTO License Values
('447885933','1913',
TO_DATE('12-08-2001','MM-DD-YYYY'),
TO_DATE('01-15-2018','MM-DD-YYYY'),
TO_DATE('09-21-2023','MM-DD-YYYY'),
TO_DATE('01-19-1983','MM-DD-YYYY'),
0,'PA','USA');

INSERT INTO License Values
('135697465','1914',
TO_DATE('12-04-1986','MM-DD-YYYY'),
TO_DATE('03-23-2018','MM-DD-YYYY'),
TO_DATE('05-31-2022','MM-DD-YYYY'),
TO_DATE('05-18-1968','MM-DD-YYYY'),
0,'PA','USA');


--select * from License;


/*================================================================*/
/*================================================================*/
/*==================      VEHICLE  TABLE   =======================*/

--DROP TABLE vehicle CASCADE CONSTRAINTS; 
--DESC vehicle;

INSERT INTO Vehicle VALUES 
('SAJWA1C78D8V38055','89001','Jaguar','XJ','2013','Sedan','6','Black','23014');

INSERT INTO Vehicle VALUES 
('JH4DB8580SS001230','89002','Acura','Integra','1995','Sedan','2','Red','125671');

INSERT INTO Vehicle VALUES 
('JTHFF2C26B2515141',NULL,'Lexus','IS','2011','Sedan','6','White','56743');

INSERT INTO Vehicle VALUES 
('WMWRC33474TC49530','89003','MINI','Cooper','2004','Sedan','6','Green','76423');

INSERT INTO Vehicle VALUES 
('WAUDK84AXRN029130',NULL,'Audi','Q5','2016','SUV','6','Grey','23505');

INSERT INTO Vehicle VALUES 
('5TFUW5F13CX228552',NULL,'Toyota','Tundra','2010','Pickup','2','Brown','96435');

INSERT INTO Vehicle VALUES 
('4A3AA46G13E081883','89004','Honda','Accord','2012','Sedan','2','Black','122345');

INSERT INTO Vehicle VALUES 
('1GKER23767J144063','89005','Subaru','Legacy','2015','Sedan','2','Blue','88907');

INSERT INTO Vehicle VALUES 
('1FTRW07L01KB09635',NULL,'Ford','F-450','2013','Pickup','3','Grey','105662');

INSERT INTO Vehicle VALUES 
('1J8GR48K78C206923',NULL,'BMW','550i','2018','Coupe','4','White','26735');

INSERT INTO Vehicle VALUES 
('WBXPA93426WG80137','89006','Toyota','Camry','2014','Sedan','2','Tan','77875');

INSERT INTO Vehicle VALUES 
('1FTRW08L82KB90741',NULL,'Jeep','Sahara','2016','SUV','4','Black','66526');


--SELECT * FROM Vehicle;

/*================================================================*/
/*================================================================*/
/*==================      VEHICLE_DRIVER TABLE   =======================*/

INSERT INTO Vehicle_Driver VALUES(
'872904534','SAJWA1C78D8V38055','534210','LRX2716',
TO_DATE('12-23-2019','MM-DD-YYYY'),
TO_DATE('12-21-2021','MM-DD-YYYY'),
TO_DATE('12-23-2013','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('430982367','JH4DB8580SS001230','842084','FEE3094',
TO_DATE('11/21/2019','MM-DD-YYYY'),
TO_DATE('11/15/2020','MM-DD-YYYY'),
TO_DATE('11/21/1995','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('615471827','JTHFF2C26B2515141','845123','6UXM244',
TO_DATE('10/02/2019','MM-DD-YYYY'),
TO_DATE('10/01/2021','MM-DD-YYYY'),
TO_DATE('10/02/2019','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('639164064','WMWRC33474TC49530','132786','AT00339',
TO_DATE('06/04/2019','MM-DD-YYYY'),
TO_DATE('05/20/2021','MM-DD-YYYY'),
TO_DATE('06/04/2011','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('120934874','WAUDK84AXRN029130','3092341','UTE4561',
TO_DATE('03/23/2020','MM-DD-YYYY'),
TO_DATE('03/15/2021','MM-DD-YYYY'),
TO_DATE('03/23/2017','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('763290487','5TFUW5F13CX228552','945213','CA51023',
TO_DATE('11/02/2020','MM-DD-YYYY'),
TO_DATE('10/25/2021','MM-DD-YYYY'),
TO_DATE('11/02/2011','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('912376536','4A3AA46G13E081883','654684','KAS8733',
TO_DATE('08/04/2019','MM-DD-YYYY'),
TO_DATE('02/06/2021','MM-DD-YYYY'),
TO_DATE('08/04/2018','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('518221360','1FTRW07L01KB09635','787876','IUWY66',
TO_DATE('12/10/2019','MM-DD-YYYY'),
TO_DATE('12/4/2023','MM-DD-YYYY'),
TO_DATE('12/10/2015','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('619852978','1GKER23767J144063','5436541','YWH723',
TO_DATE('11/05/2019','MM-DD-YYYY'),
TO_DATE('12/12/2022','MM-DD-YYYY'),
TO_DATE('11/05/2018','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('852978431','1GKER23767J144063','5436541','YWH723',
TO_DATE('11/05/2019','MM-DD-YYYY'),
TO_DATE('12/12/2022','MM-DD-YYYY'),
TO_DATE('11/05/2018','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('875465824','1J8GR48K78C206923','164654','ALSJ79',
TO_DATE('06/16/2020','MM-DD-YYYY'),
TO_DATE('11/15/2023','MM-DD-YYYY'),
TO_DATE('06/16/2010','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('621567963','WBXPA93426WG80137','6878563','YGV6235',
TO_DATE('10/22/2019','MM-DD-YYYY'),
TO_DATE('09/04/2023','MM-DD-YYYY'),
TO_DATE('10/22/2014','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('447885933','1FTRW08L82KB90741','855159','7YUS982',
TO_DATE('4/20/2019','MM-DD-YYYY'),
TO_DATE('04/15/2021','MM-DD-YYYY'),
TO_DATE('4/20/2014','MM-DD-YYYY')
);

INSERT INTO Vehicle_Driver VALUES
('135697465','1FTRW08L82KB90741','855159','7YUS982',
TO_DATE('4/20/2019','MM-DD-YYYY'),
TO_DATE('04/15/2021','MM-DD-YYYY'),
TO_DATE('4/20/2014','MM-DD-YYYY')
);

--SELECT * FROM Vehicle_Driver;

/*================================================================*/
/*================================================================*/
/*==================      VEHICLE_LIEN TABLE   =======================*/

--DROP TABLE vehicle_lien CASCADE CONSTRAINTS;  
--DESCRIBE vehicle_lien;

INSERT INTO Vehicle_Lien VALUES
('LCT001','SAJWA1C78D8V38055','Bank Of America',
--TO_DATE('4/20/2014','MM-DD-YYYY')
TO_DATE('10/23/2015','MM-DD-YYYY')
);

INSERT INTO Vehicle_Lien VALUES
('LCT002','JH4DB8580SS001230','Peoples Bank',
TO_DATE('11/1/2015','MM-DD-YYYY')
);

INSERT INTO Vehicle_Lien VALUES
('LCT003','WMWRC33474TC49530','Bank Of America',
TO_DATE('01/30/2016','MM-DD-YYYY')
);

INSERT INTO Vehicle_Lien VALUES
('LCT004','1FTRW07L01KB09635','Wells Fargo',
TO_DATE('11/10/2018','MM-DD-YYYY')
);

INSERT INTO Vehicle_Lien VALUES
('LCT005','1J8GR48K78C206923','Bank Of America',
TO_DATE('12/28/2018','MM-DD-YYYY')
);

INSERT INTO Vehicle_Lien VALUES
('LCT006','WBXPA93426WG80137','TD Bank',
TO_DATE('10/4/2019','MM-DD-YYYY')
);

--SELECT * FROM Vehicle_Lien;

/*================================================================*/
/*================================================================*/
/*==================      Insu_Agent TABLE   =======================*/

--DROP TABLE insu_agent CASCADE CONSTRAINTS;  
--DESC insu_agent;

INSERT INTO insu_agent VALUES 
('9-14206','George Robinson','MA','4.9','85000');

INSERT INTO insu_agent VALUES
('4-59944','Linda Kendrick','WI','3.6','90000');

select * from insu_Agent;

--------------------------------------------------------------------------------------------------------------------------------
/*================================================================*/
/*================================================================*/
/*==================      Product Type TABLE   =======================*/

-- DROP TABLE Product_Type CASCADE CONSTRAINTS;  

INSERT INTO Product_Type VALUES
('P101B','Basic','25000/50000','25000','Not Covered','25000/50000','Not Covered','Not Covered');

INSERT INTO Product_Type VALUES
('P102S','Silver','25000/50000','25000','Yes with Deductible 500','25000/50000',
'Yes upto Actual cash value with Deductible 500','Yes Covered');

INSERT INTO Product_Type VALUES
('P103G','Gold','50000/100000','25000','Yes with Deductible 100','50000/100000',
'Yes upto Actual cash value with Deductible 100','Yes Covered');


--SELECT * FROM Product_Type;


/*================================================================*/
/*================================================================*/
/*==================      Quote TABLE   =======================*/

INSERT INTO Quote VALUES
('1250','4-59944','1501','P101B','1200',
TO_DATE('23-10-2015','DD-MM-YYYY'),
TO_DATE('07-11-2015','DD-MM-YYYY'),
10); 

INSERT INTO Quote VALUES
('8037','9-14206','1502','P101B','1224',
TO_DATE('1-NOVEMBER-2015','DD-MON-YYYY'),
TO_DATE('16-NOVEMBER-2015','DD-MON-YYYY'),
5.5);

INSERT INTO Quote VALUES
('3209',NULL,'1503','P102S','456',
TO_DATE('03-DECEMBER-2015','DD-MON-YYYY'),
TO_DATE('18-DECEMBER-2015','DD-MON-YYYY'),
3);

INSERT INTO Quote VALUES
('2734','9-14206','1604','P102S','960',
TO_DATE('30-JANUARY-2016','DD-MON-YYYY'),
TO_DATE('14-FEBRUARY-2016','DD-MON-YYYY'),
0);

INSERT INTO Quote VALUES
('5489','4-59944','1705','P103G','1345',
TO_DATE('03 FEBRUARY 2017','DD-MON-YYYY'),
TO_DATE('18 FEBRUARY 2017','DD-MON-YYYY'),
'5');

INSERT INTO Quote VALUES
('4965','4-59944','1706','P102S','567',
TO_DATE('06 JUNE 2017','DD-MON-YYYY'),
TO_DATE('21 JUNE 2017','DD-MON-YYYY'),
'10');

INSERT INTO Quote VALUES
('1252',NULL,'1707','P101B','1272',
TO_DATE('18 OCTOBER 2017','DD-MON-YYYY'),
TO_DATE('2 NOVEMBER 2017','DD-MON-YYYY'),
'3');

INSERT INTO Quote VALUES
('8039','4-59944','1708','P103G','732',
TO_DATE('24 SEPTEMBER 2017','DD-MON-YYYY'),
TO_DATE('09 OCTOBER 2017','DD-MON-YYYY'),
'0');

INSERT INTO Quote VALUES
('3229','9-14206','1809','P101B','956',
TO_DATE('10 NOVEMBER 2018','DD-MON-YYYY'),
TO_DATE('25 NOVEMBER 2018','DD-MON-YYYY'),
'5');

INSERT INTO Quote VALUES
('2727','4-59944','1811','P101B','657',
TO_DATE('28 DECEMBER 2018','DD-MON-YYYY'),
TO_DATE('12 JANUARY 2019','DD-MON-YYYY'),
'10');

INSERT INTO Quote VALUES
('5492','9-14206','1912','P102S','540',
TO_DATE('04 OCTOBER 2019','DD-MON-YYYY'),
TO_DATE('19 OCTOBER 2019','DD-MON-YYYY'),
'3');

INSERT INTO Quote VALUES
('4972','4-59944','1913','P102S','1224',
TO_DATE('27 NOVEMBER 2019','DD-MON-YYYY'),
TO_DATE('12 DECEMBER 2019','DD-MON-YYYY'),
'0');


--SELECT * FROM Quote;

/*================================================================*/
/*================================================================*/
/*==================      Insu_Policy TABLE   =======================*/


INSERT INTO insu_Policy Values
('89001',
'SAJWA1C78D8V38055',
TO_DATE('23 OCTOBER 2019','DD-MON-YYYY'), 
TO_DATE('22 OCTOBER 2020','DD-MON-YYYY'), 
925.97, 
'1 year',
'Y',
'89001-05',
TO_DATE('17 OCTOBER 2019','DD-MON-YYYY'),
'Renewal');

INSERT INTO insu_Policy Values
('89002','JH4DB8580SS001230',
TO_DATE('1  NOVEMBER 2019','DD-MON-YYYY'),
TO_DATE('31 OCTOBER 2020','DD-MON-YYYY'),
944.48,'1 year','N',
'89002-05',
TO_DATE('26 OCTOBER 2019','DD-MON-YYYY'),
'Renewal');

INSERT INTO insu_Policy Values
('89003','WMWRC33474TC49530',
TO_DATE('28 JAN  2020','DD-MON-YYYY'),
TO_DATE('27 JAN 2021','DD-MON-YYYY'),
938.31,'1 year','N',
'89003-05',
TO_DATE('18 DECEMBER 2019','DD-MON-YYYY'),
'Renewal');


INSERT INTO insu_Policy Values
('89004','4A3AA46G13E081883',
TO_DATE('17 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('17 OCTOBER 2021','DD-MON-YYYY'),
1033.18,'1 year','N',
'89004-04',
TO_DATE('17 OCTOBER 2020','DD-MON-YYYY'),
'Renewal');

INSERT INTO insu_Policy Values
('89005','1GKER23767J144063',
TO_DATE('26 SEPTEMBER 2020','DD-MON-YYYY'),
TO_DATE('28 mar 2021','DD-MON-YYYY'),
389.01,'6 months','Y',
'89005-07',
TO_DATE('26 SEPTEMBER 2020','DD-MON-YYYY'),
'Renewal');

INSERT INTO insu_Policy Values
('89006','WBXPA93426WG80137',
TO_DATE('16 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('17 APRIL 2021','DD-MON-YYYY'),
1046.52,'6 months','Y',
'89006-03',
TO_DATE('16 OCTOBER 2020','DD-MON-YYYY'),
'Renewal');

--SELECT * FROM insu_Policy;

/*================================================================*/
/*================================================================*/
/*==================      Policy Amend TABLE   =======================*/


INSERT INTO Policy_Amend VALUES
('89001-01','89001',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89001-02','89001',
TO_DATE('27 OCTOBER 2016','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89001-03','89001',
TO_DATE('17 OCTOBER 2017','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89001-04','89001',
TO_DATE('17 OCTOBER 2018','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89001-05','89001',
TO_DATE('17 OCTOBER 2019','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89002-01','89002',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89002-02','89002',
TO_DATE('5 NOVEMBER 2016','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89002-03','89002',
TO_DATE('26 OCTOBER 2017','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89002-04','89002',
TO_DATE('26 OCTOBER 2018','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89002-05','89002',
TO_DATE('26 OCTOBER 2019','DD-MON-YYYY'),
'Renewal');

INSERT INTO Policy_Amend VALUES
('89003-01','89003',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89003-02','89003',
TO_DATE('12 MAY 2016','DD-MON-YYYY'),'Product change - Basic to Silver');

INSERT INTO Policy_Amend VALUES
('89003-03','89003',
TO_DATE('17 JANUARY 2017','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89003-04','89003',
TO_DATE('7 JANUARY 2018','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89003-05','89003',
TO_DATE('28 DECEMBER 2018','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89003-06','89003',
TO_DATE('18 DECEMBER 2019','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89004-01','89004',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89004-02','89004',
TO_DATE('20 OCTOBER 2018','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89004-03','89004',
TO_DATE('19 OCTOBER 2019','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89004-04','89004',
TO_DATE('17 OCTOBER 2020','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-01','89005',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89005-02','89005',
TO_DATE('31 MARCH 2018','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-03','89005',
TO_DATE('29 SEPTEMBER 2018','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-04','89005',
TO_DATE('30 MARCH 2019','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-05','89005',
TO_DATE('28 SEPTEMBER 2019','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-06','89005',
TO_DATE('28 MARCH 2020','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89005-07','89005',
TO_DATE('26 SEPTEMBER 2020','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89006-01','89006',NULL,NULL);

INSERT INTO Policy_Amend VALUES
('89006-02','89006',
TO_DATE('17 APRIL 2020','DD-MON-YYYY'),'Renewal');

INSERT INTO Policy_Amend VALUES
('89006-03','89006',
TO_DATE('16 OCTOBER 2020','DD-MON-YYYY'),'Renewal');


--SELECT * FROM Policy_Amend;

/*================================================================*/
/*================================================================*/
/*==================      Policy Coverage TABLE   =======================*/


INSERT INTO policy_coverage VALUES(
'89001','P101B','Active',
TO_DATE('10-23-2019','MM-DD-YYYY'),
TO_DATE('10-22-2020','MM-DD-YYYY')
);

INSERT INTO policy_coverage VALUES(
'89002','P101B','Expired',
TO_DATE('11-01-2019','MM-DD-YYYY'),
TO_DATE('10-31-2020','MM-DD-YYYY')
);

INSERT INTO policy_coverage VALUES(
'89003','P101B','Renewed',
TO_DATE('02-02-2016','MM-DD-YYYY'),
TO_DATE('05-11-2021','MM-DD-YYYY')
);

INSERT INTO policy_coverage VALUES(
'89003','P102S','Active',
TO_DATE('05-12-2016','MM-DD-YYYY'),
TO_DATE('01-27-2021','MM-DD-YYYY')
);
INSERT INTO policy_coverage VALUES(
'89004','P101B','Active',
TO_DATE('10-17-2020','MM-DD-YYYY'),
TO_DATE('10-17-2021','MM-DD-YYYY')
);
INSERT INTO policy_coverage VALUES(
'89005','P103G','Active',
TO_DATE('09-26-2020','MM-DD-YYYY'),
TO_DATE('03-28-2021','MM-DD-YYYY')
);
INSERT INTO policy_coverage VALUES(
'89006','P102S','Active',
TO_DATE('10-16-2020','MM-DD-YYYY'),
TO_DATE('04-17-2021','MM-DD-YYYY')
);

--SELECT * FROM policy_coverage;


/*================================================================*/
/*================================================================*/
/*==================      Bill TABLE   =======================*/


INSERT INTO Bill VALUES
('10567','89001','600.00','Half Yearly',0,
TO_DATE('28 OCTOBER 2015','DD-MON-YYYY'),
TO_DATE('27 NOVEMBER 2015','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10568','89001','600.00','Half Yearly','0',
TO_DATE('25 APRIL 2016','DD-MON-YYYY'),
TO_DATE('25 MAY 2016','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10569','89001','540.00','Half Yearly','0',
TO_DATE('27 OCTOBER 2016','DD-MON-YYYY'),
TO_DATE('26 NOVEMBER 2016','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('10570','89001','540.00','Half Yearly','0',
To_Date('25 APRIL 2017','DD-MON-YYYY'),
To_date('25 MAY 2017','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('10571','89001','513.00','Half Yearly','0',
TO_DATE('27 OCTOBER 2017','DD-MON-YYYY'),
TO_DATE('26 NOVEMBER 2017','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10572','89001','513.00','Half Yearly','0',
TO_DATE('25 APRIL 2018','DD-MON-YYYY'),
TO_DATE('25 MAY 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10573','89001','487.35','Half Yearly','0',
TO_DATE('27 OCTOBER 2018','DD-MON-YYYY'),
TO_DATE('26 NOVEMBER 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10574','89001','487.35','Half Yearly','0',
TO_DATE('25 APRIL 2019','DD-MON-YYYY'),
TO_DATE('25 MAY 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10575','89001','462.98','Half Yearly','0',
TO_DATE('27 OCTOBER 2019','DD-MON-YYYY'),
TO_DATE('26 NOVEMBER 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10576','89001','462.98','Half Yearly','0',
TO_DATE('24 APRIL 2020','DD-MON-YYYY'),
TO_DATE('24 MAY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('10577','89001','462.98','Half Yearly','0',
TO_DATE('26 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('25 NOVEMBER 2020','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('20645','89002','612.00','Half Yearly',0,
TO_DATE('06 NOVEMBER 2015','DD-MON-YYYY'),
TO_DATE('06 DECEMBER 2015','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('20646','89002','612.00','Half Yearly','500',
TO_DATE('04 MAY 2016','DD-MON-YYYY'),
TO_DATE('03 JUNE 2016','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20647','89002','550.80','Half Yearly','0',
TO_DATE('05 NOVEMBER 2016','DD-MON-YYYY'),
TO_DATE('05 DECEMBER 2016','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20648','89002','550.80','Half Yearly','0',
TO_DATE('04 MAY 2017','DD-MON-YYYY'),
TO_DATE('03 JUNE 2017','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20649','89002','523.26','Half Yearly','0',
TO_DATE('05 NOVEMBER 2017','DD-MON-YYYY'),
TO_DATE('05 DECEMBER 2017','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20650','89002','523.26','Half Yearly','0',
TO_DATE('04 MAY 2018','DD-MON-YYYY'),
TO_DATE('03 JUNE 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20651','89002','497.10','Half Yearly','0',
TO_DATE('05 NOVEMBER 2018','DD-MON-YYYY'),
TO_DATE('05 DECEMBER 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20652','89002','497.10','Half Yearly','0',
TO_DATE('04 MAY 2019','DD-MON-YYYY'),
TO_DATE('03 JUNE 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20653','89002','472.24','Half Yearly','0',
TO_DATE('05 NOVEMBER 2019','DD-MON-YYYY'),
TO_DATE('05 DECEMBER 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('20654','89002','472.24','Half Yearly','0',
TO_DATE('03 MAY 2020','DD-MON-YYYY'),
TO_DATE('02 JUNE 2020','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('30673','89003','480.00','Half Yearly','0',
TO_DATE('02 FEBRUARY 2016','DD-MON-YYYY'),
TO_DATE('03 MARCH 2016','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('30674','89003','672.00','Half Yearly','0',
TO_DATE('31 JULY 2016','DD-MON-YYYY'),
TO_DATE('30 AUGUST 2016','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30675','89003','547.20','Half Yearly','0',
TO_DATE('01 FEBRUARY 2017','DD-MON-YYYY'),
TO_DATE('03 MARCH 2017','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30676','89003','547.20','Half Yearly','100',
TO_DATE('31 JULY 2017','DD-MON-YYYY'),
TO_DATE('30 AUGUST 2017','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30677','89003','519.84','Half Yearly','0',
TO_DATE('01 FEBRUARY 2018','DD-MON-YYYY'),
TO_DATE('03 MARCH 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30678','89003','519.84','Half Yearly','0',
TO_DATE('31 JULY 2018','DD-MON-YYYY'),
TO_DATE('30 AUGUST 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30679','89003','493.85','Half Yearly','0',
TO_DATE('01 FEBRUARY 2019','DD-MON-YYYY'),
TO_DATE('03 MARCH 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30680','89003','493.85','Half Yearly','0',
TO_DATE('31 JULY 2019','DD-MON-YYYY'),
TO_DATE('30 AUGUST 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30681','89003','469.16','Half Yearly','0',
TO_DATE('27 JANUARY 2020','DD-MON-YYYY'),
TO_DATE('26 FEBRUARY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('30682','89003','469.16','Half Yearly','0',
TO_DATE('25 JULY 2020','DD-MON-YYYY'),
TO_DATE('24 AUGUST 2020','DD-MON-YYYY'),
'Fully Paid');



INSERT INTO Bill VALUES
('40145','89004','1272.00','Yearly','0',
TO_DATE('21 OCTOBER 2017','DD-MON-YYYY'),
TO_DATE('20 NOVEMBER 2017','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('40156','89004','1144.80','Yearly','500',
TO_DATE('21 OCTOBER 2018','DD-MON-YYYY'),
TO_DATE('20 NOVEMBER 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('40167','89004','1087.56','Yearly','500',
TO_DATE('21 OCTOBER 2019','DD-MON-YYYY'),
TO_DATE('20 NOVEMBER 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('40178','89004','1033.18','Yearly','0',
TO_DATE('20 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('19 NOVEMBER 2020','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('50231','89005','732.00','Half Yearly','0',
TO_DATE('30 SEPTEMBER 2017','DD-MON-YYYY'),
TO_DATE('30 OCTOBER 2017','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('50232','89005','658.80','Half Yearly','0',
TO_DATE('01 APRIL 2018','DD-MON-YYYY'),
TO_DATE('01 MAY 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('50233','89005','592.92','Half Yearly','0',
TO_DATE('01 OCTOBER 2018','DD-MON-YYYY'),
TO_DATE('31 OCTOBER 2018','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('50234','89005','533.63','Half Yearly','0',
TO_DATE('02 APRIL 2019','DD-MON-YYYY'),
TO_DATE('02 MAY 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('50235','89005','480.27','Half Yearly','0',
TO_DATE('02 OCTOBER 2019','DD-MON-YYYY'),
TO_DATE('01 NOVEMBER 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('50236','89005','432.24','Half Yearly','0',
TO_DATE('02 APRIL 2020','DD-MON-YYYY'),
TO_DATE('02 MAY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('50237','89005','389.01','Half Yearly','0',
TO_DATE('02 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('01 NOVEMBER 2020','DD-MON-YYYY'),
'Pending');



INSERT INTO Bill VALUES
('60132','89006','204.00','Monthly','0',
TO_DATE('18 OCTOBER 2019','DD-MON-YYYY'),
TO_DATE('17 NOVEMBER 2019','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('60133','89006','204.00','Monthly','0',
TO_DATE('17 NOVEMBER 2019','DD-MON-YYYY'),
TO_DATE('17 DECEMBER 2019','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60134','89006','204.00','Monthly','0',
TO_DATE('17 DECEMBER 2019','DD-MON-YYYY'),
TO_DATE('16 JANUARY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60135','89006','204.00','Monthly','0',
TO_DATE('16 JANUARY 2020','DD-MON-YYYY'),
TO_DATE('15 FEBRUARY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60136','89006','204.00','Monthly','0',
TO_DATE('15 FEBRUARY 2020','DD-MON-YYYY'),
TO_DATE('16 MARCH 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60137','89006','204.00','Monthly','0',
TO_DATE('16 MARCH 2020','DD-MON-YYYY'),
TO_DATE('15 APRIL 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60138','89006','1101.60','Monthly','0',
TO_DATE('20 APRIL 2020','DD-MON-YYYY'),
TO_DATE('20  MAY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60139','89006','1101.60','Monthly','0',
TO_DATE('20 MAY 2020','DD-MON-YYYY'),
TO_DATE('19 JUNE 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60140','89006','1101.60','Monthly','0',
TO_DATE('19 JUNE 2020','DD-MON-YYYY'),
TO_DATE('19 JULY 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60141','89006','1101.60','Monthly','0',
TO_DATE('19 JULY 2020','DD-MON-YYYY'),
TO_DATE('18 AUGUST 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60142','89006','1101.60','Monthly','0',
TO_DATE('18 AUGUST 2020','DD-MON-YYYY'),
TO_DATE('17 SEPTEMBER 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60143','89006','1101.60','Monthly','0',
TO_DATE('17 SEPTEMBER 2020','DD-MON-YYYY'),
TO_DATE('17 OCTOBER 2020','DD-MON-YYYY'),
'Fully Paid');


INSERT INTO Bill VALUES
('60144','89006','1046.52','Monthly','0',
TO_DATE('20 OCTOBER 2020','DD-MON-YYYY'),
TO_DATE('19 NOVEMBER 2020','DD-MON-YYYY'),
'Fully Paid');

INSERT INTO Bill VALUES
('60145','89006','1046.52','Monthly','0',
TO_DATE('19 NOVEMBER 2020','DD-MON-YYYY'),
TO_DATE('19 OCTOBER 2020','DD-MON-YYYY'),
'Pending');


--SELECT * FROM Bill;

/*================================================================*/
/*================================================================*/
/*==================      Payment Method TABLE   =======================*/

-- This is Super Type... so no INSERT command....Data is inserted in the sub type "Credit Card" and "Bank Account" in next section


/*================================================================*/
/*================================================================*/
/*==================      Credit Card TABLE   =======================*/


INSERT INTO Credit_Card Values (
payment_subtype1('PM1001','89001','4916689811047971','Tom Cruise','47 W. Pulaski Rd',null,'Joliet','IL','60435','VISA','156','Bank Of America','10/25')
);

INSERT INTO Credit_Card Values(
payment_subtype1('PM1002','89002','4916689811047971','Angelia Green','2111 Barnes Street',null,'Orlando','FL','32810','Amex','972','Peoples United','11/23')
);

INSERT INTO Credit_Card Values(
payment_subtype1('PM1004','89004','6515846293546','Heather Gale','3803 Oak Street',null,'Syracuse','NY','13202','MasterCard','966','Citi Bank','04/24')
);

Select* FROM Credit_card;

/*================================================================*/
/*================================================================*/
/*==================      bank account TABLE   =======================*/


INSERT INTO bank_account Values(
payment_subtype2('PM1003','89003','456781914', 'Edward Mills','HSBC Bank','9845672')
);
INSERT INTO bank_account Values(
payment_subtype2('PM1004','89004','852325255',	'Heather Gale',	'Citi Bank','21256482')
);
INSERT INTO bank_account Values(
payment_subtype2('PM1005','89005','645511651',	'Robert Smith',	'HSBC Bank','55296632')
);
INSERT INTO bank_account Values(
payment_subtype2('PM1006','89006','35465436',	'Sam Hansen',	'Chase Bank','2455453')
);

--select * FROM bank_account;


/*================================================================*/
/*================================================================*/
/*==================      Payment Receipt TABLE   =======================*/

--DROP TABLE payment_receipt CASCADE CONSTRAINTS; 

INSERT INTO Payment_Receipt Values 
('563354','PM1001','10568','600',
TO_DATE('4/28/2016','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('746333','PM1001','10569','540',
TO_DATE('10/30/2016','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('462623','PM1001','10570','540',
TO_DATE('4/28/2017','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('452984','PM1001','10571','513',
TO_DATE('10/30/2017','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('526294','PM1001','10572','513',
TO_DATE('4/28/2018','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('563355','PM1001','10573','487.35',
TO_DATE('10/30/2018','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('746337','PM1001','10574','487.35',
TO_DATE('4/28/2019','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('462625','PM1001','10575','462.98',
TO_DATE('10/30/2019','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('452987','PM1001','10576','462.98',
TO_DATE('4/27/2020','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('526298','PM1001','10577','462.98',
TO_DATE('10/29/2020','mm-dd-yyyy'),
'Credit Card');



INSERT INTO Payment_Receipt Values
('563356','PM1002','20645','612',
TO_DATE('11/9/2015','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('746341','PM1002','20646','1112.00',
TO_DATE('5/7/2016','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('462627','PM1002','20647','550.8',
TO_DATE('11/8/2016','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('452990','PM1002','20648','550.8',
TO_DATE('5/7/2017','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('526302','PM1002','20649','523.26',
TO_DATE('11/8/2017','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('563357','PM1002','20650','523.26',
TO_DATE('5/7/2018','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('746345','PM1002','20651','497.1',
TO_DATE('11/8/2018','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('462629','PM1002','20652','497.1',
TO_DATE('5/7/2019','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('452993','PM1002','20653','472.24',
TO_DATE('11/8/2019','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('526306','PM1002','20654','472.24',
TO_DATE('5/6/2020','mm-dd-yyyy'),
'Credit Card');





INSERT INTO Payment_Receipt Values
('563358','PM1003','30673','480',
TO_DATE('2/5/2016','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('746349','PM1003','30674','672',
TO_DATE('8/3/2016','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('462631','PM1003','30675','547.2',
TO_DATE('2/4/2017','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('452996','PM1003','30676','647.2',
TO_DATE('8/3/2017','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('526310','PM1003','30677','519.84',
TO_DATE('2/4/2018','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('563359','PM1003','30678','519.84',
TO_DATE('8/3/2018','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('746353','PM1003','30679','493.85',
TO_DATE('2/4/2019','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('462633','PM1003','30680','493.85',
TO_DATE('8/3/2019','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('452999','PM1003','30681','469.16',
TO_DATE('1/30/2020','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('526314','PM1003','30682','469.16',
TO_DATE('7/28/2020','mm-dd-yyyy'),
'Checking Account');




INSERT INTO Payment_Receipt Values
('563360','PM1004','40145','1272.00',
TO_DATE('10/24/2017','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('746357','PM1004','40156','1644.80',
TO_DATE('10/24/2018','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('462635','PM1004','40167','1587.56',
TO_DATE('10/24/2019','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('453002','PM1004','40178','1033.18',
TO_DATE('10/23/2020','mm-dd-yyyy'),
'Credit Card');







INSERT INTO Payment_Receipt Values
('526318','PM1005','50231','732',
TO_DATE('10/3/2017','mm-dd-yyyy'),
'Credit Card');


INSERT INTO Payment_Receipt Values
('563361','PM1005','50232','658.8',
TO_DATE('4/4/2018','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('746361','PM1005','50233','592.92',
TO_DATE('10/4/2018','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('462637','PM1005','50234','533.63',
TO_DATE('4/5/2019','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('453005','PM1005','50235','480.27',
TO_DATE('10/5/2019','mm-dd-yyyy'),
'Credit Card');

INSERT INTO Payment_Receipt Values
('526322','PM1005','50236','432.24',
TO_DATE('4/5/2020','mm-dd-yyyy'),
'Credit Card');




INSERT INTO Payment_Receipt Values
('746365','PM1006','60132','204',
TO_DATE('10/21/2019','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('462639','PM1006','60133','204',
TO_DATE('11/20/2019','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('453008','PM1006','60134','204',
TO_DATE('12/20/2019','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('526326','PM1006','60135','204',
TO_DATE('1/19/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('563363','PM1006','60136','204',
TO_DATE('2/18/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('746369','PM1006','60137','204',
TO_DATE('3/19/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('462641','PM1006','60138','1101.60',
TO_DATE('4/23/2020','mm-dd-yyyy'),
'Checking Account');


INSERT INTO Payment_Receipt Values
('453011','PM1006','60139','1101.60',
TO_DATE('5/23/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('526330','PM1006','60140','1101.60',
TO_DATE('6/22/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('563364','PM1006','60141','1101.60',
TO_DATE('7/22/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('746373','PM1006','60142','1101.60',
TO_DATE('8/21/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('462643','PM1006','60143','1101.60',
TO_DATE('9/20/2020','mm-dd-yyyy'),
'Checking Account');

INSERT INTO Payment_Receipt Values
('453014','PM1006','60144','1046.52',
TO_DATE('10/23/2020','mm-dd-yyyy'),
'Checking Account');



--SELECT * FROM Payment_Receipt;




/*================================================================*/
/*================================================================*/
/*==================     Incident Record TABLE   =======================*/


INSERT INTO Incident_Record Values 
('982364','JH4DB8580SS001230','872904534','Stamford, CT',TO_DATE('04-10-2016','MM-DD-YYYY'),
'10:11 AM','Speeding greater than 20miles limit');
INSERT INTO Incident_Record Values 
('783021','WMWRC33474TC49530','430982367','Hoboken, NJ',TO_DATE('07-07-2017','MM-DD-YYYY'),
'8:30 AM','Parking in No Parking Zone');
INSERT INTO Incident_Record Values 
('840268','4A3AA46G13E081883','639164064','AllenTown, PA',TO_DATE('09-26-2018','MM-DD-YYYY'),
'10:00 PM','Accident - Hit front vehicle');
INSERT INTO Incident_Record Values 
('492817','4A3AA46G13E081883','639164064','Albany, NY',TO_DATE('09-26-2019','MM-DD-YYYY'),
'6:21 PM','PropertyDamage');


--select * from Incident_Record;

/*================================================================*/
/*================================================================*/
/*==================     Claim TABLE   =======================*/



INSERT INTO Claim Values 
('CL6101','89002',TO_DATE('04-20-2016','MM-DD-YYYY'),
'8943','Settled');
INSERT INTO Claim Values 
('CL6102','89003',TO_DATE('07-17-2017','MM-DD-YYYY'),
'4152','Rejected');
INSERT INTO Claim Values 
('CL6103','89004',TO_DATE('10-06-2018','MM-DD-YYYY'),
'7532','Settled');
INSERT INTO Claim Values 
('CL6104','89004',TO_DATE('10-06-2019','MM-DD-YYYY'),
'9053','Rejected');


 select * from claim;

/*================================================================*/
/*================================================================*/
/*==================     Settlement TABLE   =======================*/

--DROP TABLE settlement CASCADE CONSTRAINTS;

INSERT INTO Settlement Values 
('SE7101','CL6101',TO_DATE('04-25-2016','MM-DD-YYYY'),
'8943','Invoice Paid');

INSERT INTO Settlement Values 
('SE7102','CL6103',TO_DATE('10-11-2018','MM-DD-YYYY'),
'4152','Invoice Paid');

--select * from settlement;



-- ===========================================================================
-- Section 4: Adding Constraints to TABLES
-- ===========================================================================

ALTER TABLE customer
ADD CONSTRAINT cust_fk_policy_no FOREIGN KEY (Policy_no) REFERENCES insu_policy(Policy_no);

ALTER TABLE license
ADD CONSTRAINT lic_fk_cust_id foreign key (cust_id)references Customer (cust_id);

ALTER TABLE vehicle
ADD CONSTRAINT vehicle_fk_policy_no FOREIGN KEY (Policy_no) REFERENCES insu_policy(Policy_no);

ALTER TABLE Vehicle_Driver
ADD CONSTRAINT veh_driver_fk1 foreign key (License_no) references license(License_no);

ALTER TABLE Vehicle_Driver
ADD CONSTRAINT veh_driver_fk2 foreign key (VIN_no)  references Vehicle (VIN_no); 

ALTER TABLE vehicle_lien
ADD CONSTRAINT veh_lien_fk foreign key (VIN_no)  references Vehicle (VIN_no); 
 
ALTER TABLE Quote
ADD constraint quote_fk1 foreign key (Agent_ID) references insu_agent(Agent_ID);

ALTER TABLE Quote
ADD constraint quote_fk2 foreign key (Cust_ID) references customer(Cust_ID); 

ALTER TABLE Quote
ADD constraint quote_fk3 foreign key (Prod_Type_ID) references product_type(Prod_Type_ID); 

ALTER TABLE insu_policy
ADD CONSTRAINT insu_policy_fk foreign key (VIN_no)  references Vehicle (VIN_no); 

ALTER TABLE policy_coverage
add constraint policy_cov_fk1 FOREIGN key (policy_no) REFERENCES insu_policy(policy_no);-- as associate entity defined the 2 FK

ALTER TABLE policy_coverage
add constraint policy_cov_fk2 FOREIGN key (prod_type_id) REFERENCES product_type(prod_type_id);

ALTER TABLE bill
add constraint bill_fk FOREIGN key (policy_no) REFERENCES insu_policy(policy_no);

ALTER TABLE payment_receipt
ADD CONSTRAINT pay_receipt_fk2 FOREIGN KEY (bill_no) REFERENCES bill(bill_no);

