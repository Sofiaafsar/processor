`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2023 10:23:49
// Design Name: 
// Module Name: alu
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


module alu(data1,data2,opcode,result,flag,clk,rst);
input clk,rst;
input  [7:0] data1,data2;
output reg [7:0] result;
output reg [3:0] flag; //Format: sign-carry-auzillarycarry-parity
input  [2:0] opcode;
reg[8:0] sum;
always@(posedge clk) begin
    if(rst) begin
        flag=4'b0;
    end
    
    
    case(opcode)
    3'b001: begin
                sum=data1+data2; //addition
                result=sum[7:0];
                flag[2]=sum[8];
                flag[3]=result[7];
                flag[0]=(^result);
                flag[1]= data1[3] & data2[3];
            end 
     3'b010: begin
                sum=data1-data2; //subraction
                result=sum[7:0];
                flag[2]=(sum[8]==0);
                flag[3]=result[7];
                flag[0]=(^result);
                flag[1]= ~data1[3] & data2[3];
            end 
     3'b011: begin
                result=data1 | data2; //or
                 flag[3]=result[7];      
                 flag[1]= ~data1[3] & data2[3];          
            end 
    3'b100: begin
                result=data1 ^ data2;  //xor
                 flag[3]=result[7];      
                 flag[1]= ~data1[3] & data2[3];  
            end 
    3'b101: begin
                result=data1 * data2; //multiply
                  flag[3]=result[7];      
                 flag[1]= ~data1[3] & data2[3];  
            end 
    3'b110: begin
                if(data1>data2) result=data1;
                else if(data2>data1) result=data2;   //returning the great number
                else result=data1; //equal
            end 
    3'b111: begin
                result=data1 & data2; //and
                  flag[3]=result[7];      
                 flag[1]= ~data1[3] & data2[3];  
            end 

     default: begin
            result=data1;
     end
    endcase
end


endmodule
