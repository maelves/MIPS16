library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity UExecution is
 Port (
          RD1 : in STD_LOGIC_VECTOR(15 downto 0);
          RD2 : in STD_LOGIC_VECTOR(15 downto 0);
          Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
          func : in STD_LOGIC_VECTOR(2 downto 0);
          sa : in STD_LOGIC;
          ALUSrc : in STD_LOGIC;
          ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
          PCinc : in STD_LOGIC_VECTOR(15 downto 0);
          BranchAddress : out STD_LOGIC_VECTOR(15 downto 0);
          ALURes : out STD_LOGIC_VECTOR(15 downto 0);
          Zero : out STD_LOGIC);
end UExecution;

architecture Behavioral of UExecution is
signal aluCtrl: std_logic_vector(2 downto 0);
signal aluInput: std_logic_vector(15 downto 0);
signal alu_Res: std_logic_vector(15 downto 0);
signal res: std_logic_vector(15 downto 0);

begin

    -- Adresa de branch
    BranchAddress <= PCinc + Ext_Imm;
    
    -- ALUSrc MUX
    aluInput <= RD2 when aluSrc = '0'
                else Ext_Imm;

    -- Obtinem codul operatiei
    process (ALUOp, func)
    begin
        case(ALUOp) is
        -- Instructiune de tip R
        when "000" => case (func) is
                 when "000" => aluCtrl <= "000"; -- add
                 when "001" => aluCtrl <= "001"; -- sub
                 when "010" => aluCtrl <= "010"; -- sll
                 when "011" => aluCtrl <= "011"; -- srl
                 when "100" => aluCtrl <= "100"; -- and
                 when "101" => aluCtrl <= "101"; -- or
                 when "110" => aluCtrl <= "110"; -- xor
                 when "111" => aluCtrl <= "111"; -- sra
                 when others => aluCtrl <= (others => '0');
                 end case;
                 
        when "001" => aluCtrl <= "000"; -- addi	
		when "101" => aluCtrl <= "001"; -- subi	
		when "110" => aluCtrl <= "001"; -- beg
        when "100" => aluCtrl <= "100"; -- andi
        when others => aluCtrl <= "000";
        end case;
    end process;

    -- Efectuam operatiile in Unitatea Artimetico-Logica
   process(aluCtrl, RD1, aluInput, sa, alu_Res)
        begin
            case aluCtrl  is
                when "000" => -- add/addi
                    alu_Res <= RD1 + aluInput;
                when "001" =>  -- sub/subi
                    alu_Res <= RD1 - aluInput;                                    
                when "010" => -- sll
                    case sa is
                        when '1' => alu_Res <= aluInput(14 downto 0) & "0";
                        when '0' => alu_Res <= aluInput;
                        when others => alu_Res <= (others => '0');
                     end case;
                when "011" => -- srl
                    case sa is
                        when '1' => alu_Res <= "0" & aluInput(15 downto 1);
                        when '0' => alu_Res <= aluInput;
                        when others => alu_Res <= (others => '0');
                    end case;                                                        
                    
                when "100" => -- and/andi
                    alu_Res <= RD1 and aluInput;        
                when "101" => -- or/ori
                    alu_Res <= RD1 or aluInput; 
                when "110" => -- xor/xori
                    alu_Res <= RD1 xor aluInput;        
                when others => alu_Res <= (others => '0');              
            end case;
    
            -- Zero Flag
            case alu_Res is
                when X"0000" => Zero <= '1';
                when others => Zero <= '0';
            end case;
        
        end process;
	
		ALURes <= alu_Res;


end Behavioral;
