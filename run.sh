#!/bin/bash

# Stop setup when a command fails
set -e

# Create neccessary folder to storage date
mkdir -p checkpoints

printf "Installing missing packages"
# Install requirement
pip3 install -r requirements.txt
pip3 install http://download.pytorch.org/whl/cu92/torch-0.4.1-cp36-cp36m-linux_x86_64.whl

printf "Downloading dataset..."
# Downloading test
if [ -f 'data/']; then
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

printf "Training... "
# Start training
python train.py