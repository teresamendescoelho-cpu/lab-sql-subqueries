-- LAB SQL SUBQUERIES
-- Sakila Database


-- 1. Determine the number of copies of the film "Hunchback Impossible"

SELECT 
    f.title,
    COUNT(i.inventory_id) AS number_of_copies
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;



-- 2. List all films longer than the average film length

SELECT 
    title,
    length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);



-- 3. Display all actors who appear in the film "Alone Trip"

SELECT 
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);



-- BONUS 4. Identify all movies categorized as Family films

SELECT 
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);



-- BONUS 5A. Customers from Canada using SUBQUERIES

SELECT 
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);



-- BONUS 5B. Customers from Canada using JOINS

SELECT
    c.first_name,
    c.last_name,
    c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';



-- BONUS 6. Films starred by the most prolific actor

SELECT 
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);



-- BONUS 7. Films rented by the most profitable customer

SELECT 
    f.title
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM inventory i
    WHERE i.inventory_id IN (
        SELECT r.inventory_id
        FROM rental r
        WHERE r.customer_id = (
            SELECT customer_id
            FROM payment
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1
        )
    )
);



-- BONUS 8. Customers who spent more than the average customer spending

SELECT 
    customer_id,
    total_amount_spent
FROM (
    SELECT
        customer_id,
        SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
) AS customer_total
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS average_customer
);