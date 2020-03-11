#!/bin/bash

echo "Attempting to install the C++ Libraries for the agent"

git clone https://bitbucket.org/m2m/cumulocity-sdk-c

echo "Entering cloned repository..."
cd cumulocity-sdk-c

echo "Initialising the repository..."
git submodule init
git submodule update

echo "Creating the init.mk file..."
printf 'SR_PLUGIN_LUA:=1 \nCPPFLAGS:=$(shell pkg-config --cflags libcurl lua5.3) \nCXXFLAGS:=-Wall -pedantic -Wextra \nLDLIBS:=$(shell pkg-config --libs libcurl lua5.3)' > init.mk

cp Makefile.template Makefile

make
cd ..

echo "Libraries successfully installed! Now installing the agent..."

git clone https://bitbucket.org/m2m/cumulocity-agents-linux
printf 'export C8Y_LIB_PATH=/home/moxa/cumulocity-sdk-c' | tee -a ~/.bashrc
echo "Path to the libraries has been set..."
cd cumulocity-agents-linux
echo "Library files have been copied for the agent.."
cp -rP $C8Y_LIB_PATH/lib $C8Y_LIB_PATH/bin .
sed -i 's/PLUGIN_MODBUS:=0/PLUGIN_MODBUS:=1/g' ./Makefile
echo "Modbus enabled..."
echo ""
sed -i '24 s/lua/lua5.3/' ./Makefile
sed -i '28 s/lua/lua5.3/' ./Makefile
echo "Lua5.3 set as the Lua version..."
echo ""
sed -i 's@"/proc/cpuinfo"@"/home/moxa/cpuinfo"@g' ./src/demoagent.cc
echo "Path to Device ID has been changed to the '~/home/moxa/cpuinfo'.."
echo ""
sed -i 's@lua.plugins=*@lua.plugins=modbus,monitoring,@' ./cumulocity-agent.conf
echo "Added Modbus on the Lua plugins list..."
echo ""
echo "Building the agent with 'make' command.."
echo ""
make
echo "Installing the agent to the device..."
echo ""
make install

