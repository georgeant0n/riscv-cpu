// blinky_tb.v — testbench for blinky: generates clock + reset, runs to $finish.
`timescale 1ns/1ps
module blinky_tb;
    reg  clk = 0;
    reg  rst = 1;
    wire led;

    blinky #(.N(3)) dut (.clk(clk), .rst(rst), .led(led));

    always #5 clk = ~clk;      // 100 MHz clock (10 ns period)

    initial begin
        #20  rst = 0;          // release reset
        #400 $finish;          // run long enough to see several LED toggles
    end
endmodule
