# Setup Oracle Linux machines

```
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y git mc ncdu htop
```

## setup python

```
sudo yum install -y oracle-softwarecollection-release-el7
sudo yum install -y --enablerepo ol7_optional_latest python3-devel
sudo yum install -y scl-utils rh-python38
sudo yum install -y dnf
```
