SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(abspath ../src/serdes_pcs_vip.v)
TOPLEVEL = serdes_pcs_vip
MODULE = test_serdes_vip
ifeq ($(SIM),verilator)
  EXTRA_ARGS += -Wno-fatal -Wno-WIDTH -Wno-lint
else ifeq ($(SIM),icarus)
  COMPILE_ARGS += -g2012
endif
include $(shell cocotb-config --makefiles)/Makefile.sim
