# Tablespace / schema / DB parameters demo on PDB

It's possible to try this scenario out on the Oracle live labs  
https://developer.oracle.com/livelabs   
with the workshop:
* Pluggables, Clones and Containers: Oracle Multitenant Fundamentals
(ID 892)

  

## Login into the oracle user
```
# login into the oracle user

sudo su - oracle

```

## Set environment
```
# set environment

source ~/.set-env-db.sh CDB1

```

## Look inside the tnsnames.ora
```
# look inside the tnsnames.ora

tnsping pdb1
tnsping pdb2
cat $ORACLE_HOME/network/admin/tnsnames.ora

```
  
## Create database link
```
# setup pdb1 table, database link and directory

sql system/Ora_DB4U@pdb1
set sqlformat ANSICONSOLE
create table pdb1_tb as select * from global_name;
select * from pdb1_tb;
create database link pdb2_lnk connect to system identified by Ora_DB4U using 'pdb2';
create directory tmp_dir as '/tmp';
exit

```


## Inside a PDB - create tablespace and table

```

[CDB1:oracle@dbhol:~]$ sql system/Ora_DB4U@pdb1

SQLcl: Release 19.1 Production on Sun Jul 24 12:42:29 2022

Copyright (c) 1982, 2022, Oracle.  All rights reserved.

Last Successful login time: Sun Jul 24 2022 12:42:30 +00:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.11.0.0.0


SQL> set sqlformat ANSICONSOLE
SQL> select file_name, bytes / 1048576
  2  from dba_data_files;
FILE_NAME                                       BYTES/1048576
/opt/oracle/oradata/CDB1/PDB1/system01.dbf                350
/opt/oracle/oradata/CDB1/PDB1/sysaux01.dbf                550
/opt/oracle/oradata/CDB1/PDB1/undotbs01.dbf               215
/opt/oracle/oradata/CDB1/PDB1/users01.dbf             2258.75


SQL> create tablespace demo_tbs datafile
  2  '/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf'
  3  size 100m ;

Tablespace created.

SQL> create user demo_schema identified by Ora_DB4U;

User created.

SQL> grant connect,resource to demo_schema;

Grant succeeded.

SQL> alter user demo_schema quota unlimited on demo_tbs;

User altered.

SQL> create table demo_schema.just_a_table tablespace demo_tbs as select * from all_objects;

Table created.

SQL> select file_name, bytes / 1048576 from dba_data_files;
FILE_NAME                                        BYTES/1048576
/opt/oracle/oradata/CDB1/PDB1/system01.dbf                 350
/opt/oracle/oradata/CDB1/PDB1/sysaux01.dbf                 550
/opt/oracle/oradata/CDB1/PDB1/undotbs01.dbf                215
/opt/oracle/oradata/CDB1/PDB1/users01.dbf              2258.75
/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf               100


SQL> select table_name, tablespace_name from dba_tables where owner='DEMO_SCHEMA';
TABLE_NAME     TABLESPACE_NAME
JUST_A_TABLE   DEMO_TBS

```

## PDB level storage limitations 
```
-- Limit the total storage of the the PDB (datafile and local temp files).
alter pluggable database storage (maxsize 5g);

-- Limit the amount of temp space used in the shared temp files.
alter pluggable database storage (max_shared_temp_size 2g);

-- Combine the two.
alter pluggable database storage (maxsize 5g max_shared_temp_size 2g);

-- Remove the limits.
alter pluggable database storage unlimited;

```

## CDB common user
```

CONN / AS SYSDBA

-- Create the common user using the CONTAINER clause.
CREATE USER c##test_user1 IDENTIFIED BY password1 CONTAINER=ALL;
GRANT CREATE SESSION TO c##test_user1 CONTAINER=ALL;

```

## CDB common Roles
```
-- Create the common role.
CREATE ROLE c##test_role1;
GRANT CREATE SESSION TO c##test_role1;

-- Grant it to a common user.
GRANT c##test_role1 TO c##test_user1 CONTAINER=ALL;

-- Grant it to a local user.
ALTER SESSION SET CONTAINER = pdb1;
GRANT c##test_role1 TO test_user3;

```

## CDB vs PDB parameter
```
[CDB1:oracle@dbhol:~]$ export ORACLE_PDB_SID=CDB1
[CDB1:oracle@dbhol:~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jul 24 12:23:49 2022
Version 19.11.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.11.0.0.0

SQL> 
column name format a35
column value format a35
 
select name, value
from   v$system_parameter
where  ispdb_modifiable = 'TRUE'
order by name;

```

