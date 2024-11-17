/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_load_unit.v   

Description :      32-bit RV32 Load Unit from Memory Data

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_load_unit(ahb_resp_in, ms_riscv32_mp_dmdata_in, iadder_out_1_0_in,
load_unsigned_in, load_size_in, lu_output_out);

input ahb_resp_in, load_unsigned_in;
input[1:0] iadder_out_1_0_in, load_size_in;
input[31:0] ms_riscv32_mp_dmdata_in;
output[31:0] lu_output_out;

reg hold_lu_output_out;

always@*
begin
	if(!ahb_resp_in)
	begin
		case(load_size_in)
			2'b00:	begin
				case(iadder_out_1_0_in)
					2'b00:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{24{1'b0}}, ms_riscv32_mp_dmdata_in[7:0]};
						else
						hold_lu_output_out = {{24{ms_riscv32_mp_dmdata_in[7]}}, ms_riscv32_mp_dmdata_in[7:0]};
						end
					2'b01:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{24{1'b0}}, ms_riscv32_mp_dmdata_in[15:8]};
						else
						hold_lu_output_out = {{24{ms_riscv32_mp_dmdata_in[15]}}, ms_riscv32_mp_dmdata_in[15:8]};
						end
					2'b10:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{24{1'b0}}, ms_riscv32_mp_dmdata_in[23:16]};
						else
						hold_lu_output_out = {{24{ms_riscv32_mp_dmdata_in[23]}}, ms_riscv32_mp_dmdata_in[23:16]};
						end
					2'b11:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{24{1'b0}}, ms_riscv32_mp_dmdata_in[31:24]};
						else
						hold_lu_output_out = {{24{ms_riscv32_mp_dmdata_in[31]}}, ms_riscv32_mp_dmdata_in[31:24]};
						end
					default: hold_lu_output_out = 32'h00000000;
				endcase
				end
			2'b01:	begin
				case(iadder_out_1_0_in[1])
					2'b0:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{16{1'b0}}, ms_riscv32_mp_dmdata_in[15:0]};
						else
						hold_lu_output_out = {{16{ms_riscv32_mp_dmdata_in[15]}}, ms_riscv32_mp_dmdata_in[15:0]};
						end
					2'b1:	begin
						if(load_unsigned_in)
						hold_lu_output_out = {{16{1'b0}}, ms_riscv32_mp_dmdata_in[31:16]};
						else
						hold_lu_output_out = {{16{ms_riscv32_mp_dmdata_in[31]}}, ms_riscv32_mp_dmdata_in[31:16]};
						end
					default: hold_lu_output_out = 32'h00000000;
				endcase
				end
			2'b10:	hold_lu_output_out = ms_riscv32_mp_dmdata_in;
			2'b11:	hold_lu_output_out = ms_riscv32_mp_dmdata_in;
			default: hold_lu_output_out = ms_riscv32_mp_dmdata_in;		
			endcase		
	end
	else
		hold_lu_output_out = 32'h00000000;	
end
assign lu_output_out = hold_lu_output_out;
endmodule
