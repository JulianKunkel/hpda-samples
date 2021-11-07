#!/bin/bash

sudo apt install postgresql
sudo -u postgres psql -c "CREATE ROLE \"bigdata\" NOSUPERUSER LOGIN PASSWORD 'mybigdata';"
sudo -u postgres psql -c "CREATE DATABASE bigdata OWNER \"bigdata\";"

# Connect via localhost (TCP) or use the current username and peer login
echo To connect, run: psql -W -U bigdata -h localhost bigdata
