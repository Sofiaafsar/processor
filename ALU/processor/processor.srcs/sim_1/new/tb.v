`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2023 11:26:05
// Design Name: 
// Module Name: tb
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


`timescale 1ns / 1ps

module alu_tb;

  reg [7:0] data1, data2;
  reg [2:0] opcode;
  wire [7:0] result;
  wire [3:0] flag;
  reg clk, rst;

  alu dut (
    .data1(data1),
    .data2(data2),
    .opcode(opcode),
    .result(result),
    .flag(flag),
    .clk(clk),
    .rst(rst)
  );
   initial begin
   clk=1'b0;
   end
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    data1 = 8'b0;
    data2 = 8'b0;
    opcode = 3'b000;
   #2 rst = 0;

    // Test Case 1: Addition
    opcode = 3'b001;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 2: Subtraction
    opcode = 3'b010;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 3: OR
    opcode = 3'b011;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 4: XOR
    opcode = 3'b100;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 5: Multiplication
    opcode = 3'b101;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 6: Greater Number
    opcode = 3'b110;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    // Test Case 7: AND
    opcode = 3'b111;
    data1 = 8'b01100011;
    data2 = 8'b00111100;
    #20 $display("Result: %b, Flag: %b", result, flag);

    $finish;
  end



endmodule

