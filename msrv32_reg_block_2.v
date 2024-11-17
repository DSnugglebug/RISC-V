/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_reg_block_2.v   

Description :      32-bit RV32 Pipelined Register Two

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
`timescale 1ns/1ps
module msrv32_reg_block_2(ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, rd_addr_in, csr_addr_in, rs_1_in, rs_2_in, 
	pc_in, pc_plus_4_in, branch_taken_in, iadder_in, alu_opcode_in, load_size_in, load_unsigned_in, alu_src_in,
	csr_wr_en_in, rf_wr_en_in, wb_mux_sel_in, csr_op_in, imm_in, rd_addr_reg_out, csr_addr_reg_out, rs_1_reg_out,
	rs_2_reg_out, pc_reg_out, pc_plus_4_reg_out, iadder_out_reg_out, alu_opcode_reg_out, load_size_reg_out,	
	load_unsigned_reg_out, alu_src_reg_out, csr_wr_en_reg_out, rf_wr_en_reg_out, wb_mux_sel_reg_out, csr_op_reg_out, imm_reg_out);

input ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, branch_taken_in, load_unsigned_in, alu_src_in, csr_wr_en_in, rf_wr_en_in;
input[1:0] load_size_in;
input[2:0] wb_mux_sel_in, csr_op_in;
input[3:0] alu_opcode_in;
input[4:0] rd_addr_in;
input[11:0] csr_addr_in;
input[31:0] rs_1_in, rs_2_in, pc_in, pc_plus_4_in, iadder_in, imm_in;  
output reg load_unsigned_reg_out, alu_src_reg_out, csr_wr_en_reg_out, rf_wr_en_reg_out;
output reg[1:0] load_size_reg_out;
output reg[2:0] wb_mux_sel_reg_out, csr_op_reg_out;
output reg[3:0] alu_opcode_reg_out;
output reg[4:0] rd_addr_reg_out;
output reg[11:0] csr_addr_reg_out;
output reg[31:0] rs_1_reg_out, rs_2_reg_out, pc_reg_out, pc_plus_4_reg_out, iadder_out_reg_out, imm_reg_out;

always@(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in)
begin
	if(ms_riscv32_mp_rst_in)
	begin
		load_unsigned_reg_out <= 1'b0;
		alu_src_reg_out <= 1'b0;
		csr_wr_en_reg_out <= 1'b0;
		rf_wr_en_reg_out <= 1'b0;

		load_size_reg_out <= 2'b00;

		wb_mux_sel_reg_out <= 3'b000;
		csr_op_reg_out <= 3'b000;

		alu_opcode_reg_out <= 4'h0;

		rd_addr_reg_out <= 5'b00000;

		csr_addr_reg_out <= 12'h000;

		rs_1_reg_out <= 32'h00000000;
		rs_2_reg_out <= 32'h00000000;
		pc_reg_out <= 32'h00000000;
		pc_plus_4_reg_out <= 32'h00000000;
		iadder_out_reg_out <= 32'h00000000;
		imm_reg_out <= 32'h00000000;
	end

	else
	begin
		load_unsigned_reg_out <= load_unsigned_in;
		alu_src_reg_out <= alu_src_in;
		csr_wr_en_reg_out <= csr_wr_en_in;
		rf_wr_en_reg_out <= rf_wr_en_in;

		load_size_reg_out <= load_size_in;

		wb_mux_sel_reg_out <= wb_mux_sel_in;
		csr_op_reg_out <= csr_op_in;

		alu_opcode_reg_out <= alu_opcode_in;

		rd_addr_reg_out <= rd_addr_in;

		csr_addr_reg_out <= csr_addr_in;

		rs_1_reg_out <= rs_1_in;
		rs_2_reg_out <= rs_2_in;
		pc_reg_out <= pc_in;
		pc_plus_4_reg_out <= pc_plus_4_in;
		iadder_out_reg_out[31:1] <=  iadder_in[31:1];
		iadder_out_reg_out[0] <= (branch_taken_in)? 1'b0: iadder_in[0];
		imm_reg_out <= imm_in;
	end

end
endmodule
