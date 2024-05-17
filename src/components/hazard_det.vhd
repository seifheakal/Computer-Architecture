--hazard dettection unit
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MRK;
USE MRK.COMMON.ALL;

entity hazard_detection is
    PORT(
        --first haazarf
            write_enable1 : IN STD_LOGIC;--f/D
            write_enable2 : IN STD_LOGIC;--f/D
            write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--f/D
            write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--f/D
            write_back_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--wb
            
            --second hazard
            read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--f/D
            read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--f/D
            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--e/m
            Register_distnatin : IN STD_LOGIC_VECTOR(2 DOWNTO 0);--e/m

            hazard_detected : OUT STD_LOGIC


    );
END entity hazard_detection;

ARCHITECTURE behavior OF hazard_detection IS

BEGIN
    PROCESS(rising_edge(clk))
    BEGIN
        IF write_enable1 = '1' AND write_address1 = write_back_address THEN
        hazard_detected <= '1';
            --nop
        else 
            hazard_detected <= '0';
        END IF;
        IF write_enable2 = '1' AND write_address2 = write_back_address THEN
            hazard_detected <= '1';
            --nop
        else
            hazard_detected <= '0';
        END IF;
        if (read_address1 = Register_distnatin OR read_address2 = Register_distnatin OR read_address1 =write_back_address OR read_address2=write_back_address ) AND (opcode=OPCODE_LDM OR opcode = OPCODE_LDD OR opcode = OPCODE_POP) then
            hazard_detected <= '1';
            --FULLFORWARDING
        else
            hazard_detected <= '0';
        end if ;
        if opcode =OPCODE_JMP OR opcode = OPCODE_CALL OR opcode = OPCODE_JZ OR opcode = OPCODE_RET OR opcode = OPCODE_RTI then
            hazard_detected <= '1';
            --FLUSH
        else
            hazard_detected <= '0';
        end if;
        
END PROCESS;

end ARCHITECTURE behavior;