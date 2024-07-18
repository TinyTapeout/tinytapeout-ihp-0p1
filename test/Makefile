export DESIGN_NICKNAME = tt-chip
export DESIGN_NAME = tt_top
export PLATFORM    = ihp-sg13g2
export DESIGN_HOME = $(abspath ../designs)
export PROJECTS_HOME = $(abspath ../projects)
export EXPECTED_REPO = TinyTapeout/tinytapeout-ihp-0p1

# cocotb setup
export COCOTB_REDUCED_LOG_FMT=1

# When executing the '_gl' rule, force GATES to 'yes'
ifneq ($(filter test_mux_gl,$(MAKECMDGOALS)),)
  GATES := yes
else
  GATES ?= no
endif

export TT_GL_VERILOG := $(abspath ../../../tt-multiplexer/ol2/tt_top/verilog/)

SIM           ?= icarus
WAVES         ?= yes
TOPLEVEL      ?= tt_top_tb
MODULE        ?= test_mux
TOPLEVEL_LANG ?= verilog
COMPILE_ARGS  += -DSIM_$(shell echo $(SIM) | tr a-z A-Z)=1
COMPILE_ARGS  += -DROM_VMEM_PATH=\"$(PROJECTS_HOME)/tt_um_chip_rom/src/rom.vmem\"

# Additional arguments to support Verilator
ifeq ($(SIM),verilator)
  COMPILE_ARGS += $(abspath lint.cfg)
  COMPILE_ARGS += --timescale 1ns/1ps
  COMPILE_ARGS += --timescale-override 1ns/1ps
  COMPILE_ARGS += -Wno-TIMESCALEMOD
  COMPILE_ARGS += -Wno-fatal
  # Verilator can't turn wave capture on and off dynamically, so instead compile
  # a specific variant with capture supported
  ifeq ($(WAVES),yes)
    COMPILE_ARGS += --trace-fst
    SIM_BUILD    := sim_build_waves
  endif
  ifeq ($(GATES),yes)
    $(info ERROR: Cannot perform gate-level simulation with Verilator)
    $(error 1)
  endif
else ifeq ($(SIM),icarus)
  ifeq ($(WAVES),yes)
    PLUSARGS += +WAVE_FILE=test_mux.vcd
  endif
endif

# Alter behaviour between GLS & fast functional sims
ifeq ($(GATES),yes)
  COMPILE_ARGS    += -i
  COMPILE_ARGS    += -DGL_TEST
  COMPILE_ARGS    += -DFUNCTIONAL
  COMPILE_ARGS    += -DSIM
  VERILOG_SOURCES += $(abspath ../IHP-Open-PDK/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v)
  VERILOG_SOURCES += $(abspath ../results/ihp-sg13g2/tt-chip/base/6_final.v)
  SIM_BUILD       := sim_build_gates
else
  COMPILE_ARGS    += -DRTL_TESTBENCH
  COMPILE_ARGS    += -f $(abspath ./includes.txt)
endif

# IO cell library is relevent for both RTL / GL sims
VERILOG_SOURCES += $(abspath ../IHP-Open-PDK/ihp-sg13g2/libs.ref/sg13g2_io/verilog/sg13g2_io.v)

# Standard sources
VERILOG_SOURCES += $(abspath test_mux_tb.v)

PYTHON_PATHS += $(abspath .)
export PYTHONPATH := $(subst $(SPACE),:,$(PYTHON_PATHS)):$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim

# ==============================================================================
# Simulation
# ==============================================================================

.PHONY: test_mux
test_mux: $(COCOTB_RESULTS_FILE)

.PHONY: test_mux_gl
test_mux_gl: $(COCOTB_RESULTS_FILE)
