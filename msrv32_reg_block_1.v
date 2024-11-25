/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_reg_block_1.v   

Description :      32-bit RV32 Pipelined Register One

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_reg_block_1(ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, pc_mux_in, pc_out);

input ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in;
input[31:0] pc_mux_in;
output reg[31:0] pc_out;

//reg[31:0] hold_pc_out;


always@(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in)
begin
	if(ms_riscv32_mp_rst_in)
		pc_out <= 0;
	else
		pc_out <= pc_mux_in;
end
//assign pc_out = hold_pc_out;

endmodule
