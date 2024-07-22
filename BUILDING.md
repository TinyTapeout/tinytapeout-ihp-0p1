# Build Tiny Tapeout IHP with OpenROAD Flow Scripts

## Environment setup (linux / WSL)

Check out the submodules:

```bash
git submodule update --init --recursive
```

Install OpenROAD Flow Scripts (ORFS):

```bash
export ORFS_ROOT=~/OpenROAD-flow-scripts

git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts $ORFS_ROOT
```

Update the IHP platform files used by ORFS to more recent version from the IHP dev branch:

```./sg13g2-update/update.sh
```

Follow the [ORFS local installation instructions](https://openroad-flow-scripts.readthedocs.io/en/latest/user/BuildLocally.html), or install the following dependencies manually:

1. [KLayout](https://www.klayout.de/build.html), version 0.28.17 or later.
2. [Yosys](https://yosyshq.net/yosys/download.html), version 0.43 or later.
3. [OpenROAD](https://github.com/Precision-Innovations/OpenROAD/releases).

## Harden

Set the `OPENROAD_EXE` and `YOSYS_CMD` environment variables to point to the OpenROAD and Yosys executables, e.g.:

```bash
export OPENROAD_EXE=$(command -v openroad)
export YOSYS_CMD=$(command -v yosys)
```

Configure paths and harden:

```bash
export WORK_HOME=$(pwd)
export IHP_PDK_ROOT=$(pwd)/IHP-Open-PDK
export DESIGN_HOME=$(pwd)/designs
export DESIGN_CONFIG=${DESIGN_HOME}/ihp-sg13g2/tt-chip/config.mk

make -B -C $ORFS_ROOT/flow
```
