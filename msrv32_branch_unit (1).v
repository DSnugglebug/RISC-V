/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_branch_unit.v   

Description :      32-bit RV32 Branch Signal

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_branch_unit(rs_1_in, rs_2_in, opcode_in, funct3_in, branch_taken_out);

input[31:0] rs_1_in, rs_2_in;
input[4:0] opcode_in;
input[2:0] funct3_in;
output branch_taken_out;

reg hold_branch_taken_out;
wire signed[31:0] signed_rs_1_in, signed_rs_2_in;

assign signed_rs_1_in = rs_1_in;
assign signed_rs_2_in = rs_2_in;
 
always@*
begin
	if (opcode_in == 5'b11000)
	begin
		case(funct3_in)
			3'b000:	begin
				if(rs_1_in == rs_2_in)
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end
			3'b001:	begin
				if(!(rs_1_in == rs_2_in))
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end
			3'b100: begin
				if(signed_rs_1_in < signed_rs_2_in)
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end
			3'b101: begin
				if(!(signed_rs_1_in < signed_rs_2_in)) 
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end 
			3'b110:	begin
				if(rs_1_in < rs_2_in)
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end
			3'b111: begin
				if(!(rs_2_in < rs_1_in))
					hold_branch_taken_out = 1'b1;
				else
					hold_branch_taken_out = 1'b0;
				end
			default:	hold_branch_taken_out =1'b0;
		endcase
	end
	else
		hold_branch_taken_out = 1'b0;
		
end
assign branch_taken_out = hold_branch_taken_out;
endmodule
