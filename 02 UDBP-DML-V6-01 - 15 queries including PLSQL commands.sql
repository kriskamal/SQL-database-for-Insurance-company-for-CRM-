-- UDBP Project : Database design for Auto Insurance Company CRM Policy Management
-- DML statements script file
-- SELECT statements for various queries

-- Section 1 to 4 are in the DDL script File
-- Section 5: Total of 16 queries using Advanced SQL statements  : Goto Row 9   in this script file
-- Section 6: Advanced features Using PL SQL commands            : Goto Row 197 in this script file

-- ===========================================================================
-- SECTION 5:  Total of 16 queries using Advanced SQL statements
-- 10 of these queries use JOIN command.s
-- ===========================================================================


-- ===========================================================================
-- Q1. What are the Policy Number, Customer ID, First and Last name, 
-- Bill Date for the current unpaid "Pending" bills ?
-- ===========================================================================
--SELECT * from POLICY_AMEND;

SELECT C.POLICY_NO, CUST_ID, FIRST_NM, LAST_NM, B.BILL_DATE
FROM CUSTOMER C INNER JOIN BILL B
ON C.POLICY_NO = B.POLICY_NO
WHERE B.STATUS = 'Pending';


-- ===========================================================================
-- Q2. Identify Customers who have both Credit Card and Bank Account as payment 
-- methods. Then list the Card holder name, Card number, Bank Account holder 
-- name and bank Account number. 
-- ===========================================================================
--SELECT * FROM PAYMENT_METHOD;
--SELECT * FROM CREDIT_CARD;
--SELECT * FROM BANK_ACCOUNT;

SELECT C.PAY_METHOD_ID, C.HOLDER_NAME AS CARD_HOLDER_NAME, C.CARD_NO, B.HOLDER_NM AS ACCOUNT_HOLDER_NAME, B.ACCOUNT_NO
FROM CREDIT_CARD C INNER JOIN BANK_ACCOUNT B
ON C.PAY_METHOD_ID = B.PAY_METHOD_ID;


-- ===========================================================================
-- Q3. Out of all claims filed, what is the percentage that was settled? 
-- ===========================================================================

SELECT  COUNT(CASE WHEN STATUS = 'Settled' THEN 1 END)/COUNT(CLAIM_NO) *100 || '%' AS SETTLED_PERCENT 
FROM CLAIM;

-- ===========================================================================
-- Q4. Calculate and display the Total Net settlement amount the company paid in the last 3 years?
-- ===========================================================================
--SELECT * FROM SETTLEMENT;

SELECT SUM(AMOUNT)
FROM SETTLEMENT
WHERE (SYSDATE-SETTLE_DATE)/365 < 3.0;


-- ===========================================================================
--Q5.  Identify All customers of NY state registered in 2018 with their first & last name ,cust_id & License no.
-- ===========================================================================

SELECT customer.first_nm, customer.last_nm,license.license_no,license.cust_id,issue_state,latest_issue_date
FROM Customer INNER JOIN License 
ON license.cust_id = customer.cust_id
WHERE issue_state = 'NY'
AND EXTRACT(YEAR FROM latest_issue_date) ='2018';


-- ===========================================================================
--Q6. Retrieve the customer first and last name with license no,cust_ID, DOB, latest issue date & 
-- issuing country  with international licenses.
-- ===========================================================================

SELECT customer.First_nm, customer.Last_nm, License.license_no,License.cust_id,License.DOB,License.latest_issue_date,License.Issue_state,License.Issue_country
FROM customer,License
WHERE license.cust_id = customer.cust_id
AND issue_country <> 'USA';



-- ===========================================================================
--Q7.  Identify the customer ID, customer full name in one column (first + last), 
-- first issue date and years of total experience for the customer with maximum 
-- driving experience.
-- ===========================================================================

SELECT customer.cust_id, customer.first_nm ||' ' || customer.last_nm AS  Customer_Name, license.First_issue_date,  ROUND ((sysdate - license.First_issue_date)/365,0) AS Year_Exp
FROM customer,license
WHERE license.cust_id = customer.cust_id 
AND first_issue_date IN (SELECT MIN(First_issue_date) FROM License);


-- ===========================================================================
-- Q8. For all policies with Silver Coverage, determine the VIN number, 
-- policy number, customer ID, customer first name, customer last name:
-- ===========================================================================

