#!/bin/bash

# Stop setup when a command fails
set -e

# Create neccessary folder to storage date
mkdir -p checkpoints

printf "Installing missing packages" 
# Install requirement
pip3 install -r requirements.txt 
pip3 install http://download.pytorch.org/whl/cu92/torch-0.4.1-cp36-cp36m-linux_x86_64.whl

printf "Downloading dataset...\n" 
# Downloading test 
if [ -f 'data/' ]; then 
python - <<END 
import gdown 
from zipfile import ZipFile 

# Variables 
fileId = '1-eENcWVi0gN5o6mrzT09WBv8FX66jMLV' 
url = 'https://drive.google.com/uc?id=' + fileId 
des = 'celeba.zip' 

# Download dataset 
gdown.download(url, output, quiet=False) 

# Exacting dataset 
with ZipFile(des, 'r') as obj: 
    obj.extractall('data') 
END
fi

# Install gcc

# Instructions for installing GCC 4.9 on various platforms.
# The commands show instructions for GCC 4.9, but any higher version will also work!

# Ubuntu (https://askubuntu.com/questions/466651/how-do-i-use-the-latest-gcc-on-ubuntu/581497#581497)
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-4.9 g++-4.9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

# CentOS (https://www.softwarecollections.org/en/scls/rhscl/devtoolset-3/)
sudo yum install centos-release-scl
sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
sudo yum install devtoolset-3
scl enable devtoolset-3 bash


# Install ninja linux
wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip
sudo unzip ninja-linux.zip -d /usr/local/bin/
sudo update-alternatives --install /usr/bin/ninja ninja /usr/local/bin/ninja 1 --force

printf "Training... " 
# Start training
python train.py