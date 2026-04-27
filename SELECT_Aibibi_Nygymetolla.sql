-- Task 1: Which staff members made the highest revenue
-- for each store and deserve a bonus for year 2017?

-- Solution 1A: Using CTE + subquery
WITH staff_revenue AS (
    SELECT s.store_id, s.staff_id, s.first_name, s.last_name,
           SUM(p.amount) AS revenue
    FROM payment p
    JOIN staff s ON p.staff_id = s.staff_id
    WHERE EXTRACT(YEAR FROM p.payment_date) = 2017
    GROUP BY s.store_id, s.staff_id, s.first_name, s.last_name
)
SELECT * FROM staff_revenue
WHERE revenue = (
    SELECT MAX(revenue) FROM staff_revenue sr2
    WHERE sr2.store_id = staff_revenue.store_id
);

-- Solution 1B: Using CTE + RANK window function
WITH staff_revenue AS (
    SELECT s.store_id, s.staff_id, s.first_name, s.last_name,
           SUM(p.amount) AS revenue
    FROM payment p
    JOIN staff s ON p.staff_id = s.staff_id
    WHERE EXTRACT(YEAR FROM p.payment_date) = 2017
    GROUP BY s.store_id, s.staff_id, s.first_name, s.last_name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY store_id ORDER BY revenue DESC) AS rnk
    FROM staff_revenue
)
SELECT store_id, staff_id, first_name, last_name, revenue
FROM ranked WHERE rnk = 1;


-- Task 2: Which five movies were rented more than the others,
-- and what is the expected age of the audience?

-- Solution 2A: Using JOIN and LIMIT
SELECT f.title, f.rating, COUNT(r.rental_id) AS rental_count,
    CASE f.rating
        WHEN 'G'     THEN 'All ages'
        WHEN 'PG'    THEN '8+'
        WHEN 'PG-13' THEN '13+'
        WHEN 'R'     THEN '17+'
        WHEN 'NC-17' THEN '18+'
    END AS expected_age
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title, f.rating
ORDER BY rental_count DESC
LIMIT 5;

-- Solution 2B: Using CTE
WITH rental_counts AS (
    SELECT f.film_id, f.title, f.rating, COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title, f.rating
)
SELECT title, rating, rental_count,
    CASE rating
        WHEN 'G'     THEN 'All ages'
        WHEN 'PG'    THEN '8+'
        WHEN 'PG-13' THEN '13+'
        WHEN 'R'     THEN '17+'
        WHEN 'NC-17' THEN '18+'
    END AS expected_age
FROM rental_counts
ORDER BY rental_count DESC
LIMIT 5;


-- Task 3: Which actors/actresses didn't act for a longer
-- period of time than the others?

-- Solution 3A: Using subquery
SELECT a.actor_id, a.first_name, a.last_name,
       MAX(f.release_year) AS last_active_year,
       (SELECT MAX(release_year) FROM film) - MAX(f.release_year) AS years_inactive
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY years_inactive DESC, last_active_year ASC
LIMIT 5;

-- Solution 3B: Using CTE and CROSS JOIN
WITH actor_activity AS (
    SELECT a.actor_id, a.first_name, a.last_name,
           MAX(f.release_year) AS last_active_year
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    GROUP BY a.actor_id, a.first_name, a.last_name
),
max_year AS (
    SELECT MAX(release_year) AS current_max FROM film
)
SELECT aa.first_name, aa.last_name, aa.last_active_year,
       (mx.current_max - aa.last_active_year) AS years_inactive
FROM actor_activity aa
CROSS JOIN max_year mx
ORDER BY years_inactive DESC
LIMIT 5;