SELECT PC.PROD_TYPE_ID, PT.PROD_TYPE_NAME, P.VIN_NO, P.POLICY_NO, C.CUST_ID, C.FIRST_NM, C.LAST_NM 
FROM INSU_POLICY P INNER JOIN CUSTOMER C
ON P.POLICY_NO = C.POLICY_NO
INNER JOIN POLICY_COVERAGE PC
ON P.POLICY_NO = PC.POLICY_NO
RIGHT JOIN PRODUCT_TYPE PT
ON PC.PROD_TYPE_ID = PT.PROD_TYPE_ID
WHERE PC.PROD_TYPE_ID = 'P102S';


-- ===========================================================================
-- Q9. Identify all the VIN nos. having a mortgage from Bank of America.
-- ===========================================================================
Select vin_no, lien_holder 
from vehicle_lien
where lien_holder = 'Bank Of America';


-- ===========================================================================
-- Q10. List all the license numbers with expiration in 2022
-- ===========================================================================
Select license_no,expiry_date
from license
where EXTRACT(year from expiry_date) = '2022';

-- ===========================================================================
--Q11.  Display first name, last name, email ids with aliases of all customers in PA state?
-- ===========================================================================

Select first_nm,last_nm,email,state_nm from customer
where state_nm = 'PA';

-- ===========================================================================
--Q12. Rank the order of the most common vehicle type to purchase policy with the company.
-- ===========================================================================

Select vehicle_type,count(vehicle_type) AS "NO.OF POLICY PURCHASED" 
from vehicle
group by vehicle_type
order by count(vehicle_type) Desc;


-- ===========================================================================
-- Q13. Determine the Customer ID, name of top 3 customers on the basis of premium amount?
-- ===========================================================================

--SELECT * FROM CUSTOMER;

SELECT C.CUST_ID, IP.POLICY_NO, C.FIRST_NM, C.LAST_NM, PREMIUM_AMOUNT,
    RANK() OVER (ORDER BY PREMIUM_AMOUNT DESC) AS TOP_CUSTOMERS
FROM INSU_POLICY IP JOIN CUSTOMER C
ON IP.POLICY_NO = C.POLICY_NO
WHERE ROWNUM <4;

-- ===========================================================================
-- Q14. How many quotes (given to potential customers) were converted into policies successfully?
-- ===========================================================================

--SELECT * FROM QUOTE;
--SELECT * FROM INSU_POLICY;


SELECT COUNT(QUOTE_ID) AS NO_OF_SUCCESS_POLICY
FROM CUSTOMER C JOIN INSU_POLICY IP
ON C.POLICY_NO = IP.POLICY_NO JOIN QUOTE Q
ON C.CUST_ID = Q.CUST_ID;

-- ===========================================================================
-- Q15. Provide the customer id, customer first name and last name whose claim was “rejected”?
-- ===========================================================================

--SELECT * FROM CLAIM;

SELECT CL.CLAIM_NO, C.POLICY_NO, C.CUST_ID, C.first_nm, C.last_nm, CL.STATUS
FROM INSU_POLICY IP JOIN CLAIM CL
ON IP.POLICY_NO = CL.POLICY_NO JOIN CUSTOMER C
ON IP.POLICY_NO = C.POLICY_NO
WHERE CL.STATUS = 'Rejected';


-- ===========================================================================
-- Q16. Which is the most common product coverage with maximum subscription among all ACTIVE policies ?
-- ===========================================================================

SELECT PROD_TYPE_ID, (COUNT(PROD_TYPE_ID))
FROM POLICY_COVERAGE
WHERE POLICY_STATUS = 'Active'
GROUP BY PROD_TYPE_ID
HAVING (COUNT(PROD_TYPE_ID)) =
(
    SELECT MAX (COUNT(PROD_TYPE_ID))
    FROM POLICY_COVERAGE
    WHERE POLICY_STATUS = 'Active'
    GROUP BY PROD_TYPE_ID
);




-- ===========================================================================
-- Section 6: Advanced features Using PL SQL commands
-- ===========================================================================

-- Set to ON, in order to display in the SQL client
SET SERVEROUTPUT ON;
   
-- ===========================================================================
-- Feature 1: To find the Total Revenue from 2015 to 2020 and for each individual year.
-- ===========================================================================

