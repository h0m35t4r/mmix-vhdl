--------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 15:10:17 10/23/2011 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library mmix;
use mmix.pipeline_ports.all;
 
entity Decode_tb is
end Decode_tb;
 
architecture behavior of Decode_tb is 
 
    component Decode
		port(	en : in std_logic;
				input : in fetch_decode;
				output : out decode_execute;
				mem_wb : in mem_wb;
				clk : in std_logic);
    end component;
    
	--Inputs
	signal input : fetch_decode;
	signal mem_wb : mem_wb;
	signal clk : std_logic := '0';
	signal en : std_logic := '1';

 	--Outputs
	signal output : decode_execute;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
   uut: Decode port map (
		en => en,
		input => input,
		mem_wb => mem_wb,
		clk => clk,
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
		variable X : std_logic_vector(7 downto 0);
   begin		
		mem_wb.writen <= '1';
		--Write values to all registers and check whether the output matches
		for i in 255 downto 0 loop
			wait for clk_period/2;
			X := std_logic_vector(to_unsigned(i, 8));
			mem_wb.waddr <= X;
			mem_wb.wdata <= std_logic_vector(to_unsigned(i, 64));
			input.IR <= X"00" & X & X & X;
			
			if output.RegX /= std_logic_vector(to_unsigned(i, 64)) or 
				output.RegY /= std_logic_vector(to_unsigned(i, 64)) or
				output.RegZ /= std_logic_vector(to_unsigned(i, 64)) then
				assert false report "Register X: Output does not match register";
			end if;
			wait for clk_period/2;
		end loop;
		
      wait;
   end process;

end;