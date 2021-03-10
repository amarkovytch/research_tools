#!/bin/bash
set -e

# clones repository into particular directory
# $1 - git path
# $2 - folder to clone to
function git_clone {
	rm -rf $2
	git clone $1 $2
}

# clone and then pip install frm the given folder and remove it
# $1 - git path 
# $2 - the folder to clone and install from
function git_clone_pip_install {
	git_clone $1 $2
	pip install -e $2
}

# some basic packages
sudo apt install python3-pip
python -m pip install --upgrade pip
pip install ipython
sudo apt-get install software-properties-common
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
sudo apt install hexedit
sudo apt install qemu-user-static

# install GEF GDB Enhancement https://gef.readthedocs.io/en/master/
if ! grep gdbinit-gef.py ~/.gdbinit > /dev/null 2>&1 ; then
	echo 'Installing GEF'
	wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
	echo source ~/.gdbinit-gef.py >> ~/.gdbinit
	gdb_python_version=$(gdb -nx -ex 'pi print(sys.version)' -ex quit | tail -n2 | head -n1 -c 3)
	echo "Pyton version used in gdb is $gdb_python_version"
	python${gdb_python_version} -m pip install keystone-engine
	python${gdb_python_version} -m pip install unicorn
	python${gdb_python_version} -m pip install ropper
	python${gdb_python_version} -m pip install keystone-engine
fi

# undefine LINES and COLUMNS in GDB https://stackoverflow.com/questions/32771657/gdb-showing-different-address-than-in-code
if ! grep LINES ~/.gdbinit > /dev/null 2>&1 ; then
	echo 'undefining LINES and COLUMNS in GDB'
	echo unset env LINES >> ~/.gdbinit
	echo unset env COLUMNS >> ~/.gdbinit
fi

# install binwalk
## deps.sh does not work properly on Ubuntu 20.0x, we need to do some of the stuff manually and patch it
#sudo add-apt-repository ppa:rock-core/qt4 -y
#sudo apt update
wget ftp://ftp.si.debian.org/debian/pool/main/c/cramfs/cramfsprogs_1.1-6_amd64.deb
sudo dpkg -i cramfsprogs_1.1-6_amd64.deb
rm cramfsprogs_1.1-6_amd64.deb

git_clone git@github.com:ReFirmLabs/binwalk.git binwalk
# remove wrong packages
sed -i 's/python-pip//g; s/python-lzo//g; s/python-lzma//g; s/pip install/pip3 install/g' binwalk/deps.sh
sed -i 's/pip3 $PIP_COMMANDS/pip3/g' binwalk/deps.sh
# add set -e
sed -i '/\#!\/bin\/bash/a set -e' binwalk/deps.sh

# fix sasquatchfs issues ...
sed -i 's/https:\/\/github.com\/devttys0\/sasquatch/https:\/\/github.com\/svenschwermer\/sasquatch.git/g' binwalk/deps.sh
sed -i 's/cd sasquatch/cd sasquatch \&\& git checkout gcc10/g' binwalk/deps.sh

echo "Y" | sudo tee binwalk/deps.sh && cd binwalk && sudo python3 setup.py install
if [ $? -eq 0 ]; then
	cd ..
	sudo rm -rf binwalk
else 
	echo 'failed to install binwalk, leaving the binwalk folder, please remove it manually'
fi	

# nasm to compile raw assembly
sudo apt install nasm

# let's install patcherex for patching binaries
## the below pip packages can only be installed properly with '-e', meaning
## that the package has to be stored manually in some local directory, 
## so let's create one
PIP_INSTALL_DIR=$HOME/.local/share

## first dependencies
git_clone_pip_install git@github.com:mechaphish/compilerex.git $PIP_INSTALL_DIR/compilerex
git_clone_pip_install git@github.com:mechaphish/povsim.git $PIP_INSTALL_DIR/povsim

sudo apt install nasm clang

## now the patcherex itself
git_clone_pip_install https://github.com/angr/patcherex.git $PIP_INSTALL_DIR/patcherex

# some more CTF libraries
pip install --upgrade git+https://github.com/arthaud/python3-pwntools.git
