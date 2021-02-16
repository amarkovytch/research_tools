#!/bin/bash

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
