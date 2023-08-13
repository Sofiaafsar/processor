`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2023 12:39:45
// Design Name: 
// Module Name: cputb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cpu_tb;
reg CLK, RESET; wire [31:0] PC;
reg [31:0] INSTRUCTIONN;
//ODO: Initialize an array of registers (8×1024) to be used as instruction memory
reg [7:0] instr_mem [1023:0];
// TODO: Create combinational logic to fetch an instruction from instruction memory, given the Program Counter(PC) value // (make sure you include the delay for instruction fetching here)
always@(PC)
begin #2
INSTRUCTIONN = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};
end
initial begin
// TODO: Initialize instruction memory with a set of instructions
//
//Hint: you can use something like this to load the instruction "loadi 4 0x19" onto instruction memory,
{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000000000000000000000011;
{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000010000000000000101;
{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000000100000000100000000;
{instr_mem[10'd15], instr_mem[10'd14], instr_mem[10'd13], instr_mem[10'd12]} = 32'b00000101000001110000001100000010;
{instr_mem[10'd19], instr_mem[10'd18], instr_mem[10'd17], instr_mem[10'd16]} = 32'b00000010000001000000000100000000;
{instr_mem[10'd23], instr_mem[10'd22], instr_mem[10'd21], instr_mem[10'd20]} = 32'b00000100000001010000000100000100;

end
/*
CPU
*/
cpu mycpu (PC, INSTRUCTIONN, CLK, RESET);

initial
begin
//// generate files needed to plot the waveform using GTKWave
$dumpfile("cpu_wavedata.vcd");
$dumpvars(0, cpu_tb); 
CLK = 1'b1;
RESET = 1'b0;
#2
RESET = 1'b1;
#4
RESET = 1'b0;
#500
$finish;
end
// clock signal generation
always
#5 CLK = ~CLK;
endmodule