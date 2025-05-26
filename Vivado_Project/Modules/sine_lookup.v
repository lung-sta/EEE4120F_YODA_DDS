`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 17:43:09
// Design Name: 
// Module Name: sine_lookup
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


module sine_lookup (
    input wire clock,
    input wire [10:0] addr,             // 11-bit address input (0-2047 if needed)
    output reg signed [15:0] value      // 16-bit signed output
);

    // Declare ROM to hold the sine wave values
    reg signed [15:0] sine_rom [0:1023]; // 1024-entry ROM (for a 10-bit addr normally)

    // Initialize the ROM from a file (optional)
    initial begin
        $readmemh("sine_lut_values.mem", sine_rom);
    end

    // On every clock edge, output the corresponding sine value
    always @(posedge clock) begin
        value <= sine_rom[addr[9:0]];    // Using only the lower 10 bits to index 0-1023
    end

endmodule

