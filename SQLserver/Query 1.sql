--
-- DB: sakila
-- SQL Server
-- Author : Ahmed Mustafa
--

-- Before optimization
SELECT cntry.country_id, MAX(r.return_date)
FROM dbo.rental AS r,
dbo.payment AS p,
dbo.staff AS stf,
dbo.store AS stor,
dbo.address AS ad,
dbo.city AS cit,
dbo.country AS cntry,
dbo.inventory AS inv,
dbo.film AS f,
dbo.language AS lang

WHERE

lang.name LIKE 'A%' AND
r.rental_id = p.rental_id AND
p.staff_id = stf.staff_id AND
stf.store_id = stor.store_id AND
stor.address_id = ad.address_id AND
ad.city_id = cit.city_id AND
cit.country_id = cntry.country_id AND
inv.store_id = stor.store_id AND
inv.film_id = f.film_id AND
lang.language_id = f.language_id

GROUP BY cntry.country_id

-- After optimization - Approach A
WITH X AS
(
	SELECT DISTINCT film_id,store.store_id,staff.staff_id,city.country_id
	FROM dbo.store INNER JOIN dbo.inventory ON inventory.store_id = store.store_id
	INNER JOIN dbo.staff ON store.store_id = staff.store_id
	INNER JOIN dbo.address ON address.address_id = store.address_id
	INNER JOIN dbo.city ON city.city_id = address.city_id
)
,Y AS
(
	SELECT rental_date,payment.staff_id
	FROM dbo.payment INNER JOIN dbo.rental ON payment.rental_id = rental.rental_id
)
,Z AS
(
	SELECT film_id
	FROM dbo.language,dbo.film
	WHERE film.language_id = language.language_id AND name LIKE 'A%'
)

SELECT X.country_id,MAX(Y.rental_date)
FROM X INNER JOIN Y ON Y.staff_id = X.staff_id
INNER JOIN Z ON Z.film_id = X.film_id
GROUP BY X.country_id

-- After optimization - Approach B
	-- prepare tables before join
	--Q1
	SELECT rental_id,return_date
	INTO #r
	FROM dbo.rental
	ORDER BY rental_id ASC, return_date DESC

	--Q2
	SELECT rental_id,staff_id
	INTO #p
	FROM dbo.payment
	ORDER BY rental_id ASC, staff_id ASC

	--Q3
	SELECT staff_id,store_id
	INTO #stf
	FROM dbo.staff
	ORDER BY staff_id ASC, store_id ASC

	--Q4
	SELECT	store_id,address_id
	INTO #stor
	FROM dbo.store
	ORDER BY store_id ASC

	--Q5
	SELECT address_id,country_id
	INTO #ad
	FROM dbo.address,dbo.city
	WHERE address.city_id = city.city_id
	ORDER BY address_id ASC, country_id ASC

	--Q6
	SELECT	store_id,film_id
	INTO #inv
	FROM dbo.inventory
	ORDER BY store_id ASC,film_id ASC

	--Q7
	SELECT film_id
	INTO #f
	FROM dbo.film INNER JOIN dbo.language ON film.language_id = language.language_id
	WHERE dbo.language.name LIKE 'A%'
	ORDER BY film_id ASC

	--Q8
	SELECT
	country_id,MAX(return_date)
	FROM
	#r, #p, #stf, #stor, #ad, #inv, #f
	WHERE
	#r.rental_id = #p.rental_id AND
	#p.staff_id = #stf.staff_id AND
	#stf.store_id = #stor.store_id AND
	#stor.address_id = #ad.address_id AND
	#inv.store_id = #stor.store_id AND
	#inv.film_id = #f.film_id

	GROUP BY #ad.country_id

	GO
	DROP TABLE #r, #p, #stf, #stor, #ad, #inv, #f
	