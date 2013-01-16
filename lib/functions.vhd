library IEEE;
use IEEE.STD_LOGIC_1164.all;

package functions is
end functions;

package body functions is

	--INFO: Addition and Subtraction
	--Addition is the most common arithmetic operation a processor performs. 
	--When two n-bit numbers are added together, it is always possible to produce a result with n + 1
	--nonzero digits due to a carry from the leftmost digit. For two's complement addition of two 
	--numbers, there are three cases to consider:
	--If both numbers are positive and the result of their addition has a sign bit of 1, then 
	--overflow has occurred; otherwise the result is correct.
	--If both numbers are negative and the sign of the result is 0, then overflow has occurred; 
	--otherwise the result is correct.
	--If the numbers are of unlike sign, overflow cannot occur and the result is always correct.
	
	--Overflow types: Its least significant byte contains eight "event" bits called DVWIOUZX from left to right,
	--where D stands for integer divide check, V for integer overflow, W for float-to-fix overflow, I for invalid
	--operation, O for floating overflow, U for floating underflow, Z for floating division by zero, and X for floating
	--inexact.
	
	-------------------------
	-- integer_overflow:
	-- Checks whether operand signs are different from the result, usually indicating an overflow
	-------------------------
	function integer_overflow(signal operand1, operand2, result : std_logic_vector) return std_logic is
	begin
		if operand1(operand1'length - 1) = '0' and operand2(operand2'length - 1) = '0' and 
			result(result'length -1) = '1' then
			return '1';
		elsif operand1(operand1'length - 1) = '1' and operand2(operand2'length - 1) = '1' and 
			result(result'length -1) = '0' then
			return '1';
		else
			return '0';
		end if;
	end integer_overflow;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;
 
end functions;
