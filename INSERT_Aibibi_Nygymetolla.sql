-- 1. Choose one of your favorite films and add it to the "film" table. 
-- Fill in rental rates with 4.99 and rental durations with 2 weeks.

INSERT INTO film (title, rental_rate, rental_duration, language_id)
VALUES ('10 things I hate about you', 4.99, 2, 1)
RETURNING film_id;

-- 2. Add the actors who play leading roles in your favorite film to 
-- the "actor" and "film_actor" tables (three or more actors in total).

INSERT INTO actor (first_name, last_name)
VALUES 
    ('Heath', 'Ledger'),
    ('Julia', 'Stiles'),
    ('Joseph', 'Gordon-Levitt')
RETURNING actor_id;

-- 201
-- 202
-- 203

INSERT INTO film_actor (actor_id, film_id)
VALUES 
    (201, 1002), 
    (202, 1002),
    (203, 1002);


-- 3. Add your favorite movies to any store's inventory.

INSERT INTO inventory (film_id, store_id)
VALUES (1002, 1)
RETURNING inventory_id;

SELECT * FROM inventory WHERE film_id = 1002;



