`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 11:37:34
// Design Name: 
// Module Name: input_controller
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


module input_controller (
    input wire clock,             //System Clock
    input wire reset,             //Asynchronous reset

    input wire btnU_raw, btnD_raw, btnL_raw, btnR_raw, btnC_raw, // Raw pushbutton inputs
    input wire [3:0] sw, // waveform selection

    output reg [15:0] freq_word,            //frequency control word
    output reg [7:0] amp_word,              //amplitude control word
    output reg [1:0] waveform_select        //selected waveform output (00=sine, 01=square, 10=triangle ,11=sawtooth)
);

    wire btnU, btnD, btnL, btnR, reset;

    // Instantiate debouncers for each button
    debounce dbU(.clock(clock), .btn_in(btnU_raw), .btn_out(btnU)); //increase frequency
    debounce dbD(.clock(clock), .btn_in(btnD_raw), .btn_out(btnD)); //decrease frequency
    debounce dbL(.clock(clock), .btn_in(btnL_raw), .btn_out(btnL)); //decrease amplitude
    debounce dbR(.clock(clock), .btn_in(btnR_raw), .btn_out(btnR)); //increase amplitude
    debounce dbC(.clock(clock), .btn_in(btnC_raw), .btn_out(btnC)); //reset

    // Registers to hold previous button states for edge detection
    reg btnU_prev, btnD_prev, btnL_prev, btnR_prev, btnC_prev;

    // Constants
    parameter FREQ_STEP = 16'd1000;
    parameter AMP_STEP  = 8'd3;
    parameter FREQ_MAX = 16'd20000;
    parameter AMP_MAX = 8'd99;
    parameter FREQ_MIN = FREQ_STEP;
    parameter AMP_MIN = AMP_STEP;
    //synchronous logic with asynchronous reset
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            //set defaults on reset
            freq_word <= 16'd10000;
            amp_word <= 8'd30;
            waveform_select <= 2'b00;
            
            //clear previous button states
            btnU_prev <= 0;
            btnD_prev <= 0;
            btnL_prev <= 0;
            btnR_prev <= 0;
            btnC_prev<= 0;
        end else begin
        if (btnC && btnC_prev)begin
            //set defaults on reset
            freq_word <= 16'd10000;
            amp_word <= 8'd30;
            waveform_select <= 2'b00;
            end else begin
            // Rising edge detection and updating the registers
                //increasing/decreasing parameters using pushbuttons
                if (btnU && !btnU_prev && freq_word <= FREQ_MAX - FREQ_STEP)
                    freq_word <= freq_word + FREQ_STEP;

                if (btnD && !btnD_prev && freq_word >= FREQ_MIN)
                    freq_word <= freq_word - FREQ_STEP;

                if (btnR && !btnR_prev && amp_word <= freq_word <= AMP_MAX - AMP_STEP)
                    amp_word <= amp_word + AMP_STEP;

                if (btnL && !btnL_prev && amp_word >= AMP_MIN)
                    amp_word <= amp_word - AMP_STEP;
                end
            // Update previous states
            btnU_prev <= btnU;
            btnD_prev <= btnD;
            btnL_prev <= btnL;
            btnR_prev <= btnR;
            btnC_prev <= btnC;
            // Waveform selection from switches
             // Priority waveform selection using slide switches
            if (sw[3])       // sine
                waveform_select <= 2'b00;
            else if (sw[2])  // square
                waveform_select <= 2'b01;
            else if (sw[1])  // triangle
                waveform_select <= 2'b10;
            else if (sw[0])  // sawtooth
                waveform_select <= 2'b11;
            else
                waveform_select <= 2'b00; // default to sine if none selected
        end
      end
endmodule

