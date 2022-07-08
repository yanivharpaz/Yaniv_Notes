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
sudo pip3 install ipykernel jupyter pandas sqlalchemy cx_oracle --user

sudo yum install -y yum-utils zip unzip
sudo yum-config-manager --enable ol7_optional_latest
sudo yum-config-manager --enable ol7_addons

sudo yum install -y oraclelinux-developer-release-el7
sudo yum-config-manager --enable ol7_developer

sudo yum install -y docker-engine btrfs-progs btrfs-progs-devel
  
