`timescale 1ns/1ps
module clock_generation_sim
#(
    parameter           CLK_1_FREQUENCY                 = 100_000_000,
    parameter           CLK_1_INITIALIZING_DELAY        = 100,
    parameter           CLK_1_PHASE                     = 30
) 
(
    output  reg                     clk_out_1
);
// NECESSARY PARAMETER
// ---
localparam  CIRCULAR_PHASE          = 360;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLK_1_PERIOD            = SECOND_IN_NANOSECOND/CLK_1_FREQUENCY;
localparam  LOW                     = 1'b0;
localparam  HIGH                    = 1'b1;
// ---

// CLOCK GENERATION
// ---
initial
begin
    clk_out_1   = LOW;
    #(CLK_1_INITIALIZING_DELAY);
    #((CLK_1_PHASE/CIRCULAR_PHASE)*CLK_1_PERIOD);
    forever
    begin
        #(CLK_1_PERIOD/2);
        clk_out_1   = !clk_out_1;
    end
end
// ---
endmodule