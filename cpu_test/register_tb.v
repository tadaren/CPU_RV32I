`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 00:03:27
// Design Name: 
// Module Name: register_tb
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


module register_tb;
reg [4:0]address1, address2, address3;
reg clk, we;
reg [31:0] wr;

wire [31:0]rs1, rs2;

register register(.address1(address1), .address2(address2), .address3(address3), .rs1(rs1), .rs2(rs2), .wr(wr), .we(we), .clk(clk));

always begin
    #10 clk <= ~clk;
end

initial begin
address1 = 0; address2 = 0; address3 = 0; we = 0; wr = 0; clk = 0;
#5  address1 = 0; address2 = 1; address3 = 2; we = 0; wr = 123456789;
#20 address1 = 0; address2 = 1; address3 = 2; we = 1; wr = 123456789;
#20 address1 = 0; address2 = 1; address3 = 1; we = 1; wr = 54321;
#20 address1 = 2; address2 = 1; address3 = 1; we = 0; wr = 54321123;

#20 $finish;
end

endmodule
