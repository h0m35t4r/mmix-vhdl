----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 21:37:02 10/15/2011 
--
-- Description: Performs operation specified by op and outputs result
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
--library ieee_proposed;
--use ieee_proposed.float_pkg.all;
--use ieee_proposed.fixed_float_types.all;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity Execute is
    port(	clk : in std_logic;
			input : in decode_execute;
			output : out execute_mem;
			branch : out branch);
end Execute;

architecture Behavioural of Execute is

	--Special registers, declared internally, they can be used by the programmer with GET
	signal reg_special : reg_special := (others => (others => '0'));
			
begin
	compute: process(clk)
	
		--References to each byte of instruction
		alias OP : std_logic_vector(7 downto 0) is input.IR(31 downto 24);
		alias X : std_logic_vector(7 downto 0) is input.IR(23 downto 16);
		alias Y : std_logic_vector(7 downto 0) is input.IR(15 downto 8);
		alias Z : std_logic_vector(7 downto 0) is input.IR(7 downto 0);
		
		--Used to check for signed overflow
		variable temp : std_logic_vector(63 downto 0);
		
		--Used for checking unsigned saturation
		variable temp64 : std_logic_vector(64 downto 0);
		
		--Unsigned arithmetic operations like div and mul do not cause overflow rather they create 16 byte results
		variable temp128 : std_logic_vector(127 downto 0);
		
		variable sadd : integer;
		
		--Holds 64 bit version of Z
		variable Z_64 : std_logic_vector(63 downto 0);
		
		--Floating point temporary
		--variable temp_float : float64;

	begin		
		if rising_edge(clk) then
			--Reset outputs
			branch.en <= '0';
			branch.addr <= (others => '0');
			output.ram_write_enable <= '0';
			output.ram_addr <= (others => '0');
			output.ram_byte_enable <= (others => '0');
			output.result <= (others => '0');
			
			--For testing only, remove when interrupt handlers have been implemented
			--reg_special.rA <= (others => '0');
			
			case OP is
				--Arithmetic
				when MMIX_ADD =>
					temp := std_logic_vector(signed(input.RegY) + signed(input.RegZ));
					if (input.RegY(63) = '0' and input.RegZ(63) = '0' and temp(63) = '1') or
						(input.RegY(63) = '1' and input.RegZ(63) = '1' and temp(63) = '0') then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						reg_special.rA <= (others => '0');
					end if;
					output.result <= temp;
				when MMIX_ADDI =>
					temp := std_logic_vector(signed(input.RegY) + signed(Z));
					if (input.RegY(63) = '0' and Z(7) = '0' and temp(63) = '1') or
						(input.RegY(63) = '1' and Z(7) = '1' and temp(63) = '0') then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						reg_special.rA <= (others => '0');
					end if;
					output.result <= temp;
				when MMIX_ADDU =>
					temp64 := std_logic_vector(unsigned('0' & input.RegY) + unsigned(input.RegZ));
					if temp64(64) = '1' then
						output.result <= X"FFFFFFFFFFFFFFFF";
					else
						output.result <= temp64(63 downto 0);
					end if;
				when MMIX_ADDUI =>
					temp64 := std_logic_vector(unsigned('0' & input.RegY) + unsigned(Z));
					if temp64(64) = '1' then
						output.result <= X"FFFFFFFFFFFFFFFF";
					else
						output.result <= temp64(63 downto 0);
					end if;
				when MMIX_SUB =>
					temp := std_logic_vector(signed(input.RegY) - signed(input.RegZ));
					if input.RegY(63) = '1' and input.RegZ(63) = '0' and temp(63) = '0' then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						reg_special.rA <= (others => '0');
					end if;
					output.result <= temp;
				when MMIX_SUBI =>
					temp := std_logic_vector(signed(input.RegY) - signed(Z));
					if input.RegY(63) = '1' and Z(7) = '0' and temp(63) = '0' then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						reg_special.rA <= (others => '0');
					end if;
					output.result <= temp;
				when MMIX_SUBU =>
					temp64 := std_logic_vector(unsigned('0' & input.RegY) - unsigned(input.RegZ));
					if temp64(64) = '1' then
						output.result <= X"0000000000000000";
					else
						output.result <= temp64(63 downto 0);
					end if;
				when MMIX_SUBUI =>
					temp64 := std_logic_vector(unsigned('0' & input.RegY) - unsigned(Z));
					if temp64(64) = '1' then
						output.result <= X"0000000000000000";
					else
						output.result <= temp64(63 downto 0);
					end if;
