`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2025 20:13:31
// Design Name: 
// Module Name: phase_accumulator
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


module phase_accumulator(
    input wire clock,
    input wire [15:0] frequency,       // frequency input in Hz (supports up to 65535 Hz)
    input wire reset,
    output reg [31:0] phase_angle
);

parameter CLK_FREQ = 100_000_000;      // 100 MHz clock
parameter PHASE_BITS = 32;

// Wires for divider
wire [47:0] dividend = frequency * (1 << PHASE_BITS);
wire [31:0] divisor = CLK_FREQ;
wire [31:0] freq_word;
wire valid;

// Instantiate divider
freq_divider freq_div_inst (
    .aclk(clock),
    .s_axis_dividend_tvalid(1'b1),
    .s_axis_dividend_tdata(dividend),
    .s_axis_divisor_tvalid(1'b1),
    .s_axis_divisor_tdata(divisor),
    .m_axis_dout_tvalid(valid),
    .m_axis_dout_tdata(freq_word)
);

always @(posedge clock or posedge reset) begin
    if(reset) begin
        phase_angle <= 0;
    end else begin
        phase_angle <= phase_angle + freq_word;
    end
end

endmodule