export DESIGN_NICKNAME = tt-chip
export DESIGN_NAME = tt_top
export PLATFORM    = ihp-sg13g2
export PROJECTS_HOME = $(DESIGN_HOME)/../projects

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/sealring/gds/sealring.gds

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/tt_top.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/basic_mux.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/wrappers/p00_wrapper.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/wrappers/p01_wrapper.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/wrappers/p02_wrapper.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/wrappers/p03_wrapper.v \
                       $(PROJECTS_HOME)/tt_um_chip_rom/src/tt_um_chip_rom.v \
                       $(PROJECTS_HOME)/tt_um_factory_test/src/tt_um_factory_test.v \
                       $(PROJECTS_HOME)/tt_um_urish_simon/src/simon.v \
                       $(PROJECTS_HOME)/tt_um_urish_simon/src/project.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/button_pulse.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/digit.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/fontROM.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/tt_vga_clock.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/vga_clock.v \
                       $(PROJECTS_HOME)/tt_um_vga_clock/src/VgaSyncGen.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA = 0 0 2200 2200
export CORE_AREA = 400 400 1800 1800
export FOOTPRINT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pad.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

export PLACE_DENSITY = 0.6
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