--				when MMIX_MUL =>
--					output.result <= std_logic_vector(resize(signed(input.RegY) * signed(input.RegZ), 64));
--				when MMIX_MULI =>
--					output.result <= std_logic_vector(resize(signed(input.RegY) * resize(signed(Z), 64), 64));
--				when MMIX_MULU =>
--					temp128 := std_logic_vector(signed(input.RegY) * signed(input.RegZ));
--					reg_special.rH <= temp128(127 downto 64);
--					output.result <= temp128(63 downto 0);
--				when MMIX_MULUI =>
--					temp128 := std_logic_vector(resize(signed(input.RegY) * resize(signed(Z), 64), 128));
--					reg_special.rH <= temp128(127 downto 64);
--					output.result <= temp128(63 downto 0);
--				when MMIX_DIV =>
--					if input.RegZ = X"0000000000000000" then
--						output.result <= X"0000000000000000";
--						reg_special.rA <= X"00000000000000" & integer_divide_exception;
--						reg_special.rR <= input.RegY;
--					elsif input.RegY = X"8000000000000000" and input.RegZ = X"1111111111111111" then
--						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
--					else
--						--output.result <= std_logic_vector(signed(input.RegY) / signed(input.RegZ));
--						--reg_special.rR <= std_logic_vector(signed(input.RegY) mod signed(input.RegZ));
--					end if;
--				when MMIX_DIVI =>
--					if Z = X"00" then
--						output.result <= X"0000000000000000";
--						reg_special.rA <= X"00000000000000" & integer_divide_exception;
--						reg_special.rR <= input.RegY;
--					elsif input.RegX = X"8000000000000000" and input.RegY = X"1111111111111111" then
--						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
--					else
--						output.result <= std_logic_vector(signed(input.RegY) / signed(Z));
--						reg_special.rR <= std_logic_vector(signed(input.RegY) mod resize(signed(Z), 64));
--					end if;
--				when MMIX_DIVU =>
--					if unsigned(input.RegX) > unsigned(reg_special.rD) then
--						output.result <= reg_special.rD;
--						reg_special.rR <= input.RegX;
--					else
--						--temp128 := std_logic_vector(unsigned(reg_special.rd & input.RegY) / unsigned(input.RegZ));
--						--output.result <= temp128(63 downto 0);
--						--reg_special.rR <= temp128(127 downto 64);
--					end if;
--				when MMIX_DIVUI =>
--					if unsigned(input.RegX) > unsigned(reg_special.rD) then
--						output.result <= reg_special.rD;
--						reg_special.rR <= input.RegX;
--					else
--						--temp128 := std_logic_vector(unsigned(reg_special.rd & input.RegY) / unsigned(Z));
--						--output.result <= temp128(63 downto 0);
--						--reg_special.rR <= temp128(127 downto 64);
--					end if;
				when MMIX_2ADDU =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 2 + unsigned(input.RegZ), 64));
				when MMIX_2ADDUI =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 2 + unsigned(Z), 64));
				when MMIX_4ADDU =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 4 + unsigned(input.RegZ), 64));
				when MMIX_4ADDUI =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 4 + unsigned(Z), 64));
				when MMIX_8ADDU =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 8 + unsigned(input.RegZ), 64));
				when MMIX_8ADDUI =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 8 + unsigned(Z), 64));
				when MMIX_16ADDU =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 16 + unsigned(input.RegZ), 64));
				when MMIX_16ADDUI =>
					output.result <= std_logic_vector(resize(unsigned(input.RegY) * 16 + unsigned(Z), 64));
				when MMIX_NEG =>
					temp := std_logic_vector(signed(Y) - signed(input.RegZ));
					if (Y = X"00" and input.RegZ = X"FFFFFFFFFFFFFFFF") or temp(63) = '1' then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						output.result <= temp;
					end if;
				when MMIX_NEGI =>
					temp := std_logic_vector(signed(Y) - signed(Z));
					if temp(63) = '1' then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						output.result <= temp;
					end if;
				when MMIX_NEGU =>
					temp64 := std_logic_vector(unsigned(Y) - unsigned(input.RegZ));
					if temp64(64) = '1' then
						output.result <= X"0000000000000000";
					else
						output.result <= temp64(63 downto 0);
					end if;
				when MMIX_NEGUI =>
					temp64 := std_logic_vector(unsigned(Y) - unsigned(Z));
					if temp64(64) = '1' then
						output.result <= X"0000000000000000";
					else
						output.result <= temp64(63 downto 0);
					end if;
				--check whether the shift amount is 64 or more to signal overflow unless Y is 0, only signed overflow
				when MMIX_SL =>
					if (unsigned(input.RegZ) and X"FFFFFFFFFFFFFF40") /= X"0000000000000000" then --is Z > 64
						output.result <= std_logic_vector(to_signed(0, 64));
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						output.result <= std_logic_vector(signed(input.RegY) sll 
							to_integer(resize(unsigned(input.RegZ), 6)));
						reg_special.rA <= (others => '0');
					end if;
				when MMIX_SLI =>
					if (unsigned(Z) and X"40") /= X"00" then
						output.result <= std_logic_vector(to_signed(0, 64));
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
					else
						output.result <= std_logic_vector(signed(input.RegY) sll to_integer(resize(unsigned(Z), 6)));
						reg_special.rA <= (others => '0');
					end if;
				when MMIX_SLU =>
					output.result <= std_logic_vector(unsigned(input.RegY) sll 
						to_integer(resize(unsigned(input.RegZ), 6)));
				when MMIX_SLUI =>
					output.result <= std_logic_vector(unsigned(input.RegY) sll to_integer(resize(unsigned(Z), 6)));
				when MMIX_SR =>
					if (unsigned(input.RegZ) and X"FFFFFFFFFFFFFF40") /= X"0000000000000000" then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
						if input.RegY(63) = '1' then
							output.result <= std_logic_vector(to_signed(-1, 64));
						else
							output.result <= std_logic_vector(to_signed(0, 64));
						end if;
					else
						output.result <= std_logic_vector(signed(input.RegY) srl to_integer(resize(unsigned(input.RegZ), 6)));
						reg_special.rA <= (others => '0');
					end if;
				when MMIX_SRI =>
					if (unsigned(Z) and X"40") /= X"00" then
						reg_special.rA <= X"00000000000000" & integer_overflow_exception;
						if input.RegY(63) = '1' then
							output.result <= std_logic_vector(to_signed(-1, 64));
						else
							output.result <= std_logic_vector(to_signed(0, 64));
						end if;
					else
						output.result <= std_logic_vector(signed(input.RegY) srl to_integer(resize(unsigned(Z), 6)));
						reg_special.rA <= (others => '0');
					end if;
				when MMIX_SRU =>
						output.result <= std_logic_vector(unsigned(input.RegY) srl to_integer(resize(unsigned(input.RegZ), 6)));
				when MMIX_SRUI =>
						output.result <= std_logic_vector(unsigned(input.RegY) srl to_integer(resize(unsigned(Z), 6)));
				when MMIX_CMP =>
					if signed(input.RegY) > signed(input.RegZ) then
						output.result <= std_logic_vector(to_signed(1, 64));
					elsif signed(input.RegY) < signed(input.RegZ) then
						output.result <= std_logic_vector(to_signed(-1, 64));
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_CMPI =>
					if signed(input.RegY) > signed(Z) then
						output.result <= std_logic_vector(to_signed(1, 64));
					elsif signed(input.RegX) < signed(Z) then
						output.result <= std_logic_vector(to_signed(-1, 64));
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_CMPU =>
					if unsigned(input.RegY) > unsigned(input.RegZ) then
						output.result <= std_logic_vector(to_signed(1, 64));
					elsif unsigned(input.RegY) < unsigned(input.RegZ) then
						output.result <= std_logic_vector(to_signed(-1, 64));
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_CMPUI =>
					if unsigned(input.RegY) > unsigned(Z) then
						output.result <= std_logic_vector(to_signed(1, 64));
					elsif unsigned(input.RegY) < unsigned(Z) then
						output.result <= std_logic_vector(to_signed(-1, 64));
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				
				--TODO: Remove unecessary features of the ieee standard
				--Floating Point
