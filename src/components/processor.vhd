-- Processor.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY mrk;
USE mrk.COMMON.ALL;

ENTITY Processor IS
    PORT (
        in_port : IN REG32; -- 32 bit
        interrupt : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        out_port : OUT REG32; -- 32 bit
        exception : OUT STD_LOGIC
    );
END Processor;

ARCHITECTURE Processor_Arch OF Processor IS
    SIGNAL clk : STD_LOGIC := '1';

    -- pc
    SIGNAL pc : MEM_ADDRESS; -- 32 bit

    -- instruction memory
    SIGNAL im_instruction_memory_bus : MEM_CELL; -- 16 bit

    -- opcode checker unit
    SIGNAL opc_extra_reads : STD_LOGIC;

    -- fetch/decode register
    SIGNAL fd_fetched_instruction : FETCHED_INSTRUCTION;

    -- register file
    SIGNAL regf_read_data_1 : REG32;
    SIGNAL regf_read_data_2 : REG32;

    -- control unit
    SIGNAL ctrl_write_enable : STD_LOGIC;
    SIGNAL ctrl_mem_write : STD_LOGIC;
    SIGNAL ctrl_mem_read : STD_LOGIC;
    SIGNAL ctrl_alu_use_logical : STD_LOGIC;
    SIGNAL ctrl_alu_use_immediate : STD_LOGIC;

    -- decode/execute
    SIGNAL de_write_address : REG_SELECTOR;
    SIGNAL de_write_enable : STD_LOGIC;
    SIGNAL de_read_data_1 : REG32;
    SIGNAL de_read_data_2 : REG32;
    SIGNAL de_mem_write : STD_LOGIC;
    SIGNAL de_mem_read : STD_LOGIC;
    SIGNAL de_alu_use_logical : STD_LOGIC;
    SIGNAL de_alu_use_immediate : STD_LOGIC;
    SIGNAL de_instr_opcode : OPCODE;
    SIGNAL de_instr_immediate : SIGNED(31 DOWNTO 0);

BEGIN
    clkProcess : PROCESS -- Clock process
    BEGIN
        WAIT FOR 50 ps;
        clk <= NOT clk;
    END PROCESS clkProcess;

    -- pc
    programCounter : ENTITY mrk.PC
        PORT MAP(
            clk => clk,
            reset => reset,
            extra_reads => opc_extra_reads,
            pcCounter => pc
        );

    -- instruction memory
    instructionMemory : ENTITY mrk.Instruction_Memory
        PORT MAP(
            clk => clk,
            reset => reset,
            pc => pc,
            data => im_instruction_memory_bus
        );

    -- opcode checker unit FOR Backward compatibility
    opcodeChecker : ENTITY mrk.Opcode_Checker
        PORT MAP(
            reserved_bit => im_instruction_memory_bus(14), -- reserved bit
            extra_reads => opc_extra_reads
        );

    -- fetch/decode register
    fetchDecodeRegister : ENTITY mrk.Fetch_Decode
        PORT MAP(
            clk => clk,
            reset => reset,
            raw_instruction => im_instruction_memory_bus,
            extra_reads => opc_extra_reads,
            out_instruction => fd_fetched_instruction
        );

    -- register file
    registerFile : ENTITY mrk.Register_File
        PORT MAP(
            clk => clk,
            reset => reset,

            -- input

            write_enable_1 => '0',
            write_addr_1 => (OTHERS => '0'), -- wb
            write_data_1 => (OTHERS => '0'), -- wb

            write_enable_2 => '0',
            write_addr_2 => (OTHERS => '0'), -- wb
            write_data_2 => (OTHERS => '0'), -- wb

            read_addr_1 => fd_fetched_instruction(7 DOWNTO 5), -- src1
            read_addr_2 => fd_fetched_instruction(10 DOWNTO 8), -- src2

            -- output
            read_data_1 => regf_read_data_1,
            read_data_2 => regf_read_data_2
        );

    -- control unit
    controlUnit : ENTITY mrk.Controller
        PORT MAP(
            opcode => fd_fetched_instruction(4 DOWNTO 0), -- opcode
            reserved_bit => fd_fetched_instruction(14), -- res(0)

            -- output
            write_enable => ctrl_write_enable,
            mem_write => ctrl_mem_write,
            mem_read => ctrl_mem_read,
            alu_use_logical => ctrl_alu_use_logical,
            alu_use_immediate => ctrl_alu_use_immediate
        );

    -- decode/execute
    decodeExecute : ENTITY mrk.Decode_Execute
        PORT MAP(
            -- input
            clk => clk,

            write_address => fd_fetched_instruction(13 DOWNTO 11), -- dst
            write_enable => ctrl_write_enable,

            read_data_1 => regf_read_data_1,
            read_data_2 => regf_read_data_2,

            mem_write => ctrl_mem_write,
            mem_read => ctrl_mem_read,
            alu_use_logical => ctrl_alu_use_logical,
            alu_use_immediate => ctrl_alu_use_immediate,
            instr_opcode => fd_fetched_instruction(4 DOWNTO 0),
            instr_immediate => fd_fetched_instruction(31 DOWNTO 16),

            -- output
            out_write_address => de_write_address,
            out_write_enable => de_write_enable,
            out_read_data_1 => de_read_data_1,
            out_read_data_2 => de_read_data_2,
            out_mem_write => de_mem_write,
            out_mem_read => de_mem_read,
            out_alu_use_logical => de_alu_use_logical,
            out_alu_use_immediate => de_alu_use_immediate,
            out_instr_opcode => de_instr_opcode,
            out_instr_immediate => de_instr_immediate
        );

    -- alu
    alu : ENTITY mrk.ALU
        PORT MAP(
            operand_1 => de_read_data_1,
            operand_2 => de_read_data_2,
            immediate => de_instr_immediate,
            opcode => de_instr_opcode,

            ctrl_use_logic => de_alu_use_logical,
            ctrl_use_immediate => de_alu_use_immediate,

            result => out_port
        );

END Processor_Arch;