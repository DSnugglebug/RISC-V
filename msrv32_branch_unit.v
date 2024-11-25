/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_branch_unit.v   

Description :      32-bit RV32 Branch Signal

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
`timescale 1ns/1ps
module msrv32_branch_unit(rs_1_in, rs_2_in, opcode_in, funct3_in, branch_taken_out);

input[31:0] rs_1_in, rs_2_in;
input[6:2] opcode_in;
input[2:0] funct3_in;
output branch_taken_out;

parameter OPCODE_BRANCH	= 5'b11000;
parameter OPCODE_JAL	= 5'b11011;
parameter OPCODE_JALR	= 5'b11001;

//reg hold_branch_taken_out;
//wire signed[31:0] signed_rs_1_in, signed_rs_2_in;
wire pc_mux_sel;
wire pc_mux_sel_en;
reg is_branch;
reg is_jal;
reg is_jalr;
wire is_jump;
reg take;

assign is_jump = is_jal | is_jalr; //signed_rs_1_in = rs_1_in;
assign pc_mux_sel_en = is_branch | is_jal | is_jalr; //signed_rs_2_in = rs_2_in;
assign pc_mux_sel = (is_jump == 1'b1)? 1'b1 :take;
assign branch_taken_out = pc_mux_sel_en & pc_mux_sel;


always@*
begin
	case(funct3_in)
		3'b000:	take = (rs_1_in == rs_2_in);
		3'b001:	take = !(rs_1_in == rs_2_in);
		3'b100: take = (rs_1_in[31] ^ rs_2_in[31])? rs_1_in[31] :(rs_1_in < rs_2_in);
		3'b101: take = (rs_1_in[31] ^ rs_2_in[31])? ~rs_1_in[31] :!(rs_1_in < rs_2_in);
		3'b110:	take = (rs_1_in < rs_2_in);
		3'b111: take = !(rs_2_in < rs_1_in);
		default:take = 1'b0;
	endcase
end
	
always@*
begin
	{is_jal, is_jalr, is_branch} = 0;
	case(opcode_in)
		OPCODE_JAL:	is_jal = 1'b1;
		OPCODE_JALR:	is_jalr= 1'b1;
		OPCODE_BRANCH:	is_branch = 1'b1;
		default:	{is_jal, is_jalr, is_branch} =3'b000;
	endcase
end
		

endmodule
