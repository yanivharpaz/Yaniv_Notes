# Setup Oracle Linux machines

```
sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y epel-release
sudo yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
sudo yum install -y git
sudo yum install -y mc ncdu htop  

```

## Setup python

```
sudo yum install -y oracle-softwarecollection-release-el7
sudo yum install -y --enablerepo ol7_optional_latest python3-devel
sudo yum install -y scl-utils rh-python38
sudo yum install -y dnf  

scl enable rh-python38 bash  
sudo update-alternatives --install /usr/bin/python3 python3 /opt/rh/rh-python38/root/usr/bin/python3 1

```

## Setup python libraries
```
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install --upgrade setuptools
sudo pip3 install wheel cython
sudo pip3 install ipykernel jupyter pandas

sudo yum localinstall -y ~/Downloads/code*.rpm

```

Reference ( https://yum.oracle.com/oracle-linux-python.html#InstallPython3FromLatest )

https://oracle.github.io/python-oracledb/

https://python-oracledb.readthedocs.io/en/latest/

https://github.com/oracle/python-oracledb

https://youtu.be/ywEJKkzwRN0

https://levelup.gitconnected.com/open-source-python-thin-driver-for-oracle-database-e82aac7ecf5a

https://oracle-base.com/articles/linux/git-2-installation-on-linux
https://oracle-base.com/articles/linux/docker-install-docker-on-oracle-linux-ol7
