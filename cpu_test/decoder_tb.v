`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/13 11:35:03
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb;
reg [31:0]instruction;
wire [4:0] rs1, rs2, rd;
wire [2:0] funct3;
wire alu_ext;
wire alu_sel;
wire [31:0]immediate;
wire register_we;
wire [1:0]register_write_sel;
wire memory_we;

decoder decoder(
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .alu_ext(alu_ext),
        .alu_sel(alu_sel),
        .immediate(immediate),
        .register_we(register_we),
        .register_write_sel(register_write_sel),
        .memory_we(memory_we)
        );

initial begin
instruction = 0;
#100 instruction = 32'b0000000_00001_00010_000_00011_0110011; // ���Z ADD
#100 instruction = 32'b0100000_00011_00001_000_00100_0110011; // ���Z SUB
#100 instruction = 32'b0000000_00011_00001_001_00100_0110011; // ���V�t�g SLL
#100 instruction = 32'b0000000_00011_00001_010_00100_0110011; // �����t�召��r SLT
#100 instruction = 32'b0000000_00011_00001_011_00100_0110011; // �����Ȃ��召��r SLTU
#100 instruction = 32'b0000000_00011_00001_100_00100_0110011; // �r���I�_���a XOR
#100 instruction = 32'b0000000_00011_00001_101_00100_0110011; // �E�_���V�t�g SRL
#100 instruction = 32'b0100000_00011_00001_101_00100_0110011; // �E�Z�p�V�t�g SRA
#100 instruction = 32'b0000000_00011_00001_110_00100_0110011; // �_���a OR
#100 instruction = 32'b0000000_00011_00001_111_00100_0110011; // �_���� AND

// ���l
#100 instruction = 32'b0000000_00001_00010_000_00011_0010011; // ���Z ADDI
#100 instruction = 32'b0000000_00011_00001_010_00100_0010011; // �����t�召��r SLTI
#100 instruction = 32'b0000000_00011_00001_011_00100_0010011; // �����Ȃ��召��r SLTIU
#100 instruction = 32'b0000000_00011_00001_100_00100_0010011; // �r���I�_���a XORI
#100 instruction = 32'b0000000_00011_00001_110_00100_0010011; // �_���a ORI
#100 instruction = 32'b0000000_00011_00001_111_00100_0010011; // �_���� ANDI
#100 instruction = 32'b0000000_00011_00001_001_00100_0010011; // ���V�t�g SLLI
#100 instruction = 32'b0000000_00011_00001_101_00100_0010011; // �E�_���V�t�g SRLI
#100 instruction = 32'b0100000_00011_00001_101_00100_0010011; // �E�Z�p�V�t�g SRAI

// �f�[�^�]��
#100 instruction = 32'b0100000_00011_00001_101_00100_0110111; // ���bit�ւ̑��l�̃��[�h LUI
//#100 instruction = 32'b0100000_00011_00001_101_00100_0010111; // PC���΃A�h���X�l�̏��bit�̃��[�h AUIPC

// JAL
// JALR
// BEQ
// BNE
// BLT
// BGE
// BLTU
// BGEU

// ���[�h
// LB 8bit
// LH 16bit
#100 instruction = 32'b0000000_00000_00000_010_00001_0000011; // LW 32bit
// LBU 8bit
// LHU 16bit

// �X�g�A
// SB 8bit
// SH 16bit
#100 instruction = 32'b0000000_00000_00000_010_00001_0100011; // SW 32bit



#100 $finish;
end

endmodule
