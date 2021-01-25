`timescale 1ns / 1ps

module cpu_mem_tb;
reg [31:0]instruction;
wire [31:0]memory_read;
wire [31:0]memory_write;
wire [31:0]memory_address;
wire [31:0]pc;
wire we;
reg clk;
reg reset;

wire [31:0]inst;

cpu cpu(
        .instruction(instruction),
        .memory_read(memory_read),
        .memory_write(memory_write),
        .memory_address(memory_address),
        .pc(pc),
        .we(we),
        .clk(clk),
        .reset(reset));

i_memory i_memory(
        .address(pc),
        .read_data(inst)
);
memory memory(
        .address(memory_address),
        .read_data(memory_read),
        .write_data(memory_write),
        .we(we),
        .clk(clk)
);

always @(inst) begin
    instruction <= inst;
end

always begin
    #10 clk <= ~clk;
end

initial begin
instruction = 0; clk = 0; reset = 1;
#15 reset = 0;

#1285 $finish;
end
endmodule
