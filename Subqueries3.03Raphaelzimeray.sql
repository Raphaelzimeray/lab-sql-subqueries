-- 1er question 

SELECT COUNT(*) AS num_copies
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

-- 2 e question 

SELECT *
FROM film 
WHERE length > (SELECT AVG(length) FROM film);

-- 3 e question 

-- join method 

SELECT a.actor_id, a.last_name, a.first_name
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id 
WHERE f.title = "Alone Trip";

-- subqueri method

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 4 e question 

-- join method

SELECT f.film_id, f.title, f.description
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name like "%family%";

-- subqueries method 

SELECT film_id, title, description
FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id =(SELECT category_id FROM category WHERE name like "%family%"));


-- 5 e question 

-- join method 

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country ctr ON ct.country_id = ctr.country_id
WHERE ctr.country like "%Canada%";

-- subquerie method 

SELECT first_name, last_name, email
FROM customer 
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country like "%Canada%")));

-- 6 e question 

-- count the number of film for each actor and limit the result to the first

SELECT actor_id, COUNT(*) AS count_actor
FROM film_actor
GROUP BY actor_id
ORDER BY count_actor LIMIT 1;

SELECT f.film_id, f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM (
        SELECT actor_id, COUNT(*) AS film_count
        FROM film_actor
        GROUP BY actor_id
        ORDER BY film_count DESC
        LIMIT 1
    ) AS most_prolific_actor_of_film
);


-- 7 e question 

-- movies rented by the most profitable customer 

SELECT customer_id, SUM(AMOUNT) AS total_payment
FROM payment
GROUP BY customer_id
ORDER BY total_payment LIMIT 1;

SELECT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (
	SELECT customer_id 
    FROM (
		SELECT customer_id, SUM(AMOUNT) AS total_payment
		FROM payment
		GROUP BY customer_id
		ORDER BY total_payment LIMIT 1)
        AS most_bankable_customer
	);
    

-- 8 e question 


SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount > (
    SELECT AVG(amount)
    FROM payment
);






