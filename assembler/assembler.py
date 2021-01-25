import argparse
import re

class ParseError(Exception):
    pass

def parse_register(rs):
    if rs[0] != 'r':
        raise ParseError(f'{rs} is not Register')
    register_num = int(rs[1:])
    if register_num < 0 or 32 <= register_num:
        raise ParseError(f'{rs} needs to be more than 0 and less than 32')
    return format(register_num, '05b')


def parse_immediate(num, length):
    num = int(num)
    if num < 0:
        b = format(num, f'b')[1:]
        return '1'*(length-len(b)) + b
    return format(num, f'0{length}b')


ALU_REG = '0110011'
ALU_IMM = '0010011'
BRANCH  = '1100011'
LOAD    = '0000011'
STORE   = '0100011'
JAL     = '1101111'
JALR    = '1100111'

def assemble(op, args):
    if op == 'ADD':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '000' + parse_register(args[2]) + ALU_REG
    if op == 'SUB':
        return '0100000' + parse_register(args[1]) + parse_register(args[0]) + '000' + parse_register(args[2]) + ALU_REG
    if op == 'SLL':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '001' + parse_register(args[2]) + ALU_REG
    if op == 'SLT':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '010' + parse_register(args[2]) + ALU_REG
    if op == 'SLTU':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '011' + parse_register(args[2]) + ALU_REG
    if op == 'XOR':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '100' + parse_register(args[2]) + ALU_REG
    if op == 'SRL':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '101' + parse_register(args[2]) + ALU_REG
    if op == 'SRA':
        return '0100000' + parse_register(args[1]) + parse_register(args[0]) + '101' + parse_register(args[2]) + ALU_REG
    if op == 'OR':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '110' + parse_register(args[2]) + ALU_REG
    if op == 'AND':
        return '0000000' + parse_register(args[1]) + parse_register(args[0]) + '111' + parse_register(args[2]) + ALU_REG
    
    if op == 'ADDI':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '000' + parse_register(args[2]) + ALU_IMM
    if op == 'SLLI':
        return '0000000' + parse_immediate(args[1], 5) + parse_register(args[0]) + '001' + parse_register(args[2]) + ALU_IMM
    if op == 'SLTI':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '010' + parse_register(args[2]) + ALU_IMM
    if op == 'SLTIU':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '011' + parse_register(args[2]) + ALU_IMM
    if op == 'XORI':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '100' + parse_register(args[2]) + ALU_IMM
    if op == 'SRLI':
        return '0000000' + parse_immediate(args[1], 5) + parse_register(args[0]) + '101' + parse_register(args[2]) + ALU_IMM
    if op == 'SRAI':
        return '0100000' + parse_immediate(args[1], 5) + parse_register(args[0]) + '101' + parse_register(args[2]) + ALU_IMM
    if op == 'ORI':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '110' + parse_register(args[2]) + ALU_IMM
    if op == 'ANDI':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '111' + parse_register(args[2]) + ALU_IMM

    if op == 'BEQ':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '000' + immediate[8:12] + immediate[1] + BRANCH
    if op == 'BNE':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '001' + immediate[8:12] + immediate[1] + BRANCH
    if op == 'BLT':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '100' + immediate[8:12] + immediate[1] + BRANCH
    if op == 'BGE':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '101' + immediate[8:12] + immediate[1] + BRANCH
    if op == 'BLTU':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '110' + immediate[8:12] + immediate[1] + BRANCH
    if op == 'BGEU':
        immediate = parse_immediate(args[2], 13)
        return immediate[0] + immediate[2:8] + parse_register(args[1]) + parse_register(args[0]) + '111' + immediate[8:12] + immediate[1] + BRANCH

    if op == 'JAL':
        immediate = parse_immediate(args[1], 21)
        return immediate[0] + immediate[10:20] + immediate[9] + immediate[1:9] + parse_register(args[0]) + JAL

    if op == 'JALR':
        return parse_immediate(args[2], 12) + parse_register(args[1]) + '000' + parse_register(args[0]) + JALR

    if op == 'LUI':
        return parse_immediate(args[1], 20) + parse_register(args[0]) + '0110111'

    if op == 'LW':
        return parse_immediate(args[1], 12) + parse_register(args[0]) + '010' + parse_register(args[2]) + LOAD

    if op == 'SW':
        immediate = parse_immediate(args[2], 12)
        return immediate[:7] + parse_register(args[0]) + parse_register(args[1]) + '010' + immediate[7:] + STORE

    if op == 'IMM':
        num = int(args[1])
        is_minus = (num < 0)
        upper_num = num & 0xfffff000
        lower_num = num & 0x00000fff
        if is_minus:
            lower_num *= -1
        ADDI = assemble('ADDI', [args[0], str(lower_num), args[0]])
        if ADDI[0] == '1':
            upper_num ^= 0xfffff000
        shifted_upper_num = upper_num >> 12
        LUI = assemble('LUI', [args[0], str(shifted_upper_num)])
        return LUI + '\n' + ADDI


def main(file_name):
    with open(file_name, 'r') as f:
        lines = f.readlines()
    for line in lines:
        line = re.sub('\s+', ' ', line.strip()) # 前後の空白と途中の空白を1つにする
        line = re.sub('//.*$', '', line) # コメントを削除
        if not line:
            continue
        splitted_line = line.split()
        op, *args = splitted_line
        # print(op, args)
        bin_code = assemble(op, args)
        print(bin_code)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('file', help='assembler file')
    args = parser.parse_args()
    main(args.file)
