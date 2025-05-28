# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_fsm(dut):
    dut._log.info("Start FSM test")

    # Setup clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initial values
    dut.ena.value = 1  # Always enable
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Apply reset
    dut._log.info("Applying reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Test case 1: manual mode (BT high)
    dut._log.info("Testing manual mode BT=1")
    dut.ui_in.value = 0b000001 | (0b01 << 4)  # BT=1, select=01
    await ClockCycles(dut.clk, 2)
    dut._log.info(f"Output K: {dut.uo_out.value}")

    # Test case 2: temp low, BT=0
    dut._log.info("Testing automatic mode temp=00")
    dut.ui_in.value = 0b000000  # BT=0, temp=00
    await ClockCycles(dut.clk, 2)
    dut._log.info(f"Output K: {dut.uo_out.value}")

    # Test case 3: temp medium, BT=0
    dut._log.info("Testing automatic mode temp=01")
    dut.ui_in.value = 0b000100  # BT=0, temp=01
    await ClockCycles(dut.clk, 2)
    dut._log.info(f"Output K: {dut.uo_out.value}")

    # More test cases can be added here...

    dut._log.info("FSM test completed")
