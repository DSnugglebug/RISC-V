/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_top.v   

Description :      32-bit RV32 top module

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_top(ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, ms_riscv32_mp_instr_hready_in,
		ms_riscv32_mp_dmdata_in, ms_riscv32_mp_instr_in, ms_riscv32_mp_hresp_in, ms_riscv32_mp_rc_in,
		ms_riscv32_mp_data_hready_in, ms_riscv32_mp_eirq_in, ms_riscv32_mp_tirq_in, ms_riscv32_mp_sirq_in,
		ms_riscv32_mp_dmwr_req_out, ms_riscv32_mp_imaddr_out, ms_riscv32_mp_dmaddr_out, ms_riscv32_mp_dmdata_out,
		ms_riscv32_mp_dmwr_mask_out, ms_riscv32_mp_data_htrans_out);


input ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, ms_riscv32_mp_instr_hready_in,
	ms_riscv32_mp_hresp_in, ms_riscv32_mp_data_hready_in, ms_riscv32_mp_eirq_in,
	ms_riscv32_mp_tirq_in, ms_riscv32_mp_sirq_in;
input[31:0] ms_riscv32_mp_dmdata_in, ms_riscv32_mp_instr_in;
input[63:0] ms_riscv32_mp_rc_in;
output ms_riscv32_mp_dmwr_req_out; 
output[1:0] ms_riscv32_mp_data_htrans_out;
output[3:0] ms_riscv32_mp_dmwr_mask_out;
output[31:0] ms_riscv32_mp_imaddr_out, ms_riscv32_mp_dmaddr_out, ms_riscv32_mp_dmdata_out;

wire 	hold_ir_wr_gn_file_out, hold_ir_wr_gn_flush_in_mc_out, hold_ir_mux_flush_in_mc_out,
	hold_reg_2_wr_gn_rf_out, hold_reg_2_wr_gn_csr_out, hold_ir_wr_gn_csr_out, hold_brch_out,
	hold_dec_trap_in_mc_out, hold_dec_mem_req_out, hold_dec_load_unsign_out, hold_dec_alu_src_out,
	hold_dec_iadder_src_out, hold_dec_csr_wr_en_out, hold_dec_rf_wr_en_out, hold_dec_illegal_instr_out,
	hold_dec_mis_load_out, hold_dec_mis_store_out, hold_reg_2_load_unsign_out, hold_reg_2_alu_src_out,
	hold_pc_misalinged_instr_out_mc_in, hold_mc_int_ext_out, hold_mc_int_ext_en_out, hold_mc_pc_en_out,
	hold_mc_instr_count_out, hold_mc_clear_mie_out, hold_mc_set_mie_out, misaligned_exception, hold_csr_mie_out,
	hold_csr_meie_out, hold_csr_mtie_out, hold_csr_msie_out, hold_csr_meip_out, hold_csr_mtip_out, 
	hold_csr_msip_out;
wire[1:0] hold_pc_src_in_mc_out, hold_dec_load_size_out, hold_reg_2_load_size_out;
wire[2:0] hold_ir_funct3_out, hold_dec_wb_mux_out, hold_dec_imm_type_out, hold_dec_csr_op_out, hold_reg_2_wb_mux_sel_out,
	  hold_reg_2_csr_op_out;
wire[3:0] hold_dec_alu_opc_out, hold_reg_2_alu_opc_out, hold_mc_int_ext_code_out;
wire[4:0] hold_rs_1_addr_out, hold_rs_2_addr_out, hold_rd_addr_out, hold_reg_2_rd_addr_out;
wire[6:0] hold_ir_opc_out, hold_ir_funct7_out;
wire[11:0] hold_ir_mux_csr_addr_out, hold_reg_2_csr_addr_out;
wire[24:0] hold_ir_mux_instr_out;
wire[31:0] hold_pc_trap_addr_in_csr_out, hold_pc_iaddr_in_imm_addr_out, hold_epc_in_csr_out, 
	hold_pc_in_reg_1_out, hold_pc_plus_4_out, hold_pc_mux_out_reg_1_in, hold_reg_1_out, 
	hold_imm_gen_out, hold_rs_1_out, hold_rs_2_out, hold_imm_add_out, hold_reg_2_pc_plus_4_out,
	hold_reg_2_pc_out, hold_reg_2_rs_2_out, hold_reg_2_rs_1_out, hold_reg_2_imm_out, 
	hold_reg_2_iadder_out, hold_lu_out, hold_wb_mux_to_alu_out, hold_alu_result_out, hold_csr_data_out, hold_wb_mux_out;

	
