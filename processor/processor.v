module cpu(PC,INSTRUCTION,CLK,RESET);
 input [31:0] INSTRUCTION;
 
 input CLK;
 input RESET;
output [31:0] PC;
reg [31:0] PC;
 wire [31:0] PCRESULT;
reg writeEnable;
    reg isAdd;
    reg isImediate;
    reg [2:0] aluOp;
    reg [2:0] regRead1Addres;
    reg [2:0] regRead2Addres;
    reg [2:0] writeRegAddres;
    reg [7:0] immediateVal;
    wire [7:0] mux1out;
    wire [7:0] mux2out;
    wire [7:0] ALURESULT;
    wire [7:0] minusVal;
reg [7:0] IN;
    wire [7:0] OUT1;
    wire [7:0] OUT2;
reg [7:0] OPCODE; 
    reg [2:0] DESTINATION;  
    reg [2:0] SOURCE1; 
    reg [2:0] SOURCE2;
always@(RESET)
    //reseting the pc if reset is on
    begin
     if(RESET ==1)  PC =-4;
    
    end
//adder to update pc from 4
    adder myadder(PC,PCRESULT);
    always@(posedge CLK)
    begin
       #1
       PC = PCRESULT;
    end
 
    always @(INSTRUCTION)
 begin
     // taking the opcode from the instruction
     OPCODE = INSTRUCTION[31:24];
     #1
     //decodeing the opcode
  case(OPCODE)
   8'b00000000:
       begin
    writeEnable = 1'b1;
    aluOp = 3'b000;
    isAdd = 1'b1;
    isImediate = 1'b1;
    end
   8'b00000001:
       begin
    writeEnable = 1'b1;  
    aluOp = 3'b000;
    isAdd = 1'b1;
    isImediate = 1'b0;
    end
   8'b00000010:
       begin
    writeEnable = 1'b1;
    aluOp = 3'b001;
    isAdd = 1'b1;
    isImediate = 1'b0;
    end
   8'b00000011:
       begin
    writeEnable = 1'b1;
    aluOp = 3'b001;
    isAdd = 1'b0;
    isImediate = 1'b0;
    end
   8'b00000100:
       begin
    writeEnable = 1'b1;
    aluOp = 3'b010;
    isAdd = 1'b1;
    isImediate = 1'b0; 
    end
   8'b00000101:
       begin
    writeEnable = 1'b1;
    aluOp = 3'b011;
    isAdd  =1'b1;
    isImediate = 1'b0; 
    end     
    
  endcase        
 end
 //including the register file
    reg_file myReg(IN,OUT1,OUT2,DESTINATION,SOURCE1,SOURCE2,writeEnable,CLK,RESET);
 always@(INSTRUCTION)
 begin
     DESTINATION  = INSTRUCTION[18:16];
      SOURCE1   = INSTRUCTION[10:8];
     SOURCE2 = INSTRUCTION[2:0];
     immediateVal =INSTRUCTION[7:0];
 end
 //this is two's complemebt unit to substraction
 twosCompliment mytwo(OUT2,minusVal);
//multiplexer to choose between minus value and plus value
 mux2_1 mymux1(OUT2,minusVal,isAdd,mux1out);
 
 //multiplexer to chose between immediate value and mux1 output
 mux2_1 mymux2(immediateVal,mux1out,isImediate,mux2out);
 
    //allu module
    alu myalu(OUT1, mux2out, ALURESULT, aluOp);
    always@(ALURESULT)
 begin
    IN =ALURESULT;  //setting the reg input with the alu result
 end
endmodule
module mux2_1(in0,in1,se1,out);
 input se1;      //immediae value
 input [7:0] in0; 
 input [7:0] in1;           // register output
 output [7:0] out;
 reg out;
always @(in0,in1,se1)
 begin
  if(se1==1'b1) begin
   out =in0;
  end 
  else 
  begin
   out =in1;
  end
 end    
endmodule
//this is used to convert numbers into minus in two's complement
module twosCompliment(in,result);
   input [7:0] in;
   output [7:0] result;
   reg result;
   always@(*) 
   begin
       result = ~in+1;
   end
endmodule
module adder(PCINPUT,RESULT);
 input [31:0] PCINPUT;
 output [31:0] RESULT;
 reg RESULT;
 always@(PCINPUT)
 begin
  RESULT = PCINPUT+ 4;
 end
endmodule
module alu(DATA1, DATA2, RESULT, SELECT,ZERO);
 //initializing the inputs and outputs
  input [7:0] DATA1;
  input [7:0] DATA2;
  input [2:0] SELECT;
  output [7:0] RESULT;
  output ZERO;
  reg [7:0] RESULT;
  reg ZERO; 
  reg [7:0] RshiftResult;
//barrelShifter myRightLogicalShifter(DATA1,DATA2[7:5],RshiftResult);
 //creating the always block which runs whenever a input is changed
 always @(DATA1,DATA2,SELECT)
 begin
 //selecting based on the SELECT input using s switch case
 case(SELECT)
 3'b000:
 #1 RESULT = DATA2; //Forward function
 3'b001:
 #2 RESULT = DATA1 + DATA2; //Add and Sub function
 3'b010:
 #1 RESULT = DATA1 & DATA2; //AND and Sub function
 3'b011:
 #1 RESULT = DATA1 | DATA2; //OR and Sub function
 3'b100:
 RESULT=8'b00000000;
 3'b101:
 RESULT = 8'b00000000; 
 3'b110:
 RESULT = 8'b00000000; 
 3'b111:
 RESULT = 8'b00000000; 
 endcase 
 end
 // creating the ZERO bit using the alu result
 //modified part
 always@(RESULT)
 begin
ZERO = ~RESULT[0] | ~RESULT[1] | ~RESULT[2] | ~RESULT[3] | ~RESULT[4] | ~RESULT[5] | ~RESULT[6] | ~RESULT[7];
 end
endmodule
module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET) ;
 //Initalizing inputs
 input [2:0] INADDRESS;
 input [2:0] OUT1ADDRESS;
 input [2:0] OUT2ADDRESS;
 input WRITE;
 input CLK;
 input RESET;
 input [7:0] IN;
 //initializing outputs
 output [7:0] OUT1;
 output [7:0] OUT2;
 //initializing register variables
integer i; 
 //creating the register array
 reg [7:0] regFile [0:7]; 
 //resetting the registers if the reset is 1 as a level triggered input
 always@(*)
 if (RESET == 1) begin 
 #2
 for (i = 0; i < 8; i = i + 1) 
 begin
 regFile [i] = 8'b00000000 ; 
 end 
 
 end 
 //this always block runs of the positive edge of the clock and write to the register if write is ennable
 always@(posedge CLK)
 begin 
 if(WRITE == 1'b1 && RESET == 1'b0) begin
 #2 regFile [INADDRESS] = IN; //this includes the write reg delay
 //$monitor($time," %b",regFile [INADDRESS]);
 end 
 end
 
 assign #2 OUT1 = regFile[OUT1ADDRESS];
 assign #2 OUT2 = regFile[OUT2ADDRESS];
endmodule