--				when MMIX_FADD =>
--					if Isnan(to_float(input.RegY, 11, 52)) or Isnan(to_float(input.RegZ, 11, 52)) then
--						reg_special.rA <= X"00000000000000" & invalid_operation_exception;
--					else
--						reg_special.rA <= (others => '0');
--					end if;
--
--					output.result <= to_slv(add(l => to_float(input.RegY, 11, 52), r => to_float(input.RegZ, 11, 52), 
--							round_style => round_type_constant(to_integer(unsigned(reg_special.rA(16 downto 15))))));
--				when MMIX_FSUB =>
--					output.result <= to_slv(subtract(l => to_float(input.RegY, 11, 52), r => to_float(input.RegZ, 11, 52), 
--							round_style => round_type_constant(to_integer(unsigned(reg_special.rA(16 downto 15))))));
--				when MMIX_FMUL =>
--					output.result <= to_slv(multiply(l => to_float(input.RegY, 11, 52), r => to_float(input.RegZ, 11, 52), 
--							round_style => round_type_constant(to_integer(unsigned(reg_special.rA(16 downto 15))))));
--				when MMIX_FDIV =>
--					output.result <= to_slv(divide(l => to_float(input.RegY, 11, 52), r => to_float(input.RegZ, 11, 52), 
--							round_style => round_type_constant(to_integer(unsigned(reg_special.rA(16 downto 15))))));
--				--Remainder is commented out in library - check it out
--				when MMIX_FREM =>
--				--Square root is commented out in library - check it out
--				when MMIX_FSQRT =>
--				when MMIX_FINT =>
--					output.result <= std_logic_vector(to_signed(to_integer(to_float(input.RegZ, 11, 52), round_style => 
--						round_type_constant(to_integer(unsigned(reg_special.rA(16 downto 15))))), 64));
--				when MMIX_FCMP =>
--					if Isnan(to_float(input.RegY, 11, 52)) or Isnan(to_float(input.RegZ, 11, 52)) then
--						reg_special.rA <= X"00000000000000" & invalid_operation_exception;
--						output.result <= std_logic_vector(to_signed(0, 64));
--					elsif to_float(input.RegY, 11, 52) < to_float(input.RegZ, 11, 52) then
--						output.result <= std_logic_vector(to_signed(-1, 64));
--					else
--						output.result <= std_logic_vector(to_signed(0, 64));
--					end if;
--				when MMIX_FEQL =>
--					if Isnan(to_float(input.RegY, 11, 52)) or Isnan(to_float(input.RegZ, 11, 52)) then
--						reg_special.rA <= X"00000000000000" & invalid_operation_exception;
--						output.result <= std_logic_vector(to_signed(0, 64));
--					elsif to_float(input.RegY, 11, 52) = to_float(input.RegZ, 11, 52) then
--						output.result <= std_logic_vector(to_signed(1, 64));
--					else
--						output.result <= std_logic_vector(to_signed(0, 64));
--					end if;
--				when MMIX_FUN =>
--					if Unordered(to_float(input.RegY, 11, 52), to_float(input.RegZ, 11, 52)) then
--						output.result <= std_logic_vector(to_signed(1, 64));
--					else
--						output.result <= std_logic_vector(to_signed(0, 64));
--					end if;
--				when MMIX_FCMPE =>
--				when MMIX_FEQLE =>
--				when MMIX_FUNE =>
--				when MMIX_FIX =>
--				when MMIX_FIXU =>
--					if Isnan(to_float(input.RegZ, 11, 52)) or Finite(to_float(input.RegZ, 11, 52)) then
--						reg_special.rA <= X"00000000000000" & invalid_operation_exception;
--						output.result <= input.RegZ;
--					else
--						reg_special.rA <= (others => '0');
--						output.result <= std_logic_vector(to_signed(to_integer(to_float(input.RegZ, 11, 52)), 64));
--					end if;
--				when MMIX_FLOT =>
--					output.result <= to_slv(to_float(to_integer(signed(input.RegZ)), 11, 52));
--				when MMIX_FLOTI =>
--					output.result <= to_slv(to_float(to_integer(resize(signed(input.RegZ), 64)), 11, 52));
--				when MMIX_FLOTU =>
--					output.result <= to_slv(to_float(to_integer(unsigned(input.RegZ)), 11, 52));
--				when MMIX_FLOTUI =>
--					output.result <= to_slv(to_float(to_integer(resize(unsigned(input.RegZ), 64)), 11, 52));
--				when MMIX_SFLOT =>
--				when MMIX_SFLOTU =>

				
				--Bitwise
				when MMIX_AND =>
					output.result <= input.RegY and input.RegZ;
				when MMIX_ANDI =>
					output.result <= std_logic_vector(unsigned(input.RegY) and resize(unsigned(Z), 64));
				when MMIX_OR =>
					output.result <= input.RegY or input.RegZ;
				when MMIX_ORI =>
					output.result <= std_logic_vector(unsigned(input.RegY) or resize(unsigned(Z), 64));
				when MMIX_XOR =>
					output.result <= input.RegY xor input.RegZ;
				--1 bit xor wtf
				when MMIX_XORI =>
					output.result <= std_logic_vector(unsigned(input.RegY) xor resize(unsigned(Z), 64));
				when MMIX_ANDN =>
					output.result <= input.RegY and (not input.RegZ);
				when MMIX_ANDNI =>
					output.result <= std_logic_vector(unsigned(input.RegY) and (not resize(unsigned(Z), 64)));
				when MMIX_ORN =>
					output.result <= input.RegY or (not input.RegZ);
				when MMIX_ORNI =>
					output.result <= std_logic_vector(unsigned(input.RegY) or (not resize(unsigned(Z), 64)));
				when MMIX_NAND =>
					output.result <= input.RegY nand input.RegZ;
				when MMIX_NANDI =>
					output.result <= std_logic_vector(unsigned(input.RegY) nand resize(unsigned(Z), 64));
				when MMIX_NOR =>
					output.result <= input.RegY nor input.RegZ;
				when MMIX_NORI =>
					output.result <= std_logic_vector(unsigned(input.RegY) nor resize(unsigned(Z), 64));
				when MMIX_NXOR =>
					output.result <= input.RegY xnor input.RegZ;
				when MMIX_NXORI =>
					output.result <= input.RegY xnor input.RegZ;
				when MMIX_MUX =>
					output.result <= (input.RegY and reg_special.rM) or (input.RegZ and (not reg_special.rM));
				when MMIX_MUXI =>
					output.result <= std_logic_vector(unsigned(input.RegY and reg_special.rM) or 
						(resize(unsigned(Z), 64) and unsigned(not reg_special.rM)));
				--Expensive hardware, write this better
