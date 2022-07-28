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

sql system/Ora_DB4U@pdb1
set sqlformat ANSICONSOLE
SQL> select file_name, bytes / 1048576
     from dba_data_files;

FILE_NAME                                       BYTES/1048576
/opt/oracle/oradata/CDB1/PDB1/system01.dbf                350
/opt/oracle/oradata/CDB1/PDB1/sysaux01.dbf                550
/opt/oracle/oradata/CDB1/PDB1/undotbs01.dbf               215
/opt/oracle/oradata/CDB1/PDB1/users01.dbf             2258.75


SQL> create tablespace demo_tbs datafile
     '/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf'
      size 100m ;

SQL> create user demo_schema identified by Ora_DB4U;

SQL> grant connect,resource to demo_schema;

SQL> alter user demo_schema quota unlimited on demo_tbs;

SQL> create table demo_schema.just_a_table tablespace demo_tbs as select * from all_objects;

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
sql system/Ora_DB4U@pdb1
set sqlformat ANSICONSOLE

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
sql system/Ora_DB4U@pdb1
set sqlformat ANSICONSOLE

-- Create the common user using the CONTAINER clause.
CREATE USER c##common_user1 IDENTIFIED BY Ora_DB4U CONTAINER=ALL;
GRANT CREATE SESSION TO c##common_user1 CONTAINER=ALL;

```

## CDB common Roles
```
-- Create the common role.
CREATE ROLE c##common_role1;
GRANT CREATE SESSION TO c##common_role1;

-- Grant it to a common user.
GRANT c##common_role1 TO c##common_user1 CONTAINER=ALL;

-- Grant it to a local user.
ALTER SESSION SET CONTAINER = pdb1;
GRANT c##common_role1 TO local_user1;

```

## CDB vs PDB parameter
```
sql sys/Ora_DB4U@pdb1 as sysdba
set sqlformat ANSICONSOLE

-- Check which parameters can be modified 
select name, value,isses_modifiable
from   v$system_parameter
where  ispdb_modifiable = 'TRUE'
order by name;

```

## Change parameter on CDB level
```
sql sys/Ora_DB4U@pdb1 as sysdba
set sqlformat ANSICONSOLE

SQL> shu immediate
Database closed.
Database dismounted.
ORACLE instance shut down.

SQL> startup
ORACLE instance started.

Total System Global Area 32...... bytes
Fixed Size		    32.... bytes
Variable Size		 32.... bytes
Database Buffers	 32.... bytes
Redo Buffers		    32.... bytes
Database mounted.
Database opened.
SQL>
SQL> alter system set sga_max_size=4G scope=spfile;

System altered.

SQL> startup force
ORACLE instance started.

Total System Global Area 42.... bytes
Fixed Size		    32.... bytes
Variable Size		 32.... bytes
Database Buffers	 32.... bytes
Redo Buffers		    32.... bytes
Database mounted.
Database opened.

-- Options ALL / Current
SQL> alter system set parameter_name=value;
SQL> alter system set parameter_name=value container=current;
SQL> alter system set parameter_name=value container=all;


```
## PDB level spfile
## PDB level managed in table pdb_spfile$
```
sql sys/Ora_DB4U@pdb1 as sysdba
set sqlformat ANSICONSOLE

-- Get the list of parameters, including the PDB.
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
sql sys/Ora_DB4U@pdb1 as sysdba
set sqlformat ANSICONSOLE

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
alter pluggable database datafile '/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf' offline;
alter pluggable database datafile '/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf' online;

alter pluggable database datafile '/opt/oracle/oradata/CDB1/PDB1/demo_tbs01.dbf'
  resize 1g autoextend on next 1m;

-- Supplemental logging for PDB.
alter pluggable database add supplemental log data;
alter pluggable database drop supplemental log data;

```

## Pluggable database Patching Process
Note: Disable the backup job of RMAN.

1. Set ORACLE_HOME, PATH and ORACLE_SID
```
# set environment

source ~/.set-env-db.sh CDB1
```

2. Check the OPatch utility version
```
/opt/oracle/product/19c/dbhome_1/OPatch/opatch version
```

3. Check the compatibility.
Go to patch location
```
cd /tmp/32904851

