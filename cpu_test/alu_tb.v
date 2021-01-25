`timescale 1ns / 1ps

module alu_tb;
    reg [31:0]A, B;
    reg [2:0]sel;
    reg ext;
    wire [31:0]Y;
    
    alu alu(.A(A), .B(B), .sel(sel), .ext(ext), .Y(Y));
    
    initial begin
    A = 0; B = 0; sel = 0; ext = 0;
    // ADD
    #100 A = 0; B = 0; sel = 0; ext = 0;
    #100 A = 10; B = 5;
    #100 A = 10; B = -5;
    #100 A = 5; B = -10;
    #100 A = 31'hffffffff; B = 1;
    // SUB
    #100 A = 10; B = 5; sel = 0; ext = 1;
    #100 A = 10; B = 5;
    #100 A = 5; B = 10;
    #100 A = 10; B = 0;
    #100 A = 0; B = 10;
    // SLL
    #100 A = 10; B = 0; sel = 1; ext = 0;
    #100 A = 0; B = 10;
    #100 A = 1; B = 1;
    #100 A = 1; B = 31;
    #100 A = 1; B = 32;
    // SLT
    #100 A = 10; B = 5; sel = 2; ext = 0;
    #100 A = 5; B = 10;
    #100 A = -1; B = 0;
    #100 A = 0; B = -1;
    // SLTU
    #100 A = 10; B = 5; sel = 3; ext = 0;
    #100 A = 5; B = 10;
    #100 A = -1; B = 0;
    #100 A = 0; B = -1;
    // XOR
    #100 A = 10; B = 5; sel = 4; ext = 0;
    #100 A = 32'hffffffff; B = 32'haaaaaaaa;
    // SRL
    #100 A = 10; B = 1; sel = 5; ext = 0;
    #100 A = 10; B = 0;
    #100 A = 0; B = 10;
    #100 A = 32'hffffffff; B = 31;
    #100 A = 32'hffffffff; B = 32;
    // SRA
    #100 A = 10; B = 1; sel = 5; ext = 1;
    #100 A = 10; B = 0;
    #100 A = 0; B = 10;
    #100 A = 32'hffffffff; B = 31;
    #100 A = 32'hffffffff; B = 32;
    // OR
    #100 A = 10; B = 5; sel = 6; ext = 0;
    #100 A = 32'hffffffff; B = 32'haaaaaaaa;
    // AND
    #100 A = 10; B = 5; sel = 7; ext = 0;
    #100 A = 32'hffffffff; B = 32'haaaaaaaa;
    
    #100 $finish;
    end
endmodule
