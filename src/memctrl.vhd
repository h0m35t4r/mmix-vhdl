----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 18:29:29 02/13/2012 
--
-- Description: Control unit for interfacing with nexys2 ROM and RAM
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity memctrl is
	port(
		clk : in std_logic;
		MemDB : inout std_logic_vector(15 downto 0);	--Memory data
		MemAdr : out std_logic_vector(23 downto 1);		--Memory address
		MemOE : out std_logic;			--output enable
		MemWR : out std_logic;			--write enable
		RamAdv : out std_logic;			--RAM address valid pin
		RamCS : out std_logic;			--RAM select
		RamClk : out std_logic;			--RAM clock
		RamCRE : out std_logic;			--Cfg register enable
		RamLB : out std_logic;			--RAM Lower byte enable
		RamUB : out std_logic;			--RAM Upper byte enable
		RamWait : in std_logic;			--RAM wait pin
		FlashRp : out std_logic;		--Flash RP pin
		FlashCS : out std_logic;		--Flash select
		FlashStSts : in std_logic;		--Flase ST-STS pin
		RamSel : in std_logic;
		RomSel : in std_logic;
		WriteEn : in std_logic;
		ReadEn : in std_logic;
		Addr : in std_logic_vector(23 downto 1);
		data : inout std_logic_vector(15 downto 0)
	);
end memctrl;

architecture Behavioral of memctrl is

begin
	
	--ROM or RAM Chip enable
	RamCS <= RamSel;
	FlashCS <= RomSel;
	
	--Read and write enables
	MemOE <= ReadEn;
	MemWR <= WriteEn;
	
	--Memory address
	MemAdr <= Addr;
	
	process(clk)
	begin
		data <= MemDB;
	end process;
	
end Behavioral;