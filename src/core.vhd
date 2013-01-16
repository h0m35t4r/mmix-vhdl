----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 20:48:14 10/16/2011 
--
-- Description: Core Processor for MMIX
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity core is
	port(	clk : in std_logic;
			vga_addr : in std_logic_vector(12 downto 0);
			vga_read_data : out std_logic_vector(7 downto 0);
			reset : in std_logic);
end core;

architecture rtl of core is

	component Fetch
		port( 	en : in std_logic;
				reset : in std_logic;
				branch : branch;
				output : out fetch_decode;
				clk : in std_logic);
	end component;
	
	component Decode
		port(	en : in std_logic;
				input : in fetch_decode;
				output : out decode_execute;
				mem_wb : in mem_wb;
				clk : in std_logic);
	end component;
	
	component Execute
		port(	input : in decode_execute;
				output : out execute_mem;
				branch : out branch;
				clk : in std_logic);
	end component;
	
	component Memory_Access
		port(	input : in execute_mem;
				output : out mem_wb;
				vga_addr : in std_logic_vector(12 downto 0);
				vga_read_data : out std_logic_vector(7 downto 0);
				clk : in std_logic);
	end component;

	--Fetch -> Decode signals
	signal IF_ID_INPUT : fetch_decode;
	signal IF_ID_OUTPUT : fetch_decode;
	
	--Decode -> Execute signals
	signal ID_EX_INPUT : decode_execute;
	signal ID_EX_OUTPUT : decode_execute;
	
	--Execute -> Memory Access signals
	signal EX_MEM : execute_mem;
	
	--Memory Access -> Write Back signals
	signal MEM_WB : mem_wb;
		
	--Branch signals
	signal branch : branch;
	
	--Enable signals are synchronous and used to turn off pipeline units during normal operation
	signal Fetch_en : std_logic 	:= '1';
	signal Decode_en : std_logic 	:= '1';
	
