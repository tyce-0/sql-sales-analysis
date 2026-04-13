--3.Display in descending order of seniority the male employees whose net salary (salary + commission) is greater than or equal to 8000.
--The resulting table should include the following columns: Employee Number, First Name and Last Name, Age, and Seniority.

select EMPLOYEE_int as employee_number,FIRST_NAME,LAST_NAME,
--calculating seniority 
datediff(YEAR,HIRE_date,GETDATE()) AS SENIORITY,
--CALCULATING NET SALARY
SALARY + ISNULL(COMMISSION,0) AS NET_SALARY
FROM EMPLOYEES

where SALARY + isnull(COMMISSION,0)>=8000
and TITLE='Mr.'

ORDER BY SENIORITY



--4. Display products that meet the following criteria: (C1) quantity is packaged in bottle(s), 
--(C2) the third character in the product name is 't' or 'T', (C3) supplied by suppliers 1, 2, or 3, 
--(C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null). 
--The resulting table should include the following columns: product number, product name, supplier number, units ordered
--and unit price.


select PRODUCT_REF AS PRODUCT_NUMBER ,
PRODUCT_NAME,
SUPPLIER_int AS SUPPLIER_NUMBER,
UNITS_ON_ORDER AS UNITS_ORDERED,
UNIT_PRICE
FROM PRODUCTS
WHERE
--(C1)Quantity packed in bottles
QUANTITY LIKE '%bottles%'
--(C2) the third character in the product name is 't' or 'T'
AND (PRODUCT_NAME LIKE '__t%' OR PRODUCT_NAME LIKE '__T%')
--(C3) supplied by suppliers 1, 2, or 3
AND SUPPLIER_int IN (1,2,3)
--(C4) unit price ranges between 70 and 200
AND UNIT_PRICE BETWEEN 70 AND 200
 --(C5) units ordered are specified (not null). 
 AND UNITS_ON_ORDER IS NOT NULL


 --5.Display customers who reside in the same region as supplier 1, meaning they share the same country, city, 
 --and the last three digits of the postal code. 
 --The query should utilize a single subquery. 
 --The resulting table should include all columns from the customer table.

