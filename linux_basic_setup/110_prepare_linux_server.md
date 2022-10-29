# Install linux packages and docker

this note is relevant for all the hosts in the cluster

During this installation process, it is required to create / edit files. The most common and simple way is with **vim**. In order to have things flowing and make the process as automatic as possible, I'm using here 2 technics in order to avoid vim, so it would be faster to use. If you feel more comfortable with using vim, go ahead.

* **"sed -i"** will be changing values in-place, inside a file.
* **"cat > my_file_name.ext << EOF"** will create or run-over the existing file with the content (till reaching EOF)
* **"cat >> my_file_name.ext << EOF"** will add at the end of the file the content (till reaching EOF)

# Ubuntu
```
sudo apt-get update
```

### Ubuntu - Install basic RPMs 
```
sudo apt-get install -y apt-transport-https conntrack git mc ncdu zsh htop gcc net-tools jq 
sudo apt-get install -y ca-certificates curl gnupg-agent software-properties-common
```

### Ubuntu - Install python RPMs 
```
#sudo apt-get install -y python-pip python3-pip python-virtualenv
sudo apt-get install -y python3-pip
sudo apt-get install -y unixodbc-dev

pip3 install pip --upgrade pip  
pip3 install pandas tqdm matplotlib plotly scipy ipykernel ipywidgets jupyterlab
```


### Ubuntu - Install Microsoft ODBC driver
```
sudo su
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Ubuntu 16.04
#curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 18.04
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 20.04
#curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 20.10
#curl https://packages.microsoft.com/config/ubuntu/20.10/prod.list > /etc/apt/sources.list.d/mssql-release.list

exit
```

```
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
sudo apt-get install -y unixodbc-dev
```



### Install Docker
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-get remove -y docker docker-engine docker.io containerd runc
# sudo apt-get install -y docker.io
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker.io containerd.io
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo apt-cache madison docker-ce
```

### Start docker service and test it (below I explain how to use it without root)
```
sudo service docker start
sudo docker run hello-world
```

# Centos / Red Hat
```
sudo yum update -y
```

### Centos - Install basic RPMs 
```
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y epel-release apt-transport-https conntrack git mc ncdu zsh htop vim gcc 
```

### Centos - Install python RPMs 
```
sudo yum install -y python36 python36-devel python36-pip python-devel python-virtualenv
sudo yum install -y bind-utils mlocated yum-utils createrepo bin-utils openssh-clients perl parted
```

### Centos - Install Docker
```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum update -y

sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo yum list docker-ce --showduplicates | sort -r
```

# Make sure docker runs under regular non-admin users
### Start docker service and test it
```
sudo service docker start
```
### docker service starts on boot
```
sudo systemctl enable docker
```

### Allow using docker without root 
### (might work only after logoff/logon or even restart the machine)
```
sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker restart
```

### Usualy now you need to login again and then the "docker run" would work
```
docker run hello-world
```

# Optional - Oh My Zsh (each user should be installing it separately)
```
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# or
 sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"  
```

### Start the zsh  
```
zsh
```

### Switch shell 
```
sudo chsh -s `which zsh`
```

### Install oh my zsh plugins (run for each user)
```
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

sudo sed -i 's/plugins=(git)/plugins=(git git-flow brew history node npm kubectl zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
```

# Oh My Zsh Themes

## agnoster theme (for usage with poweline fonts only and only if root is using zsh)
```
sudo sed -i 's/robbyrussell/agnoster/' ~/.zshrc
echo 'RPROMPT="[%D{%f/%m/%y} | %D{%L:%M:%S}]"' | tee --append ~/.zshrc
```

## alanpeabody theme (for standard terminals)
```
sudo sed -i 's/robbyrussell/alanpeabody/' ~/.zshrc
```

## powerline10k
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

## Alien
```
cd ~
git clone https://github.com/eendroroy/alien.git
cd alien
git submodule update --init --recursive
```

### Add the following line to your ~/.zshrc
```
source ~/alien/alien.zsh
```
### add new plug-ins to all users
```
sudo sed -i 's/plugins=(git)/plugins=(git git-flow brew history node npm kubectl zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc
```

### if you want to automatically start with zsh // this will add a command on your bashrc
```
echo "bash -c zsh" | tee --append ~/.bashrc
```

### Provide remote desktop access (Ubuntu)

```

sudo su

apt update ; apt install -y xrdp ; apt install -y xfce4-session

sudo useradd rdp_user
sudo passwd rdp_user << EOF
RDPrdp123@
RDPrdp123@
EOF

iptables -I INPUT -p tcp --dport 3389 -j ACCEPT -m comment --comment "Allow remote desktop"

sudo service xrdp restart

sudo apt install -y firefox git

```


### Provide remote desktop access (Centos)

```

sudo su

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#   PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/ssh_config
service sshd restart

sudo useradd rdp_user
sudo usermod -aG wheel rdp_user
sudo passwd rdp_user << EOF
RDPrdp123@
RDPrdp123@
EOF

sudo su - rdp_user

cat > ~/.Xclients << EOF
#!/bin/bash
XFCE="\$(which xfce4-session 2>/dev/null)"
exec "\$XFCE"
EOF

chmod +x ~/.Xclients

exit

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y 
sudo yum install -y xrdp tigervnc-server
sudo yum install -y firefox
sudo yum groups -y install "Xfce"
sudo systemctl enable xrdp && sudo systemctl restart xrdp

sudo /usr/sbin/iptables -I INPUT -p tcp --dport 3389 -j ACCEPT -m comment --comment "Allow remote desktop"

echo "$(curl ifconfig.me) "

```
