-- disable all constraints
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- enable all constraints
exec sp_MSforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

-- list all the indexes for a specified table:
select * from sys.indexes
where object_id = (select object_id from sys.objects where name = 'MYTABLE')

-- list all foreign keys
SELECT * FROM sys.foreign_keys
SELECT * FROM sys.foreign_key_columns

-- rows count
SELECT  
	( SELECT COUNT(*) FROM   actor   		) AS actor,
    ( SELECT COUNT(*) FROM   address 		) AS address,
	( SELECT COUNT(*) FROM   category   	) AS category,
    ( SELECT COUNT(*) FROM   city 			) AS city,
	( SELECT COUNT(*) FROM   country   		) AS country,
    ( SELECT COUNT(*) FROM   customer		) AS customer,
	( SELECT COUNT(*) FROM   film   		) AS film,
    ( SELECT COUNT(*) FROM   film_actor 	) AS film_actor,
	( SELECT COUNT(*) FROM   film_category  ) AS film_category,
    ( SELECT COUNT(*) FROM   film_text 		) AS film_text,
	( SELECT COUNT(*) FROM   inventory 		) AS inventory,
    ( SELECT COUNT(*) FROM   language 		) AS language,
	( SELECT COUNT(*) FROM   payment   		) AS payment,
    ( SELECT COUNT(*) FROM   rental 		) AS rental,
	( SELECT COUNT(*) FROM   staff   		) AS staff,
    ( SELECT COUNT(*) FROM   store		 	) AS store
	
--table row size
dbcc showcontig ('actor') with TABLERESULTS
dbcc showcontig ('address') with TABLERESULTS
dbcc showcontig ('category') with tableresults
dbcc showcontig ('city') with TABLERESULTS
dbcc showcontig ('country') with TABLERESULTS
dbcc showcontig ('customer') with tableresults
dbcc showcontig ('film') with TABLERESULTS
dbcc showcontig ('film_actor') with TABLERESULTS
dbcc showcontig ('film_category') with tableresults
dbcc showcontig ('film_text') with TABLERESULTS
dbcc showcontig ('inventory') with TABLERESULTS
dbcc showcontig ('language') with tableresults
dbcc showcontig ('payment') with TABLERESULTS
dbcc showcontig ('rental') with TABLERESULTS
dbcc showcontig ('staff') with tableresults
dbcc showcontig ('store') with tableresults

-- all tables memory data
create table #t
(
  name nvarchar(128),
  rows varchar(50),
  reserved varchar(50),
  data varchar(50),
  index_size varchar(50),
  unused varchar(50)
)

declare @id nvarchar(128)
declare c cursor for
select name from sysobjects where xtype='U'

open c
fetch c into @id

while @@fetch_status = 0 begin

  insert into #t
  exec sp_spaceused @id

  fetch c into @id
end

close c
deallocate c

select * from #t
--order by convert(int, substring(data, 1, len(data)-3)) desc
ORDER BY name

drop table #t

-----------------------------------------------------------------------------

-- trace events

DECLARE @filename NVARCHAR(1000);
DECLARE @bc INT;
DECLARE @ec INT;
DECLARE @bfn VARCHAR(1000);
DECLARE @efn VARCHAR(10);
-- Get the name of the current default trace
SELECT @filename = CAST(value AS NVARCHAR(1000))
FROM ::fn_trace_getinfo(DEFAULT)
WHERE traceid = 1 AND property = 2;
-- rip apart file name into pieces
SET @filename = REVERSE(@filename);
SET @bc = CHARINDEX('.',@filename);
SET @ec = CHARINDEX('_',@filename)+1;
SET @efn = REVERSE(SUBSTRING(@filename,1,@bc));
SET @bfn = REVERSE(SUBSTRING(@filename,@ec,LEN(@filename)));
-- set filename without rollover number
SET @filename = @bfn + @efn
-- process all trace files
SELECT 
ftg.StartTime
,te.name AS EventName
,DB_NAME(ftg.databaseid) AS DatabaseName 
,ftg.Filename
,(ftg.IntegerData*8)/1024.0 AS GrowthMB 
,(ftg.duration/1000)AS DurMS
FROM ::fn_trace_gettable(@filename, DEFAULT) AS ftg 
INNER JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id
WHERE (
ftg.EventClass = 92 -- Date File Auto-grow
OR ftg.EventClass = 93 -- Log File Auto-grow
OR ftg.EventClass = 25 -- lock: deadlock
OR ftg.EventClass = 94 -- data file auto-shrink
OR ftg.EventClass = 95 -- log file auto-shrink
OR ftg.EventClass = 38 -- cache hit
OR ftg.EventClass = 12 -- batch start
OR ftg.EventClass = 13 -- batch complete
OR ftg.EventClass = 40 -- stmt start
OR ftg.EventClass = 41 -- stmt complete
OR ftg.EventClass = 46 -- object create
OR ftg.EventClass = 47 -- object delete
) 

ORDER BY ftg.StartTime