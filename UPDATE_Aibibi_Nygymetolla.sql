-- 1. Alter the rental duration and rental rates of the film you 
-- inserted before to three weeks and 9.99, respectively.
UPDATE film
SET rental_duration = 3, rental_rate = 9.99
WHERE film_id = 1002;

SELECT * FROM film WHERE film_id = 1002;

-- 2. Alter any existing customer in the database with at least 10 rental and 
-- 10 payment records. Change their personal data to yours (first name, last 
-- name, address, etc.). You can use any existing address from the "address" 
-- table. Please do not perform any updates on the "address" table, as this can 
-- impact multiple records with the same address.

SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(DISTINCT r.rental_id) AS rental_count,
       COUNT(DISTINCT p.payment_id) AS payment_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT r.rental_id) >= 10 
   AND COUNT(DISTINCT p.payment_id) >= 10
LIMIT 5;

SELECT address_id, address 
FROM address 
LIMIT 10;

UPDATE customer
SET first_name = 'Aibibi',
    last_name = 'Nygymetolla',
    email = 'aibibi@email.com',
    address_id = 5  -- 1913 Hanoi Way
WHERE customer_id = 1;

SELECT * FROM customer WHERE customer_id = 1;


-- 3. Change the customer's create_date value to current_date.

UPDATE customer
SET create_date = CURRENT_DATE
WHERE customer_id = 1;