msrv32_pc PC(.ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), .pc_src_in(hold_pc_src_in_mc_out),
	.pc_in(hold_pc_in_reg_1_out), .epc_in(hold_epc_in_csr_out), .trap_address_in(hold_pc_trap_addr_in_csr_out),
	.branch_taken_in(hold_brch_out), .iaddr_in(hold_imm_add_out[31:1]), 
	.ahb_ready_in(ms_riscv32_mp_instr_hready_in), .ms_riscv32_mp_iaddr_out(ms_riscv32_mp_imaddr_out),
	.pc_plus_4_out(hold_pc_plus_4_out), .misaligned_instr_logic_out(hold_pc_misalinged_instr_out_mc_in), 
	.pc_mux_out(hold_pc_mux_out_reg_1_in));

msrv32_reg_block_1 REG_1(.ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
			.pc_mux_in(hold_pc_mux_out_reg_1_in), .pc_out(hold_reg_1_out));


msrv32_imm_generator IMM_GEN(.instr_in(hold_ir_mux_instr_out), .imm_type_in(hold_dec_imm_type_out),
				.imm_out(hold_imm_gen_out));


msrv32_immediate_adder IMM_ADDER(.iadder_src_in(hold_dec_iadder_src_out), .pc_in(hold_reg_1_out), .rs_1_in(hold_rs_1_out),
				.imm_in(hold_imm_gen_out), .iadder_out(hold_imm_add_out));
/*
msrv32_integer_file IRF(.ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), 
				.wr_en_in(hold_ir_wr_gn_file_out), .rs_1_addr_in(hold_rs_1_addr_out), 
				.rs_2_addr_in(hold_rs_2_addr_out), .rd_addr_in(hold_reg_2_rd_addr_out), .rd_in(hold_wb_mux_out),
				.rs_1_out(hold_rs_1_out), .rs_2_out(hold_rs_2_out));
*/

msrv32_integer_file IRF(.clk_in(ms_riscv32_mp_clk_in), .reset_in(ms_riscv32_mp_rst_in), 
				.wr_en_in(hold_ir_wr_gn_file_out), .rs_1_addr_in(hold_rs_1_addr_out), 
				.rs_2_addr_in(hold_rs_2_addr_out), .rd_addr_in(hold_reg_2_rd_addr_out), .rd_in(hold_wb_mux_out),
				.rs_1_out(hold_rs_1_out), .rs_2_out(hold_rs_2_out));

msrv32_wr_en_generator IR_WR_GEN(.flush_in(hold_ir_wr_gn_flush_in_mc_out), .rf_wr_en_reg_in(hold_reg_2_wr_gn_rf_out), 
				.csr_wr_en_reg_in(hold_reg_2_wr_gn_csr_out), .wr_en_integer_file_out(hold_ir_wr_gn_file_out),
				 .wr_en_csr_file_out(hold_ir_wr_gn_csr_out));


msrv32_instruction_mux IR_MUX(.flush_in(hold_ir_mux_flush_in_mc_out), .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in), .opcode_out(hold_ir_opc_out),
			 .funct3_out(hold_ir_funct3_out), .funct7_out(hold_ir_funct7_out), .rs_1_addr_out(hold_rs_1_addr_out), 
			.rs_2_addr_out(hold_rs_2_addr_out), .rd_addr_out(hold_rd_addr_out), .csr_addr_out(hold_ir_mux_csr_addr_out), 
			.instr_out(hold_ir_mux_instr_out));


msrv32_branch_unit BRCH(.rs_1_in(hold_rs_1_out), .rs_2_in(hold_rs_2_out), .opcode_in(hold_ir_opc_out[6:2]), .funct3_in(hold_ir_funct3_out),
			 .branch_taken_out(hold_brch_out));


