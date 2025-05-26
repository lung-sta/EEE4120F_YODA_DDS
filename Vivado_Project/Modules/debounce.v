`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 11:38:52
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce(
    input wire clock,
    input wire btn_in,
    output reg btn_out
);

    reg [3:0] shift_reg;

    always @(posedge clock) begin
        shift_reg <= {shift_reg[2:0], btn_in};
        if (&shift_reg)         // All 1s
            btn_out <= 1;
        else if (~|shift_reg)   // All 0s
            btn_out <= 0;
    end
endmodule
