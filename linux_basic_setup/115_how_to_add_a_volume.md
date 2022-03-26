# Add a disk volume on AWS (without stopping / restarting the server)

this note is relevant for all the hosts in the cluster, if you want to use specific disk volumes and mount points
Tested on Centos but relevant to Ubuntu as well

## It is based on the AWS doc: [ebs-using-volumes](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html)

#### on the AWS Console, EC2 dashboard -> Volumes -> create Volume
#### Pick the size, type, availability zone and press "Create Volume"
#### then attach the volume to the EC2 instance you want (through the "actions" menu)

![Create and attach volume](aws-attach-volume.jpg?raw=true "Create and attach volume")

### go superuser
```
sudo su
```

## Discover the device

```
lsblk
```
### Look for the device (on the left) that does not have a mount point and fits the size of the volume you created.
### On this example it s xvdh
```
[root@ip-172-31-23-156 centos]# lsblk
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk 
└─xvda1 202:1    0   8G  0 part /
xvdf    202:80   0  10G  0 disk /data/1
xvdg    202:96   0  12G  0 disk /data/2
xvdh    202:112  0  10G  0 disk 
```

#### this is the line we wanted to see:

xvdh    202:112  0  10G  0 disk 

### Format the volume (here I picked the Cloudera supported file system: ext4)

```
mkfs -t ext4 /dev/xvdh
```

### Create a directory and mount the device on it
```
mkdir -p /data/3
mount /dev/xvdh /data/3
```

### Look for it on the file system report
```
df -h
```

### We can see the new volume at the bottom line
```
[root@ip-172-31-23-156 centos]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1      8.0G  822M  7.2G  11% /
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G   17M  1.9G   1% /run
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
tmpfs           379M     0  379M   0% /run/user/1000
/dev/xvdf       9.8G   37M  9.2G   1% /data/1
/dev/xvdg        12G   41M   12G   1% /data/2
/dev/xvdh       9.8G   37M  9.2G   1% /data/3
```