begin

	MMIX_IF: Fetch port map(
		en => Fetch_en,
		reset => reset,
		clk => clk,
		branch => branch,
		output => IF_ID_INPUT);
		
	MMIX_ID: Decode port map(
		en => Decode_en,
		input => IF_ID_OUTPUT,
		clk => clk,
		output => ID_EX_INPUT,
		mem_wb => MEM_WB);
		
	MMIX_EX: Execute port map(
		input => ID_EX_OUTPUT,
		clk => clk,
		output => EX_MEM,
		branch => branch);
		
	MMIX_MEM: Memory_Access port map(
		input => EX_MEM,
		vga_addr => vga_addr,
		vga_read_data => vga_read_data,
		clk => clk,
		output => MEM_WB);
	
	--Reset IF and ID when branch is enabled
	branch_reset : process(IF_ID_INPUT, ID_EX_INPUT, branch.en)
	begin
		if branch.en = '1' then
			IF_ID_OUTPUT.IR <= (others => '0');
			IF_ID_OUTPUT.NPC <= (others => '0');
			ID_EX_OUTPUT.RegX <= (others => '0');
			ID_EX_OUTPUT.RegY <= (others => '0');
			ID_EX_OUTPUT.RegZ <= (others => '0');
			ID_EX_OUTPUT.IR <= (others => '0');
			ID_EX_OUTPUT.NPC <= (others => '0');
			ID_EX_OUTPUT.writen <= '0';
		else
			IF_ID_OUTPUT <= IF_ID_INPUT;
			ID_EX_OUTPUT <= ID_EX_INPUT;
		end if;
	end process;
	
	--Data dependencies cause the pipeline to stall until the required data has been written
	hazard_check : process(IF_ID_INPUT.IR, ID_EX_INPUT.IR, ID_EX_INPUT.writen, MEM_WB.writen, MEM_WB.waddr)
		variable hazard_addr: std_logic_vector(7 downto 0);
	begin
		--Once the pipeline has written the required data then we can resume fetching instructions
		if (MEM_WB.writen = '1' and MEM_WB.waddr = hazard_addr) then
			Fetch_en <= '1';
			Decode_en <= '1';
		elsif ID_EX_INPUT.writen = '1' then
			case IF_ID_INPUT.IR(31 downto 24) is
				--Instructions that require RegX
				when MMIX_BN | MMIX_BZ | MMIX_BP | MMIX_BOD | MMIX_BNN | MMIX_BNNB | MMIX_BNZ |
					MMIX_BNP | MMIX_BEV | MMIX_PBN | MMIX_PBZ | MMIX_PBP | MMIX_PBOD | MMIX_PBNN | 
					MMIX_PBNZ | MMIX_PBNP | MMIX_PBEV | MMIX_INCH | MMIX_INCMH | MMIX_INCML | MMIX_INCL |
					MMIX_ORH | MMIX_ORMH | MMIX_ORML | MMIX_ORL | MMIX_ANDNH | MMIX_ANDNMH | MMIX_ANDNML |
					MMIX_ANDNL =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(23 downto 16) then
						Fetch_en <= '0';
						Decode_en <= '0';
						hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				--Instructions that require RegY
				when MMIX_ADDI | MMIX_ADDUI | MMIX_SUBI | MMIX_SUBUI | MMIX_MULI | MMIX_MULUI | 
					MMIX_DIVI | MMIX_DIVUI | MMIX_2ADDUI | MMIX_4ADDUI | MMIX_8ADDUI | MMIX_16ADDUI | 
					MMIX_SLI | MMIX_SLUI | MMIX_SRI | MMIX_SRUI | MMIX_CMPI | MMIX_CMPUI | MMIX_FLOTI |
					MMIX_FLOTUI | MMIX_ANDI | MMIX_ORI | MMIX_XORI | MMIX_ANDNI | MMIX_ORNI | MMIX_NANDI | 
					MMIX_NORI | MMIX_NXORI | MMIX_SADDI | MMIX_BDIFI | MMIX_WDIFI | 
					MMIX_TDIFI | MMIX_ODIFI | MMIX_MORI | MMIX_MXORI | MMIX_LDBI | MMIX_LDBUI | 
					MMIX_LDWI | MMIX_LDWUI | MMIX_LDTI | MMIX_LDTUI | MMIX_LDOI | MMIX_LDOUI =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(15 downto 8) then
						Fetch_en <= '0';
						Decode_en <= '0';
						hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				--Instructions that require RegZ
				when MMIX_NEG | MMIX_NEGU | MMIX_PUT =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(7 downto 0) then
						Fetch_en <= '0';
						Decode_en <= '0';
						hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				--Instructions that require RegX or RegY
				when MMIX_STBI | MMIX_STBUI | MMIX_STWI | MMIX_STWUI | MMIX_STTI | MMIX_STTUI | 
					MMIX_STOI | MMIX_STOUI | MMIX_STCOI | MMIX_STHTI =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(23 downto 16) or
						ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(15 downto 8) then
						Fetch_en <= '0';
						Decode_en <= '0';
						hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				--Instructions that require RegY or RegZ
				when MMIX_ADD | MMIX_ADDU | MMIX_SUB | MMIX_MUL | MMIX_MULU | MMIX_DIV | MMIX_DIVU |
					MMIX_2ADDU | MMIX_4ADDU | MMIX_8ADDU | MMIX_16ADDU | MMIX_SL | MMIX_SLU | MMIX_SR |
					MMIX_SRU | MMIX_CMP | MMIX_CMPU | MMIX_FADD | MMIX_FSUB | MMIX_FMUL | MMIX_FDIV |
					MMIX_FREM | MMIX_FSQRT | MMIX_FINT | MMIX_FCMP | MMIX_FEQL | MMIX_FUN | MMIX_FCMPE |
					MMIX_FEQLE | MMIX_FUNE | MMIX_FIX | MMIX_FIXU | MMIX_FLOT | MMIX_FLOTU | MMIX_SFLOT |
					MMIX_SFLOTU | MMIX_AND | MMIX_OR | MMIX_XOR | MMIX_ANDN | MMIX_ORN | MMIX_NAND | 
					MMIX_NOR | MMIX_NXOR | MMIX_MUX | MMIX_SADD | MMIX_BDIF | MMIX_WDIF | MMIX_TDIF |
					MMIX_ODIF | MMIX_MOR | MMIX_MXOR | MMIX_CSN | MMIX_CSZ | MMIX_CSP | MMIX_CSOD |
					MMIX_CSNN | MMIX_CSNZ | MMIX_CSNP | MMIX_CSEV | MMIX_ZSN | MMIX_ZSZ | MMIX_ZSP |
					MMIX_ZSOD | MMIX_ZSNN | MMIX_ZSNZ | MMIX_ZSNP | MMIX_ZSEV | MMIX_GO | MMIX_LDB |
					MMIX_LDBU | MMIX_LDW | MMIX_LDWU | MMIX_LDT | MMIX_LDTU | MMIX_LDO | MMIX_LDOU =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(15 downto 8) or
						ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(7 downto 0) then
						Fetch_en <= '0';
						Decode_en <= '0';
						hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				--Instructions that require RegX, RegY or RegZ
				when MMIX_STB | MMIX_STBU | MMIX_STW | MMIX_STWU | MMIX_STT | MMIX_STTU | MMIX_STO |
					MMIX_STOU | MMIX_STCO | MMIX_STHT =>
					if ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(23 downto 16) or
						ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(15 downto 8) or
						ID_EX_INPUT.IR(23 downto 16) = IF_ID_INPUT.IR(7 downto 0) then
							Fetch_en <= '0';
							Decode_en <= '0';
							hazard_addr := ID_EX_INPUT.IR(23 downto 16);
					end if;
				when others => null;
			end case;
		end if;
	end process;

end rtl;