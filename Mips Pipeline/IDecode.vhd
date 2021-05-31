library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDecode is
    Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(12 downto 0);
           wa: in STD_LOGIC_VECTOR(2 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(15 downto 0);
           RD2 : out STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR(2 downto 0);
           sa : out STD_LOGIC);
end IDecode;

architecture Behavioral of IDecode is

type mem is array (0 to 7) of std_logic_vector (15 downto 0);
signal RF : mem := (others => x"0000");
signal WriteAdress : std_logic_vector (2 downto 0);
signal extsign : std_logic_vector (8 downto 0);

begin

    -- Pt. instructiuni de tip R luam tipul functiei si Shift Amount
    func <= Instr(2 downto 0);
    sa <= Instr(3);

    -- Scriere in RF
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and RegWrite = '1' then
                RF(conv_integer(WriteAdress)) <= WD;
            end if;
       end if;      
    end process;
    
    -- Extindere cu semn
    with Instr(6) Select
        extsign <= "000000000" when '0', "111111111" when '1', "000000000" when others;
    
    -- Decidem daca scriem in RD sau in RT
    -- with RegDst Select
    --  WriteAdress <= Instr(9 downto 7) when '0', Instr(6 downto 4) when '1', "000" when others;
    
    -- Luam datele din RF
    with ExtOp Select
        Ext_imm <= "000000000" & Instr(6 downto 0) when '0', extsign & Instr(6 downto 0) when '1', X"0000" when others;
     RD1 <= RF(conv_integer(Instr(12 downto 10)));
     RD2 <= RF(conv_integer(Instr(9 downto 7)));
    

end Behavioral;