//===========================================================
//
//			Name & Student ID
//           
//			Implemented Instructions are:
//			R format:  add(u), sub(u), and, or, xor, nor, slt, sltu;
//			I format:  beq, bne, lw, sw, addi, addiu, slti, sltiu, andi, ori, xori, lui.
//
//===========================================================

`timescale 1ns/1ns

`define ADD  3'b000
`define SUB  3'b001
`define SLT  3'b010
`define SLTU 3'b011
`define AND  3'b100
`define OR   3'b101
`define NOR  3'b110
`define XOR  3'b111
		 
module single_cycle_mips 
(
	input clk,
	input reset
);
 
	initial begin
		$display("Single Cycle ACA-MIPS Implemention");
		$display("Name & Student ID");
	end

	reg [31:0] PC;          // Keep PC as it is, its name is used in higher level test bench

	// Datapath
	wire [31:0] SrcA, SrcB, ALUResult, WriteData, ReadData,
				Result, PCBranch, RegFile_RD2, imm32;
	wire Zero;		
	wire zero_ext, lui_op;	
	wire [4:0] WriteReg_5b;
	// ----------- Instr. Fetch ----------- 
	wire [31:0] instr;
	wire [31:0] PC_plus4 = PC + 4;
	
	// ----------- Instr. Decode -----------
	wire [5:0] opcode = instr[31:26];
	wire [4:0] rs = instr[25:21];
	wire [4:0] rt = instr[20:16];
	// ----------- R-Type -----------
	wire [4:0] rd = instr[15:11];
	wire [4:0] shamt = instr[10:6];
	wire [5:0] funct = instr[5:0];
	// ----------- I-Type -----------
	wire [15:0] imm16 = instr[15:0];
	// ----------- J-Type -----------
	wire [25:0] addr = instr[25:0];
	
	// ----------- Control Signals
	reg MemtoReg, MemWrite, Branch, ALUSrc,
		RegDst, RegWrite, PCSrc;
	reg [2:0] ALUControl;
	
	wire op_beq, op_bne, is_branch;

	always@(*) begin
		MemtoReg = 1'b0;
		MemWrite = 1'b0;
		Branch = 1'b0;
		ALUSrc = 1'b0;
		RegDst = 1'b0;
		RegWrite = 1'b0;
		PCSrc = 1'b0;
		ALUControl = `ADD;
		case (opcode)
			// R-Format
			6'b000000: begin
					   RegWrite = 1'b1;
					   RegDst = 1'b1;
					   case (funct) 
							6'b100000: ALUControl = `ADD;
							6'b100001: ALUControl = `ADD;
							6'b100010: ALUControl = `SUB;
							6'b100011: ALUControl = `SUB;
							6'b100100: ALUControl = `AND;
							6'b100101: ALUControl = `OR;
							6'b100110: ALUControl = `XOR;
							6'b100111: ALUControl = `NOR;
							6'b101010: ALUControl = `SLT;
							6'b101011: ALUControl = `SLTU;
							default:   ALUControl = `ADD;
					   	
					   endcase
			end
			// I-Format
			// beq		   
			6'b000100:	begin 
						Branch = 1'b1;
						ALUControl = `SUB;
			end
			// bne
			6'b000101:  begin
						Branch = 1'b1;
						ALUControl = `SUB;
			end
			// addi			
			6'b001000: 	begin
						ALUSrc = 1'b1;
						RegDst = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						ALUControl = `ADD;
			end
			// addiu
			6'b001001:  begin
						ALUSrc = 1'b1;
						RegDst = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						ALUControl = `ADD;
			end
			// slti
			6'b001010: begin
					   ALUSrc = 1'b1;
					   ALUControl = `SLT;
					   RegWrite = 1'b1;
			end
			// sltiu
			6'b001011: begin
					   ALUSrc = 1'b1;
					   ALUControl = `SLTU;
					   RegWrite = 1'b1;
			end
			// andi
			6'b001100: begin 
					   ALUSrc = 1'b1;
					   ALUControl = `AND;
					   RegWrite = 1'b1;
			end
			// ori
			6'b001101:  begin
						ALUSrc = 1'b1;
					    ALUControl = `OR;
					    RegWrite = 1'b1;
			end
			// xori
			6'b001110: begin
					   ALUSrc = 1'b1;
					   ALUControl = `XOR;
					   RegWrite = 1'b1;
			end
			// lui
			6'b001111: begin
					   ALUSrc = 1'b1;
					   ALUControl = `ADD;
					   RegWrite = 1'b1;
			end
			// lw
			6'b100011: begin
					   ALUSrc = 1'b1;
					   ALUControl = `ADD;
					   RegWrite = 1'b1;
					   MemtoReg = 1'b1;
			end
			// sw
			6'b101011: begin
					   ALUSrc = 1'b1;
					   MemWrite = 1'b1;
					   ALUControl = `ADD;	
			end	
		endcase
	end

	assign WriteReg_5b = RegDst ? rd : rt;

	assign zero_ext = (opcode == 6'b001100) | (opcode == 6'b001101) | (opcode == 6'b001110);

	assign lui_op = (opcode == 6'b001111);

	assign imm32 = zero_ext ? {16'b0, imm16} :
				   lui_op ?   {imm16, 16'b0} :
				   			  {{16{imm16[15]}}, imm16};

	assign Result = MemtoReg ? ReadData : ALUResult;
	
	assign SrcB = ALUSrc ? imm32 : RegFile_RD2;

	assign PCBranch = (imm32 << 2) + PC_plus4;

	assign op_beq = (opcode == 6'b000100) & Zero;

	assign op_bne = (opcode == 6'b000101) & (~Zero);

	assign is_branch = Branch & (op_beq | op_bne);
	
	always@(posedge clk or posedge reset) begin
		if(reset)
			PC <= 32'h00000000;
		else if(is_branch)
			PC <= PCBranch;
		else
			PC <= PC_plus4;
	end

	my_alu main_alu
	(
		.Op(ALUControl),
    	.A(SrcA),
   		.B(SrcB),
   		.X(ALUResult),
   		.Z(Zero)
	);
//========================================================== 
//	instantiated modules
//========================================================== 

//	Instruction Memory
	async_mem imem			// keep the exact instance name
	(
		.clk		   (1'b0),
		.write		(1'b0),		// no write for instruction memory
		.address	   ( PC ),	   // address instruction memory with pc
		.write_data	('bx),
		.read_data	(instr)
	);
	
// Register File
	reg_file rf
	(
		.clk(clk),
		.write(RegWrite),
		.WR(WriteReg_5b),
		.WD(Result),
		.RR1(rs),
		.RR2(rt),
		.RD1(SrcA),
		.RD2(RegFile_RD2)
	);
// Data Memory
	async_mem dmem			// keep the exact instance name
	(
		.clk		(clk),
		.write		(MemWrite),
		.address	(ALUResult),
		.write_data	(RegFile_RD2),
		.read_data	(ReadData)
	);

endmodule

//==============================================================================
// This is a sample ALU, You may need to change it
// Note: You have to define Op case constants
//==============================================================================

module my_alu(
   input  [2:0] Op,
   input  [31:0] A,
   input  [31:0] B,
   output [31:0] X,
   output        Z
   );

   wire sub = Op != `ADD;
   wire [31:0] bb = sub ? ~B : B;
   wire [32:0] sum = A + bb + sub;
   wire sltu = ! sum[32];

   wire v = sub ?
            ( A[31] != B[31] && A[31] != sum[31] )
          : ( A[31] == B[31] && A[31] != sum[31] );

   wire slt = v ^ sum[31];

   reg [31:0] x;

   always @( * )
      case( Op )
         `ADD : x = sum;
         `SUB : x = sum;
         `SLT : x = slt;
         `SLTU: x = sltu;
         `AND : x = A & B;
         `OR  : x = A | B;
         `NOR : x = ~(A | B);
         `XOR : x = A ^ B;
         default : x = 32'hxxxxxxxx;
      endcase

   assign X = x;
   assign Z = x == 32'h00000000;

endmodule

//============================================================================


