---------------------------------------------------------------------------------- 
-- Engineer: Riccardo Russell
-- Create Date: 11:33:33 02/11/2012 
--
-- Description: Demo for the MMIX processor
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity demo is
	port(	clk : in std_logic;
			sw : in std_logic_vector(7 downto 0);
			btn : in std_logic_vector(3 downto 0);
			Led : out std_logic_vector(7 downto 0);
			segment_data : out std_logic_vector(15 downto 0);
			char_we : out std_logic;
			char_waddr : out std_logic_vector(11 downto 0);
			char_wdata : out std_logic_vector(5 downto 0)
	);
end demo;

architecture Behavioral of demo is

	signal position : integer range 0 to 4800 := 0;

begin

	led <= sw;
	
	process(sw)
	begin
		segment_data <= X"00" & sw;
	end process;
	
	keyboard: process(clk)
	begin
		if rising_edge(clk) then
			if btn(0) = '1' then
				char_we <= '1';
				char_waddr <= std_logic_vector(to_unsigned(position, 12));
				char_wdata <= std_logic_vector(to_unsigned(to_integer(unsigned(sw)) - 33, 6));
				position <= position + 1;
			else
				char_we <= '0';
			end if;
		end if;
	end process;

end Behavioral;