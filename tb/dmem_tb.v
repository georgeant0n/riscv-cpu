// dmem_tb.v — self-checking testbench for dmem.
`timescale 1ns/1ps
module dmem_tb;
    reg         clk = 0;
    reg         we = 0;
    reg  [31:0] addr = 0, wd = 0;
    wire [31:0] rd;
    integer     errors = 0;

    dmem #(.DEPTH(64)) dut (.clk(clk), .we(we), .addr(addr), .wd(wd), .rd(rd));

    always #5 clk = ~clk;

    task write_word(input [31:0] a, input [31:0] data);
        begin
            @(negedge clk); we = 1; addr = a; wd = data;
            @(negedge clk); we = 0;
        end
    endtask

    task check(input [31:0] a, input [31:0] exp, input [8*24-1:0] what);
        begin
            addr = a; #1;
            if (rd !== exp) begin
                $display("FAIL: %0s  got=%h  expected=%h", what, rd, exp);
                errors = errors + 1;
            end else
                $display("pass: %0s = %h", what, rd);
        end
    endtask

    initial begin
        write_word(32'd0,   32'hDEADBEEF);
        write_word(32'd4,   32'h12345678);
        write_word(32'd252, 32'hCAFEF00D);          // last word (index 63)

        check(32'd0,   32'hDEADBEEF, "addr 0");
        check(32'd4,   32'h12345678, "addr 4");
        check(32'd252, 32'hCAFEF00D, "addr 252 (last word)");

        // we = 0: memory must NOT change
        @(negedge clk); we = 0; addr = 32'd4; wd = 32'h0;
        @(negedge clk);
        check(32'd4, 32'h12345678, "addr 4 unchanged (we=0)");

        // overwrite
        write_word(32'd0, 32'h00000042);
        check(32'd0, 32'h00000042, "addr 0 overwritten");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
