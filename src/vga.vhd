----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- 
-- Create Date: 13:36:01 02/19/2012 
-- Description: Controls VGA signals, written for 640x480 resolutions
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity vga is
	port (	clk : in std_logic;
			--reset : in std_logic;
			pixel : in std_logic_vector(7 downto 0);		--RGB value
			Hsync : out std_logic;							--Horizontal Sync
			Vsync : out std_logic;							--Vertical Sync
			vgaRed : out std_logic_vector(2 downto 0);
			vgaGreen : out std_logic_vector(2 downto 0);
			vgaBlue : out std_logic_vector(2 downto 1);
			HCnt : out std_logic_vector(9 downto 0);		--Horizontal Pixel
			VCnt : out std_logic_vector(9 downto 0)		--Vertical Pixel
	);
end vga;

architecture Behavioral of vga is
	
	--Horizontal Timing
	constant HSP: integer := 800;	--Sync Pulse Time
	constant HD: integer := 640;	--Display Time
	constant HPW:integer := 96;		--Pulse Width
	constant HFP:integer := 16;		--Front Porch
	constant HBP:integer := 48;		--Back Porch
	
	--Vertical Timing
	constant VSP: integer := 521;	--Sync Pulse Time
	constant VD: integer := 480;	--Display Time
	constant VPW:integer := 2;		--Pulse Width
	constant VFP:integer := 10;		--Front Porch
	constant VBP:integer := 29;		--Back Porch

	signal divclk : std_logic := '0';
	signal HorizontalCount : integer range 0 to HSP - 1 := 0;
	signal VerticalCount : integer range 0 to VSP - 1 := 0;

begin

	--Divides clock in half to 25MHz
	clkdiv25MHz: process(clk)
		variable cnt : std_logic;
	begin
		if rising_edge(clk) then
			divclk <= not(divclk);
		end if;
	end process;
	
	output: process(divclk)
	begin
		if rising_edge(divclk) then
			if HorizontalCount = HSP - 1 then
				HorizontalCount <= 0;
				if VerticalCount = VSP - 1 then
					VerticalCount <= 0;
				else
					VerticalCount <= VerticalCount + 1;
				end if;
			else
				HorizontalCount <= HorizontalCount + 1;
			end if;
			
			
			if HorizontalCount = HD - 1 + HFP then
				Hsync <= '0';
			elsif HorizontalCount = HD - 1 + HFP + HPW then
				Hsync <= '1';
			end if;
			
			if VerticalCount = VD - 1 + VFP then
				Vsync <= '0';
			elsif VerticalCount = VD - 1 + VFP + VPW then
				Vsync <= '1';
			end if;
			
			if HorizontalCount < HD and VerticalCount < VD then
				vgaRed <= pixel(7 downto 5);
				vgaGreen <= pixel(4 downto 2);
				vgaBlue <= pixel(1 downto 0);
				HCnt <= std_logic_vector(to_unsigned(HorizontalCount, 10));
				VCnt <= std_logic_vector(to_unsigned(VerticalCount, 10));
			else
				vgaRed <= "000";
				vgaGreen <= "000";
				vgaBlue <= "00";
			end if;
		end if;
	end process;
	
end Behavioral;

