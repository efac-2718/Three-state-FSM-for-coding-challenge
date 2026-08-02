`timescale 1ns/100ps
program automatic stimulus
		(output logic [31:0] data_i, 
		 output logic 			rstn_i, 
		 input logic 			clk_i);

	 localparam logic [7:0] NOP  = 8'h00;
	 localparam logic [7:0] SET  = 8'h01;
	 localparam logic [7:0] JUMP = 8'h02;
	 localparam logic [7:0] LPAD = 8'h03; 
	 
	task drive(input logic [7:0] cmd, input logic [23:0] lbl);
		data_i = {cmd, lbl};
		@(posedge clk_i);
	endtask
	
	task reset();
		rstn_i = 1'b0;
		data_i = {NOP, 24'h0};
		repeat (2) @(posedge clk_i);
		rstn_i = 1'b1;
		@(posedge clk_i);
	endtask
	
	initial begin
		reset();
		drive(SET, 24'hABCDEF);
		drive(NOP, 24'h123456);
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'hABCDEF);
		
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'hABCDEF);
		
		drive(SET, 24'hABCDEF);
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'hABCDEE);
		
		drive(SET, 24'hABCDEE);
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'hABCDEE);
		
		reset();
		drive(SET, 24'h112233);
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'h112233);
		
		drive(JUMP, 24'h000000);
		drive(NOP, 24'h000000);
		drive(NOP, 24'h000000);
		
		reset();
		drive(JUMP, 24'h000000);
		drive(LPAD, 24'h000000);
		
		drive(LPAD, 24'h999999);
		drive(NOP, 24'h000000);
		
		$display("stimulus complete");
		$finish;
		end
endprogram
		
		
		
		

	