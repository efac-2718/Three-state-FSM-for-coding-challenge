`timescale 1ns/100ps
module clock_gen #(parameter real ClockFreq_MHz = 100.0) (output logic clk_i);

localparam real ClockHigh = (500.0)/ClockFreq_MHz;

initial
	begin
		clk_i = 1'b0;
	forever #(ClockHigh) clk_i = ~clk_i;
	end
	
endmodule
