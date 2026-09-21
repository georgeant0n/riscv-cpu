# Learning resources

Curated materials for this project — theory, Verilog, tools, and RISC-V.

## 1. Theory — how a CPU works
- **Onur Mutlu — Digital Design & Computer Architecture (ETH Zürich)** — the gold-standard
  free course; builds a single-cycle → pipelined processor exactly like we will.
  https://www.youtube.com/@OnurMutluLectures
- **Harris & Harris — *Digital Design and Computer Architecture: RISC-V Edition*** — the
  companion textbook for the course. https://pages.hmc.edu/harris/ddca/
- **Ben Eater — 8-bit breadboard computer** — best intuition for what a datapath/control
  unit *is*, at the gate level. Concepts transfer directly to RTL. https://eater.net/8bit

## 2. Verilog — the language
- **HDLBits** — interactive practice, the fastest way to learn Verilog. https://hdlbits.01xz.net
- **nandland** — beginner-friendly Verilog + FPGA tutorials, with videos.
  https://nandland.com  ·  YouTube: https://www.youtube.com/@nandland
- **ASIC-World Verilog** — reference/cheat-sheet. https://www.asic-world.com/verilog/veritut.html

## 3. Tools — Vivado
- **Digilent — Getting started with Vivado**
  https://digilent.com/reference/programmable-logic/guides/getting-started-with-vivado
- **nandland — Vivado / FPGA getting started** (video walkthroughs).

## 4. RISC-V
- **RISC-V unprivileged ISA spec (RV32I base)** — https://riscv.org/technical/specifications/
- Keep the RV32I instruction encodings handy when writing the decoder.

## HDLBits path for this project (do in this order)
1. **Getting Started** (Step one, Output Zero)
2. **Verilog Language → Basics** (Wire, GND, NOR, …)
3. **Verilog Language → Vectors** (all of them)
4. **Verilog Language → Modules: Hierarchy**
5. **Verilog Language → Procedures** (always blocks, if, case) — *most important*
6. **Circuits → Combinational Logic → Multiplexers, Arithmetic**
7. **Circuits → Sequential Logic → Flip-flops, Counters, Finite State Machines**

These seven cover everything needed to build the CPU. The rest of HDLBits is optional bonus.
