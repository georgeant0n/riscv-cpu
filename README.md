# RISC-V CPU (RV32I subset) in Verilog

A single-cycle RISC processor built from scratch in Verilog, verified with SystemVerilog
testbenches, and targeted to a Xilinx Artix-7 FPGA (Digilent Basys 3). Built as a hands-on
VLSI / digital-design portfolio project.

## Status
**Week 1** — Verilog fundamentals & toolchain setup. First working module + testbench (`blinky`) ✅

## Repository structure
| Folder | Contents |
|--------|----------|
| `rtl/` | Synthesizable Verilog design sources |
| `tb/`  | Testbenches (Verilog / SystemVerilog) |
| `asm/` | Assembly test programs + Python assembler (added in week 3) |
| `sim/` | Simulation notes / scripts |
| `docs/`| Architecture notes & curated learning resources |

## Toolchain
- **Vivado ML Standard** (free) — simulation + synthesis
- Target part: `xc7a35tcpg236-1` (Digilent Basys 3, Artix-7)

## Roadmap
1. **Verilog fundamentals + toolchain** (this week) — HDLBits, first module + testbench
2. **Single-cycle RV32I datapath** — PC, Register File, ALU, Control, ImmGen, memories
3. **Integration + verification** — self-checking testbench, run a program via a small Python assembler
4. **FPGA** — constraints (XDC), I/O, synthesis, run on hardware

## Getting started (simulation)
1. Open Vivado → **Create Project** → RTL Project.
2. Add `rtl/*.v` as **design sources** and `tb/*.v` as **simulation sources**.
3. Set the testbench as the simulation top.
4. **Run Behavioral Simulation** → type `run all` in the Tcl console → **Zoom Fit**.

## What works so far
- `blinky` — a parameterized clock-divider that toggles an LED every `2^N` clock cycles,
  verified in behavioral simulation (`blinky_tb`).
