LW      r0 0 r1
LW      r0 4 r2
IMM     r3 -12
ADDI    r1 -4 r4
SLTI    r1 -1 r6
SLTI    r1 15 r5
SLTIU   r1 5 r7
SLTIU   r1 -1 r8
XORI    r1 12 r9
ORI     r1 12 r10
ANDI    r1 12 r11
SLLI    r1 10 r12
SRLI    r3 4 r13
SRAI    r3 4 r14
ADD     r1 r2 r15
SUB     r2 r1 r16
SLL     r1 r2 r17
SLT     r2 r3 r18
SLT     r3 r2 r19
SLTU    r2 r3 r20
SLTU    r3 r2 r21
XOR     r1 r2 r22
SRL     r3 r2 r23
SRA     r3 r2 r24
OR      r1 r2 r25
AND     r1 r2 r26
SW      r4 r0 8
SW      r5 r0 12
SW      r6 r0 16
SW      r7 r0 20
SW      r8 r0 24
SW      r9 r0 28
SW      r10 r0 32
SW      r11 r0 36
SW      r12 r0 40
SW      r13 r0 44
SW      r14 r0 48
SW      r15 r0 52
SW      r16 r0 56
SW      r17 r0 60
SW      r18 r0 64
SW      r19 r0 68
SW      r20 r0 72
SW      r21 r0 76
SW      r22 r0 80
SW      r23 r0 84
SW      r24 r0 88
SW      r25 r0 92
SW      r26 r0 96
BEQ     r1 r3 8
SW      r3 r0 100
BNE     r1 r3 8
SW      r3 r0 104
BLT     r1 r3 8
SW      r3 r0 108
BGE     r1 r3 8
SW      r3 r0 112
BLTU    r1 r3 8
SW      r3 r0 116
BGEU    r1 r3 8
SW      r3 r0 120
JAL     r27 8
SW      r3 r0 124
SW      r27 r0 128
JALR    r28 r1 258
SW      r3 r0 132
SW      r28 r0 136