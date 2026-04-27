-- 1. Remove a previously inserted film from the inventory and all 
-- corresponding rental records

DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id FROM inventory WHERE film_id = 1002
);

DELETE FROM inventory
WHERE film_id = 1002;

SELECT * FROM inventory WHERE film_id = 1002;

-- 2. Remove any records related to you (as a customer) from all tables 
-- except "Customer" and "Inventory"

DELETE FROM payment
WHERE customer_id = 1;

DELETE FROM rental
WHERE customer_id = 1;

SELECT * FROM payment WHERE customer_id = 1;
SELECT * FROM rental WHERE customer_id = 1;