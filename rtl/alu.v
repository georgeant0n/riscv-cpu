// alu.v — Arithmetic Logic Unit
// Computes one operation on a and b, chosen by alu_ctrl.
//
//   alu_ctrl   operation   result
//   --------   ---------   ---------------------------------------------
//   3'b000     ADD         a + b
//   3'b001     SUB         a - b
//   3'b010     AND         a & b
//   3'b011     OR          a | b
//   3'b101     SLT         1 if a < b (as SIGNED numbers), else 0
//   other      -           0
//
//   zero = 1 when result == 0   (beq uses SUB and checks zero)
module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);
    // TODO 1 — always @(*) with a case on alu_ctrl (like the mux in module_shift8).
    //          Hint for SLT: $signed(a) < $signed(b) compares as signed numbers.
    always @(*) begin
    case (alu_ctrl)
        3'b000:  result = a + b;
        3'b001:  result = a-b;
        3'b010:  result = a&b;
        3'b011:  result = a | b;
        3'b101:  result = $signed(a) < $signed(b) ? 1:0;
        default: result = 32'b0;
    endcase
end

    // TODO 2 — zero flag: one assign statement.
    assign zero = result == 0 ? 1 :0;

endmodule
