#!/bin/sh

yum -y install python python-devel
gunzip simplejson-2.1.1.tar.gz
tar -xf simplejson-2.1.1.tar
cd simplejson-2.1.1
python setup.py install
cd ..
