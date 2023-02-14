  
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

