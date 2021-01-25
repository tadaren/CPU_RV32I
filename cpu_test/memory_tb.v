`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 11:20:40
// Design Name: 
// Module Name: memory_tb
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


module memory_tb;
reg [31:0]address, write_data;
reg we, clk;
wire [31:0]read_data;

memory memory(.address(address), .read_data(read_data), .write_data(write_data), .we(we), .clk(clk));

always begin
#10 clk <= ~clk;
end

initial begin
address = 32'h00000000; write_data = 32'h00000000; we = 0; clk = 0;
#5  address = 32'h00000000; write_data = 32'hffffffff; we = 0;
#20 address = 32'h00000000; write_data = 32'hffffffff; we = 1;
#20 address = 32'h00000000; write_data = 32'h00000000; we = 0;
#20 address = 32'hffffffff; write_data = 32'h00000000; we = 0;
#20 address = 32'hffffffff; write_data = 32'h00000000; we = 1;
#20 address = 32'hffffffff; write_data = 32'h11111111; we = 1;
#20 address = 32'hffffffff; write_data = 32'h55555555; we = 0;
#20 address = 32'h11111111; write_data = 32'h55555555; we = 0;
#20 $finish;
end

endmodule
