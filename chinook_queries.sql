-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, LastName, Country FROM Customer WHERE Country != "USA";

-- Provide a query only showing the Customers from Brazil.
SELECT * FROM Customer WHERE Country = "Brazil";

-- Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT cust.FirstName, cust.LastName, inv.InvoiceId, inv.BillingCountry, inv.InvoiceDate
FROM Invoice as inv LEFT JOIN Customer as cust on inv.CustomerId = cust.CustomerId
WHERE inv.BillingCountry = "Brazil";

-- Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee WHERE Title = "Sales Support Agent";

--5 Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry FROM Invoice; 

-- Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT emp.FirstName, emp.LastName, emp.Title, inv.InvoiceId
FROM Customer as cust LEFT JOIN Invoice as inv 
ON cust.customerId = inv.customerId
LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId 
WHERE emp.Title = "Sales Support Agent";

-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT inv.Total, cust.FirstName as "Customer First Name", cust.LastName as "Customer Last Name", cust.Country, empl.FirstName as 
	"Employee First Name", empl.LastName as "Employee Last Name"
FROM Customer as cust LEFT JOIN Invoice as inv ON cust.CustomerId = inv.CustomerId
LEFT JOIN Employee as empl ON cust.SupportRepId = empl.EmployeeId;

-- How many Invoices were there in 2009 and 2011?
SELECT COUNT(InvoiceId) 
FROM Invoice
WHERE InvoiceDate BETWEEN "2009-01-01 00:00:00" AND "2009-12-31 00:00:00"
OR
InvoiceDate BETWEEN "2011-01-01 00:00:00" AND "2011-12-31 00:00:00";

-- What are the respective total sales for each of those years?
SELECT SUM(Total)
FROM Invoice
WHERE InvoiceDate GLOB "2009*" OR InvoiceDate GLOB "2011*"
GROUP BY InvoiceDate GLOB "2011*";


--10 Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceId)
FROM InvoiceLine
WHERE InvoiceId = "37";


-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT InvoiceId, COUNT(InvoiceId) as "Line Items"
FROM InvoiceLine
GROUP BY InvoiceId;

-- Provide a query that includes the purchased track name with each invoice line item.
SELECT tr.Name, invline.InvoiceLineId
FROM InvoiceLine as invline LEFT JOIN Track as tr on tr.TrackId = invline.TrackId;

-- Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT t.Name, art.Name, il.*
FROM Track as t LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Album as a ON t. AlbumId = a.AlbumId
LEFT JOIN Artist as art ON a.AlbumId = art.ArtistId;

-- Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT BillingCountry, COUNT(InvoiceId)
FROM Invoice
GROUP BY BillingCountry;

--15 Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
SELECT p.name as "Playlist Name", COUNT(pt.TrackId) as "Number of Tracks"
From Playlist as p LEFT JOIN PlaylistTrack as pt ON p.PlaylistId = pt.PlaylistId
group by p.PlaylistId

-- Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT t.Name as "Track Name", a.Title as "Album Name", mt.Name as "Media Type", g.Name as "Genre"
FROM Track as t LEFT JOIN Album as a ON t.AlbumId = a.AlbumId
LEFT JOIN MediaType as mt ON t.MediaTypeId = mt.MediaTypeId
LEFT JOIN Genre as g ON t.GenreId = g.GenreId;

-- Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT inv.InvoiceId, COUNT(line.InvoiceId)
FROM Invoice inv LEFT JOIN InvoiceLine line ON inv.InvoiceId = line.InvoiceId
GROUP BY inv.InvoiceId;

-- Provide a query that shows total sales made by each sales agent.


-- Which sales agent made the most in sales in 2009?
--     Hint: Use the MAX function on a subquery.
SELECT MAX(Basis.SumOf), Basis.FirstName, Basis.LastName
FROM (SELECT emp.FirstName, emp.LastName, SUM(inv.Total) as "SumOf"
FROM Employee emp
LEFT JOIN Customer cust ON emp.EmployeeId = cust.SupportRepId
LEFT JOIN Invoice inv ON cust.CustomerId = inv.CustomerId
WHERE inv.InvoiceDate GLOB "2009*"
GROUP BY emp.FirstName
ORDER BY SUM(inv.Total) DESC) as Basis;

--20 Which sales agent made the most in sales over all?
SELECT emp.FirstName, emp.LastName, SUM(inv.Total)
FROM Employee emp 
LEFT JOIN Customer cust ON emp.EmployeeId = cust.SupportRepId
LEFT JOIN Invoice inv ON inv.CustomerId = cust.CustomerId
ORDER BY SUM(inv.Total) DESC LIMIT 1;

-- Provide a query that shows the count of customers assigned to each sales agent.
SELECT emp.FirstName, emp.LastName, COUNT(cust.SupportRepId) as 'Total Cases'
FROM Employee emp
LEFT JOIN Customer cust ON emp.EmployeeId = cust.SupportRepId
GROUP BY emp.EmployeeId
ORDER BY COUNT(cust.SupportRepId) DESC;

-- Provide a query that shows the total sales per country.
SELECT BillingCountry, SUM(Total)
FROM invoice
GROUP BY BillingCountry;

-- Which country's customers spent the most?
SELECT BillingCountry, SUM(Total)
FROM Invoice
GROUP BY BillingCountry 
ORDER BY SUM(Total) DESC Limit 1;

-- Provide a query that shows the most purchased track of 2013.
SELECT t.Name 'Track', COUNT(*) 'Purchases'
FROM Track t, Invoice inv, InvoiceLine il
WHERE t.TrackId = il.TrackId and inv.InvoiceId = il.InvoiceId and inv.InvoiceDate GLOB "2013*"
GROUP BY t.TrackId
ORDER BY COUNT(*) desc LIMIT 1;

--25 Provide a query that shows the top 5 most purchased tracks over all.
SELECT t.Name 'Track', COUNT(*) 'Purchases'
FROM Track t, Invoice I, InvoiceLine il
WHERE t.TrackId = il.TrackId and i.InvoiceId = il.InvoiceId 
GROUP BY t.TrackId
ORDER BY COUNT(*) desc limit 5;

-- Provide a query that shows the top 3 best selling artists.
SELECT art.Name, tr.Name, SUM(inv.UnitPrice)
FROM Artist art 
INNER JOIN Album alb on art.ArtistId = alb.ArtistId
INNER JOIN Track tr on alb.AlbumId = tr.AlbumId
INNER JOIN InvoiceLine inv on inv.TrackId = tr.TrackId
GROUP BY art.Name
ORDER BY SUM(inv.UnitPrice) DESC LIMIT 3;

-- Provide a query that shows the most purchased Media Type.
SELECT mt.Name, COUNT (t.MediaTypeId) as NumberSold
FROM Track as t 
LEFT JOIN MediaType as mt ON t.MediaTypeId = mt.MediaTypeId
LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Invoice as i ON il.InvoiceId = i.InvoiceId
GROUP BY mt.Name ORDER BY NumberSold DESC LIMIT 1;
