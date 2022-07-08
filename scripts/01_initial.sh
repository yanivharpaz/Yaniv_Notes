sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y epel-release
sudo yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
sudo yum install -y git
sudo yum install -y mc ncdu htop  

sudo yum install -y oracle-softwarecollection-release-el7
sudo yum install -y --enablerepo ol7_optional_latest python3-devel
sudo yum install -y scl-utils rh-python38
sudo yum install -y dnf  

sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install --upgrade setuptools
sudo pip3 install wheel cython
sudo pip3 install ipykernel jupyter pandas sqlalchemy cx_oracle ipykernel --user

sudo yum install -y yum-utils zip unzip
sudo yum-config-manager --enable ol7_optional_latest
sudo yum-config-manager --enable ol7_addons

sudo yum install -y oraclelinux-developer-release-el7
sudo yum-config-manager --enable ol7_developer

sudo yum install -y docker-engine btrfs-progs btrfs-progs-devel
  

echo "export LD_LIBRARY_PATH=/opt/oracle/product/19c/dbhome_1/lib" | tee --append ~/.bashrc
echo "export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1" | tee --append ~/.bashrc



cat >> ~/run_oracle_connect.py << EOF

#!/usr/bin/python3

# pip3 install sqlalchemy pandas cx_oracle --user

import sqlalchemy
import pandas       as pd

sUserName = "system"
# sPassword = "Oracle123"
sPassword = "Ora_DB4U"
sHost     = "localhost"
sPort     = "1521"
sService  = "pdb1"

sUrl    = f"oracle+cx_oracle://{sUserName}:{sPassword}@{sHost}:{sPort}/?service_name={sService}"
print(sUrl)
oEngine = sqlalchemy.create_engine(sUrl)

sQuery  = "select * from global_name"
dData   = pd.read_sql(sQuery, oEngine)
print(dData)

EOF


