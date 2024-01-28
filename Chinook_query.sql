/***********************************************************************
**Retrieving data from SQL**
***********************************************************************/

/***********************************************************************
In which country are the music store's employees located?
***********************************************************************/
SELECT DISTINCT "Country"
FROM public."Employee"

/***********************************************************************
What are the titles of all albums?
***********************************************************************/
SELECT DISTINCT "Title"
FROM "Album"

/***********************************************************************
What is the unit price per track?
***********************************************************************/
SELECT DISTINCT "UnitPrice"
FROM "Track"



/***********************************************************************
**Filtering data from SQL**
***********************************************************************/

/***********************************************************************
Compile a list of customers and their email
***********************************************************************/
SELECT "FirstName", "LastName", "Email"
FROM "Customer";
/***********************************************************************
Retract customers ehwere support rep id is equal to between 4 and 5
***********************************************************************/
SELECT *
FROM "Customer"
WHERE "SupportRepId" BETWEEN 4 AND 5
ORDER BY "SupportRepId" ASC
/***********************************************************************
Call the first 10 Customers
***********************************************************************/
SELECT *
FROM "Customer"
WHERE "SupportRepId" BETWEEN 4 AND 5
ORDER BY "SupportRepId" ASC
LIMIT 10;

/***********************************************************************
Call customers with no phone number provided
***********************************************************************/
SELECT "FirstName", "LastName", "Phone"
FROM "Customer"
WHERE "Phone" IS NULL;

/***********************************************************************
Call customers who live in Australia
***********************************************************************/
SELECT "FirstName", "LastName", "Country"
FROM "Customer"
WHERE "Country"
IN ('Australia');

/***********************************************************************
Call customers who are in Canada but not in Vancouver
***********************************************************************/
SELECT "FirstName", "LastName", "Country", "City"
FROM "Customer"
WHERE "Country"
IN ('Canada')
AND "City"
NOT IN ('Vancouver');

/***********************************************************************
What is the full name of the Customer with CustomerId 42
***********************************************************************/
SELECT "FirstName", "LastName"
FROM "Customer"
WHERE "CustomerId" = 42;

/***********************************************************************
What is the title of the employee who lives at an address starting with 
7727B
***********************************************************************/
SELECT "Title"
FROM "Employee"
WHERE "Address"
LIKE '7727B%';

/***********************************************************************
How many customer records have no postal codes?
***********************************************************************/
SELECT COUNT (*) 
FROM "Customer"
WHERE "PostalCode"
IS NULL; 

/***********************************************************************
What was the total value of orders placed in March 2009? 
***********************************************************************/
SELECT SUM("Total")
FROM "Invoice"
WHERE "InvoiceDate"
BETWEEN '2009-03-01' AND '2009-03-31';

/***********************************************************************
**Aggregating and Grouping Data**
***********************************************************************/

/***********************************************************************
What is the number of invoices where total amount was over $10
***********************************************************************/
SELECT COUNT (*)
FROM "Invoice"
WHERE "Total" > 10

/***********************************************************************
Calculate the total amount of all invoices
***********************************************************************/
SELECT SUM("Total")
FROM "Invoice"

/***********************************************************************
Minimum and Maximum Invoice Total
***********************************************************************/
SELECT MIN("Total")
FROM "Invoice"

SELECT MAX("Total")
FROM "Invoice"

/***********************************************************************
Calculate the average of invoices generated
***********************************************************************/
SELECT ROUND(AVG("Total"),2)
FROM "Invoice"

/***********************************************************************
**Combine functions**
***********************************************************************/
SELECT COUNT(*) AS "Total",
  MIN("Total") AS "Min",
  MAX("Total") AS "Max",
  ROUND(AVG("Total"),2) AS "Average",
  SUM("Total") AS "Sum"
FROM "Invoice";

/***********************************************************************
Determine the number of tracks for Albums with AlbumId of 1
***********************************************************************/
SELECT COUNT("TrackId")
FROM "Track"
WHERE "AlbumId" = 1

/***********************************************************************
Number of tracks for all albums 
***********************************************************************/
SELECT "AlbumId", COUNT("TrackId")
FROM "Track"
GROUP BY "AlbumId"

/***********************************************************************
Call first 10 albums with more than 20 tracks in descending order
***********************************************************************/
SELECT "AlbumId", COUNT("TrackId")
FROM "Track"
GROUP BY "AlbumId"
HAVING COUNT("TrackId") >= 20
ORDER BY COUNT("TrackId") DESC
LIMIT 10

/***********************************************************************
**Subqueries / nested queries**
***********************************************************************/

/***********************************************************************
Return the number of tracks released by the artist Van Halen
***********************************************************************/
SELECT "AlbumId", COUNT ("TrackId")
FROM "Track"
WHERE "AlbumId" IN (
   SELECT "AlbumId"
   FROM "Album"
   WHERE "Title" LIKE 'Van Halen%')
GROUP BY "AlbumId"

/***********************************************************************
Find the average length of an album
***********************************************************************/
SELECT ROUND(AVG("AlbumLength"),2)
FROM (
	SELECT SUM("Milliseconds") AS "AlbumLength"
    FROM "Track"
    GROUP BY "AlbumId"
 ) AS Album
 
 
 
/***********************************************************************
**Quiz**
***********************************************************************/
/***********************************************************************
Average length of tracks in the database? 
***********************************************************************/
SELECT ROUND(AVG("Milliseconds" / 1000.0), 2) AS "Seconds"
FROM "Track"

/***********************************************************************
Which album is the longest in minutes?
***********************************************************************/
SELECT SUM("Milliseconds"/1000) AS "Albumlength", "AlbumId"
FROM "Track"
GROUP BY "AlbumId"
ORDER BY "Albumlength" DESC

/***********************************************************************
How many album names start with the letter ‘M’?
***********************************************************************/
SELECT COUNT("Title")
FROM "Album"
WHERE "Title"
LIKE 'M%'

/***********************************************************************
How many invoices were created for Emma Jones?
***********************************************************************/
SELECT COUNT("CustomerId")
FROM "Invoice"
WHERE "CustomerId" IN ( 
   SELECT "CustomerId"
   FROM "Customer"
   WHERE "FirstName" = 'Emma' 
   AND "LastName" = 'Jones')
   
/***********************************************************************
What is the average number of tracks on an invoice 
(rounded to the nearest whole number)?
***********************************************************************/
SELECT ROUND(AVG("num_tracks"),0) AS "TrackPerInvoice"
FROM (
    SELECT "InvoiceId", COUNT("TrackId") AS num_tracks
	FROM "InvoiceLine"
    GROUP BY "InvoiceId")
AS "AvgTracks"