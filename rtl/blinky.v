// blinky.v — parameterized clock-divider LED blinker
// N=3 in simulation (toggles every 8 clocks, easy to see in waveform).
// On Basys 3 (100 MHz) use N=26 for ~1.5 Hz.
module blinky #(parameter N = 3) (
    input  wire clk,
    input  wire rst,
    output reg  led
);
    reg [N-1:0] count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            led   <= 1'b0;
        end else if (count == (1<<N)-1) begin
            count <= 0;
            led   <= ~led;          // toggle the LED
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
