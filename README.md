# RISC-V CPU (RV32I subset) in Verilog

A single-cycle RISC processor built from scratch in Verilog, verified with SystemVerilog
testbenches, and targeted to a Xilinx Artix-7 FPGA (Digilent Basys 3). Built as a hands-on
VLSI / digital-design portfolio project.

## Status
**Stage 2 complete** — every building block of the single-cycle datapath is implemented and
verified by its own self-checking testbench (7 modules, 55 checks, all passing).
**Next:** integrate them into a top-level CPU and run real programs.

| Module | Description | Status |
|--------|-------------|--------|
| `pc`      | Program counter (sync reset) | ✅ passes `pc_tb` |
| `regfile` | 32×32-bit register file, 2 read / 1 write port, x0 hardwired to 0 | ✅ passes `regfile_tb` |
| `alu`     | ADD / SUB / AND / OR / signed SLT + zero flag | ✅ passes `alu_tb` |
| `immgen`  | Immediate generator for I / S / B / J formats (sign-extended) | ✅ passes `immgen_tb` |
| `control` | Main decoder + ALU decoder + next-PC select (lw, sw, R-type, addi, beq, jal) | ✅ passes `control_tb` |
| `imem`    | Instruction memory (ROM, loaded with `$readmemh`, word-addressed) | ✅ passes `imem_tb` |
| `dmem`    | Data memory (sync write, combinational read) | ✅ passes `dmem_tb` |
| `cpu` (top) | Wire everything into a working processor | ⏳ next (stage 3) |

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
