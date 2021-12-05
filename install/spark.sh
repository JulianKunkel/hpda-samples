#!/bin/bash

sudo apt-get install jupyter-notebook
sudo pip3 install pyspark[pandas_on_spark,sql] chart-studio

#ipython3 profile create pyspark
# Create startup file for Spark
#mkdir startup
#cp pyspark_setup.py startup
#chmod 755 startup/*

echo now run:
echo jupyter notebook 