--				when MMIX_SADD =>
--					sadd := 0;
--					for i in 63 downto 0 loop
--						if input.RegY(i) = (not input.RegZ(i)) then
--							sadd := sadd + 1;
--						end if;
--					end loop;
--					output.result <= std_logic_vector(to_signed(sadd, 64));
--				when MMIX_SADDI =>
--					sadd := 0;
--					Z_64 := std_logic_vector(resize(unsigned(Z), 64));
--					for i in 63 downto 0 loop
--						if input.RegY(i) = (not Z_64(i)) then
--							sadd := sadd + 1;
--						end if;
--					end loop;
--					output.result <= std_logic_vector(to_signed(sadd, 64));
					
				--Bytewise
				when MMIX_BDIF =>
					output.result <= input.RegX(63 downto 8) & (input.RegY(7 downto 0) and not(input.RegZ(7 downto 0)));
				when MMIX_BDIFI =>
					output.result <= input.RegX(63 downto 8) & (input.RegY(7 downto 0) and not Z);
				when MMIX_WDIF =>
					output.result <= input.RegX(63 downto 16) & (input.RegY(15 downto 0) and not(input.RegZ(15 downto 0)));
				when MMIX_WDIFI =>
					output.result <= input.RegX(63 downto 16) & (input.RegY(15 downto 0) and not X"00" & Z);
				when MMIX_TDIF =>
					output.result <= input.RegX(63 downto 32) & (input.RegY(31 downto 0) and not(input.RegZ(31 downto 0)));
				when MMIX_TDIFI =>
					output.result <= input.RegX(63 downto 32) & (input.RegY(31 downto 0) and not X"000000" & Z);
				when MMIX_ODIF =>
					output.result <= input.RegY and not(input.RegZ);
				when MMIX_ODIFI =>
					output.result <= std_logic_vector(unsigned(input.RegY) and not(resize(unsigned(Z), 64)));
				when MMIX_MOR =>
				when MMIX_MORI =>
				when MMIX_MXOR =>
				when MMIX_MXORI =>
				
				--Conditional
				when MMIX_CSN =>
					if input.RegY(63) = '1' then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSZ =>
					if unsigned(input.RegY) = 0 then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSP =>
					if signed(input.RegY) > 0 then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSOD =>
					if input.RegY(0) = '1' then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSNN =>
					if input.RegY(63) = '0' then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSNZ =>
					if unsigned(input.RegY) /= 0 then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSNP =>
					if signed(input.RegY) <= 0 then
						output.result <= input.RegZ;
					end if;
				when MMIX_CSEV =>
					if input.RegY(0) = '0' then
						output.result <= input.RegZ;
					end if;
				when MMIX_ZSN =>
					if input.RegY(63) = '1' then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSZ =>
					if unsigned(input.RegY) = 0 then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSP =>
					if signed(input.RegY) > 0 then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSOD =>
					if input.RegY(0) = '1' then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSNN =>
					if input.RegY(63) = '0' then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSNZ =>
					if signed(input.RegY) /= 0 then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSNP =>
					if signed(input.RegY) <= 0 then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
				when MMIX_ZSEV =>
					if input.RegY(0) = '0' then
						output.result <= input.RegZ;
					else
						output.result <= std_logic_vector(to_signed(0, 64));
					end if;
								
				--Jumps and branches
				--Backward variants need to be coded
				when MMIX_JMP =>
					branch.en <= '1';
					branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((X & Y & Z))), 64));
				when MMIX_JMPB =>
					branch.en <= '1';
					branch.addr <= std_logic_vector(resize(unsigned(input.NPC) - (unsigned((X & Y & Z))), 64));
				--ember to replace this with the real address offset
				when MMIX_GO =>
					output.result <= std_logic_vector(unsigned(input.NPC) + 1);
					branch.en <= '1';
					branch.addr <= std_logic_vector(unsigned(input.RegY) + unsigned(input.RegZ));
				when MMIX_BN =>
					if input.RegX(63) = '1' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BZ =>
						branch.en <= '1';
					if unsigned(input.RegX) = 0 then
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BP =>
					if signed(input.RegX) > 0 then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BOD =>
					if input.RegX(0) = '1' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BNN =>
					if input.RegX(63) = '0' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BNNB =>
					if input.RegX(63) = '0' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(signed(input.NPC) + (signed((Y & Z))), 64));
					end if;
				when MMIX_BNZ =>
					if signed(input.RegX) /= 0 then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BNP =>
					if input.RegX(63) = '1' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				when MMIX_BEV =>
					if input.RegX(0) = '0' then
						branch.en <= '1';
						branch.addr <= std_logic_vector(resize(unsigned(input.NPC) + (unsigned((Y & Z))), 64));
					end if;
				--Probable branches, need to decide how to deal with this
				when MMIX_PBN =>
				when MMIX_PBZ =>
				when MMIX_PBP =>
				when MMIX_PBOD =>
				when MMIX_PBNN =>
				when MMIX_PBNZ =>
				when MMIX_PBNP =>
				when MMIX_PBEV =>
				
				--Subroutine calls
				when MMIX_PUSHJ =>
				when MMIX_PUSHGO =>
				when MMIX_POP =>
				when MMIX_SAVE =>
				when MMIX_UNSAVE =>
				
				--Caching
				
				--Interrupts
				when MMIX_TRIP =>
				when MMIX_TRAP =>
				when MMIX_RESUME =>
				
				--Loading and Storing					
				when MMIX_LDB | MMIX_LDBU =>
					output.ram_byte_enable <= "0001";
					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(input.RegZ));
				when MMIX_LDBI | MMIX_LDBUI =>
					output.ram_byte_enable <= "0001";
					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(Z));
