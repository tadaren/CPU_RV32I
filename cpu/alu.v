`timescale 1ns / 1ps

module alu(A, B, sel, ext, Y);
    input [31:0]A, B;
    input [2:0]sel;
    input ext;
    output [31:0]Y;
    
    reg [31:0] Y;

    reg signed [31:0]signed_a;
    reg signed [31:0]signed_b;
    reg signed [31:0]signed_y;
    
    reg [4:0]b_5;
    reg signed [4:0]signed_b_5; 
    
    always @(A or B or sel or ext)
    begin
        signed_a = $signed({1'b0, A});
        signed_b = $signed({1'b0, B});
        b_5 = B[4:0];
        signed_b_5 = signed_b[4:0];
        signed_y = signed_a >>> signed_b_5;

        case(sel)
            0: Y <= (ext == 0) ? (A + B) : (A - B);      // ADD SUB
            1: Y <= A << b_5;                              // SLL
            2: Y <= (signed_a < signed_b);               // SLT
            3: Y <= (A < B) ? 1 : 0;                     // SLTU
            4: Y <= A ^ B;                               // XOR
            5: Y <= (ext == 0) ? (A >> b_5) : signed_y;   // SRL SRA
            6: Y <= A | B;                               // OR
            7: Y <= A & B;                               // AND
            default: Y <= 32'hxxxxxxxx;
        endcase
    end
endmodule
