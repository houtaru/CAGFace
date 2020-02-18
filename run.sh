#!/bin/bash

# Stop setup when a command fails
set -e

# Create neccessary folder to storage date
mkdir -p checkpoints

printf "Installing requirements...\n" 
# Install requirement
if [ ! `python -c "import torch"` ] || [ `python -c "import torch; print(torch.__version__)"` != "1.0.0" ]; then
    pip3 install https://files.pythonhosted.org/packages/7e/60/66415660aa46b23b5e1b72bc762e816736ce8d7260213e22365af51e8f9c/torch-1.0.0-cp36-cp36m-manylinux1_x86_64.whl
fi

if [ ! `python -c "import torchvision"` ] || [ `python -c "import torchvision; print(torchvision.__version__)"` != "0.2.1" ]; then
    pip install https://files.pythonhosted.org/packages/ca/0d/f00b2885711e08bd71242ebe7b96561e6f6d01fdb4b9dcf4d37e2e13c5e1/torchvision-0.2.1-py2.py3-none-any.whl
fi
pip3 install -r requirements.txt

printf "Downloading dataset...\n" 
# Downloading test 
if [ ! -f 'celeba.zip' ]; then 
python - <<END 
    import gdown 
    from zipfile import ZipFile 

    # Variables 
    fileId = '1-eENcWVi0gN5o6mrzT09WBv8FX66jMLV' 
    url = 'https://drive.google.com/uc?id=' + fileId 
    des = 'celeba.zip' 

    # Download dataset 
    gdown.download(url, des, quiet=False) 
END
fi

if [ ! -f 'data' ]; then
mkdir -p data
python -<<END
    print('Extracting...')
    # Extracting dataset 
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
sudo apt-get install gcc g++
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

# Install ninja linux
if [ -f 'ninja-linux.zip' ]; then
    wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip
    sudo unzip ninja-linux.zip -d /usr/local/bin/
    sudo update-alternatives --install /usr/bin/ninja ninja /usr/local/bin/ninja 1 --force
fi

printf "Training...\n " 
# Start training
python train.py
