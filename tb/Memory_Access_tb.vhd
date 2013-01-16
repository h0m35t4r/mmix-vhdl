--------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 16:30:41 11/13/2011
--
-- Description:   
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;
 
entity Memory_Access_tb is
end Memory_Access_tb;
 
architecture behavior of Memory_Access_tb is 
  
    component Memory_Access
		port(	input : in execute_mem;
				output : out  mem_wb;
				vga_addr : in std_logic_vector(12 downto 0);
				vga_read_data : out std_logic_vector(7 downto 0);
				clk : in std_logic
		);
    end component;
    

	--Inputs
	signal input : execute_mem;
	signal clk : std_logic;
	signal en : std_logic := '1';
	signal vga_addr : std_logic_vector(12 downto 0);
				

	--Outputs
	signal output : mem_wb;
	signal vga_read_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
	uut: Memory_Access port map (
		input => input,
		output => output,
		vga_addr => vga_addr,
		vga_read_data => vga_read_data,
		clk => clk
	);

	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;	

		wait for clk_period*10;

		input.ram_write_enable <= '1';
		input.ram_addr <= X"0000000000000000";
		input.result <= X"F000000000100111";

		wait;
	end process;
	
end;