DECLARE
    TOTAL_REVENUE NUMBER(10,2);
    TOTAL2015 NUMBER(10,2);
    TOTAL2016 NUMBER(10,2);
    TOTAL2017 NUMBER(10,2);
    TOTAL2018 NUMBER(10,2);
    TOTAL2019 NUMBER(10,2);
    TOTAL2020 NUMBER(10,2); 
    CURSOR C_BILL
    IS
        SELECT 
            BILL_NO, BILL_AMOUNT, BILL_DATE
        FROM
            BILL;
BEGIN
    TOTAL_REVENUE := 0;
    TOTAL2015 := 0;
    TOTAL2016 := 0;
    TOTAL2017 := 0;
    TOTAL2018 := 0;
    TOTAL2019 := 0;
    TOTAL2020 := 0;
    FOR BILL_ROW IN C_BILL
    LOOP
        if BILL_ROW.BILL_DATE > TO_DATE('01-01-2015', 'MM-DD-YYYY') AND 
        BILL_ROW.BILL_DATE < TO_DATE('12-31-2015','MM-DD-YYYY')then
            TOTAL2015 := TOTAL2015 + BILL_ROW.BILL_AMOUNT;
        elsif BILL_ROW.BILL_DATE > TO_DATE('01-01-2016', 'MM-DD-YYYY') AND 
        BILL_ROW.BILL_DATE < TO_DATE('12-31-2016','MM-DD-YYYY')then
            TOTAL2016 := TOTAL2016 + BILL_ROW.BILL_AMOUNT;
        elsif BILL_ROW.BILL_DATE > TO_DATE('01-01-2017', 'MM-DD-YYYY') AND 
        BILL_ROW.BILL_DATE < TO_DATE('12-31-2017','MM-DD-YYYY')then
            TOTAL2017 := TOTAL2017 + BILL_ROW.BILL_AMOUNT;
        elsif BILL_ROW.BILL_DATE > TO_DATE('01-01-2018', 'MM-DD-YYYY') AND 
        BILL_ROW.BILL_DATE < TO_DATE('12-31-2018','MM-DD-YYYY')then
            TOTAL2018 := TOTAL2018 + BILL_ROW.BILL_AMOUNT;
        elsif BILL_ROW.BILL_DATE > TO_DATE('01-01-2019', 'MM-DD-YYYY') AND 
        BILL_ROW.BILL_DATE < TO_DATE('12-31-2019','MM-DD-YYYY')then
            TOTAL2019 := TOTAL2019 + BILL_ROW.BILL_AMOUNT;
        else
            TOTAL2020 := TOTAL2020 + BILL_ROW.BILL_AMOUNT;
        END IF;
        TOTAL_REVENUE := TOTAL_REVENUE + BILL_ROW.BILL_AMOUNT;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTAL REVENUE FROM 2015 TO 2020 IS: $ ' ||TOTAL_REVENUE);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2015 YEAR IS: $ ' ||TOTAL2015);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2016 YEAR IS: $ ' ||TOTAL2016);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2017 YEAR IS: $ ' ||TOTAL2017);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2018 YEAR IS: $ ' ||TOTAL2018);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2019 YEAR IS: $ ' ||TOTAL2019);
    DBMS_OUTPUT.PUT_LINE('       => REVENUE FOR 2020 YEAR IS: $ ' ||TOTAL2020);
END;
/
     
--=================================================================
-- Feature 2: To log the changes done to "customer" table as part of audit function 
-- using "Trigger" command.
--=================================================================

DROP TABLE audits CASCADE CONSTRAINTS;

CREATE TABLE audits(
      table_name       VARCHAR2(255),
      transaction_name VARCHAR2(10),
      by_user          VARCHAR2(30),
      transaction_date DATE
);

CREATE OR REPLACE TRIGGER customers_audit_trg
    AFTER 
    UPDATE OR DELETE 
    ON customer
    FOR EACH ROW    
DECLARE
   l_transaction VARCHAR2(10);
BEGIN
   -- determine the transaction type
   l_transaction := CASE  
         WHEN UPDATING THEN 'UPDATE'
         WHEN DELETING THEN 'DELETE'
   END;

   -- insert a row into the audit table   
   INSERT INTO audits (table_name, transaction_name, by_user, transaction_date)
   VALUES('CUSTOMER', l_transaction, USER, SYSDATE);
END;
/

SELECT * FROM customer;

UPDATE
    customer
SET
    email = 'new1@email.com'
WHERE
    cust_id = 1501;
    
SELECT * FROM audits;  