[CDB1:oracle@dbhol:/tmp/32904851]$ /opt/oracle/product/19c/dbhome_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -ph .
```

4. Check the lsinventory
```
/opt/oracle/product/19c/dbhome_1/OPatch/opatch lsinventory

/opt/oracle/product/19c/dbhome_1/OPatch/opatch lsinventory | grep 32904851
```
5. Status of the listener
```
lsnrctl status
```

6. Take RMAN backup  

7. Create PFILE from SPFILE
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

create pfile='/tmp/initpfileCDB1.ora' from spfile;
```
8. Check the status of all pluggable database
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select d.con_id, v.name, v.open_mode, nvl(v.restricted, 'n/a') "RESTRICTED", d.status
from v$PDBs v inner join dba_pdbs d using (GUID) order by v.create_scn;
```
9. Open all the pluggable database.
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

alter pluggable database all open;

select d.con_id, v.name, v.open_mode, nvl(v.restricted, 'n/a') "RESTRICTED", d.status
from v$PDBs v inner join dba_pdbs d using (GUID) order by v.create_scn;
```

10. Check the invalid objects in PDBs & CDB database 
Note: CDB view only return value for open pdbs, so all pdb must be open.
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select count(*) from cdb_objects where status='INVALID';

Select con_id, count(*) from cdb_objects where status='INVALID' group by con_id;
```

11. Check the SQL Patch view for patch history
Note: CDB view only return value for open pdbs, so all pdb must be open.
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select con_id, patch_id, version, status, Action, Action_time from cdb_registry_sqlpatch order by action_time;
```

12. Check the dba_registry components
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select con_id,comp_id,comp_name,version,status from cdb_registry;
```

13. Check the database archive mode
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

archive log list;
```

14. Shutdown the PDBs and CDB 
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

alter pluggable database all close immediate;

select d.con_id, v.name, v.open_mode, nvl(v.restricted, 'n/a') "RESTRICTED", d.status
from v$PDBs v inner join dba_pdbs d using (GUID) order by v.create_scn;

shutdown immediate;
```

15. Apply the patch
```
cd /tmp/32904851

[CDB1:oracle@dbhol:/tmp/32904851]$ /opt/oracle/product/19c/dbhome_1/OPatch/opatch apply
```

16. Post installation
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

-- Steps only for apply window bundle patch
startup
alter pluggable database all open;

-- Check all pdb is in upgrade state
select d.con_id, v.name, v.open_mode, nvl(v.restricted, 'n/a') "RESTRICTED", d.status
from v$PDBs v inner join dba_pdbs d using (GUID) order by v.create_scn;
```

17. Execute the datapatch verbose commands
```
cd %ORACLE_HOME%/OPatch
datapatch -verbose
```

18. Check the log files for catbundle at following locations

%ORACLE_HOME%\cfgtoollogs\catbundle or %ORACLE_BASE%\cfgtoollogs\catbundle for any errors:

19. Open the CDB & PDB’s database in normal mode:
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

--CDB
Shutdown immediate
startup

--PDB
alter pluggable database all open;

--check with following view about error or action need to take:
select message,action from pdb_plug_in_violations;

select d.con_id, v.name, v.open_mode, nvl(v.restricted, 'n/a') "RESTRICTED"
, d.status from v$PDBs v inner join dba_pdbs d using (GUID) order by v.create_scn;
```

20. Check the invalid objects in all PDBs & CDB and compile invalid objects
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select count(*) from cdb_objects where status='INVALID';

Select con_id, count(*) from cdb_objects where status='INVALID' group by con_id;

-- If needed run
SQL> @utlrp.sql
```

21. Check the database registry view

```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select con_id,comp_id,comp_name,version,status from cdb_registry;
```

22. Check the registry$history view
```
sql sys/Ora_DB4U@cdb1 as sysdba
set sqlformat ANSICONSOLE

select con_id, patch_id, version, status, Action, Action_time from cdb_registry_sqlpatch order by action_time;

select patch_id, patch_uid, version, status, description from cdb_registry_sqlpatch;
select patch_id, version, status, Action, Action_time from cdb_registry_sqlpatch order by action_time;
```

23. Check the listener connectivity
```
lsnrctl status

sql sys/Ora_DB4U@cdb1 as sysdba
exit
sql sys/Ora_DB4U@pdb1 as sysdba
exit
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
  
    
      

You can contact me at http://www.twitter.com/w1025
  
    

