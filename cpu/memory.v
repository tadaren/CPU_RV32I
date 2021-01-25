`timescale 1ns / 1ps

module memory(address, read_data, write_data, we, clk);
input [31:0]address;
output [31:0]read_data;
input [31:0]write_data;
input we;
input clk;

reg [31:0] memory[0:4096];

assign read_data = memory[address >> 2];

always @(posedge clk)
    if(we) memory[address >> 2] <= write_data;
    
initial begin
    $readmemb("data.txt", memory);
end

endmodule
