/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_load_unit_v2.v   

Description :      32-bit RV32 Load Unit from Memory Data

Author Name :      Dr. Princewill

Version     : 	   2.0
*********************************************************************************************/
module msrv32_load_unit_v2(ahb_resp_in, ms_riscv32_mp_dmdata_in, iadder_out_1_0_in,
			load_unsigned_in, load_size_in, lu_output_out);

input ahb_resp_in, load_unsigned_in;
input[1:0] iadder_out_1_0_in, load_size_in;
input[31:0] ms_riscv32_mp_dmdata_in;
output reg [31:0] lu_output_out;

//reg hold_lu_output_out;
wire a, b, c, d;

assign a = (load_unsigned_in)?0:ms_riscv32_mp_dmdata_in[7];
assign b = (load_unsigned_in == 1'b1)? 1'b0: ms_riscv32_mp_dmdata_in[15];
assign c = (load_unsigned_in == 1'b1)? 1'b0: ms_riscv32_mp_dmdata_in[23];
assign d = (load_unsigned_in == 1'b1)? 1'b0: ms_riscv32_mp_dmdata_in[31];

always@(*)
begin
	begin
	lu_output_out = 0;
	if(!ahb_resp_in)
		case(load_size_in)
			2'b00:	begin
				case(iadder_out_1_0_in)
					2'b00:	lu_output_out = {{24{a}}, ms_riscv32_mp_dmdata_in[7:0]};
					
					2'b01:	lu_output_out = {{24{b}}, ms_riscv32_mp_dmdata_in[15:8]};
						
					2'b10:	lu_output_out = {{24{c}}, ms_riscv32_mp_dmdata_in[23:16]};

					2'b11:	lu_output_out = {{24{d}}, ms_riscv32_mp_dmdata_in[31:24]};
				endcase
				end
			2'b01: begin
				case(iadder_out_1_0_in[1])
					1'b0:	lu_output_out = {{16{b}}, ms_riscv32_mp_dmdata_in[15:0]};
						
					1'b1:	lu_output_out = {{16{d}}, ms_riscv32_mp_dmdata_in[31:16]};
				endcase
			 	end
			default: lu_output_out = ms_riscv32_mp_dmdata_in;		
		endcase			
	end
end
//assign lu_output_out = hold_lu_output_out;

endmodule
