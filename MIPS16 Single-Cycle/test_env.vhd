library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal q1 : std_logic := '0';
signal q2 : std_logic := '0';
signal rst : std_logic := '0';
signal digits1 : std_logic_vector(15 downto 0);
signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal wd : std_logic_vector(15 downto 0);
signal ALURes : std_logic_vector(15 downto 0);
signal ALURess : std_logic_vector(15 downto 0);
signal MemData : std_logic_vector(15 downto 0);
signal jump_address: std_logic_vector(15 downto 0);
signal branch_address: std_logic_vector(15 downto 0);
signal instr_signal: std_logic_vector(15 downto 0);
signal pc_sig: std_logic_vector(15 downto 0);
signal prog_count: std_logic_vector(7 downto 0);
signal PCSrc: std_logic;
signal Branch: std_logic;
signal Zero: std_logic;
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUsrc: std_logic;
signal Jump: std_logic;
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal sa: std_logic;
signal func: std_logic_vector (2 downto 0);
signal ALUOp: std_logic_vector (2 downto 0);
signal Ext_imm: std_logic_vector (15 downto 0);


component MPG is
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component MPG;

component SSD is
    Port(   clk : in STD_LOGIC;
            digits : in STD_LOGIC_VECTOR (15 downto 0);
            an : out STD_LOGIC_VECTOR (3 downto 0);
            cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component IFetch
    Port ( clk: in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           branch_address : in STD_LOGIC_VECTOR(15 downto 0);
           jump_address : in STD_LOGIC_VECTOR(15 downto 0);
           jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component IDecode is
    Port ( RegWrite: in std_logic;
           Instr: in std_logic_vector(12 downto 0);
           RegDst: in std_logic;
           clk: in std_logic;
           en: in std_logic;
           ExtOp: in std_logic;
           WD: in std_logic_vector (15 downto 0);
           RD1 : out std_logic_vector (15 downto 0);
           RD2 : out std_logic_vector (15 downto 0);
           Ext_imm : out std_logic_vector (15 downto 0);
           func: out std_logic_vector (2 downto 0);
           sa : out std_logic);
end component;

component UControl
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
end component;

component UExecution
    Port ( RD1 : in STD_LOGIC_VECTOR(15 downto 0);
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
end component;

component MEM
   Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResInput : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

begin
        mapareMPG1: MPG port map(
                                input => btn(0),
                                clk => clk,
                                en => q1);
        mapareMPG2: MPG port map(
                                 input => btn(1),
                                 clk => clk,
                                 en => q2);
                                                                 
        mapareSSD: SSD port map(
                                clk => clk,
                                digits => digits1,
                                an => an,
                                cat => cat);
                                
        mapareIFetch: IFetch port map(
                                clk => clk,
                                rst => rst,
                                en => q1,
                                branch_address => branch_address,
                                jump_address => jump_address,
                                jump => Jump,
                                PCSrc => PCSrc, 
                                instruction => instr_signal, 
                                PCinc => pc_sig);
                                
        mapareIDecode: IDecode port map(
                                RegWrite => RegWrite,
                                Instr => instr_signal(12 downto 0),
                                RegDst => RegDst,
                                clk => clk,
                                en => q1,
                                ExtOp => ExtOp,
                                WD => wd,
                                RD1 => RD1,
                                RD2 => RD2,
                                Ext_imm => Ext_imm,
                                func => func,
                                sa => sa);
                                
        mapareUCotrol: UControl port map(
                                Instr => instr_signal(15 downto 13),
                                RegDst => RegDst,
                                ExtOp => ExtOp,
                                ALUSrc => ALUSrc,
                                Branch => Branch,
                                Jump => Jump,
                                ALUOp => ALUOp,
                                MemWrite => MemWrite,
                                MemtoReg => MemtoReg,
                                RegWrite => RegWrite);
                                
         mapareUExecution: UExecution port map(
                                RD1 => RD1,
                                RD2 => RD2,
                                Ext_Imm => Ext_Imm,
                                func => func,
                                sa => sa,
                                ALUSrc => ALUSrc,
                                ALUOp => ALUOp,
                                PCinc => pc_sig,
                                BranchAddress => branch_address,
                                ALURes => ALURes,
                                Zero => Zero);
                                
         mapareMEM: MEM port map(
                                clk => clk,
                                en => q1,
                                ALUResInput => ALURes,
                                RD2 => RD2,
                                MemWrite => MemWrite,            
                                MemData => MemData,
                                ALUResOut => ALURess);
       
       -- Mux PCSrc
       PCSrc <= Branch and Zero;
       
       -- Jump Adress
      jump_address <= pc_sig(15 downto 13) & instr_signal(12 downto 0);
       
       -- Write Back Unit
       with MemtoReg select
        wd <= MemData when '1',
              ALURess when '0',
              (others => 'X') when others;
              
        -- Afisarea semnalelor de control pe leduri
         led(10 downto 0) <= ALUOp & ALUSrc & Branch & ExtOp & Jump & MemWrite & MemtoReg & RegWrite & RegDst;
         
        -- Afisare pe SSD
         with sw(2 downto 0) select
                digits1 <= instr_signal when "000", 
                           pc_sig when "001",
                           RD1 when "010",
                           RD2 when "011",
                           Ext_Imm when "100",
                           ALURes when "101",
                           MemData when "110",
                           wd when "111",
                           (others => '0') when others;
         
end Behavioral;