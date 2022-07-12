# Datapump examples to use with multitenant PDBs

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
  
## Check out each container DB - which PDBs each one has

```
# check out each container DB - which PDBs each one has

sql system/Ora_DB4U@cdb1
show pdbs
exit

sql system/Ora_DB4U@cdb2
show pdbs
exit

```


## Setup pdb1 table, database link and directory 
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

## Setup pdb2 table, database link and directory
```
# setup pdb2 table, database link and directory

sql system/Ora_DB4U@pdb2
set sqlformat ANSICONSOLE
create table pdb2_tb as select * from global_name;
select * from pdb2_tb;
create database link pdb1_lnk connect to system identified by Ora_DB4U using 'pdb2';
create directory tmp_dir as '/tmp';
exit 

```

## Datapump export into files from both PDBs
```
# datapump export into files from both PDBs

expdp system/Ora_DB4U@pdb1 directory=tmp_dir dumpfile=pdb1_tb.dmp tables=pdb1_tb reuse_dumpfiles=y logfile=pdb1_exp_tb.log

expdp system/Ora_DB4U@pdb2 directory=tmp_dir dumpfile=pdb2_tb.dmp tables=pdb2_tb reuse_dumpfiles=y logfile=pdb2_exp_tb.log

```

## Datapump import files from both PDBs
```
# datapump import files from both PDBs

impdp system/Ora_DB4U@pdb1 directory=tmp_dir dumpfile=pdb2_tb.dmp TABLE_EXISTS_ACTION=replace logfile=pdb2_imp_to_pdb1_tb.log

impdp system/Ora_DB4U@pdb2 directory=tmp_dir dumpfile=pdb1_tb.dmp TABLE_EXISTS_ACTION=replace logfile=pdb1_imp_to_pdb2_tb.log

```

## Datapump import through database link
```
# datapump import through database link

impdp system/Ora_DB4U@pdb1 directory=tmp_dir network_link=pdb2_lnk tables=pdb2_tb TABLE_EXISTS_ACTION=replace logfile=pdb2_imp_to_pdb1_network.log

```
  
You can contact me at http://www.twitter.com/w1025
  
    

