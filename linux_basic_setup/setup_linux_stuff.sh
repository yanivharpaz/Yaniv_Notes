# Install linux packages and docker

read -p "make sure the sudo is already set, press and key <<-->>"

# Ubuntu
sudo apt-get update

### Ubuntu - Install basic RPMs 
sudo apt-get install -y apt-transport-https conntrack git mc ncdu zsh htop gcc net-tools
sudo apt-get install -y ca-certificates curl gnupg-agent software-properties-common

### Ubuntu - Install python RPMs 
sudo apt-get install -y python3 python3-pip
sudo apt-get install -y unixodbc-dev

pip3 install pandas tqdm matplotlib plotly scipy ipykernel ipywidgets jupyterlab

### Ubuntu - Install Microsoft ODBC driver
sudo su
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Ubuntu 16.04
#curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 18.04
#curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 20.04
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

#Ubuntu 20.10
#curl https://packages.microsoft.com/config/ubuntu/20.10/prod.list > /etc/apt/sources.list.d/mssql-release.list

exit

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
sudo apt-get install -y unixodbc-dev



### Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-get remove -y docker docker-engine docker.io containerd runc
# sudo apt-get install -y docker.io
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker.io
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo apt-cache madison docker-ce
 
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

### Start the zsh  
zsh

### Switch shell 
sudo chsh -s `which zsh`

### Install oh my zsh plugins (run for each user)
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

sudo sed -i 's/plugins=(git)/plugins=(git git-flow brew history node npm kubectl zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Oh My Zsh Themes

## agnoster theme (for usage with poweline fonts only and only if root is using zsh)
sudo sed -i 's/robbyrussell/agnoster/' ~/.zshrc
echo 'RPROMPT="[%D{%f/%m/%y} | %D{%L:%M:%S}]"' | tee --append ~/.zshrc

sudo sed -i 's/plugins=(git)/plugins=(git git-flow brew history node npm kubectl zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc


