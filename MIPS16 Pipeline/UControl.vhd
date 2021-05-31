library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UControl is
    Port ( Instr : in STD_LOGIC_VECTOR(2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UControl;

architecture Behavioral of UControl is
begin

    process(Instr)
    begin
        -- Initializez semnalele cu zero
        RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; 
        Branch <= '0'; Jump <= '0'; MemWrite <= '0';
        MemtoReg <= '0'; RegWrite <= '0';
        ALUOp <= "000";
        
        -- verificam tipul instructiunii
        case (Instr) is 
            when "000" => -- instructiuni de tip R
                ALUOp <= "000";
                RegDst <= '1';
                RegWrite <= '1';
            when "001" => -- addi
                ALUOp <= "001";
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
            when "010" => -- lw
                ALUOp <= "001";
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
            when "011" => -- sw
                ALUOp <= "001";
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
            when "110" => -- beq
                ALUOp <= "110";
                ExtOp <= '1';
                Branch <= '1';
            when "100" => -- andi
				ALUOp <= "100";	 
				ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
            when "101" => -- subi
                ALUOp <= "101";
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
            when "111" => -- j
                Jump <= '1';
                
            when others => 
                RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; 
                Branch <= '0'; Jump <= '0'; MemWrite <= '0';
                MemtoReg <= '0'; RegWrite <= '0';
                ALUOp <= "000";
        end case;
        
    end process;		

end Behavioral;