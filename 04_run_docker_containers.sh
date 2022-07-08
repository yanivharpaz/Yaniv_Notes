# sudo docker pull jupyter/all-spark-notebook

sudo mkdir -p /vscode_user/data
sudo chown 1000 /vscode_user/data

sudo docker run -d -p 8888:8888 -p 4040:4040 --name nb01 \
    --user root -e NB_UID=1000 \
    -v /vscode_user/data:/home/jovyan/work \
    jupyter/all-spark-notebook

# in order to get the token:
sudo docker exec nb01 jupyter server list

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

