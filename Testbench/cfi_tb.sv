`timescale 1ns/100ps
module cfi_sargantana_tb;

	logic [31:0] data_i;
	logic clk_i;
	logic rstn_i;
	logic error_o;
	
	clock_gen #(100.0) c0 (.*);
	stimulus s0 (.*);
	cfi_sargantana dut(.*);
	verify v0 (.*);
	
	initial begin 
		$dumpfile("cfi.vcd");
		$dumpvars(0, cfi_sargantana_tb);
	end

endmodule 


