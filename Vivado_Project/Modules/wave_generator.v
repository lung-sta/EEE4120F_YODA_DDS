`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2025 21:03:01
// Design Name: 
// Module Name: wave_generator
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


module wave_generator (
    input wire clock,
    input wire [31:0] phase_angle,
    input wire [1:0] wave_type, // 00=sine, 01=square, 10=triangle, 11=sawtooth
    input wire [15:0] amplitude,
    output reg signed [15:0] wave_out
);

    // Wave LUT declarations
    reg signed [15:0] sine_lut [0:1023];
    reg signed [15:0] square_lut [0:1023];
    reg signed [15:0] triangle_lut [0:1023];
    reg signed [15:0] sawtooth_lut [0:1023];
    
    // Initialize LUTs from hex files
    initial begin
        $readmemh("sine_lut_values.mem", sine_lut);
        $readmemh("square_lut_values.mem", square_lut);
        $readmemh("triangle_lut_values.mem", triangle_lut);
        $readmemh("sawtooth_lut_values.mem", sawtooth_lut);
    end

    // Wave generation
    always @(posedge clock) begin
        case(wave_type)
            2'b00: wave_out <= (sine_lut[phase_angle[31:22]] * amplitude) >>> 15;
            2'b01: wave_out <= (square_lut[phase_angle[31:22]] * amplitude) >>> 15;
            2'b10: wave_out <= (triangle_lut[phase_angle[31:22]] * amplitude) >>> 15;
            2'b11: wave_out <= (sawtooth_lut[phase_angle[31:22]] * amplitude) >>> 15;
        endcase
    end
endmodule
