----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 20:08:33 02/10/2012 
--
-- Description: Controls 7 segment display
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port ( 	clk : in std_logic;
			data : in std_logic_vector(15 downto 0);
			seg : out std_logic_vector(6 downto 0);
			dp : out std_logic;
			an : out std_logic_vector(3 downto 0));
end display;

architecture Behavioral of display is

	signal divclk : std_logic;
	type led_segment is array(0 to 15) of std_logic_vector(6 downto 0);
	constant hex_output: led_segment := (
		1 => "1111001",
		2 => "0100100",
		3 => "0110000",
		4 => "0011001",
		5 => "0010010",
		6 => "0000010",
		7 => "1111000",
		8 => "0000000",
		9 => "0010000",
		10 => "0001000",
		11 => "0000011",
		12 => "1000110",
		13 => "0100001",
		14 => "0000110",
		15 => "0001110",
		others => "1000000");
begin

	dp <= '1';

	clkdiv1kHz: process(clk)
		variable cnt : integer range 0 to 50000;
	begin
		if rising_edge(clk) then
			if cnt = 50000 then
				cnt := 0;
				divclk <= '1';
			else
				cnt := cnt + 1;
				divclk <= '0';
			end if;
		end if;
	end process;
	
	output: process(divclk)
		variable led_no : integer range 1 to 5;
	begin
		if rising_edge(divclk) then			
			if led_no = 1 then
				an <= "0111";
				seg <= hex_output(to_integer(unsigned(data(15 downto 12))));
			elsif led_no = 2 then
				an <= "1011";
				seg <= hex_output(to_integer(unsigned(data(11 downto 8))));
			elsif led_no = 3 then
				an <= "1101";
				seg <= hex_output(to_integer(unsigned(data(7 downto 4))));
			elsif led_no = 4 then
				an <= "1110";
				seg <= hex_output(to_integer(unsigned(data(3 downto 0))));
			end if;
			
			--Iterate through each segment display
			if led_no = 4 then
				led_no := 1;
			else
				led_no := led_no + 1;
			end if;
		end if;
	end process;
	
end Behavioral;