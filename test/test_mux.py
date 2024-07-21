import cocotb
from cocotb.types import LogicArray
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
import re
import os
import binascii


async def enable_design(dut, mux_addr):
    dut._log.info(f"enabling design at mux address {mux_addr}")
    dut.ctrl_ena.value = 0
    dut.ctrl_sel_rst_n.value = 0
    dut.ctrl_sel_inc.value = 0
    await Timer(100, units="ns")
    dut.ctrl_sel_rst_n.value = 1
    await Timer(100, units="ns")
    for i in range(mux_addr):
        dut.ctrl_sel_inc.value = 1
        await Timer(100, units="ns")
        dut.ctrl_sel_inc.value = 0
        await Timer(100, units="ns")
    dut.ctrl_ena.value = 1
    await Timer(100, units="ns")


@cocotb.test()
async def test_factory_test(dut):
    clock = Clock(dut.clk, 100, units="ns")  # 10 MHz
    cocotb.start_soon(clock.start())

    dut.uio.value = LogicArray("Z" * 8)
    dut.ui_in.value = 0
    # select test design
    dut.rst_n.value = 0
    await enable_design(dut, 1)

    # with bit 0 of ui_in set to 0, module will copy inputs to outputs
    dut.ui_in.value = 0b0
    await ClockCycles(dut.clk, 5)  # wait until the wait state config is read
    dut.rst_n.value = 1

    dut._log.info("test loopback")
    for i in range(256):
        dut.uio.value = i
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value == i

    # with bit 0 of ui_in set to 1, module will enable bidirectional outputs and put a counter on both output and bidirectional output
    dut.uio.value = LogicArray("Z" * 8)
    dut.ui_in.value = 0b1

    # reset it
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)  # wait until the wait state config is read
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)  # sync

    dut._log.info("test counter")
    for i in range(256):
        assert dut.uo_out.value == dut.uio.value
        assert dut.uo_out.value == i
        await ClockCycles(dut.clk, 1)  # wait until the wait state config is read


@cocotb.test()
async def test_rom(dut):
    clock = Clock(dut.clk, 100, units="ns")  # 10 MHz
    cocotb.start_soon(clock.start())

    dut.uio.value = LogicArray("Z" * 8)
    dut.ui_in.value = 0
    # select ROM design
    dut.rst_n.value = 0
    await enable_design(dut, 0)

    dut._log.info("test ROM")
    buf = bytearray(256)
    for byte_idx in range(len(buf)):
        dut.ui_in.value = byte_idx
        await ClockCycles(dut.clk, 1)
        buf[byte_idx] = dut.uo_out.value.integer

    text = buf[32:128].rstrip(b"\0").decode("ascii")
    items = {}
    for line in text.split("\n"):
        if len(line) == 0:
            break
        key, value = line.split("=", 2)
        items[key] = value

    dut._log.info(f"ROM start bytes: {binascii.hexlify(buf[:32], ' ').decode('ascii')}")
    dut._log.info(f"ROM text data: {items}")

    assert "shuttle" in items
    assert "repo" in items
    # commit is not available in IHP ROM
    #assert "commit" in items

    assert items["repo"] == os.environ.get("EXPECTED_REPO")
    #assert re.match("^[0-9a-f]{8}$", items["commit"]) != None

    magic = buf[248:252]
    assert magic == b"TT\xFA\xBB"

    crc32 = int.from_bytes(buf[252:256], "little")
    assert crc32 == binascii.crc32(buf[0:252])

@cocotb.test()
async def test_loopback(dut):
    for c in "loopback test":
        for i in range(8):
            bit = (ord(c) >> i) & 1
            dut.loopback_in.value = bit
            await Timer(100, units="ns")
            assert dut.loopback_out.value == bit