--				when MMIX_LDW | MMIX_LDWI =>
--					octabyte_addr_lsb := 0 + (octabyte_offset - (octabyte_offset mod 2)) * 8;
--					octabyte_addr_msb := octabyte_addr_lsb + 15;
--					output.wdata <= std_logic_vector(resize(unsigned(
--						data_ram(aligned_rwaddr)(octabyte_addr_msb downto octabyte_addr_lsb)), 64));
--				when MMIX_LDWU | MMIX_LDWUI =>
--				when MMIX_LDT | MMIX_LDTI =>
--					octabyte_addr_lsb := 0 + (octabyte_offset - (octabyte_offset mod 4)) * 8;
--					octabyte_addr_msb := octabyte_addr_lsb + 31;
--					output.wdata <= std_logic_vector(resize(unsigned(
--						data_ram(aligned_rwaddr)(octabyte_addr_msb downto octabyte_addr_lsb)), 64));
--				when MMIX_LDTU | MMIX_LDTUI =>
--				when MMIX_LDOI | MMIX_LDOUI =>
--					output.ram_byte_enable <= "1111";
--					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(input.RegZ));
--				when MMIX_LDO | MMIX_LDOU =>
--					output.ram_byte_enable <= "1111";
--					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(Z));
--				when MMIX_LDHT | MMIX_LDHTI =>
				when MMIX_STB | MMIX_STBU =>
					output.ram_write_enable <= '1';
					output.ram_byte_enable <= "0001";
					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(input.RegZ));
					output.result <= input.RegX;
				when MMIX_STBI | MMIX_STBUI =>
					output.ram_write_enable <= '1';
					output.ram_byte_enable <= "0001";
					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(Z));
					output.result <= input.RegX;
