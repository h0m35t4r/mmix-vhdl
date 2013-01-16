----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 16:04:53 02/20/2012 
--
-- Description: Controls selection of video RAM depending on screen position
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity char_ctrl is
	port(	HCnt : in std_logic_vector(9 downto 0);		--Horizontal Count
			VCnt : in std_logic_vector(9 downto 0);		--Vertical Count
			char_raddr : out std_logic_vector(12 downto 0);	--Read address for Character RAM
			char_data : in std_logic_vector(63 downto 0);	--Character bitmap
			char_pixel : out std_logic_vector(7 downto 0)
	);
end char_ctrl;

architecture Behavioral of char_ctrl is

begin

	process(HCnt, VCnt)
	begin
		char_raddr <= std_logic_vector((resize(unsigned(VCnt(9 downto 3)), 13) sll 6) + 
			(resize(unsigned(VCnt(9 downto 3)), 13) sll 4) + unsigned(HCnt(9 downto 3)));
	end process;
	
	process(char_data)
		variable start_row : integer range 0 to 56;
		variable pixel : integer range 0 to 7;
		variable row : std_logic_vector(7 downto 0);
	begin
		start_row := to_integer(resize(unsigned(VCnt(2 downto 0)), 6) sll 3);
		pixel := to_integer(unsigned(HCnt(2 downto 0)));
		row := char_data(63 - start_row downto 56 - start_row);
		
		if row(7 - pixel) = '1' then
			char_pixel <= X"FF";
		else
			char_pixel <= X"00";
		end if;
	end process;

end Behavioral;