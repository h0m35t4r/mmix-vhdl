--------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 21:54:18 11/18/2011
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library mmix;
use mmix.pipeline_ports.all;
 
entity core_tb is
end core_tb;
 
architecture behavior of core_tb is

    component core
		port(	clk : in std_logic;
			 	vga_addr : in std_logic_vector(12 downto 0);
				vga_read_data : out std_logic_vector(7 downto 0);
				reset : in std_logic);
    end component;
    

	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	
	--Outputs
	signal vga_addr : std_logic_vector(12 downto 0);
	signal vga_read_data : std_logic_vector(7 downto 0);
	
	-- Clock period definitions
	constant clk_period : time := 10 ns;
 
begin
 
   uut: core port map (
			clk => clk,
			vga_addr => vga_addr,
			vga_read_data => vga_read_data,
			reset => reset);

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
end;