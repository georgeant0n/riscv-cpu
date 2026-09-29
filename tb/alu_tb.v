// alu_tb.v — self-checking testbench for alu.
`timescale 1ns/1ps
module alu_tb;
    reg  [31:0] a, b;
    reg  [2:0]  alu_ctrl;
    wire [31:0] result;
    wire        zero;
    integer     errors = 0;

    alu dut (.a(a), .b(b), .alu_ctrl(alu_ctrl), .result(result), .zero(zero));

    // Apply one operation and compare result + zero flag.
    task check(input [2:0] op, input [31:0] x, input [31:0] y,
               input [31:0] exp, input exp_zero, input [8*20-1:0] what);
        begin
            alu_ctrl = op; a = x; b = y; #1;
            if (result !== exp || zero !== exp_zero) begin
                $display("FAIL: %0s  result=%h zero=%b  expected=%h zero=%b",
                         what, result, zero, exp, exp_zero);
                errors = errors + 1;
            end else
                $display("pass: %0s = %h (zero=%b)", what, result, zero);
        end
    endtask

    initial begin
        //     op      a              b              expected       zero  name
        check(3'b000, 32'd5,         32'd7,         32'd12,        1'b0, "ADD 5+7");
        check(3'b000, 32'hFFFFFFFF,  32'd1,         32'd0,         1'b1, "ADD wraps to 0");
        check(3'b001, 32'd10,        32'd3,         32'd7,         1'b0, "SUB 10-3");
        check(3'b001, 32'd3,         32'd10,        32'hFFFFFFF9,  1'b0, "SUB 3-10 = -7");
        check(3'b001, 32'd42,        32'd42,        32'd0,         1'b1, "SUB equal -> zero");
        check(3'b010, 32'hF0F0F0F0,  32'hFF00FF00,  32'hF000F000,  1'b0, "AND");
        check(3'b011, 32'hF0F0F0F0,  32'h0F0F0F0F,  32'hFFFFFFFF,  1'b0, "OR");
        check(3'b101, 32'd3,         32'd9,         32'd1,         1'b0, "SLT 3<9");
        check(3'b101, 32'd9,         32'd3,         32'd0,         1'b1, "SLT 9<3");
        check(3'b101, 32'hFFFFFFFF,  32'd1,         32'd1,         1'b0, "SLT -1<1 signed");
        check(3'b101, 32'd1,         32'hFFFFFFFF,  32'd0,         1'b1, "SLT 1<-1 signed");
        check(3'b111, 32'd5,         32'd7,         32'd0,         1'b1, "unused op -> 0");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
