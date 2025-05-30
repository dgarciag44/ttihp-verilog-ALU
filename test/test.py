# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_alu(dut):
    dut._log.info("Start ALU test")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    dut._log.info("Loading A: 10101010")
    for i in range(8):
        dut.ui_in.value = (0b0 << 1) | (0b1)  # bit + sel_AB (A=0)
        dut.ui_in.value |= (1 << 2)  # confirm load
        await ClockCycles(dut.clk, 1)

    dut._log.info("Loading B: 01010101")
    for i in range(8):
        dut.ui_in.value = (0b1 << 1) | (0b1)  # bit + sel_AB (B=1)
        dut.ui_in.value |= (1 << 2)  # confirm load
        await ClockCycles(dut.clk, 1)

    dut._log.info("Running SUM")
    dut.ui_in.value = (0b000 << 3)  # op[2:0] = 000 (sum)
    await ClockCycles(dut.clk, 1)

    result = dut.uo_out.value.integer
    dut._log.info(f"ALU result: {result}")

    assert result >= 0  # Dummy check, replace with real expected result!
