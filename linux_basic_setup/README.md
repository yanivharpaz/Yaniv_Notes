# Install Spark Operator on Ubuntu Cloud VM

These notes are for **demo purpose** only, not for production installation. Tested on Ubuntu 18

##### Based on Ubuntu 18 64-bit // Tested on the t2.xlarge servers (4 cores / 16GB) or Azure DS3 v2 (4 cores / 14GB)


This section is intended for people who would like to try and install a spark operator (Kubernetes operator for Spark) on top of Amazon's EC2 (Elastic Compute Cloud) servers or Microsoft Azure.

It is also relevant to anyone who is using any basic installation of Linux. I am using a basic Linux image provided by the cloud providers. I provided info how to do it by yourself, without automatic scripts. I want this to be as simple as possible, so anyone can use it and understand in each and every step, what I'm trying to do.


### When you decide to shutdown (for a clean startup when needed)
1. [ not written yet ]
2. [ not written yet ]
3. Only after both are offline, turn off the linux servers (from the AWS Console or with **"shutdown -P now"**)

### Linux preparations for the server and docker installation
* [110_prepare_linux_server](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/110_prepare_linux_server.md)

### In case you want to add / manage the disk volumes on the server hosts
* [115_how_to_add_a_volume](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/115_how_to_add_a_volume.md)

### Install MiniKube and Helm
* [116_install_minikube](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/116_install_minikube.md)

### Spark 2, JDK installation Version 1.8 and Scala (Optional)
* [120_install_oracle_jdk_8](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/120_install_oracle_jdk_8.md)

### Install Spark Operator ( radanalyticsio / spark-operator )
* [150_launch_CM_installer](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/150_launch_CM_installer.md)

### Load data (NYC Transportation example) - Credit to Khen Moscovici for the dataset
* [250_load_nyc_trips](https://gitlab.com/yaniv.harpaz/notes/blob/master/cloudera_install/250_load_nyc_trips.md)

### Spark Demo (used with the user hdfs, on pyspark)
* [270_spark_demo](https://gitlab.com/yaniv.harpaz/notes/blob/master/spark_operator/270_spark_demo.py)



