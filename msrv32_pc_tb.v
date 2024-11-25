/********************************************************************************************
Copyright 2023 - Chiplab. 
 
All Rights Reserved.

Filename    :	   msrv32_pc_tb.v   

Description :      32-bit RV32 Program Counter TestBench

Author Name :      Dr. Princewill

Version     : 	   1.0
*********************************************************************************************/
module msrv32_pc_tb();

//define port directions
reg rst_in, branch_taken_in, ahb_ready_in;
reg[1:0] pc_src_in;
reg[31:1] iaddr_in;
reg[31:0] epc_in, trap_address_in, pc_in;
wire misaligned_instr_logic_out;
wire[31:0] iaddr_out, pc_plus_4_out, pc_mux_out;

reg[31:0] hold_concat, hold_4_add, next_pc, hold_pc_mux, hold_ahb_mux;
reg[31:0] hold_rst_mux;

//parameter to hold reset boot address
parameter	BOOT_ADDRESS = 32'h00000000;
		//CYCLE = 10;

//instatiate DUT 
msrv32_pc pc(rst_in, pc_src_in, epc_in, trap_address_in, branch_taken_in, iaddr_in, ahb_ready_in, pc_in, iaddr_out, pc_plus_4_out, misaligned_instr_logic_out, pc_mux_out);

//generate clock cycle
/*always
begin
	#(CYCLE/2);
	clk = 1'b0;
	#(CYCLE/2);
	clk = ~clk;
end
*/
//task to reset DUT
/*task reset();
begin
	@(negedge clk);
	rst_in = 1'b1;
	@(negedge clk);
	rst_in = 1'b0;
	#5;
end
endtask
*/
task initialize();
begin
	rst_in = 1'b1;
	ahb_ready_in = 1'b0;
	pc_src_in = 2'b00;
	pc_in = 32'h00000000;	
end
endtask

task stimulus_pc(input[31:0] epc_data, trap_add);
begin
	epc_in = epc_data;
	trap_address_in = trap_add;
end
endtask 

task mux_select_src(input[1:0] src_data);
begin
	pc_src_in = src_data;
end
endtask


task mux_select_bus(input bus_ready);
begin
	ahb_ready_in = bus_ready;
end
endtask

task mux_select_reset(input reset);
begin
	rst_in = reset;
end
endtask

task mux_select_nextpc(input branch_in);
begin
	branch_taken_in = branch_in;	
end
endtask

task stimulus_pc_address(input[31:0] pc_address_in, input[30:0] imm_address_in);
begin
	pc_in = pc_address_in;
	iaddr_in = imm_address_in;
end
endtask

initial
begin
initialize;
#10;
stimulus_pc(32'h00000111, 00001111);
mux_select_src(2'b11);
mux_select_bus(1'b1);
mux_select_reset(1'b0);
mux_select_nextpc(1'b0);
stimulus_pc_address(0, 8);
#10;
stimulus_pc_address(4, 8);
#10;
stimulus_pc_address(8, 8);
#10;
stimulus_pc_address(11, 8);
#10;
stimulus_pc_address(16, 8);
#10;
stimulus_pc_address(20, 8);
#10;
$finish;
end

 //Process to monitor the changes in the variables	
 initial 
  $monitor("Next Address = %d, PC Count = %d, PC Mux Out = %d, Misalingned = %b",iaddr_out, pc_plus_4_out, pc_mux_out, misaligned_instr_logic_out);
	


endmodule


