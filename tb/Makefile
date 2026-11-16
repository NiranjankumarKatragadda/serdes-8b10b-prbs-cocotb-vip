SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(abspath ../src/serdes_pcs_vip.v)
TOPLEVEL = serdes_pcs_vip
MODULE = test_serdes_vip
EXTRA_ARGS += -Wno-fatal -Wno-WIDTH -Wno-lint
include $(shell cocotb-config --makefiles)/Makefile.sim
