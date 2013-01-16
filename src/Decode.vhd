----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 14:10:01 10/15/2011
-- 
-- Description: Gets contents of registers $X, $Y, $Z
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity Decode is
	port(	en : in std_logic;
			input : in fetch_decode;
			output : out decode_execute;
			mem_wb : in mem_wb;
			clk : in std_logic);
end Decode;

architecture Behavioural of Decode is
	
	alias OP : std_logic_vector(7 downto 0) is input.IR(31 downto 24);
	alias X : std_logic_vector(7 downto 0) is input.IR(23 downto 16);
	alias Y : std_logic_vector(7 downto 0) is input.IR(15 downto 8);
	alias Z : std_logic_vector(7 downto 0) is input.IR(7 downto 0);

	COMPONENT general_register
		PORT (
			clka : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			clkb : IN STD_LOGIC;
			web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			dinb : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
		);
	END COMPONENT;
	
	signal regX, regY, regZ, new_regX, new_regY, new_regZ : std_logic_vector(63 downto 0);
	
begin

	register_X : general_register
		PORT MAP (
			clka => clk,
			wea(0) => mem_wb.writen,
			addra => mem_wb.waddr,
			dina => mem_wb.wdata,
			douta => new_regX,
			clkb => clk,
			web(0) => '0',
			addrb => X,
			dinb => (others => '0'),
			doutb => regX
		);
	register_Y : general_register
		PORT MAP (
			clka => clk,
			wea(0) => mem_wb.writen,
			addra => mem_wb.waddr,
			dina => mem_wb.wdata,
			douta => new_regY,
			clkb => clk,
			web(0) => '0',
			addrb => Y,
			dinb => (others => '0'),
			doutb => regY
		);
		
	register_Z : general_register
		PORT MAP (
			clka => clk,
			wea(0) => mem_wb.writen,
			addra => mem_wb.waddr,
			dina => mem_wb.wdata,
			douta => new_regZ,
			clkb => clk,
			web(0) => '0',
			addrb => Z,
			dinb => (others => '0'),
			doutb => regZ
		);

	decode : process(clk)
	begin
		if rising_edge(clk) then
			if en = '1' then
				case OP is
					when MMIX_ADD | MMIX_ADDI | MMIX_ADDU | MMIX_ADDUI | MMIX_SUB | MMIX_SUBI | MMIX_SUBU | MMIX_SUBUI |
						MMIX_MUL | MMIX_MULI | MMIX_MULU | MMIX_MULUI | MMIX_DIV | MMIX_DIVI | MMIX_DIVU | MMIX_DIVUI |
						MMIX_2ADDU | MMIX_2ADDUI | MMIX_4ADDU | MMIX_4ADDUI | MMIX_8ADDU | MMIX_8ADDUI | MMIX_16ADDU |
						MMIX_16ADDUI | MMIX_NEG | MMIX_NEGU | MMIX_SL | MMIX_SLI | MMIX_SLU | MMIX_SLUI |  MMIX_SR |
						MMIX_SRI | MMIX_SRU | MMIX_SRUI | MMIX_CMP | MMIX_CMPI | MMIX_CMPU | MMIX_CMPUI | MMIX_AND |
						MMIX_ANDI | MMIX_OR | MMIX_ORI | MMIX_XOR | MMIX_XORI | MMIX_ANDN | MMIX_ANDNI |
						MMIX_ORN | MMIX_ORNI | MMIX_NAND | MMIX_NANDI | MMIX_NOR | MMIX_NORI | MMIX_NXOR | MMIX_NXORI |
						MMIX_MUX | MMIX_MUXI | MMIX_SADD | MMIX_SADDI | MMIX_BDIF | MMIX_BDIFI | MMIX_WDIF | MMIX_WDIFI |
						MMIX_TDIF | MMIX_TDIFI | MMIX_MOR | MMIX_MORI | MMIX_MXOR | MMIX_MXORI | MMIX_GO | MMIX_SETH | 
						MMIX_SETMH | MMIX_SETML | MMIX_SETL | MMIX_INCH | MMIX_INCMH | MMIX_INCML |
						MMIX_INCL | MMIX_ORH | MMIX_ORMH | MMIX_ORML | MMIX_ORL | MMIX_ANDNH | MMIX_ANDNMH | MMIX_ANDNML |
						MMIX_ANDNL | MMIX_LDB | MMIX_LDBI | MMIX_LDBU | MMIX_LDBUI | MMIX_LDW | MMIX_LDWI | MMIX_LDWU | 
						MMIX_LDWUI | MMIX_LDT | MMIX_LDTI | MMIX_LDTU | MMIX_LDTUI | MMIX_LDO | MMIX_LDOI | MMIX_LDOU | 
						MMIX_LDOUI | MMIX_LDHT | MMIX_LDHTI | MMIX_GET =>
							output.writen <= '1';
					when others => output.writen <= '0';
				end case;
				
				output.IR <= input.IR;
				output.NPC <= input.NPC;
			else
				output.IR <= (others => '0');
				output.NPC <= (others => '0');
				output.writen <= '0';
			end if;
		end if;
	end process;
	
	output.RegX <= new_RegX when X = mem_wb.waddr and mem_wb.writen = '1' else regX;
	output.RegY <= new_RegY when Y = mem_wb.waddr and mem_wb.writen = '1' else regY;
	output.RegZ <= new_RegZ when Z = mem_wb.waddr and mem_wb.writen = '1' else regZ;
	
end Behavioural;