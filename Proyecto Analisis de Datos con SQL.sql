/* ---------------------------------------------------------------------------------
 * --------------------------- DQL - Data Query Languaje ---------------------------
 * by Ivan Alducin
 */

--1. Vamos a seleccionar el nombre y apellido de los actores
select first_name,
        last_name
from actor
	
--2. Vamos a seleccionar el nombre completo del actor en una sola columna
select first_name || ' ' || last_name AS NombreCompleto
from actor

--3. Selecciona los actores que su nombre empieza con "D"
select first_name,
       last_name
from actor
where first_name like 'D%';

--4. ¿Tenemos algún actor con el mismo nombre?
select first_name,
	   count(*) As Name_Dup
from actor
group by first_name
having count(*) > 1;

--5. ¿Cuál es el costo máximo de renta de una película?

select max(amount) as CostoMaximo
from payment

--6. ¿Cuáles son las peliculas que fueron rentadas con ese costo?	

SELECT 
    f.title
FROM 
    payment p
INNER JOIN 
    rental r ON p.rental_id = r.rental_id
INNER JOIN 
    inventory i ON r.inventory_id = i.inventory_id
INNER JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    p.amount = 11.99;

--7. ¿Cuantás películas hay por el tipo de audencia (rating)?

select rating,
     count(*) as CantidadPeliculasAudiencia
from film
Group by rating

--8. Selecciona las películas que no tienen un rating R o NC-17
-- NOT IN selecciona todas las películas cuyo rating no esté en la lista que contiene R y NC-17.

select title,
	   rating
from film
where rating NOT IN ('R', 'NC-17');
	
--9. ¿Cuantos clientes hay en cada tienda?

select store_id, count(customer_id) as ClientesXTienda
from customer
group by store_id

--10. ¿Cuál es la pelicula que mas veces se rento?

SELECT f.title, COUNT(i.film_id) AS PeliculaMasRentada
FROM film f
INNER JOIN inventory i
    ON f.film_id = i.film_id
INNER JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY PeliculaMasRentada DESC
LIMIT 1;

--11. ¿Qué peliculas no se han rentado?

SELECT f.title
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;
	
--12. ¿Qué clientes no han rentado ninguna película?

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

--13. ¿Qué actores han actuado en más de 30 películas?

select a.first_name, count(fa.film_id) as Mas30Peliculas
from  actor a
	inner join film_actor fa
		on
		fa.actor_id = a.actor_id
group by a.first_name
having count(fa.film_id) > 30
order by Mas30Peliculas desc;

--14. Muestra las ventas totales por tienda

select s.store_id, sum(p.amount) as TotalVentas
from payment p
inner join rental r ON p.rental_id = r.rental_id
inner join inventory i ON r.inventory_id = i.inventory_id
inner join film f ON i.film_id = f.film_id
inner join customer c ON r.customer_id = c.customer_id
inner join store s ON c.store_id = s.store_id
group by s.store_id;

--15. Muestra los clientes que rentaron una pelicula más de una vez
with rental_counts as (
    select c.customer_id, 
           c.first_name,
           count(r.rental_id) as rental_count
    from customer c
    inner join rental r on c.customer_id = r.customer_id
    inner join inventory i on r.inventory_id = i.inventory_id
    group by c.customer_id, c.first_name,i.film_id
)
select customer_id, 
       first_name
from rental_counts
where rental_count > 1;
