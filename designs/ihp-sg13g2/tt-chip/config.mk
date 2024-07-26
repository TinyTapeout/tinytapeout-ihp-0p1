export DESIGN_NICKNAME = tt-chip
export DESIGN_NAME = tt_top
export PLATFORM    = ihp-sg13g2
export PROJECTS_HOME = $(DESIGN_HOME)/../projects

export ENABLE_PROJECT_00 = 1
export ENABLE_PROJECT_01 = 1
export ENABLE_PROJECT_02 = 1
export ENABLE_PROJECT_03 = 1
export ENABLE_PROJECT_04 = 0
export ENABLE_PROJECT_05 = 0
export ENABLE_PROJECT_06 = 0
export ENABLE_PROJECT_07 = 0
export ENABLE_PROJECT_08 = 0
export ENABLE_PROJECT_09 = 0
export ENABLE_PROJECT_10 = 0
export ENABLE_PROJECT_11 = 0
export ENABLE_PROJECT_12 = 0
export ENABLE_PROJECT_13 = 0
export ENABLE_PROJECT_14 = 0
export ENABLE_PROJECT_15 = 0
export ENABLE_PROJECT_16 = 0
export ENABLE_PROJECT_17 = 0
export ENABLE_PROJECT_18 = 0
export ENABLE_PROJECT_19 = 0
export ENABLE_PROJECT_20 = 0
export ENABLE_PROJECT_21 = 0
export ENABLE_PROJECT_22 = 0
export ENABLE_PROJECT_23 = 0

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/sealring/gds/sealring.gds

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/tt_top.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/basic_mux.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/tt_logo.v

include $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/projects.mk

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA = 0 0 2200 2200
export CORE_AREA = 400 400 1800 1800
export FOOTPRINT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pad.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

export PLACE_DENSITY = 0.7
export TNS_END_PERCENT = 100

export SYNTH_MEMORY_MAX_BITS = 16384

# Allow routing on the TopMetal layers, for the padring connections
export MAX_ROUTING_LAYER = TopMetal2

# Following exports should be part of platforms/ihp-sg13g2/config.mk and
# might be obsolete in the future.
export ADDITIONAL_LEFS = \
    $(IHP_PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io.lef \
    $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/bondpad/lef/bondpad_70x70.lef
export ADDITIONAL_GDS = \
    $(IHP_PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_io/gds/sg13g2_io.gds \
    $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/bondpad/gds/bondpad_70x70.gds
export ADDITIONAL_LIBS = \
    $(IHP_PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_dummy.lib
export CDL_FILE = \
    $(IHP_PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl \
    $(IHP_PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_io/cdl/sg13g2_io.cdl \
    $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/bondpad/cdl/bondpad_70x70.cdl
