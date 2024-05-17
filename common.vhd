-- Common types, etc

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE COMMON IS
    -- our register is 32 bits
    SUBTYPE REG32 IS STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- memory entry is 16 bits
    SUBTYPE MEM_CELL IS STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- PC and SP are 32 bits, any memory access addr is 32 bits
    SUBTYPE MEM_ADDRESS IS STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- data memory cell is 16, but we assume 32 bits (read 2 consec. cells)
    SUBTYPE DATA_MEM_CELL IS STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Register selector is 3 bits
    SUBTYPE REG_SELECTOR IS STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Fetched instruction is 32 bits
    SUBTYPE FETCHED_INSTRUCTION IS STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Memory array is 4096 cells
    TYPE MEMORY_ARRAY IS ARRAY (0 TO 4095) OF MEM_CELL;

    -- Constant types

    -- -- logical alu signals (or, cmp, dec, etc)
    -- SUBTYPE ALU_CS_LOGICAL IS STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- -- alu control signals
    -- CONSTANT ALU_CS_LOGICAL_NOT : ALU_CS_LOGICAL := "00";
    -- CONSTANT ALU_CS_LOGICAL_OR : ALU_CS_LOGICAL := "01";
    -- CONSTANT ALU_CS_LOGICAL_DEC : ALU_CS_LOGICAL := "10";
    -- CONSTANT ALU_CS_LOGICAL_CMP : ALU_CS_LOGICAL := "11";

    -- opcodes
    SUBTYPE OPCODE IS STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- instruction opcodes
    CONSTANT OPCODE_NOP : OPCODE := "00000";
    CONSTANT OPCODE_NOT : OPCODE := "00001";
    CONSTANT OPCODE_NEG : OPCODE := "00010";
    CONSTANT OPCODE_INC : OPCODE := "00011";
    CONSTANT OPCODE_DEC : OPCODE := "00100";
    CONSTANT OPCODE_OUT : OPCODE := "00101";
    CONSTANT OPCODE_IN : OPCODE := "00110";
    CONSTANT OPCODE_MOV : OPCODE := "00111";
    CONSTANT OPCODE_SWAP : OPCODE := "01000";
    CONSTANT OPCODE_ADD : OPCODE := "01001";
    CONSTANT OPCODE_ADDI : OPCODE := "01010";
    CONSTANT OPCODE_SUB : OPCODE := "01011";
    CONSTANT OPCODE_SUBI : OPCODE := "01100";
    CONSTANT OPCODE_AND : OPCODE := "01101";
    CONSTANT OPCODE_OR : OPCODE := "01110";
    CONSTANT OPCODE_XOR : OPCODE := "01111";
    CONSTANT OPCODE_CMP : OPCODE := "10000";
    CONSTANT OPCODE_PUSH : OPCODE := "10001";
    CONSTANT OPCODE_POP : OPCODE := "10010";
    CONSTANT OPCODE_LDM : OPCODE := "10011";
    CONSTANT OPCODE_LDD : OPCODE := "10100";
    CONSTANT OPCODE_STD : OPCODE := "10101";
    CONSTANT OPCODE_PROTECT : OPCODE := "10110";
    CONSTANT OPCODE_FREE : OPCODE := "10111";
    CONSTANT OPCODE_JZ : OPCODE := "11000";
    CONSTANT OPCODE_JMP : OPCODE := "11001";
    CONSTANT OPCODE_CALL : OPCODE := "11010";
    CONSTANT OPCODE_RET : OPCODE := "11011";
    CONSTANT OPCODE_RTI : OPCODE := "11100";
    CONSTANT OPCODE_RESET : OPCODE := "11101";
    CONSTANT OPCODE_INTERRUPT : OPCODE := "11110";

    -- control signals
    SUBTYPE SIGBUS IS STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT SIGBUS_WRITE_ENABLE : INTEGER := 0;
    CONSTANT SIGBUS_MEM_WRITE : INTEGER := 1;
    CONSTANT SIGBUS_MEM_READ : INTEGER := 2;
    CONSTANT SIGBUS_MEM_TO_REG : INTEGER := 3;
    CONSTANT SIGBUS_USE_IO : INTEGER := 4;
    CONSTANT SIGBUS_ALU_PASS_THROUGH : INTEGER := 5;
    CONSTANT SIGBUS_ALU_USE_LOGICAL : INTEGER := 6;
    CONSTANT SIGBUS_ALU_USE_IMMEDIATE : INTEGER := 7;
    CONSTANT SIGBUS_ALU_UPDATE_FLAGS : INTEGER := 8;
    CONSTANT SIGBUS_SIGN_EXTEND_IMMEDIATE : INTEGER := 9;
    CONSTANT SIGBUS_USE_SP : INTEGER := 10;
    CONSTANT SIGBUS_OP_PUSH : INTEGER := 11;
    CONSTANT SIGBUS_OP_POP : INTEGER := 12;
    CONSTANT SIGBUS_OP_JMP : INTEGER := 13;
    CONSTANT SIGBUS_OP_JZ : INTEGER := 14;

END PACKAGE COMMON;