`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 18:08:38
// Design Name: 
// Module Name: dds_top2
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


module dds_top2(
    input wire clock,
    input wire reset,
    input wire [3:0] sw,            //switch input for waveform selection
    input wire btnU_raw, btnD_raw, btnL_raw, btnR_raw, btnC_raw,    //Raw pushbutton inputs
    output wire pwm_out,            // Final PWM output signal
    output wire [7:0] seg,
    output wire [7:0] anode
);

// Internal wires
wire [31:0] phase_angle;
wire [9:0] lookup_addr;  // Only need 10 bits for 1024-entry ROMs
wire [15:0] sine_val, square_val, triangle_val, sawtooth_val;

// Wires for input controller outputs
wire [15:0] freq_word;
wire [7:0] amp_word;
wire [1:0] waveform_select;

wire [7:0] amplitude = 8'd255;

// Internal signal for wave_out (no longer an output)
wire [15:0] wave_out;
reg [15:0] wave_out_reg;  // Temporary reg to compute wave_out value

input_controller u_input_ctrl (
    .clock(clock),
    .reset(reset),
    .btnC_raw(btnC_raw),
    .btnU_raw(btnU_raw),
    .btnD_raw(btnD_raw),
    .btnL_raw(btnL_raw),
    .btnR_raw(btnR_raw),
    .sw(sw),
    .freq_word(freq_word),
    .amp_word(amp_word),
    .waveform_select(waveform_select)
);

// Instantiate phase accumulator
phase_accumulator u_phase_acc (
    .clock(clock),
    .reset(reset),
    .frequency(freq_word),
    .phase_angle(phase_angle)
);

// Take top 11 bits as lookup table address
assign lookup_addr = phase_angle[31:22];

// Instantiate lookup tables
sine_lookup u_sine_lookup (
    .clock(clock),
    .addr(lookup_addr),
    .value(sine_val)
);

squares_lookup u_square_lookup (
    .clock(clock),
    .addr(lookup_addr),
    .value(square_val)
);

triangles_lookup u_triangle_lookup (
    .clock(clock),
    .addr(lookup_addr),
    .value(triangle_val)
);

sawtooth_lookup u_sawtooth_lookup (
    .clock(clock),
    .addr(lookup_addr),
    .value(sawtooth_val)
);

// Choose waveform based on wave_type
always @(posedge clock) begin
        case (waveform_select)
            2'b00: wave_out_reg <= (sine_val * amplitude) >> 8;      // Scale amplitude (amplitude is 8 bits)
            2'b01: wave_out_reg <= (square_val * amplitude) >> 8;
            2'b10: wave_out_reg <= (triangle_val * amplitude) >> 8;
            2'b11: wave_out_reg <= (sawtooth_val * amplitude) >> 8;
            default: wave_out_reg <= 16'd0;
        endcase
   
end

// Assign the registered value to wave_out wire
assign wave_out = wave_out_reg;

pwm_generator u_pwm (
    .clk(clock),
    .rst(reset),
    .pwm_in(wave_out[7:0]), // Use bottom 8 bits of signed 16-bit output
    .pwm_out(pwm_out)
);

//Instantiate the segmentOut module
segmentOut u_seg (
    .clk(clock),
    .freq(freq_word),
    .amp(amp_word),
    .sw(sw),
    .seg(seg),
    .anode(anode)
);
endmodule


