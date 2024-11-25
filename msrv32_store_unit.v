/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_store_unit.v   

Description :      32-bit RV32 Store Unit to Memory Data

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_store_unit(funct3_in, iadder_in, rs_2_in, mem_wr_req_in, ahb_ready_in,
			 ms_riscv32_mp_dmdata_out, ms_riscv32_mp_dmaddr_out, 
			ms_riscv32_mp_dmwr_mask_out, ms_riscv32_mp_dmwr_req_out, ahb_htrans_out);

input mem_wr_req_in, ahb_ready_in;
input[1:0] funct3_in;
input[31:0] iadder_in, rs_2_in;
output ms_riscv32_mp_dmwr_req_out;
output reg[3:0] ms_riscv32_mp_dmwr_mask_out;
output reg[31:0] ms_riscv32_mp_dmdata_out;
output[31:0] ms_riscv32_mp_dmaddr_out;
output reg[1:0] ahb_htrans_out;

reg[3:0] hold_byte_mask_out, hold_half_mask_out;
reg[31:0] hold_byte_data_out, hold_half_data_out;


always@*
begin
	if(ahb_ready_in)
	begin
		case(funct3_in)
			2'b00:	ms_riscv32_mp_dmdata_out = hold_byte_data_out;
			2'b01:	ms_riscv32_mp_dmdata_out = hold_half_data_out;
			2'b10:	ms_riscv32_mp_dmdata_out = rs_2_in;
			//hold_ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};
			default:ms_riscv32_mp_dmdata_out = rs_2_in;
			//hold_ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};
		endcase
		ahb_htrans_out = 2'b10;
	end
	else
		ahb_htrans_out =2'b00;
end

always@*
begin
	case(iadder_in[1:0])
		2'b00:	hold_byte_data_out = {8'b0, 8'b0, 8'b0, rs_2_in[7:0]};  	
		2'b01:	hold_byte_data_out = {8'b0, 8'b0, rs_2_in[15:8], 8'b0};
		2'b10:	hold_byte_data_out = {8'b0, rs_2_in[23:16], 8'b0, 8'b0};
		2'b11:	hold_byte_data_out = {rs_2_in[31:24], 8'b0, 8'b0, 8'b0};
		default: hold_byte_data_out = 32'h00000000;	
		endcase
end

always@*
begin
	case(iadder_in[1])
		1'b0:	hold_half_data_out = {16'b0, rs_2_in[15:0]};  
		1'b1:	hold_half_data_out = {rs_2_in[31:16], 16'b0};
		default: hold_half_data_out = 32'h00000000;	
	endcase
end

always@*
begin
	case(funct3_in)
		2'b00:	ms_riscv32_mp_dmwr_mask_out = hold_byte_mask_out;
		2'b01:	ms_riscv32_mp_dmwr_mask_out = hold_half_mask_out;
		default:ms_riscv32_mp_dmwr_mask_out = 0;
	endcase
end

always@*
begin
	case(iadder_in[1:0])
		2'b00:	hold_byte_mask_out = {2'b0, 1'b0, mem_wr_req_in};
		2'b01:	hold_byte_mask_out = {2'b0, mem_wr_req_in, 1'b0};
		2'b10:	hold_byte_mask_out = {1'b0, mem_wr_req_in, 2'b0};	
		2'b11:	hold_byte_mask_out = {mem_wr_req_in, 2'b0, 1'b0};
		default:hold_byte_mask_out = 32'h00000000;	
	endcase
end


always@*
begin
	case(iadder_in[1])
		1'b0:	hold_half_mask_out = {2'b0, {2{mem_wr_req_in}}};
		1'b1:	hold_half_mask_out = {{2{mem_wr_req_in}}, 2'b0};
		default: hold_half_mask_out = 32'h00000000;	
	endcase
end

//assign ms_riscv32_mp_dmdata_out = hold_data_out;
//assign ms_riscv32_mp_dmwr_mask_out = hold_mask_out;
assign ms_riscv32_mp_dmaddr_out = {iadder_in[31:2], 2'b00};
assign ms_riscv32_mp_dmwr_req_out = mem_wr_req_in;
endmodule 
