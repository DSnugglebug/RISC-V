/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_wr_en_generator.v   

Description :      32-bit RV32 Write Enable Generator

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_wr_en_generator(flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in, wr_en_integer_file_out, wr_en_csr_file_out);

input flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in;
output wr_en_integer_file_out, wr_en_csr_file_out;

assign wr_en_csr_file_out = (flush_in == 1'b1)? 1'b0: csr_wr_en_reg_in;
assign wr_en_integer_file_out = (flush_in == 1'b1)? 1'b0: rf_wr_en_reg_in;

endmodule
