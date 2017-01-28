--
-- DB: sakila
-- SQL Server
-- Author : Ahmed Mustafa
--

-- Before optimization
SELECT 
*
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id JOIN actor a ON a.actor_id = fa.actor_id JOIN dbo.language l ON f.original_language_id = l.language_id
ORDER BY f.title

-- After optimization (we free cache before query to get performance statistics)
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
GO
DBCC FREEPROCCACHE;
GO
DBCC FREESYSTEMCACHE ('ALL');
GO
DBCC FREESESSIONCACHE;
GO       
SET STATISTICS TIME ON;  
GO  
SELECT
*
FROM film f
LEFT JOIN film_actor fa ON fa.film_id = f.film_id LEFT JOIN actor a ON a.actor_id = fa.actor_id LEFT JOIN dbo.language l ON f.original_language_id = l.language_id
ORDER BY f.title

Select *
from sys.dm_os_performance_counters WHERE instance_name = 'sakila' and counter_name like 'Cache%';