SELECT *
FROM CUSTOMERS C
WHERE EXISTS (
    SELECT 1
    FROM SUPPLIERS S
    WHERE S.SUPPLIER_int = 1
      AND C.COUNTRY = S.COUNTRY
      AND C.CITY = S.CITY
      AND RIGHT(C.POSTAL_CODE, 3) = RIGHT(S.POSTAL_CODE, 3)

 --using multiple subqueries --less efficient manner
 SELECT *
FROM CUSTOMERS
WHERE COUNTRY = (SELECT COUNTRY FROM SUPPLIERS WHERE SUPPLIER_int = 1)
  AND CITY = (SELECT CITY FROM SUPPLIERS WHERE SUPPLIER_int = 1)
  AND RIGHT(POSTAL_CODE, 3) =
      (SELECT RIGHT(POSTAL_CODE, 3) FROM SUPPLIERS WHERE SUPPLIER_int = 1);

--6.For each order number between 10998 and 11003, do the following:  
--Display the new discount rate, which should be 0% if the total order amount before 
--discount (unit price * quantity) is between 0 and 2000, 5% if between 2001 and 10000, 10% if between 10001 and 40000, 
--15% if between 40001 and 80000, and 20% otherwise.
--Display the message "apply old discount rate" if the order number is between 10000 and 10999, 
--and "apply new discount rate" otherwise. The resulting table should display the columns: order number, 
--new discount rate, and discount rate application note.

SELECT ORDER_int,
--new discount rate based on total order amount before discount
CASE
WHEN total_amount BETWEEN 0 AND 2000 THEN 0
WHEN total_amount BETWEEN 2001 AND 10000 THEN 0.05
WHEN total_amount BETWEEN 10001 AND 40000 THEN 0.10
WHEN total_amount BETWEEN 40001 AND 80000 THEN 0.15
ELSE 0.20   
end as new_discount_rate,

--Message for displaying the message "discount rate application note."
CASE 
WHEN ORDER_int BETWEEN 10000 AND 10999 THEN 'apply old discount rate'
ELSE 'apply new discount rate' 
END AS discount_note

--subquery for calculating total order amount before discount
FROM (SELECT ORDER_int, SUM(UNIT_PRICE * QUANTITY) AS total_amount 
from ORDER_DETAILS
where ORDER_int BETWEEN 10998 AND 11003
group by ORDER_int) AS order_totals;


--7 -Display suppliers of beverage products. The resulting table should display 
--the columns: supplier number, company, address, and phone number.


SELECT DISTINCT P.SUPPLIER_int as SUPPLIER_NUMBER,S.COMPANY,S.PHONE AS PHONE_NUMBER
FROM PRODUCTS P
JOIN SUPPLIERS S 
ON P.SUPPLIER_int = S. SUPPLIER_int
JOIN CATEGORIES C
ON P.CATEGORY_CODE = C.CATEGORY_CODE
WHERE  CATEGORY_NAME = 'Beverages'
GROUP BY P.SUPPLIER_int ,S.COMPANY,S.PHONE;
 





--8.Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product.
--The resulting table should display the column: customer code.

SELECT C.CUSTOMER_CODE 
FROM CUSTOMERS C
LEFT JOIN ORDERS O
ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS OD
ON O.ORDER_int = OD.ORDER_int 
LEFT JOIN PRODUCTS P
ON OD.PRODUCT_REF = P.PRODUCT_REF
LEFT JOIN CATEGORIES CA
ON P.CATEGORY_CODE = CA.CATEGORY_CODE
AND CA.CATEGORY_NAME = 'Desserts'
WHERE C.CITY = 'Berlin'
GROUP BY C.CUSTOMER_CODE
HAVING COUNT(CA.CATEGORY_CODE)<=1



--9.Display customers who reside in France and the total amount of orders they placed every Monday in 
--April 1998 (considering customers who haven't placed any orders yet).
--The resulting table should display the columns: customer number, company name, phone number, total amount, and country.

SELECT C.CUSTOMER_CODE,
C.COMPANY,
C.PHONE,
ISNULL(SUM(OD.UNIT_PRICE * OD.QUANTITY),0) AS TOTAL_AMOUNT,
C.COUNTRY
FROM CUSTOMERS C
LEFT JOIN ORDERS O
ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
AND O.ORDER_DATE  BETWEEN '1998-04-01' AND '1998-04-30'
AND DATENAME(WEEKDAY,O.ORDER_DATE) = 'Monday'
LEFT JOIN ORDER_DETAILS OD
ON O.ORDER_int = OD.ORDER_int
WHERE C.COUNTRY = 'France'
GROUP BY  C.CUSTOMER_CODE,
C.COMPANY,
C.PHONE,
C.COUNTRY;

--10-Display customers who have ordered all products. 
--The resulting table should display the columns: customer code, company name, and telephone number.
   

SELECT C.CUSTOMER_CODE,
C.COMPANY,
C.PHONE
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_CODE= O.CUSTOMER_CODE
JOIN ORDER_DETAILS OD
ON O.ORDER_int =OD.ORDER_int
JOIN PRODUCTS P
ON OD.PRODUCT_REF = P.PRODUCT_REF
GROUP BY 
C.CUSTOMER_CODE,
C.COMPANY,
C.PHONE
HAVING COUNT (DISTINCT OD.PRODUCT_REF)=(
  SELECT COUNT (*) FROM PRODUCTS)


--11. Display for each customer from France the number of orders they have placed. 
--The resulting table should display the columns: customer code and number of orders.
 

 SELECT C.CUSTOMER_CODE,COUNT(O.ORDER_int) AS Number_of_orders
 FROM CUSTOMERS C
  LEFT JOIN ORDERS O
 on C.CUSTOMER_CODE = O.CUSTOMER_CODE
 where C.COUNTRY = 'France'
 group by C.CUSTOMER_CODE 


--12.Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. 
--The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.

SELECT
--for orders in 1996
SUM( CASE 
WHEN YEAR(ORDER_DATE) = 1996 THEN 1 
ELSE 0 END) AS ORDERS_IN_1996,

--for orders in 1997
SUM( CASE 
WHEN YEAR (ORDER_DATE) =1997 THEN 1
ELSE 0 END) AS ORDERS_IN_1997,

--calculating the difference
SUM( CASE 
WHEN YEAR(ORDER_DATE) = 1996 THEN 1 
ELSE 0 END) -
SUM( CASE 
WHEN YEAR (ORDER_DATE) =1997 THEN 1
ELSE 0 END) AS THE_DIFFERENCE

FROM ORDERS ;

    