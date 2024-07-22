#!/bin/bash
export UPDATE_DIR=$(dirname $(realpath $0))
cd ${ORFS_ROOT:-orfs}/flow/platforms/ihp-sg13g2
python $UPDATE_DIR/sg13g2-update.py
cp $UPDATE_DIR/config.mk .