--				when MMIX_STW | MMIX_STWI =>
--					octabyte_addr_lsb := 0 + (octabyte_offset - (octabyte_offset mod 2)) * 8;
--					octabyte_addr_msb := octabyte_addr_lsb + 15;
--					--data_ram(aligned_rwaddr)(octabyte_addr_msb downto octabyte_addr_lsb) <= 
--						--std_logic_vector(resize(unsigned(input.result), 16));
--				when MMIX_STWU | MMIX_STWUI  =>
--				when MMIX_STT | MMIX_STTI =>
--					octabyte_addr_lsb := 0 + (octabyte_offset - (octabyte_offset mod 4)) * 8;
--					octabyte_addr_msb := octabyte_addr_lsb + 31;
--					--data_ram(aligned_rwaddr)(octabyte_addr_msb downto octabyte_addr_lsb) <= 
--						--std_logic_vector(resize(unsigned(input.result), 32));
--				when MMIX_STTU | MMIX_STTUI =>
--				when MMIX_STOI | MMIX_STOUI =>
--					output.ram_write_enable <= '1';
--					output.ram_byte_enable <= "1111";
--					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(Z));
--					output.result <= input.RegX;
--				when MMIX_STO | MMIX_STOU =>
--					output.ram_write_enable <= '1';
--					output.ram_byte_enable <= "1111";
--					output.ram_addr <= std_logic_vector(unsigned(input.RegY) + unsigned(input.RegZ));
--					output.result <= input.RegX;
--				when MMIX_STCO | MMIX_STCOI =>
--				when MMIX_STHT | MMIX_STHTI =>
--				when MMIX_LDSF =>
--				when MMIX_STSF =>
                                when MMIX_LDSFI =>
                                when MMIX_STSFI =>
								
				--Immediate register set
				when MMIX_SETH =>
					output.result <= std_logic_vector(unsigned(Y) & unsigned(Z) & X"000000000000");
				when MMIX_SETMH =>
					output.result <= std_logic_vector(X"0000" & unsigned(Y) & unsigned(Z) & X"00000000");
				when MMIX_SETML =>
					output.result <= std_logic_vector(X"00000000" & unsigned(Y) & unsigned(Z) & X"0000");
				when MMIX_SETL =>
					output.result <= std_logic_vector(X"000000000000" & unsigned(Y) & unsigned(Z));
				when MMIX_INCH =>
					output.result <= std_logic_vector((unsigned(Y) & unsigned(Z) & X"000000000000") or 
						(unsigned(input.RegX) and X"0000FFFFFFFFFFFF"));
				when MMIX_INCMH =>
					output.result <= std_logic_vector((X"0000" & unsigned(Y) & unsigned(Z) & X"00000000") or 
						(unsigned(input.RegX) and X"FFFF0000FFFFFFFF"));
				when MMIX_INCML =>
					output.result <= std_logic_vector((X"00000000" & unsigned(Y) & unsigned(Z) & X"0000") or
						(unsigned(input.RegX) and X"FFFFFFFF0000FFFF"));
				when MMIX_INCL =>
					output.result <= std_logic_vector((X"000000000000" & unsigned(Y) & unsigned(Z)) or
						(unsigned(input.RegX) and X"FFFFFFFFFFFF0000"));
				when MMIX_ORH =>
					output.result <= std_logic_vector((unsigned(Y) & unsigned(Z) & X"000000000000") or 
						unsigned(input.RegX));
				when MMIX_ORMH =>
					output.result <= std_logic_vector((X"0000" & unsigned(Y) & unsigned(Z) & X"00000000") or 
						unsigned(input.RegX));
				when MMIX_ORML =>
					output.result <= std_logic_vector((X"00000000" & unsigned(Y) & unsigned(Z) & X"0000") or
						unsigned(input.RegX));
				when MMIX_ORL =>
					output.result <= std_logic_vector((X"000000000000" & unsigned(Y) & unsigned(Z)) or
						unsigned(input.RegX));
				when MMIX_ANDNH =>
					output.result <= std_logic_vector((unsigned(Y) & unsigned(Z) & X"000000000000") and
						unsigned(input.RegX));
				when MMIX_ANDNMH =>
					output.result <= std_logic_vector((X"0000" & unsigned(Y) & unsigned(Z) & X"00000000") and 
						unsigned(input.RegX));
				when MMIX_ANDNML =>
					output.result <= std_logic_vector((X"00000000" & unsigned(Y) & unsigned(Z) & X"0000") and
						unsigned(input.RegX));
				when MMIX_ANDNL =>
					output.result <= std_logic_vector((X"000000000000" & unsigned(Y) & unsigned(Z)) and
						unsigned(input.RegX));
						
				--Special Registers
				when MMIX_GET =>
					if unsigned(Z) < 32 then
						case to_integer(unsigned(Z)) is
