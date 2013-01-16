--------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 13:15:14 10/23/2011 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library mmix;
use mmix.pipeline_ports.all;
 
entity Fetch_tb is
end Fetch_tb;
 
architecture behaviour of Fetch_tb is
  
    component Fetch
		port( 	en : std_logic;
				reset : in std_logic;
				clk : in std_logic;
				branch : branch;
				output : out fetch_decode);
	end component;
    

	--Inputs
	signal en : std_logic := '1';
	signal reset : std_logic := '0';
	signal clk : std_logic := '0';
	signal branch : branch;

 	--Outputs
	signal output : fetch_decode;

	-- Clock period definitions
	constant clk_period : time := 10 ns;
 
begin

	uut: Fetch port map (
		en => en,
		reset => reset,
		clk => clk,
		branch => branch,
		output => output
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
		wait for clk_period*10;	

		--Branch test
		branch.en <= '1';
		branch.addr <= X"0000000001000000";
		wait for clk_period;
		branch.en <= '0';

		--Reset test
		wait for clk_period*10;
		reset <= '1';
		wait for clk_period;
		reset <= '0';

		wait;
	end process;

end;
