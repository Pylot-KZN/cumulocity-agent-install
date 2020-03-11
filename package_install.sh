#!/bin/bash

#This is a script for installing the packages needed
#for the Cumulocity Linux agent!

pkg="build-essential libmodbus-dev liblua5.3-dev libreadline-dev pkg-config git libcurl4-gnutls-dev"

echo "About to install the following packages\n"
echo $pkg
echo "\n"

apt-get update
apt-get upgrade
apt-get install -y $pkg
