/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_alu.v   

Description :      32-bit RV32 ALU Module for logical and Arithmetic operations

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_alu(op_1_in, op_2_in, opcode_in, result_out);

input[3:0] opcode_in;
input[31:0] op_1_in, op_2_in;
output reg[31:0] result_out;

//reg[31:0] hold_result_out;
wire[31:0] hold_funct7_msb;
wire[31:0] hold_add_sub;
wire[31:0] hold_shift_right;
wire[31:0] hold_shift_arith;
wire[31:0] hold_shift_logical;
wire[31:0] hold_slt, hold_sltu;

wire signed[31:0] signed_op_1_in, signed_op_2_in;


parameter	ALU_ADD_SUB= 3'b000,
		ALU_SLT	= 3'b010,
		ALU_SLTU= 3'b011,
		ALU_AND	= 3'b111,
		ALU_OR	= 3'b110,
		ALU_XOR	= 3'b100,
		ALU_SLL	= 3'b001,
		ALU_SR	= 3'b101;

assign signed_op_1_in = op_1_in;
assign signed_op_2_in = -op_2_in;

assign hold_funct7_msb = (opcode_in[3]==1'b1)? (signed_op_2_in): op_2_in;
assign hold_add_sub = signed_op_1_in + hold_funct7_msb;

assign hold_shift_arith = signed_op_1_in >>> op_2_in[4:0];
assign hold_shift_logical = op_1_in >> op_2_in[4:0];
assign hold_shift_right = (opcode_in[3]==1'b1)? hold_shift_arith: hold_shift_logical;
assign hold_sltu = signed_op_1_in < op_2_in;
assign hold_slt = (signed_op_1_in[31]^op_2_in[31])? signed_op_1_in[31] :hold_sltu;

always@*
begin
	case(opcode_in[2:0])
		ALU_ADD_SUB:	result_out	= hold_add_sub;
		ALU_SLT:	result_out	= {31'b0, hold_slt};
		ALU_SLTU:	result_out	= {31'b0, hold_sltu};
		ALU_AND:	result_out	= op_1_in & op_2_in;
		ALU_OR:		result_out	= op_1_in | op_2_in;
		ALU_XOR:	result_out	= op_1_in ^ op_2_in;
		ALU_SLL:	result_out	= op_1_in << op_2_in[4:0];
		ALU_SR:		result_out	= hold_shift_right;
		default:	result_out = 32'h00000000;
	endcase
end
//assign result_out = hold_result_out;
endmodule