## Change parameter on CDB level
```
[CDB1:oracle@dbhol:~]$ export ORACLE_PDB_SID=CDB1
[CDB1:oracle@dbhol:~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jul 24 12:23:49 2022
Version 19.11.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.11.0.0.0

SQL> shu immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup
ORACLE instance started.

Total System Global Area 3221223184 bytes
Fixed Size		    9139984 bytes
Variable Size		 1610612736 bytes
Database Buffers	 1593835520 bytes
Redo Buffers		    7634944 bytes
Database mounted.
Database opened.
SQL>
SQL> alter system set sga_max_size=4G scope=spfile;

System altered.

SQL> startup force
ORACLE instance started.

Total System Global Area 4294963992 bytes
Fixed Size		    9143064 bytes
Variable Size		 2684354560 bytes
Database Buffers	 1593835520 bytes
Redo Buffers		    7630848 bytes
Database mounted.
Database opened.


SQL> alter system set parameter_name=value;
SQL> alter system set parameter_name=value container=current;

SQL> alter system set parameter_name=value container=all;
```
## PDB level spfile
```
-- Get the list of parameters, including the PDB_UID.
set linesize 120
column pdb_name format a10
column name format a30
column value$ format a30

select ps.db_uniq_name,
       ps.pdb_uid,
       p.name as pdb_name,
       ps.name,
       ps.value$
from   pdb_spfile$ ps
       join v$pdbs p on ps.pdb_uid = p.con_uid
order by 1, 2, 3;

-- Delete the PDB-level parameters from the table, using the PDB_UID value.
delete from pdb_spfile$ where pdb_uid = {your PDB_UID value};
commit;

-- Restart the container database.
alter pluggable database close immediate;
alter pluggable database open;

```
## Changes on PDB level
```

-- ALTER SYSTEM Statement on a PDB
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER SYSTEM DISABLE RESTRICTED SESSION;
ALTER SYSTEM SET USE_STORED_OUTLINES;
ALTER SYSTEM SUSPEND;
ALTER SYSTEM RESUME;
ALTER SYSTEM CHECKPOINT;
ALTER SYSTEM CHECK DATAFILES;
ALTER SYSTEM REGISTER;
ALTER SYSTEM KILL SESSION;
ALTER SYSTEM DISCONNECT SESSION;


-- Default tablespace type for PDB.
alter pluggable database set default bigfile tablespace;
alter pluggable database set default smallfile tablespace;

-- Default tablespaces for PDB.
alter pluggable database default tablespace users;
alter pluggable database default temporary tablespace temp;

-- Change the global name. This will change the container name and the
-- name of the default service registered with the listener.
alter pluggable database open restricted force;
alter pluggable database rename global_name to pdb1a.localdomain;
alter pluggable database close immediate;
alter pluggable database open;

-- Time zone for PDB.
alter pluggable database set time_zone='GMT';


-- Make datafiles in the PDB offline/online and make storage changes.
alter pluggable database datafile '/u01/app/oracle/oradata/cdb1/pdb1/pdb1_users01.dbf' offline;
alter pluggable database datafile '/u01/app/oracle/oradata/cdb1/pdb1/pdb1_users01.dbf' online;

alter pluggable database datafile '/u01/app/oracle/oradata/cdb1/pdb1/pdb1_users01.dbf'
  resize 1g autoextend on next 1m;

-- Supplemental logging for PDB.
alter pluggable database add supplemental log data;
alter pluggable database drop supplemental log data;

```




## Bonus material #1 : PDB CDB Monitoring with SQL Developer // YouTube 
( https://youtu.be/eDp7o2fh8bw )

## Bonus material #2 : PDB CDB Monitoring with the EM LiveLab
( https://apexapps.oracle.com/pls/apex/f?p=133:180:114093654042284::::wid:656 )


## Bonus material #3 : connect directly to your PDB (+ warnings) + Restart
```
export ORACLE_PDB_SID=PDB1
sqlplus / as sysdba
show con_name

# and if you want to be 100% it's only a PDB
shu immediate

startup

```  

More PDB demos here:  
( https://github.com/yanivharpaz/Yaniv_Notes/blob/main/multitenant_datapump.md )
  
Thank you for reading.  
  
    
      
Writers: Alex Terehovsky & Yaniv Harpaz  
You can contact me at http://www.twitter.com/w1025
  
    

