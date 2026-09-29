# RISC-V CPU (RV32I subset) in Verilog

A single-cycle RISC processor built from scratch in Verilog, verified with SystemVerilog
testbenches, and targeted to a Xilinx Artix-7 FPGA (Digilent Basys 3). Built as a hands-on
VLSI / digital-design portfolio project.

## Status
**Week 2** — building the single-cycle datapath, module by module. Each module has a
self-checking testbench.

| Module | Description | Status |
|--------|-------------|--------|
| `pc`      | Program counter (sync reset) | ✅ passes `pc_tb` |
| `regfile` | 32×32-bit register file, 2 read / 1 write port, x0 hardwired to 0 | ✅ passes `regfile_tb` |
| `alu`     | Arithmetic/logic unit | ⏳ next |
| `immgen`  | Immediate generator | ⏳ |
| `control` | Main + ALU decoder | ⏳ |
| `imem` / `dmem` | Instruction & data memories | ⏳ |

## Repository structure
| Folder | Contents |
|--------|----------|
| `rtl/` | Synthesizable Verilog design sources |
| `tb/`  | Testbenches (Verilog / SystemVerilog) |
| `asm/` | Assembly test programs + Python assembler (added in week 3) |
| `sim/` | `run.bat` — command-line simulation (`sim\run.bat <module>`) |
| `scripts/` | `create_vivado_project.tcl` — recreates the Vivado project |
| `docs/`| Architecture notes & curated learning resources |

## Toolchain
- **Vivado ML Standard** (free) — simulation + synthesis
- Target part: `xc7a35tcpg236-1` (Digilent Basys 3, Artix-7)

## Roadmap
1. **Verilog fundamentals + toolchain** (this week) — HDLBits, first module + testbench
2. **Single-cycle RV32I datapath** — PC, Register File, ALU, Control, ImmGen, memories
3. **Integration + verification** — self-checking testbench, run a program via a small Python assembler
4. **FPGA** — constraints (XDC), I/O, synthesis, run on hardware

## Running the tests
**Command line (fastest):**
```
sim\run.bat regfile     # compiles rtl\*.v + tb\regfile_tb.v, prints pass/FAIL per check
sim\run.bat pc
```

**Vivado GUI:**
1. `vivado -mode batch -source scripts/create_vivado_project.tcl` (creates the project once).
2. Open the project → set the desired testbench as simulation top → **Run Behavioral Simulation**.

## What works so far
- `blinky` — a parameterized clock-divider that toggles an LED every `2^N` clock cycles,
  verified in behavioral simulation (`blinky_tb`).
