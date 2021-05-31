library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResInput : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal MEM : mem_type := (
    X"0001",
    X"0003",
    X"0003",
    X"0006",
    X"0007",
    X"0005",
    X"000A",
    
    others => X"0000");
    
begin

    -- Citire din memorie (asincrona)
    ALUResOut <= ALUResInput;
    
    -- Scriere in memorie (sincrona)
    process(clk) 			
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite = '1' then
                MEM(conv_integer(ALUResInput(4 downto 0))) <= RD2;
				MemData <= RD2;
			else
				MemData <= MEM(conv_integer(ALUResInput(4 downto 0)));
            end if;
        end if;
    end process;

end Behavioral;
