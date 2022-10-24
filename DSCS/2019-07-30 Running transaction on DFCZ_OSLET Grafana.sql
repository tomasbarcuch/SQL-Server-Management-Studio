
--SELECT * FROM sys.sysprocesses WHERE open_tran = 1

select transaction_id, name, transaction_begin_time
 ,case transaction_type 
    when 1 then '1 = Read/write transaction'
    when 2 then '2 = Read-only transaction'
    when 3 then '3 = System transaction'
    when 4 then '4 = Distributed transaction'
end as transaction_type 
,case transaction_state 
    when 0 then '0 = The transaction has not been completely initialized yet'
    when 1 then '1 = The transaction has been initialized but has not started'
    when 2 then '2 = The transaction is active'
    when 3 then '3 = The transaction has ended. This is used for read-only transactions'
    when 4 then '4 = The commit process has been initiated on the distributed transaction'
    when 5 then '5 = The transaction is in a prepared state and waiting resolution'
    when 6 then '6 = The transaction has been committed'
    when 7 then '7 = The transaction is being rolled back'
    when 8 then '8 = The transaction has been rolled back'
end as transaction_state
,case dtc_state 
    when 1 then '1 = ACTIVE'
    when 2 then '2 = PREPARED'
    when 3 then '3 = COMMITTED'
    when 4 then '4 = ABORTED'
    when 5 then '5 = RECOVERED'
end as dtc_state 
,transaction_status, transaction_status2,dtc_status, dtc_isolation_level, filestream_transaction_id
from sys.dm_tran_active_transactions

--sp_who where dbname = 'DFCZ_OSLET'

--sp_who2




declare @sp_who2 table (SPID INT,Status VARCHAR(255),
      Login  VARCHAR(255),HostName  VARCHAR(255), 
      BlkBy  VARCHAR(255),DBName  VARCHAR(255), 
      Command VARCHAR(255),CPUTime INT, 
      DiskIO INT,LastBatch VARCHAR(255), 
      ProgramName VARCHAR(255),SPID2 INT, 
      REQUESTID INT) 
INSERT INTO @sp_who2 EXEC sp_who2
SELECT      * 
FROM        @sp_who2
-- Add any filtering of the results here :
WHERE       DBName <> 'master'
-- Add any sorting of the results here :
ORDER BY    DBName ASC



declare @tempTable table 
( SPID SMALLINT
, Status NCHAR(30)
, Login NCHAR(128)
, HostName NCHAR(128)
, BlkBy SMALLINT
, DBName VARCHAR(255)
, Command NCHAR(16)
, CPUTime INT
, Disk_IO BIGINT
, LastBatch DATETIME
, ProgramName NCHAR(128)
, REQUESTID INT
, HostProcess NCHAR(10)
, LoginTime DATETIME
, OpenTransactions SMALLINT 
)

INSERT INTO @tempTable 
SELECT SPID
, sysprocesses.STATUS
, LOGINAME
, HOSTNAME
, BLOCKED
, sysdatabases.name
, CMD
, CPU
, PHYSICAL_IO
, LAST_BATCH
, PROGRAM_NAME
, REQUEST_ID
, HOSTPROCESS
, LOGIN_TIME
, OPEN_TRAN
FROM sys.sysprocesses
JOIN master.dbo.sysdatabases
ON sysprocesses.DBID = sysdatabases.DBID

SELECT
SPID,
DATEDIFF(MINUTE,lastbatch,getdate()) as minutes,
ProgramName,
[HostName],
[Login],
Command,
[Status],
DBName
FROM @tempTable
WHERE 
DBName = 'DFCZ_OSLET' and 
[Status] in ('runnable', 'suspended') and 
DATEDIFF(MINUTE,lastbatch,getdate()) > 0
ORDER BY DATEDIFF(MINUTE,lastbatch,getdate()) desc

--KILL 135


SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, 
dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time 
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a order by start_time asc




--sp_who
--sp_who2




