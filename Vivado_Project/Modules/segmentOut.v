`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2025 10:37:17
// Design Name: 
// Module Name: segmentOut
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

module segmentOut(
    input wire clk,
    input wire [3:0] sw,
    input wire [15:0] freq,
    input wire [7:0] amp,
    output reg [7:0] seg,
    output reg [7:0] anode
    );

    //Used only here
    integer freq_khz;
    integer d2, d1, d0;
    reg [6:0] digit [7:0];
    reg [7:0] dp = 8'b11111111;
    reg [3:0] a1, a0;
    
    // Simple 7-segment lookup    
    function [6:0] num;
        input [3:0] val;
        case (val)
            4'd0: num = 7'b0000001;
            4'd1: num = 7'b1001111;
            4'd2: num = 7'b0010010;
            4'd3: num = 7'b0000110;
            4'd4: num = 7'b1001100;
            4'd5: num = 7'b0100100;
            4'd6: num = 7'b0100000;
            4'd7: num = 7'b0001111;
            4'd8: num = 7'b0000000;
            4'd9: num = 7'b0010000;
            default: num = 7'b1111111; // blank
        endcase
    endfunction
    
    // Character encoding for letters
    function [6:0] let;
        input [7:0] ch;
        case (ch)
            "S": let = 7'b0100100;
            "I": let = 7'b1111001;
            "N": let = 7'b0001001;
            "A": let = 7'b0001000;
            "W": let = 7'b1010101;
            "Q": let = 7'b0001100;
            "R": let = 7'b0011001;
            "T": let = 7'b1110000;
            default: let = 7'b1111111; // blank default
        endcase
    endfunction    
    
    // Refresh for 8 digits
    reg [2:0] digit_sel = 0;
    reg [19:0] counter = 0;
    
    always @(posedge clk) begin
        counter <= counter + 1;
        // Update the display every 10ns (100MHz clock period)
        if (counter == 100000) begin
            counter <= 0;
            if (digit_sel == 3'd7)
                digit_sel <= 0;
            else
                digit_sel <= digit_sel + 1;
        end
    end
    
    //main 
    always @(posedge clk)
    begin
        // Default: blank all
        digit[0] = 7'b1111111;
        digit[1] = 7'b1111111;
        digit[2] = 7'b1111111;
        digit[3] = 7'b1111111;
        digit[4] = 7'b1111111;
        digit[5] = 7'b1111111;
        digit[6] = 7'b1111111;
        digit[7] = 7'b1111111;
        dp = 8'b11111111;
                 
        case(sw)
            4'b1000: begin //for sin
                digit[7] = let("S");
                digit[6] = let("I");
                digit[5] = let("N");
            end
            4'b0001: begin //for saw
                digit[7] = let("S");
                digit[6] = let("A");
                digit[5] = let("W");
            end
            4'b0100: begin //for squ
                digit[7] = let("S");
                digit[6] = let("Q");
                digit[5] = let("R");
            end
            4'b0010: begin //for tri
                digit[7] = let("T");
                digit[6] = let("R");
                digit[5] = let("I");
            end
            default: begin //otherwise sine wave
                digit[7] = let("S");
                digit[6] = let("I");
                digit[5] = let("N");
            end
        endcase
    
        // frequency to hundredths of kHz
        freq_khz = (freq * 100) / 1000;
        
        //to segment display
        if (freq < 1000) begin
            d2 = 0;
            d1 = (freq_khz/100)%10;
            d0 = (freq_khz/10)%10;
            dp[4] = 1'b0;
        end else if (freq < 10000) begin
            d2 = (freq_khz/100)%10; //get tens/hundreds
            d1 = (freq_khz/10)%10; //get ones/tens
            d0 = freq_khz%10; //get dp/ones
            dp[4] = 1'b0;
        end else begin
            d2 = (freq_khz/1000)%10; //get tens/hundreds
            d1 = (freq_khz/100)%10; //get ones/tens
            d0 = (freq_khz/10)%10; //get dp/ones
            dp[3] = 1'b0;
        end
        
        digit[4] = num(d2);
        digit[3] = num(d1);
        digit[2] = num(d0);
        
        a1 = (amp / 10) % 10;
        a0 = amp % 10;
        digit[1] = num(a1);
        digit[0] = num(a0);
        
    end
    
    // Segment and anode outputs
    always @(posedge clk) begin
        seg = {dp[digit_sel], digit[digit_sel]};
        anode = 8'b11111111;
        anode[digit_sel] = 1'b0;
    end
    
endmodule
