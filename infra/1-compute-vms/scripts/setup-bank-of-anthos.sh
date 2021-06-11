#!/bin/bash

WORK_DIR=../.target
rm -fr ${WORK_DIR}
mkdir ${WORK_DIR}; cd ${WORK_DIR}
# git clone the repo
git clone https://github.com/finiteloopme/bank-of-anthos