--							when 0 => output.result <= reg_special.rB;
--							when 1 => output.result <= reg_special.rD;
--							when 2 => output.result <= reg_special.rE;
							when 3 => output.result <= reg_special.rH;
--							when 4 => output.result <= reg_special.rJ;
--							when 5 => output.result <= reg_special.rM;
							when 6 => output.result <= reg_special.rR;
--							when 7 => output.result <= reg_special.rBB;
--							when 8 => output.result <= reg_special.rC;
--							when 9 => output.result <= reg_special.rN;
--							when 10 => output.result <= reg_special.rO;
--							when 11 => output.result <= reg_special.rS;
--							when 12 => output.result <= reg_special.rI;
--							when 13 => output.result <= reg_special.rT;
--							when 14 => output.result <= reg_special.rTT;
--							when 15 => output.result <= reg_special.rK;
--							when 16 => output.result <= reg_special.rQ;
--							when 17 => output.result <= reg_special.rU;
--							when 18 => output.result <= reg_special.rV;
--							when 19 => output.result <= reg_special.rG;
--							when 20 => output.result <= reg_special.rL;
							when 21 => output.result <= reg_special.rA;
--							when 22 => output.result <= reg_special.rF;
--							when 23 => output.result <= reg_special.rP;
--							when 24 => output.result <= reg_special.rW;
--							when 25 => output.result <= reg_special.rX;
--							when 26 => output.result <= reg_special.rY;
--							when 27 => output.result <= reg_special.rZ;
--							when 28 => output.result <= reg_special.rWW;
--							when 29 => output.result <= reg_special.rXX;
--							when 30 => output.result <= reg_special.rYY;
--							when 31 => output.result <= reg_special.rZZ;
							when others => null;
						end case;
					end if;
				when MMIX_PUT =>
					case to_integer(unsigned(X)) is
