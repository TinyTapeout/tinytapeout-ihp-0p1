#!/bin/bash
export UPDATE_DIR=$(dirname $(realpath $0))
export ORFS_ROOT=${ORFS_ROOT:-$(realpath orfs)}
cd $ORFS_ROOT/flow/platforms/ihp-sg13g2
python $UPDATE_DIR/sg13g2-update.py
cp $UPDATE_DIR/config.mk .

# patch Metal2 minimum area rule
sed -i -e '/^LAYER Metal2$/,/^END Metal2$/!b' -e '/^ *AREA /!b' -e 's/0\.144/0.18/' $ORFS_ROOT/flow/platforms/ihp-sg13g2/lef/sg13g2_tech.lef
