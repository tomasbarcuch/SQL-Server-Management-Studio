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
spid,
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
[Status] in ('runnable','suspended') and 
DATEDIFF(MINUTE,lastbatch,getdate()) > 0
ORDER BY DATEDIFF(MINUTE,lastbatch,getdate()) desc