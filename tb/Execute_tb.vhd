--------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date:   19:28:15 10/29/2011
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity Execute_tb IS
end Execute_tb;

architecture Behaviour OF Execute_tb is 

	component Execute
		port(	clk : in std_logic;
				input : in decode_execute;
				output : out execute_mem;
				branch : out branch
			);
	end component;

	--inputs
	signal clk : std_logic := '0';
	signal input : decode_execute;

	--outputs
	signal output : execute_mem;
	signal branch : branch;

	-- Clock period definitions
	constant clk_period : time := 10 ns;

begin

	uut: Execute port map (
		clk => clk,
		input => input,
		output => output,
		branch => branch
		);

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	stim_proc : process
	begin
		-- hold reset state for 100 ns.
		wait for 100 ns;	

		wait for clk_period*10;
		
		--MMIX_ADD - Overflow test
		input.IR <= MMIX_ADD & X"00" & X"00" & X"00";
		input.RegY <= X"8000000000000000";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_ADD - Overflow test fail" severity error;
		
		--MMIX_ADDI - Overflow test
		input.IR <= MMIX_ADDI & X"00" & X"00" & X"FF";
		input.RegY <= X"8000000000000000";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_ADDI - Overflow test fail" severity error;
		
		--MMIX_ADDU - Saturation test
		input.IR <= MMIX_ADDU & X"00" & X"00" & X"00";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_ADDU - Saturation test fail" severity error;
		
		--MMIX_ADDUI - Saturation test
		input.IR <= MMIX_ADDUI & X"00" & X"00" & X"01";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_ADDUI - Saturation test fail" severity error;
		
		--MMIX_SUB - Overflow test
		input.IR <= MMIX_SUB & X"00" & X"00" & X"00";
		input.RegY <= X"8000000000000000";
		input.RegZ <= X"0000000000000001";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SUB - Overflow test fail" severity error;
		
		--MMIX_SUBI - Overflow test
		input.IR <= MMIX_SUBI & X"00" & X"00" & X"01";
		input.RegY <= X"8000000000000000";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SUBI - Overflow test fail" severity error;
		
		--MMIX_SUBU - Saturation test
		input.IR <= MMIX_SUBU & X"00" & X"00" & X"00";
		input.RegY <= X"0000000000000000";
		input.RegZ <= X"0000000000000001";
		wait for clk_period;
		assert (output.result = X"0000000000000000") 
		report "MMIX_SUBU - Saturation test fail" severity error;
		
		--MMIX_SUBUI - Saturation test
		input.IR <= MMIX_SUBUI & X"00" & X"00" & X"01";
		input.RegY <= X"0000000000000000";
		wait for clk_period;
		assert (output.result = X"0000000000000000") 
		report "MMIX_SUBUI - Saturation test fail" severity error;
		
