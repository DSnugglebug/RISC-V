/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_immediate_adder.v   

Description :      32-bit RV32 Immediate Adder

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_immediate_adder(pc_in, rs_1_in, imm_in, iadder_src_in, iadder_out);

input iadder_src_in;
input[31:0] pc_in, rs_1_in, imm_in;
output[31:0] iadder_out;


wire[31:0] hold_iadder_mux;

assign hold_iadder_mux = (iadder_src_in)? rs_1_in: pc_in;

assign iadder_out = hold_iadder_mux + imm_in;

endmodule




