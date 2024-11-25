/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_imm_generator.v   

Description :      32-bit RV32 Immediate Generator

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
`timescale 1ns / 1ps
module msrv32_imm_generator(instr_in, imm_type_in, imm_out);

input[31:7] instr_in;
input[2:0] imm_type_in;
output reg[31:0] imm_out;

wire [31:0] hold_r_type, hold_i_type, hold_s_type, hold_b_type, hold_u_type, hold_j_type, hold_csr_type;
//reg [31:0] hold_imm_out;

assign hold_r_type = { {20{instr_in[31]}}, instr_in[31:20]};
assign hold_i_type = {{20{instr_in[31]}}, instr_in[31:20]};
assign hold_s_type = {{20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]}; 
assign hold_b_type = {{19{instr_in[31]}},instr_in[31],instr_in[7],instr_in[30:25], instr_in[11:8], 1'b0};
assign hold_u_type = {instr_in[31:12], 12'h000};
assign hold_j_type = {{11{instr_in[31]}}, instr_in[31], instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0};
assign hold_csr_type = {27'b0, instr_in[19:15]};

always@*
begin
	case(imm_type_in)
		3'b000:	imm_out = hold_r_type;
		3'b001: imm_out = hold_i_type;
		3'b010: imm_out = hold_s_type;
		3'b011: imm_out = hold_b_type;
		3'b100:	imm_out = hold_u_type;
		3'b101: imm_out = hold_j_type;
		3'b110: imm_out = hold_csr_type;
		3'b111: imm_out = hold_i_type;
		default: imm_out = hold_i_type;
	endcase
end

//assign imm_out = hold_imm_out;

endmodule 