--						when 0 => reg_special.rB <= input.RegZ;
--						when 1 => reg_special.rD <= input.RegZ;
--						when 2 => reg_special.rE <= input.RegZ;
						when 3 => reg_special.rH <= input.RegZ;
--						when 4 => reg_special.rJ <= input.RegZ;
						when 5 => reg_special.rM <= input.RegZ;
						when 6 => reg_special.rR <= input.RegZ;
--						when 7 => reg_special.rBB <= input.RegZ;
--						when 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 =>
--							--exception goes here
--						when 19 =>
--							if (unsigned(input.RegZ) < 255) and (unsigned(input.RegZ) > 31) and (input.RegZ > reg_special.rL) then
--								reg_special.rG <= input.RegZ;
--							end if;
--						when 20 =>
--							if unsigned(input.RegZ) < unsigned(reg_special.rL) then
--								reg_special.rL <= input.RegZ;
--							end if;
--						when 21 =>
--							if unsigned(input.RegZ) < X"3FFFF" then
--								reg_special.rA <= input.RegZ;
--							end if;
						when others => null;
					end case;
				when MMIX_GETA =>
				when MMIX_SWYM =>
				when others => null;
			end case;
			
			output.reg_addr <= X;
			output.reg_write_enable <= input.writen;
			
		end if;
	end process;
	
end Behavioural;