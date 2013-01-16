----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 11:45:29 10/15/2011
--
-- Description: Implements a counter that points to instruction memory
-- fetching a new instruction on every cycle. Supports branching and synchronous reset
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use std.textio.all;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity Fetch is
	port( 	en : in std_logic;
			reset : in std_logic;
			clk : in std_logic;
			branch : branch;
			output : out fetch_decode);
end Fetch;

architecture Behavioural of Fetch is

	type rom_type is array (0 to 255) of std_logic_vector(31 downto 0);
    constant rom : rom_type := ( 
		MMIX_SETL & X"00" & X"00" & X"48",
		MMIX_SETL & X"01" & X"00" & X"45",
		MMIX_SETL & X"02" & X"00" & X"4C",
		MMIX_SETL & X"03" & X"00" & X"4F",
		MMIX_STBI & X"00" & X"FF" & X"00",
		MMIX_STBI & X"01" & X"FF" & X"01",
		MMIX_STBI & X"02" & X"FF" & X"02",
		MMIX_STBI & X"02" & X"FF" & X"03",
		MMIX_STBI & X"03" & X"FF" & X"04",
		others => X"00000000");
	
	signal PC : std_logic_vector(63 downto 0) := (others => '0');
	
begin

	increment_process: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				PC <= (others => '0');
			elsif en = '1' then 
				if branch.en = '1' then
					PC <= branch.addr;
				else
					PC <= std_logic_vector(unsigned(PC) + 1);
				end if;
			end if;
		end if;
	end process;
	
	output.IR <= rom(to_integer(resize(unsigned(PC), 8)));
	output.NPC <= std_logic_vector(unsigned(PC) + 1);
	
end Behavioural;