# PostgreSQL on docker  

## Run the PostgreSQL database server on a container  
this will create a directory named ```docker_db_fs``` inside your home directory and under it a directory with the name you picked for your docker container name.

For example, if your O/S user name is scott, it will create ```/home/scott/docker_db_fs/pg101 ```  
and the database files will be written there (starting with 50MB space for an empty DB)

If you run more than one docker container, you will need to change the ```$DOCKER_NAME and $PORT_TO_USE``` environment variables on the additional containers you use.

## Prerequisites:    
* Container engine (docker-desktop should be great)  
* MacOS / Linux / WSL (Windows Subsystem for Linux)  
  
```
# envrionment variables
export DOCKER_NAME=pg101
export PORT_TO_USE=5432
export PG_USER=myuser
export PG_PASSWORD=mypass
export PG_DATABASE=mydb
export PG_HOST_PATH=$HOME/docker_db_fs/$DOCKER_NAME

# create the host filesystem for the DB data directory
mkdir -p $PG_HOST_PATH

# docker run command
docker run -d                                      \
     --name $DOCKER_NAME                           \
     -p     $PORT_TO_USE:5432                      \
     -e     POSTGRES_USER=$PG_USER                 \
     -e     POSTGRES_PASSWORD=$PG_PASSWORD         \
     -e     POSTGRES_DB=$PG_DATABASE               \
     -e     PGDATA=/var/lib/postgresql/data/pgdata \
     -v     $PG_HOST_PATH:/var/lib/postgresql/data \
     postgres:latest
```

Check out the logs of the PostgreSQL container  
```
docker logs $DOCKER_NAME
```

Get the internal IP container address
```
docker inspect -f '{{.NetworkSettings.IPAddress}}' $DOCKER_NAME
```

Start a bash session inside the DB container
```
docker exec -it $DOCKER_NAME /bin/bash
```
___
## Example of usage inside the container (with the user: ``` myuser ``` and db: ``` mydb ```)  
```
~/docker_db_fs > docker exec -it $DOCKER_NAME /bin/bash

root@e368e2d38338:/# useradd myuser
root@e368e2d38338:/# mkdir /home/myuser
root@e368e2d38338:/# chown myuser /home/myuser
root@e368e2d38338:/# su - myuser
$ psql -d mydb
psql (14.2 (Debian 14.2-1.pgdg110+1))
Type "help" for help.

mydb=# create table my_tb (my_id int);
CREATE TABLE
mydb=# insert into my_tb values (1);
INSERT 0 1
mydb=# insert into my_tb values (2);
INSERT 0 1
mydb=# insert into my_tb values (3);
INSERT 0 1
mydb=# insert into my_tb values (4);
INSERT 0 1
mydb=# select * from my_tb;
 my_id
-------
     1
     2
     3
     4
(4 rows)

mydb=#
```

## Client Tools:  
ADS - Azure Data Studio //  
Multi-platform database client (Based on Visual Studio Code)  
(https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15) 

Install the Microsoft PostgreSQL extension for Azure Data Studio  
https://github.com/Microsoft/azuredatastudio-postgresql/

The most popular admin tool - PGAdmin  
https://www.pgadmin.org/

## psql client
https://www.geeksforgeeks.org/postgresql-psql-commands/

## PostgreSQL docker reference
https://hub.docker.com/_/postgres
  
  
  

___
Contact me @
https://twitter.com/w1025
