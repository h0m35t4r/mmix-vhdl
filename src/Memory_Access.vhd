----------------------------------------------------------------------------------
-- Engineer: Riccardo Russell
-- Create Date: 20:21:17 10/16/2011
--
-- Description: Reads or writes data to and from the data cache if needed. 
-- Most register write control signals are generated here except for conditionals
---------Aligning Memory for idiots---------
	--t = bytes to read
	--addr = raddr(2 downto 0)
	--start = 63 - (addr - (addr mod t))*8
	--end = start - (t*8)
	--
	--Example: reading 4 bytes at address 1002 with memory beginning at 1000
	--t = 4
	--addr = 1002(2 downto 0) = 2
	--start = 63 - (2 - (2 mod 4))*8 = 63
	--end = 63 - (4 * 8) = 63 downto 31
--variable octabyte_offset : integer range 0 to 7;
--variable octabyte_addr_lsb : integer range 0 to 55;
--variable octabyte_addr_msb : integer range 7 to 63;
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library mmix;
use mmix.opcode.all;
use mmix.pipeline_ports.all;

entity Memory_Access is
	port(	input : in execute_mem;
			output : out mem_wb;
			vga_addr : in std_logic_vector(12 downto 0);
			vga_read_data : out std_logic_vector(7 downto 0);
			clk : in std_logic
	);
end Memory_Access;

architecture Behavioural of Memory_Access is

	constant ADDR_WIDTH : integer := 13;
	constant DATA_WIDTH : integer := 8; 

	type memory is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector (DATA_WIDTH-1 downto 0);
	signal ram: memory := (others => X"00");
	
begin

	--Performs one read/write of memory and one read for VGA memory
	read_write: process(clk)
		variable resized_addr : integer range 0 to 2**ADDR_WIDTH-1;
		variable resized_vga_addr : integer range 0 to 2**ADDR_WIDTH-1;
	begin
		if (rising_edge(clk)) then
			resized_addr := to_integer(resize(unsigned(input.ram_addr), ADDR_WIDTH));
			resized_vga_addr := to_integer(resize(unsigned(vga_addr), ADDR_WIDTH));
			output.writen <= input.reg_write_enable;
			output.waddr <= input.reg_addr;
			output.wdata <= input.result;
			
			if(input.ram_write_enable = '1') then
				ram(resized_addr) <= std_logic_vector(resize(unsigned(input.result), DATA_WIDTH));
			end if;
			vga_read_data <= ram(resized_vga_addr);
		end if;
	end process;

end Behavioural;