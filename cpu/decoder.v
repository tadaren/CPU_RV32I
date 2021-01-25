`timescale 1ns / 1ps

`define LOAD    7'b0000011
`define STORE   7'b0100011
`define ALU_REG 7'b0110011
`define ALU_IMM 7'b0010011
`define LUI     7'b0110111
`define AUIPC   7'b0010111
`define JAL     7'b1101111
`define JALR    7'b1100111
`define BRANCH  7'b1100011

module decoder(instruction, rs1, rs2, rd, alu_sel, alu_ext, alu_input_sel, immediate, register_we, register_write_sel, memory_we, branch_sel, opcode);
input [31:0]instruction;          // 命令
output [4:0] rs1, rs2, rd;        // レジスタアドレス
output [2:0] alu_sel;              // 命令のfunct3部分 aluの命令セレクタ
output alu_ext;                   // aluの命令セレクタ(2つ目)
output alu_input_sel;             // aluの2入力目のセレクタ(レジスタ，即値)
output [31:0] immediate;          // 即値
output register_we;               // レジスタ書き込み
output [1:0]register_write_sel;   // レジスタ書き込みデータのセレクタ(ALU,メモリ, 即値)
output memory_we;                 // メモリ書き込み
output[2:0]branch_sel;                // 分岐命令
output [6:0]opcode;

wire [6:0]funct7;
wire [2:0]funct3;

wire [11:0]immediate_i; // 即値演算・ロード
wire [31:0]immediate_t; // 転送命令
wire [11:0]immediate_s; // ストア
wire [31:0]immediate_lui; // LUI
wire [31:0]immediate_b; // 分岐命令
wire [31:0]immediate_j; // ジャンプ
wire [19:0]sign; // 符号拡張

assign {funct7, rs2, rs1, funct3, rd, opcode} = instruction;
assign alu_ext = ((opcode == `ALU_REG) && instruction[30]) || ((opcode == `ALU_IMM) && (funct3 == 3'b101) && instruction[30]);
assign immediate_i = {funct7, rs2};
assign immediate_t = {funct7, rs2, rs1, 12'h000};
assign immediate_s = {funct7, rd};
assign immediate_lui = {funct7, rs2, rs1, funct3} << 12;
assign immediate_b = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
assign immediate_j = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
assign sign = {20{instruction[31]}};

assign immediate = (opcode == `LUI) ? immediate_lui : 
                   (opcode == `ALU_IMM) ? { sign, immediate_i } : 
                   (opcode == `LOAD) ? { sign, immediate_i } : 
                   (opcode == `STORE) ? { sign, immediate_s } :
                   (opcode == `BRANCH) ? { sign, immediate_b } :
                   (opcode == `JAL) ? {sign, immediate_j} :
                   (opcode == `JALR ) ? {sign, immediate_i} : 0;

assign alu_sel = ((opcode == `LOAD) || (opcode == `STORE)) ? 3'b000 : funct3;
assign alu_input_sel = ((opcode == `ALU_IMM) || (opcode == `JALR) || (opcode == `LOAD) || (opcode == `STORE)) ? 1 : 0;

assign branch_sel = funct3;
            
assign register_we = (opcode == `LUI) || (opcode == `ALU_REG) || (opcode == `ALU_IMM) || (opcode == `LOAD) || (opcode == `JAL) || (opcode == `JALR);

reg [1:0]write_sel;
always @(*) begin
    case(opcode)
        `ALU_REG: write_sel = 0; // alu
        `ALU_IMM: write_sel = 0; // alu即値
        `LOAD: write_sel = 1; // ロード
        `LUI: write_sel = 2; // lui
        `JAL: write_sel = 3; // 無条件ジャンプ
        `JALR: write_sel = 3; // 無条件ジャンプ
    endcase
end
assign register_write_sel = write_sel;
assign memory_we = (opcode == `STORE);

endmodule