--		--MMIX_DIVI - Remainder test
--		input.IR <= MMIX_DIVI & X"01" & X"01" & X"0A";
--		input.RegY <= X"0000000000000049";
--		wait for clk_period;
--		input.IR <= MMIX_GET & X"000006";
--		wait for clk_period;
--		assert (output.result = X"0000000000000003")
--		report "MMIX_DIVI - Remainder test fail" severity error;
--		
--		--MMIX_MUL - Overflow test
--		input.IR <= MMIX_MUL & X"00" & X"00" & X"00";
--		input.RegY <= X"8000000000000000";
--		input.RegZ <= X"0000000000000002";
--		wait for clk_period;
--		input.IR <= MMIX_GET & X"000015";
--		wait for clk_period;
--		assert (output.result = X"00000000000000" & integer_overflow_exception) 
--		report "MMIX_MUL - Overflow test fail" severity error;
--		
--		--MMIX_FADD - NaN test
--		input.IR <= MMIX_FADD & X"00" & X"00" & X"00";
--		input.RegY <= X"FFF0000000000001";
--		input.RegZ <= X"0000000000000001";
--		wait for clk_period;
--		input.IR <= MMIX_GET & X"000015";
--		wait for clk_period;
--		assert (output.result = X"00000000000000" & invalid_operation_exception) 
--		report "MMIX_FADD - NaN test fail" severity error;

		--MMIX_2ADDU - Saturation test
		input.IR <= MMIX_2ADDU & X"00" & X"00" & X"00";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF")
		report "MMIX_2ADDU - Saturation test fail" severity error;
		
		--MMIX_2ADDUI - Saturation test
		input.IR <= MMIX_2ADDUI & X"00" & X"00" & X"01";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_2ADDUI - Saturation test fail" severity error;
		
		--MMIX_4ADDU - Saturation test
		input.IR <= MMIX_4ADDU & X"00" & X"00" & X"00";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF")
		report "MMIX_4ADDU - Saturation test fail" severity error;
		
		--MMIX_4ADDUI - Saturation test
		input.IR <= MMIX_4ADDUI & X"00" & X"00" & X"01";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_4ADDUI - Saturation test fail" severity error;
		
		--MMIX_8ADDU - Saturation test
		input.IR <= MMIX_8ADDU & X"00" & X"00" & X"00";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF")
		report "MMIX_8ADDU - Saturation test fail" severity error;
		
		--MMIX_8ADDUI - Saturation test
		input.IR <= MMIX_8ADDUI & X"00" & X"00" & X"01";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_8ADDUI - Saturation test fail" severity error;
		
		--MMIX_16ADDU - Saturation test
		input.IR <= MMIX_16ADDU & X"00" & X"00" & X"00";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF")
		report "MMIX_16ADDU - Saturation test fail" severity error;
		
		--MMIX_16ADDUI - Saturation test
		input.IR <= MMIX_16ADDUI & X"00" & X"00" & X"01";
		input.RegY <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		assert (output.result = X"FFFFFFFFFFFFFFFF") 
		report "MMIX_16ADDUI - Saturation test fail" severity error;
		
		--MMIX_NEG - Overflow test
		input.IR <= MMIX_NEG & X"00" & X"FF" & X"00";
		input.RegZ <= X"FFFFFFFFFFFFFFFF";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_NEG - Overflow test fail" severity error;
		
		--MMIX_NEGI - Overflow test
		input.IR <= MMIX_NEGI & X"00" & X"00" & X"01";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_NEGI - Overflow test fail" severity error;
		
		--MMIX_NEGU - Saturation test
		input.IR <= MMIX_NEGU & X"00" & X"00" & X"00";
		input.RegZ <= X"0000000000000001";
		wait for clk_period;
		assert (output.result = X"0000000000000000")
		report "MMIX_NEGU - Saturation test fail" severity error;
		
		--MMIX_SL - Overflow test
		input.IR <= MMIX_SL & X"00" & X"00" & X"00";
		input.RegY <= X"0000000000000001";
		input.RegZ <= X"0000000000000040";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SL - Overflow test fail" severity error;
		
		--MMIX_SLI - Overflow test
		input.IR <= MMIX_SLI & X"00" & X"00" & X"40";
		input.RegY <= X"0000000000000001";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SLI - Overflow test fail" severity error;
		
		--MMIX_SR - Overflow test
		input.IR <= MMIX_SR & X"00" & X"00" & X"00";
		input.RegY <= X"0000000000000001";
		input.RegZ <= X"0000000000000040";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SR - Overflow test fail" severity error;
		
		--MMIX_SRI - Overflow test
		input.IR <= MMIX_SRI & X"00" & X"00" & X"40";
		input.RegY <= X"0000000000000001";
		wait for clk_period;
		input.IR <= MMIX_GET & X"000015";
		wait for clk_period;
		assert (output.result = X"00000000000000" & integer_overflow_exception) 
		report "MMIX_SRI - Overflow test fail" severity error;
		
		wait;
	end process;

end;