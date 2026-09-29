// imem_tb.v — self-checking testbench for imem (loads tb/imem_test.hex).
`timescale 1ns/1ps
module imem_tb;
    reg  [31:0] addr;
    wire [31:0] instr;
    integer     errors = 0;

    imem #(.DEPTH(64), .INIT_FILE("C:/fpga/riscv-cpu/tb/imem_test.hex"))
        dut (.addr(addr), .instr(instr));

    task check(input [31:0] a, input [31:0] exp, input [8*28-1:0] what);
        begin
            addr = a; #1;
            if (instr !== exp) begin
                $display("FAIL: %0s  got=%h  expected=%h", what, instr, exp);
                errors = errors + 1;
            end else
                $display("pass: %0s -> %h", what, instr);
        end
    endtask

    initial begin
        check(32'd0,  32'h00500093, "addr 0  (word 0) addi");
        check(32'd4,  32'h0080A103, "addr 4  (word 1) lw");
        check(32'd8,  32'h0020A623, "addr 8  (word 2) sw");
        check(32'd12, 32'h00208463, "addr 12 (word 3) beq");
        check(32'd16, 32'h010000EF, "addr 16 (word 4) jal");
        check(32'd6,  32'h0080A103, "addr 6 -> low bits ignored");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
