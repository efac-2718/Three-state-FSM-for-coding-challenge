module cfi_sargantana (input logic [31:0]data_i, input logic clk_i, rstn_i, output logic error_o);

	typedef enum {
		IDLE, CHECK, ERROR
	} state_t;

	logic [7:0]command;
	logic [23:0]data;
	
	assign command = data_i [31:24];
	assign data = data_i [23:0];
	
	localparam logic [7:0]SET = 8'b00000001;
	localparam logic [7:0]JUMP = 8'b00000010;
	localparam logic [7:0]LPAD = 8'b00000011;

	logic [23:0] label;
	
	state_t state, next_state;

	always_ff @(posedge clk_i, negedge rstn_i) begin: SEQ
		if (~rstn_i) begin
			state <= IDLE;
			label <= 24'b0;
		end else begin
			state <= next_state;
			if(state == IDLE && command == SET) begin
				label <= data;
			end
		end
	end
	
	always_comb begin: OP
		error_o = '0;
		next_state = state;
		
		case (state)
			IDLE: begin
					if (command == JUMP) begin
						next_state = CHECK;
					end
				end
			CHECK: begin 
					 if (command == LPAD && label == data) begin
						next_state = IDLE;
					 end else begin
						next_state = ERROR;
					 end
					end
			ERROR: begin
					next_state = ERROR;
					end
		endcase
		
		if (state == ERROR) begin
			error_o = 1'b1;
		end
	end
endmodule
