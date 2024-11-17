/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_integer_file.v   

Description :      32-bit RV32 Integer File Register

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_integer_file(ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, rs_1_addr_in, rs_2_addr_in, rd_addr_in, wr_en_in, rd_in, rs_1_out, rs_2_out);
 

input ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, wr_en_in;
input[4:0] rs_1_addr_in, rs_2_addr_in, rd_addr_in;
input[31:0] rd_in;
output[31:0] rs_1_out, rs_2_out;

integer i;

reg[31:0]reg_file[0:31];
wire[31:0] hold_rs_1_out, hold_rs_2_out;

always@(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in)
begin
	if(ms_riscv32_mp_rst_in)
	begin
		for(i=0; i<32; i=i+1)
		 reg_file[i] <= 32'b0;
	end
	else if(wr_en_in && rd_addr_in)
		reg_file[rd_addr_in] <= rd_in;
end

//always@*
//begin
	//if(wr_en_in)
	//begin
assign hold_rs_1_out = (rs_1_addr_in == rd_addr_in && (wr_en_in==1'b1))? 1'b1: 1'b0; //rd_in: integer_reg_file[rs_1_addr_in];
assign hold_rs_2_out = (rs_2_addr_in == rd_addr_in && (wr_en_in==1'b1))? 1'b1: 1'b0; //rd_in: integer_reg_file[rs_2_addr_in];
	//end
	//else
	//begin
	//hold_rs_1_out = integer_reg_file[rs_1_addr_in];
	//hold_rs_2_out = integer_reg_file[rs_2_addr_in];
	//end
//end

assign rs_1_out = (hold_rs_1_out == 1'b1)? rd_in :reg_file[rs_1_addr_in];
assign rs_2_out = (hold_rs_2_out == 1'b1)? rd_in :reg_file[rs_2_addr_in];

endmodule
