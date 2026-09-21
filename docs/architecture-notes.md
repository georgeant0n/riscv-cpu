# Architecture notes

Personal notes as the design comes together. Fill in as you go.

## Instruction set (planned RV32I subset)
Start with these ~10 instructions, then extend:

| Instr | Type | Meaning |
|-------|------|---------|
| `add`  | R | rd = rs1 + rs2 |
| `sub`  | R | rd = rs1 - rs2 |
| `and`  | R | rd = rs1 & rs2 |
| `or`   | R | rd = rs1 \| rs2 |
| `addi` | I | rd = rs1 + imm |
| `lw`   | I | rd = mem[rs1 + imm] |
| `sw`   | S | mem[rs1 + imm] = rs2 |
| `beq`  | B | if (rs1 == rs2) pc += imm |
| `jal`  | J | rd = pc+4; pc += imm |
| _(stretch: `slt`, `bne`, `jalr`, `andi`, `ori`)_ | | |

## Modules (single-cycle)
- `pc`        — program counter register
- `imem`      — instruction memory (ROM)
- `regfile`   — 32× 32-bit registers, 2 read ports + 1 write port
- `alu`       — add/sub/and/or/slt (+ zero flag for branches)
- `immgen`    — sign-extend immediates by instruction type
- `control`   — main decoder + ALU decoder → control signals
- `dmem`      — data memory (for lw/sw)
- `datapath`  / `cpu` top — wires it all together

## Control signals (fill in the table per instruction)
| Instr | RegWrite | ALUSrc | MemWrite | MemToReg | Branch | ALUOp |
|-------|----------|--------|----------|----------|--------|-------|
| add   |          |        |          |          |        |       |
| ...   |          |        |          |          |        |       |