msrv32_decoder DEC(.trap_taken_in(hold_dec_trap_in_mc_out), .funct7_five_in(hold_ir_funct7_out[5]), .opcode_in(hold_ir_opc_out), 
		.funct3_in(hold_ir_funct3_out), .iadder_out_1_0_in(hold_imm_add_out[1:0]), .alu_opcode_out(hold_dec_alu_opc_out),
		.mem_wr_req_out(hold_dec_mem_req_out), .load_size_out(hold_dec_load_size_out), .load_unsigned_out(hold_dec_load_unsign_out),
		.alu_src_out(hold_dec_alu_src_out), .iadder_src_out(hold_dec_iadder_src_out), .csr_wr_en_out(hold_dec_csr_wr_en_out), 
		.rf_wr_en_out(hold_dec_rf_wr_en_out), .wb_mux_sel_out(hold_dec_wb_mux_out), .imm_type_out(hold_dec_imm_type_out), 
		.csr_op_out(hold_dec_csr_op_out), .illegal_instr_out(hold_dec_illegal_instr_out), .misaligned_load_out(hold_dec_mis_load_out),
		.misaligned_store_out(hold_dec_mis_store_out));


msrv32_reg_block_2 REG2(.ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in), .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in), .rd_addr_in(hold_rd_addr_out), 
			.csr_addr_in(hold_ir_mux_csr_addr_out), .rs_1_in(hold_rs_1_out), .rs_2_in(hold_rs_2_out), .pc_in(hold_reg_1_out), 
			.pc_plus_4_in(hold_pc_plus_4_out), .branch_taken_in(hold_brch_out), .iadder_in(hold_imm_add_out), 
			.alu_opcode_in(hold_dec_alu_opc_out), .load_size_in(hold_dec_load_size_out), .load_unsigned_in(hold_dec_load_unsign_out),
			.alu_src_in(hold_dec_alu_src_out), .csr_wr_en_in(hold_dec_csr_wr_en_out), .rf_wr_en_in(hold_dec_rf_wr_en_out),
			.wb_mux_sel_in(hold_dec_wb_mux_out), .csr_op_in(hold_dec_csr_op_out), .imm_in(hold_imm_gen_out), 
			.rd_addr_reg_out(hold_reg_2_rd_addr_out), .csr_addr_reg_out(hold_reg_2_csr_addr_out), .rs_1_reg_out(hold_reg_2_rs_1_out),
			.rs_2_reg_out(hold_reg_2_rs_2_out), .pc_reg_out(hold_reg_2_pc_out), .pc_plus_4_reg_out(hold_reg_2_pc_plus_4_out), 
			.iadder_out_reg_out(hold_reg_2_iadder_out), .alu_opcode_reg_out(hold_reg_2_alu_opc_out), .load_size_reg_out(hold_reg_2_load_size_out),
			.load_unsigned_reg_out(hold_reg_2_load_unsign_out), .alu_src_reg_out(hold_reg_2_alu_src_out), .csr_wr_en_reg_out(hold_reg_2_wr_gn_csr_out),
			.rf_wr_en_reg_out(hold_reg_2_wr_gn_rf_out), .wb_mux_sel_reg_out(hold_reg_2_wb_mux_sel_out), .csr_op_reg_out(hold_reg_2_csr_op_out),
			.imm_reg_out(hold_reg_2_imm_out));


msrv32_store_unit STORE(.funct3_in(hold_ir_funct3_out[1:0]), .iadder_in(hold_imm_add_out), .rs_2_in(hold_rs_2_out), .mem_wr_req_in(hold_dec_mem_req_out), 
		.ahb_ready_in(ms_riscv32_mp_data_hready_in), .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out), .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
		.ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out), .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out), .ahb_htrans_out(ms_riscv32_mp_data_htrans_out));

msrv32_load_unit_v2 LOAD(.ahb_resp_in(ms_riscv32_mp_hresp_in), .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in), .iadder_out_1_0_in(hold_reg_2_iadder_out[1:0]), 
			.load_unsigned_in(hold_reg_2_load_unsign_out), .load_size_in(hold_reg_2_load_size_out), .lu_output_out(hold_lu_out));


msrv32_alu ALU(.op_1_in(hold_reg_2_rs_1_out), .op_2_in(hold_wb_mux_to_alu_out), .opcode_in(hold_reg_2_alu_opc_out), .result_out(hold_alu_result_out));


