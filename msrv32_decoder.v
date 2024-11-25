/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_decoder.v   

Description :      32-bit RV32 Decoder

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
`timescale 1ns /1ps
module msrv32_decoder(trap_taken_in, funct7_five_in, opcode_in, funct3_in, iadder_out_1_0_in, alu_opcode_out,
			mem_wr_req_out, load_size_out, load_unsigned_out, alu_src_out, iadder_src_out,
			csr_wr_en_out, rf_wr_en_out, wb_mux_sel_out, imm_type_out, csr_op_out, illegal_instr_out,
			misaligned_load_out, misaligned_store_out);

input trap_taken_in,  funct7_five_in;
input[1:0] iadder_out_1_0_in;
input[2:0] funct3_in;
input[6:0] opcode_in;
output mem_wr_req_out, load_unsigned_out, alu_src_out, iadder_src_out, csr_wr_en_out, rf_wr_en_out, illegal_instr_out, misaligned_load_out, misaligned_store_out;
output[1:0] load_size_out;
output[3:0] alu_opcode_out;
output[2:0] csr_op_out, imm_type_out, wb_mux_sel_out;

parameter	OP_R   =  5'b01100,
		OP_IMM =  5'b00100,
		LOAD   =  5'b00000,
		STORE  =  5'b01000,
		BRANCH =  5'b11000,
		JAL    =  5'b11011,  
		JALR   =  5'b11001,
		LUI    =  5'b01101,
		AUIPC  =  5'b00101,
		ENVRM  =  5'b11100,
		MISC   =  5'b00011;


parameter	ADD  =	3'b000,
		SLL  =	3'b001,
		SLT  =	3'b010,
		SLTU =	3'b011,
		XOR  =	3'b100,
		SRL  =	3'b101,
		SRA  =  3'b101,
		OR   =	3'b110,
		AND  =	3'b111;
reg is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem;
reg is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori;
wire is_csr, is_implemented_instr;
wire mal_word, mal_half;

always@*
begin
case(opcode_in[6:2])
	BRANCH:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b10000000000;
	JAL:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b01000000000;
	JALR:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00100000000;
	AUIPC:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00010000000;
	LUI:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00001000000;
	OP_R:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000100000;
	OP_IMM:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000010000;
	LOAD:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000001000;
	STORE:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000000100;
	ENVRM:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000000010;
	MISC:	{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem}	= 11'b00000000001;
	default:{is_branch, is_jal, is_jalr, is_auipc, is_lui, is_op_r, is_op_imm, is_load, is_store, is_envrm, is_misc_mem} 	= 11'b00000000000;
endcase
end

always@*
begin
case(funct3_in)
	ADD:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
	SLT:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {1'b0, is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0};
	SLTU:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {1'b0, 1'b0, is_op_imm, 1'b0, 1'b0, 1'b0};
	AND:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, is_op_imm, 1'b0, 1'b0};
	OR:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, is_op_imm, 1'b0};
	XOR:	{is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, is_op_imm};
	default: {is_addi, is_slti, is_sltui, is_andi, is_ori, is_xori} = 6'b000000;
endcase
end

assign mal_word = funct3_in[1] & ~funct3_in[0] & (iadder_out_1_0_in[1] | iadder_out_1_0_in[0]);
assign mal_half = ~funct3_in[1] & funct3_in[0] & iadder_out_1_0_in[0];

assign alu_opcode_out[2:0] = funct3_in;
assign csr_op_out = funct3_in;
assign alu_opcode_out[3] = funct7_five_in & ~(is_addi | is_slti | is_sltui | is_andi | is_ori | is_xori);
assign load_size_out = funct3_in[1:0];
assign load_unsigned_out = funct3_in[2];
assign alu_src_out = opcode_in[5];

assign iadder_src_out = is_load | is_store | is_jalr;

assign rf_wr_en_out = is_lui | is_auipc | is_jalr | is_jal | is_op_r | is_load | is_csr | is_op_imm;

assign wb_mux_sel_out[0] = is_load | is_auipc | is_jal | is_jalr;
assign wb_mux_sel_out[1] = is_lui | is_auipc;
assign wb_mux_sel_out[2] = is_csr | is_jal | is_jalr;

assign imm_type_out[0] = is_op_imm | is_load | is_jalr | is_branch | is_jal;
assign imm_type_out[1] = is_store | is_branch | is_csr;
assign imm_type_out[2] = is_lui | is_auipc | is_jal | is_csr;

assign is_implemented_instr = is_branch | is_jal | is_jalr | is_auipc | is_lui | is_op_r | is_op_imm | is_load | is_store | is_envrm | is_misc_mem;

assign is_csr = is_envrm & (funct3_in[0] | funct3_in[1] | funct3_in[2]);
assign csr_wr_en_out = is_csr;

assign illegal_instr_out = ~is_implemented_instr | ~opcode_in[1] | ~opcode_in[0];

assign misaligned_load_out = (mal_half | mal_word) & is_load;
assign misaligned_store_out = (mal_half | mal_word) & is_store;

//assign mem_wr_req_out = (is_store & trap_taken_in) && ((mal_word && mal_half)==1'b0? 1'b1: 1'b0); 
assign mem_wr_req_out = is_store & ~trap_taken_in & ~(mal_word | mal_half); 


endmodule
