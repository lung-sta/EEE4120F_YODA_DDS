// A simple 8-bit PWM Generator module
// It takes a clock input and a duty cycle value (0-255), 
// and outputs a PWM signal with the corresponding duty cycle.

module pwm_generator(
    input clk,             // Clock input (100 MHz for the Nexys a7 board)
    input rst,             // Active-high reset signal
    input [7:0] pwm_in,    // 8-bit PWM input (duty cycle value from 0 to 255)
    output reg pwm_out     // Output PWM signal
);

// 8-bit counter that counts from 0 to 255 repeatedly
reg [7:0] counter;


// Triggers on every rising edge of the clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 8'd0;
        pwm_out <= 1'b0;
    end else begin
        counter <= counter + 1;                           // Increment counter every clock cycle
    // Set output HIGH if counter is less than the input duty cycle
    // Set output LOW otherwise
        pwm_out <= (counter < pwm_in) ? 1'b1 : 1'b0;
    end
end

endmodule



