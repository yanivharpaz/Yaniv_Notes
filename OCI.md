# OCI-Cloud-Shell
Oracle Cloud Shell scripts

| filename         | usage                                        |
|------------------|----------------------------------------------|
| oci_bashrc.sh    | example of ~/.bashrc                         |
| adw.sh           | create a bastion session for the ADW         |
| vm-python.sh     | create bastion sessions for the VMs and ADW  |
| show_commands.py | display the SSH tunnel commands on localhost |

  
  
# SSH Keys conversion  
## Setup and install  

### MacOS  
```
# setup and install on MacOS
brew install putty
```

### Linux
```
# setup and install on linux
apt install -y putty
```  

## PEM (linux/unix SSH client) to PPK (Windows / Moba / PuTTY)  
```
puttygen my_pem_key.key -o my_ppk_key.ppk -O private

```  

##  PPK (Windows / Moba / PuTTY) to PEM (linux/unix SSH client)
```
puttygen my_ppk_key.ppk -O private-openssh -o my_pem_key.key


```  

You can contact me at www.twitter.com/w1025 

