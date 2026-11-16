# SerDes K28.5 + PRBS-7/31 Cocotb Verification IP

[[https://github.com/NiranjankumarKatragadda/serdes-8b10b-prbs-cocotb-vip/actions/workflows/ci.yml/badge.svg]](https://github.com/NiranjankumarKatragadda/serdes-8b10b-prbs-cocotb-vip/actions/workflows/ci.yml)
[[https://img.shields.io/badge/License-MIT-blue.svg]](LICENSE)

Portable Python/Cocotb verification IP for SerDes links featuring **K28.5 (`10'b0011111010`) comma alignment**, **PRBS-7 (`x^7 + x^6 + 1`)** and **PRBS-31 (`x^31 + x^28 + 1`)** generators/checkers, and deterministic bit-error fault injection across **Verilator 5.020** and **Icarus Verilog**.

## Run Locally
```bash
make -C tb SIM=verilator
make -C tb SIM=icarus
