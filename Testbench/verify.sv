`timescale 1ns/100ps
module verify (input logic [31:0] data_i,
					input logic clk_i, rstn_i, error_o);
					
	localparam logic [7:0] SET = 8'h01;
	localparam logic [7:0] JUMP = 8'h02;
	localparam logic [7:0] LPAD = 8'h03;
	
	logic [7:0] cmd;
	logic [23:0] lbl;
	assign cmd = data_i[31:24];
	assign lbl = data_i[23:0];
	
	int unsigned fails = 0;
	
	
	typedef enum logic [1:0] {M_IDLE, M_CHECK, M_ERROR} mstate_e;
	mstate_e m_state;
	logic [23:0] m_label;
	
	always_ff @(posedge clk_i, negedge rstn_i) begin
		if (!rstn_i) begin
			m_state <= M_IDLE;
			m_label <= 24'h0;
		end
		else case (m_state)
			M_IDLE: begin
						if (cmd == SET) m_label <= lbl;
						if (cmd == JUMP) m_state <= M_CHECK;
					  end
		   M_CHECK: m_state <= (cmd == LPAD && lbl == m_label) ? M_IDLE : M_ERROR;
			default: m_state <= M_ERROR;
		endcase
	end
	
	a_match: assert property (@(posedge clk_i) disable iff (!rstn_i)
	                          error_o == (m_state == M_ERROR))
	  else begin
	    fails++;
	    $error("error_o=%b but model is in %s", error_o, m_state.name());
	  end
	
	
	always @(negedge rstn_i) begin
		#1;
		if(error_o !== 1'b0) begin
			fails++;
			$display("FAIL @%0t: reset did not clear error_o", $time);
		end 
	end
	
	final begin
		$display("---------------------------");
		$display(" failures: %0d", fails);
		$display(" RESULT : %s", (fails == 0) ? "PASS" : "FAIL");
		$display("---------------------------");
	end
endmodule
		
		
		
		
		