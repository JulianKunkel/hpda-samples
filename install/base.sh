#!/bin/bash

# All the base systems

apt install git openssh-server openjdk-11-jdk
ssh-keygen
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
ssh localhost echo
git clone https://github.com/JulianKunkel/hpda-samples.git

