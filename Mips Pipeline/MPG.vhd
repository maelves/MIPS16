library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal num: std_logic_vector(15 downto 0);
signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
begin
	en <= q2 and (not q3);
	
    process(clk)
    begin
        if clk'event and clk = '1' then
             num <= num+1;
         end if;
    end process;
    
    process(clk)
    begin
        if clk'event and clk = '1' then
            if num = "1111111111111111" then
                q1 <= input;
             end if;
        end if;
    end process;
    
    process(clk)
    begin
        if clk'event and clk = '1' then
               q2 <= q1;
               q3 <= q2;
        end if;
    end process;
    
end Behavioral;