/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_pc.v   

Description :      32-bit RV32 Program Counter

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_pc(ms_riscv32_mp_rst_in, pc_src_in, epc_in, trap_address_in, branch_taken_in, iaddr_in, ahb_ready_in, pc_in, ms_riscv32_mp_iaddr_out, pc_plus_4_out, misaligned_instr_logic_out, pc_mux_out);

//define port directions
input ms_riscv32_mp_rst_in, branch_taken_in, ahb_ready_in;
input[1:0] pc_src_in;
input[31:1] iaddr_in;
input[31:0] epc_in, trap_address_in, pc_in;
output misaligned_instr_logic_out;
output reg[31:0] ms_riscv32_mp_iaddr_out;
output[31:0] pc_plus_4_out, pc_mux_out;

wire[31:0] hold_concat, hold_4_add, next_pc;
reg[31:0] hold_pc_mux;

//parameter to hold reset boot address
parameter	BOOT_ADDRESS = 32'h00000000;

//concatenate input address
assign hold_concat = {iaddr_in, 1'b0};

//logic to increment pc by 4
//assign hold_4_add[31:2] = pc_in[31:2] + 1;
//assign hold_4_add[1:0] = 2'b00;
assign hold_4_add = pc_in + 4;
assign pc_plus_4_out = hold_4_add;

//branch mux logic
assign next_pc = (branch_taken_in)? hold_concat:hold_4_add;

//logic for pc_mux
always@*
begin
case(pc_src_in)
	2'b00:	hold_pc_mux = BOOT_ADDRESS;
	2'b01:	hold_pc_mux = epc_in;
	2'b10:	hold_pc_mux = trap_address_in;
	2'b11:	hold_pc_mux = next_pc;
	default: hold_pc_mux = next_pc;
endcase
end

//logic to activate a branch
assign misaligned_instr_logic_out = next_pc[1] & branch_taken_in;

//logic to enable ahb bus
//always@*
//begin
//if(ahb_ready_in)
//hold_ahb_mux = hold_pc_mux;
//else
//hold_ahb_mux = hold_rst_mux;
//end
//hold_ahb_mux = ahb_ready_in? hold_pc_mux: hold_rst_mux;




//pc register to clock address to Instruction memory
always@*
begin
	if (ms_riscv32_mp_rst_in)
		ms_riscv32_mp_iaddr_out <= BOOT_ADDRESS;
	else if(ahb_ready_in)
		ms_riscv32_mp_iaddr_out <= hold_pc_mux;
end

assign pc_mux_out = hold_pc_mux;
//assign ms_riscv32_mp_iaddr_out = hold_rst_mux;
endmodule



