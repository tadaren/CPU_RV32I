`timescale 1ns / 1ps

module cpu(instruction, memory_read, memory_write, memory_address, pc, we, clk, reset);
input [31:0]instruction;
input [31:0]memory_read;
output [31:0]memory_write;
output [31:0]memory_address;
output [31:0]pc;
output we;
input clk;
input reset;

reg [31:0]pc_;

wire [4:0]rs1, rs2, rd;
wire [2:0]alu_sel;
wire alu_ext;
wire [31:0]immediate;

wire [31:0]A, B, Y;
wire [31:0]rsd1, rsd2;
wire alu_input_sel;
reg [31:0]return_pc;
reg [31:0]wr;
wire register_we;
wire [1:0]register_write_sel;
wire [6:0]opcode;

decoder decoder(.instruction(instruction), 
                .rs1(rs1),
                .rs2(rs2),
                .rd(rd),
                .alu_sel(alu_sel),
                .alu_ext(alu_ext),
                .alu_input_sel(alu_input_sel),
                .immediate(immediate),
                .register_we(register_we),
                .register_write_sel(register_write_sel),
                .memory_we(we),
                .opcode(opcode));
alu alu(.A(A), .B(B), .sel(alu_sel), .ext(alu_ext), .Y(Y));
register register(.address1(rs1), .address2(rs2), .address3(rd), .rs1(rsd1), .rs2(rsd2), .wr(wr), .we(register_we), .clk(clk));

reg signed [31:0]signed_rsd1;
reg signed [31:0]signed_rsd2;
always @(posedge clk, posedge reset) begin
    // 分岐命令
    signed_rsd1 = $signed({1'b0, rsd1});
    signed_rsd2 = $signed({1'b0, rsd2});
    if(opcode == 7'b1100011)
        if(alu_sel == 3'b000 && rsd1 == rsd2)
            pc_ = pc_ + immediate;
        else if(alu_sel == 3'b001 && rsd1 != rsd2)
            pc_ = pc_ + immediate;
        else if(alu_sel == 3'b100 && signed_rsd1 < signed_rsd2)
            pc_ = pc_ + immediate;
        else if(alu_sel == 3'b101 && signed_rsd1 >= signed_rsd2)
            pc_ = pc_ + immediate;
        else if(alu_sel == 3'b110 && rsd1 < rsd2)
            pc_ = pc_ + immediate;
        else if(alu_sel == 3'b111 && rsd1 >= rsd2)
            pc_ = pc_ + immediate;
        else
            pc_ <= pc_ + 4;
    else if(opcode == 7'b1101111) // JAL
        pc_ = pc_ + immediate;
    else if(opcode == 7'b1100111) // JALR
        pc_ = Y;
    else
        pc_ = pc_ + 4;
    
    if(reset == 1'b1)begin
        pc_ = 0;
    end
end

always @(*) begin
    return_pc = pc_ + 4;
    case(register_write_sel)
        0: wr <= Y;
        1: wr <= memory_read;
        2: wr <= immediate;
        3: wr <= return_pc;
        default: wr <= 32'bzzzzzzzz;
    endcase
end

assign A = rsd1;
assign B = (alu_input_sel == 1'b0)? rsd2 : immediate;
assign memory_address = Y;
assign memory_write = rsd2;

assign pc = pc_;

endmodule
