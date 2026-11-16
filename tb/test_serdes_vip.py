import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

async def run_prbs(dut, prbs31, errs):
    dut.rst_n.value = 0; dut.mode_prbs31.value = prbs31; dut.send_comma.value = 1; dut.err_inject.value = 0
    await Timer(20, units="ns"); dut.rst_n.value = 1
    for _ in range(3): await RisingEdge(dut.clk)
    dut.send_comma.value = 0
    for _ in range(25): await RisingEdge(dut.clk)
    assert int(dut.rx_locked.value) == 1
    assert int(dut.rx_ok_cnt.value) >= 20 and int(dut.rx_err_cnt.value) == 0
    for _ in range(errs):
        dut.err_inject.value = 1; await RisingEdge(dut.clk)
    dut.err_inject.value = 0; await RisingEdge(dut.clk); await RisingEdge(dut.clk)
    assert int(dut.rx_err_cnt.value) == errs, f"expected {errs}, got {dut.rx_err_cnt.value}"

@cocotb.test()
async def test_prbs7_and_prbs31(dut):
    cocotb.start_soon(Clock(dut.clk, 4, units="ns").start())
    await run_prbs(dut, 0, 3)
    await run_prbs(dut, 1, 2)
    dut._log.info("PASS: K28.5 comma lock + PRBS-7/31 + fault injection verified!")
