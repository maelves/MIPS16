library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          branch_address : in STD_LOGIC_VECTOR(15 downto 0);
          jump_address : in STD_LOGIC_VECTOR(15 downto 0);
          jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is

type tROM is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal ROM : tROM := (
    B"000_000_000_111_0_000",   -- X"0070" -- 0. add $7, $0, $0
    B"001_000_101_0000000",     -- X"2280" -- 1. addi $5, $0, 0
    B"001_000_110_0000111",     -- X"2307" -- 2. et: addi $6, $0, 7	
    B"110_110_101_0010000",     -- X"DA90" -- 3. beq $5, $6, exitt
    B"000_001_101_001_0_000",   -- X"0690" -- 4. add $1, $1, $5
    B"010_001_100_0000000",     -- X"4600" -- 5. lw $4, 0($1)
    B"011_001_100_0000000",     -- X"6600" -- 6. sw $4, 0($1)
    B"010_001_100_0000000",     -- X"4600" -- 7. lw $4, 0($1)
    B"001_000_111_0000001",     -- X"2381" -- 8. addi $7, $0, 1
    B"100_101_111_0000001",     -- X"9781" -- 9. andi $7, $5, 1
    B"110_000_111_0001000",     -- X"C388" -- 10.beq $7, $0, par, par = 19
    
    B"001_001_001_0000111",     -- X"2487" -- 11. addi $1, $1, 7
    B"000_100_101_100_0_000",   -- X"12C0" -- 12. add $4, $4, $5
    B"011_001_100_0000000",     -- X"6600" -- 13. sw $4, 0($1)
    B"001_001_001_0000111",     -- X"2487" -- 14. addi $1, $1, 7
    B"000_100_101_100_0_001",   -- X"12C1" -- 15. sub $4, $4, $5
    B"011_001_100_0000000",     -- X"6600" -- 16. sw $4, 0($1)
    B"001_101_101_0000001",     -- X"3681" -- 17. addi $5, $5, 1
    B"111_0000000000010",       -- X"E002" -- 18. J et, et = 2
    
    B"001_001_001_0000111",     -- X"2487" -- par: 19. addi $1, $1, 7
    B"000_100_100_110_0_000",   -- X"1260" -- 20. add $6, $4, $4
    B"001_110_110_0000101",     -- X"1D85" -- 21. addi $6, $6, 5
    B"011_001_100_0000000",     -- X"6600" -- 22. sw $6, 0($1)
    B"001_001_001_0000111",     -- X"2487" -- 23. addi $1, $1, 7
    B"000_110_100_110_0_001",   -- X"1A61" -- 24. sub $6, $6, $4
    B"101_110_110_0000101",     -- X"BB05" -- 25. subi $6, $6, 5
    B"001_101_101_0000001",     -- X"3681" -- 26. addi $5, $5, 1
    B"111_0000000000010",       -- X"E002" -- 27. J et, et = 2
    
    others => X"0000");

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PC_1: STD_LOGIC_VECTOR(15 downto 0);
signal next_addr: STD_LOGIC_VECTOR(15 downto 0);
signal signal1: STD_LOGIC_VECTOR(15 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= next_addr;
            end if;
        end if;
    end process;

    Instruction <= ROM(conv_integer(PC(7 downto 0)));

    PC_1 <= PC + 1;
    PCinc <= PC_1;
    
    process(PCSrc, PC_1, branch_address)
    begin
        case PCSrc is 
            when '1' => signal1 <= branch_address;
            when others => signal1 <= PC_1;
        end case;
    end process;
    	
    process(jump, signal1, jump_address)
    begin
        case jump is
            when '1' =>next_addr <= jump_address;
            when others => next_addr <= signal1;
        end case;
    end process;

end Behavioral;