msrv32_wb_mux_sel_unit WB_MUX(.alu_src_reg_in(hold_reg_2_alu_src_out), .wb_mux_sel_reg_in(hold_reg_2_wb_mux_sel_out), .alu_result_in(hold_alu_result_out), .lu_output_in(hold_lu_out),
			.imm_reg_in(hold_reg_2_imm_out), .iadder_out_reg_in(hold_reg_2_iadder_out), .csr_data_in(hold_csr_data_out), .pc_plus_4_reg_in(hold_reg_2_pc_plus_4_out), 
			.rs_2_reg_in(hold_reg_2_rs_2_out), .wb_mux_out(hold_wb_mux_out), .alu_2nd_src_mux_out(hold_wb_mux_to_alu_out));

msrv32_csr_file CSRF(.clk_in(ms_riscv32_mp_clk_in), .rst_in(ms_riscv32_mp_rst_in), .wr_en_in(hold_ir_wr_gn_csr_out), .csr_addr_in(hold_reg_2_csr_addr_out), 
		.csr_op_in(hold_reg_2_csr_op_out), .csr_uimm_in(hold_reg_2_imm_out[4:0]), .csr_data_in(hold_reg_2_rs_1_out), .csr_data_out(hold_csr_data_out),
		.pc_in(hold_reg_2_pc_out), .iadder_in(hold_reg_2_iadder_out), .e_irq_in(ms_riscv32_mp_eirq_in), .t_irq_in(ms_riscv32_mp_tirq_in), .s_irq_in(ms_riscv32_mp_sirq_in),
		.i_or_e_in(hold_mc_int_ext_out), .set_cause_in(hold_mc_int_ext_en_out), .cause_in(hold_mc_int_ext_code_out), .set_epc_in(hold_mc_pc_en_out), 
		.instret_inc_in(hold_mc_instr_count_out), .mie_clear_in(hold_mc_clear_mie_out), .mie_set_in(hold_mc_set_mie_out), .misaligned_exception_in(misaligned_exception), 
		.mie_out(hold_csr_mie_out), .meie_out(hold_csr_meie_out), .mtie_out(hold_csr_mtie_out), .msie_out(hold_csr_msie_out), .meip_out(hold_csr_meip_out), 
		.mtip_out(hold_csr_mtip_out), .msip_out(hold_csr_msip_out), .real_time_in(ms_riscv32_mp_rc_in), .epc_out(hold_epc_in_csr_out), .trap_address_out(hold_pc_trap_addr_in_csr_out));

msrv32_machine_control MC(.clk_in(ms_riscv32_mp_clk_in), .reset_in(ms_riscv32_mp_rst_in), .illegal_instr_in(hold_dec_illegal_instr_out), .misaligned_instr_in(hold_pc_misalinged_instr_out_mc_in),
			.misaligned_load_in(hold_dec_mis_load_out), .misaligned_store_in(hold_dec_mis_store_out), .opcode_6_to_2_in(hold_ir_opc_out[6:2]), .funct3_in(hold_ir_funct3_out),
			.funct7_in(hold_ir_funct7_out), .rs1_addr_in(hold_rs_1_addr_out), .rs2_addr_in(hold_rs_2_addr_out), .rd_addr_in(hold_rd_addr_out), .e_irq_in(ms_riscv32_mp_eirq_in),
			.t_irq_in(ms_riscv32_mp_tirq_in), .s_irq_in(ms_riscv32_mp_sirq_in), .i_or_e_out(hold_mc_int_ext_out), .set_cause_out(hold_mc_int_ext_en_out), .cause_out(hold_mc_int_ext_code_out),
			.set_epc_out(hold_mc_pc_en_out), .instret_inc_out(hold_mc_instr_count_out), .mie_clear_out(hold_mc_clear_mie_out), .mie_set_out(hold_mc_set_mie_out), 
			.misaligned_exception_out(misaligned_exception), .mie_in(hold_csr_mie_out), .meie_in(hold_csr_meie_out), .mtie_in(hold_csr_mtie_out), .msie_in(hold_csr_msie_out), 
			.meip_in(hold_csr_meip_out), .mtip_in(hold_csr_mtip_out), .msip_in(hold_csr_msip_out), .pc_src_out(hold_pc_src_in_mc_out), .flush_out(hold_ir_wr_gn_flush_in_mc_out), 
			.trap_taken_out(hold_dec_trap_in_mc_out));

endmodule

