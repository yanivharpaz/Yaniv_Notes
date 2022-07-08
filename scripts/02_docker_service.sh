sudo service docker start
sudo systemctl enable docker

sudo groupadd docker
sudo usermod -aG docker oracle
sudo usermod -aG docker opc
sudo service docker restart

echo "please logoff and login again"

