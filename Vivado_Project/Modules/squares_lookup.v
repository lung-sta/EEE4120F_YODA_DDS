`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 18:05:13
// Design Name: 
// Module Name: squares_lookup
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


module squares_lookup(
    input wire clock,
    input wire [9:0] addr,       // 11 bits
    output reg [15:0] value       // 16-bit output
);

reg [15:0] rom [0:1023];

initial begin
    $readmemh("square_lut_values.mem", rom);
end

always @(posedge clock) begin
    value <= rom[addr];
end

endmodule

