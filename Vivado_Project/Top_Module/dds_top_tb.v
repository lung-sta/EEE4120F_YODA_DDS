`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 18:31:18
// Design Name: 
// Module Name: dds_top_tb
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

module dds_top_tb;
    integer fd;
    // Inputs
    reg clock = 0;
    reg reset = 0;
    reg [3:0] sw = 4'b0000;
    reg btnU_raw = 0;
    reg btnD_raw = 0;
    reg btnL_raw = 0;
    reg btnR_raw = 0;

    // Outputs
    wire pwm_out;
    wire [7:0] seg;
    wire [7:0] anode;

    // Clock generation: 100 MHz
    always #5 clock = ~clock;

    // Instantiate the Unit Under Test (UUT)
    dds_top2 uut (
        .clock(clock),
        .reset(reset),
        .sw(sw),
        .btnU_raw(btnU_raw),
        .btnD_raw(btnD_raw),
        .btnL_raw(btnL_raw),
        .btnR_raw(btnR_raw),
        .pwm_out(pwm_out),
        .seg(seg),
        .anode(anode)
    );
    
initial begin
    fd = $fopen("pwm_output.csv", "w"); // Use "output.txt" if preferred
    if (fd == 0) begin
        $display("Error opening file.");
        $finish;
    end
    $fwrite(fd, "time, signal_value\n"); // Write header (optional)
end

always @(posedge clock) begin
    $fwrite(fd, "%0t, %0d\n", $time, pwm_out);  // Time and value
end

    initial begin
        // Start with reset asserted
        reset = 1;
        #100;              // 100 ns reset
        reset = 0;

        // Initial waveform selection
        sw = 4'b0000;      // Default waveform

        // Wait for 2 ms before changing inputs
        #8000000;          // 2 ms = 2,000,000 ns

        // Simulate pressing btnU to increase frequency
        btnU_raw = 1;
        #100000;           // 100 us button press
        btnU_raw = 0;

        // Wait another 2 ms
        #8000000;

        // Simulate pressing btnD to decrease frequency
        btnD_raw = 1;
        #100000;
        btnD_raw = 0;

        // Wait another 2 ms
        #8000000;

        // Simulate pressing btnR to increase amplitude
        btnR_raw = 1;
        #100000;
        btnR_raw = 0;

        // Wait another 2 ms
        #8000000;

        // Simulate pressing btnL to decrease amplitude
        btnL_raw = 1;
        #100000;
        btnL_raw = 0;

        // Wait a little before ending simulation
        #40000000;
        
        $fclose(fd);
        $finish;
    end
    
endmodule


