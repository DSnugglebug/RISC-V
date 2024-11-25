/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_instruction_mux.v   

Description :      32-bit RV32 Multiplexer for Instruction Register

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_instruction_mux(flush_in, ms_riscv32_mp_instr_in, opcode_out, funct3_out, funct7_out, rs_1_addr_out, rs_2_addr_out, rd_addr_out, csr_addr_out, instr_out);

input flush_in;
input[31:0] ms_riscv32_mp_instr_in;
output reg[2:0] funct3_out;
output reg[4:0] rs_1_addr_out, rs_2_addr_out, rd_addr_out;
output reg[6:0] opcode_out, funct7_out;
output reg[11:0] csr_addr_out;
output reg[24:0] instr_out;

parameter FLUSH = 32'h00000013;
/*
reg[2:0] hold_funct3_out;
reg[4:0] hold_rs_1_addr_out, hold_rs_2_addr_out, hold_rd_addr_out;
reg[6:0] hold_opcode_out, hold_funct7_out;
reg[11:0] hold_csr_addr_out;
reg[24:0] hold_instr_out;
*/
always@*
begin
	if(flush_in)
	begin
		opcode_out = FLUSH[6:0];
		funct3_out = FLUSH[14:12];
		funct7_out = FLUSH[31:25];
		csr_addr_out = FLUSH[31:20];
		rs_1_addr_out = FLUSH[19:15];
		rs_2_addr_out = FLUSH[24:20];
		rd_addr_out = FLUSH[11:7];
		instr_out = FLUSH[31:7];
	end
	else
	begin
		opcode_out = ms_riscv32_mp_instr_in[6:0];
		funct3_out = ms_riscv32_mp_instr_in[14:12];
		funct7_out = ms_riscv32_mp_instr_in[31:25];
		csr_addr_out = ms_riscv32_mp_instr_in[31:20];
		rs_1_addr_out = ms_riscv32_mp_instr_in[19:15];
		rs_2_addr_out = ms_riscv32_mp_instr_in[24:20];
		rd_addr_out = ms_riscv32_mp_instr_in[11:7];
		instr_out = ms_riscv32_mp_instr_in[31:7];
	end
end
/*
assign funct3_out = hold_funct3_out;
assign rs_1_addr_out = hold_rs_1_addr_out;
assign rs_2_addr_out = hold_rs_2_addr_out;
assign rd_addr_out = hold_rd_addr_out;
assign opcode_out = hold_opcode_out;
assign funct7_out = hold_funct7_out;
assign csr_addr_out = hold_csr_addr_out;
assign instr_out = hold_instr_out;
*/
endmodule
