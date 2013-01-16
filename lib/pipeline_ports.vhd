--Declares input and output ports between each pipelined unit including special registers

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library ieee_proposed;
use ieee_proposed.fixed_float_types.all;

package pipeline_ports is

	type fetch_decode is record
		NPC : std_logic_vector(63 downto 0);		--Next Program Counter
		IR : std_logic_vector(31 downto 0);			--Instruction Register
	end record;
	
	type decode_execute is record
		RegX : std_logic_vector(63 downto 0);		--Contents of register X
        RegY : std_logic_vector(63 downto 0);		--Contents of register Y
        RegZ : std_logic_vector(63 downto 0);		--Contents of register Z
		NPC : std_logic_vector(63 downto 0);
		IR : std_logic_vector(31 downto 0);
		writen : std_logic;							--Register write enable
	end record;
	
	type execute_mem is record
		result : std_logic_vector(63 downto 0);
		reg_write_enable : std_logic;
		reg_addr : std_logic_vector(7 downto 0);
		ram_write_enable : std_logic;
		ram_byte_enable : std_logic_vector(3 downto 0);	--Amount of bytes to read/write
		ram_addr : std_logic_vector(63 downto 0);		--Memory read/write address
	end record;
	
	type mem_wb is record
		writen : std_logic;							--Register write enable
		waddr : std_logic_vector(7 downto 0);		--Register write address
		wdata : std_logic_vector(63 downto 0);		--Register write data
	end record;
	
	--Connects to the output of the execute unit providing branching to the fetch unit
	type branch is record
		en : std_logic;								--Branch enable
		addr : std_logic_vector(63 downto 0);		--Branch address
	end record;
	
	--Special registers
	type reg_special is record
		rA : std_logic_vector(63 downto 0);			--Arithmetic Exception Register
		--rB : std_logic_vector(63 downto 0);			--Bootstrap Register (trip)
		--rC : std_logic_vector(63 downto 0);			--Continuation Register
		--rD : std_logic_vector(63 downto 0);			--Dividend Register
		--rE : std_logic_vector(63 downto 0);			--Epsilon Register
		--rF : std_logic_vector(63 downto 0);			--Failure Location Register
		--rG : std_logic_vector(63 downto 0);			--Global Threshold Register
		rH : std_logic_vector(63 downto 0);			--Himult Register
		--rI : std_logic_vector(63 downto 0);			--Interval Counter
		--rJ : std_logic_vector(63 downto 0);			--Return-Jump Register
		--rK : std_logic_vector(63 downto 0);			--Interrupt Mask Register
		--rL : std_logic_vector(63 downto 0);			--Local Threshold Register
		rM : std_logic_vector(63 downto 0);			--Multiplex Mask Register
		--rN : std_logic_vector(63 downto 0);			--Serial Number
		--rO : std_logic_vector(63 downto 0);			--Register Stack Offset
		--rP : std_logic_vector(63 downto 0);			--Prediction Register
		--rQ : std_logic_vector(63 downto 0);			--Interrupt Request Register
		rR : std_logic_vector(63 downto 0);			--Remainder Register
		--rS : std_logic_vector(63 downto 0);			--Register Stack Pointer
		--rT : std_logic_vector(63 downto 0);			--Trap Address Register
		--rU : std_logic_vector(63 downto 0);			--Usage Counter
		--rV : std_logic_vector(63 downto 0);			--Virtual Translation Register
		--rW : std_logic_vector(63 downto 0);			--Where-Interrupted Register (trip)
		--rX : std_logic_vector(63 downto 0);			--Execution Register (trip)
		--rY : std_logic_vector(63 downto 0);			--Y Operand (trip)
		--rZ : std_logic_vector(63 downto 0);			--Z Operand (trip)
		--rBB : std_logic_vector(63 downto 0);		--Bootstrap Register (trap)
		--rTT : std_logic_vector(63 downto 0);		--Dynamic Trap Address Register
		--rWW : std_logic_vector(63 downto 0);		--Where-Interrupted Register (trap)
		--rXX : std_logic_vector(63 downto 0);		--Execution Register (trap)
		--rYY : std_logic_vector(63 downto 0);		--Y Operand (trap)
		--rZZ : std_logic_vector(63 downto 0);		--Z Operand (trap)
	end record;
	
	--Arithmetic Exception register bits
	constant integer_divide_exception : std_logic_vector(7 downto 0) 		:= X"80";
	constant integer_overflow_exception : std_logic_vector(7 downto 0)		:= X"40";
	constant float2fix_exception : std_logic_vector(7 downto 0)				:= X"20";
	constant invalid_operation_exception : std_logic_vector(7 downto 0)		:= X"10";
	constant floating_overflow_exception : std_logic_vector(7 downto 0)		:= X"08";
	constant floating_underflow_exception : std_logic_vector(7 downto 0)	:= X"04";
	constant floating_divide_zero_exception : std_logic_vector(7 downto 0)	:= X"02";
	constant floating_inexact_exception : std_logic_vector(7 downto 0)		:= X"01";
	
	--Work around for trying to reference a non-constant enumeration
	type round_type_vector is array (3 downto 0) of round_type;
	constant round_type_constant : round_type_vector := (round_nearest,    -- Default, nearest LSB '0'
                      round_inf,        -- Round toward positive infinity
                      round_neginf,     -- Round toward negative infinity
                      round_zero);
	type states is (operating, branching, data_hazard, core_meltdown);
end pipeline_ports;

package body pipeline_ports is 
end pipeline_ports;