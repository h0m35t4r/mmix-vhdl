library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package opcode is

	--MMIX opcodes
	constant MMIX_TRAP: std_logic_vector(7 downto 0) := X"00";
	constant MMIX_FCMP: std_logic_vector(7 downto 0) := X"01";
	constant MMIX_FUN : std_logic_vector(7 downto 0) := X"02";
	constant MMIX_FEQL: std_logic_vector(7 downto 0) := X"03";
	constant MMIX_FADD: std_logic_vector(7 downto 0) := X"04";
	constant MMIX_FIX: std_logic_vector(7 downto 0) := X"05";
	constant MMIX_FSUB: std_logic_vector(7 downto 0) := X"06";
	constant MMIX_FIXU: std_logic_vector(7 downto 0) := X"07";
	constant MMIX_FLOT: std_logic_vector(7 downto 0) := X"08";
	constant MMIX_FLOTI: std_logic_vector(7 downto 0) := X"09";
	constant MMIX_FLOTU: std_logic_vector(7 downto 0) := X"0A";
	constant MMIX_FLOTUI: std_logic_vector(7 downto 0) := X"0B";
	constant MMIX_SFLOT: std_logic_vector(7 downto 0) := X"0C";
	constant MMIX_SFLOTI: std_logic_vector(7 downto 0) := X"0D";
	constant MMIX_SFLOTU: std_logic_vector(7 downto 0) := X"0E";
	constant MMIX_SFLOTUI: std_logic_vector(7 downto 0) := X"0F";
	constant MMIX_FMUL: std_logic_vector(7 downto 0) := X"10";
	constant MMIX_FCMPE: std_logic_vector(7 downto 0) := X"11";
	constant MMIX_FUNE: std_logic_vector(7 downto 0) := X"12";
	constant MMIX_FEQLE: std_logic_vector(7 downto 0) := X"13";
	constant MMIX_FDIV: std_logic_vector(7 downto 0) := X"14";
	constant MMIX_FSQRT: std_logic_vector(7 downto 0) := X"15";
	constant MMIX_FREM: std_logic_vector(7 downto 0) := X"16";
	constant MMIX_FINT: std_logic_vector(7 downto 0) := X"17";
	constant MMIX_MUL: std_logic_vector(7 downto 0) := X"18";
	constant MMIX_MULI: std_logic_vector(7 downto 0) := X"19";
	constant MMIX_MULU: std_logic_vector(7 downto 0) := X"1A";
	constant MMIX_MULUI: std_logic_vector(7 downto 0) := X"1B";
	constant MMIX_DIV: std_logic_vector(7 downto 0) := X"1C";
	constant MMIX_DIVI: std_logic_vector(7 downto 0) := X"1D";
	constant MMIX_DIVU: std_logic_vector(7 downto 0) := X"1E";
	constant MMIX_DIVUI: std_logic_vector(7 downto 0) := X"1F";
	constant MMIX_ADD: std_logic_vector(7 downto 0) := X"20";
	constant MMIX_ADDI: std_logic_vector(7 downto 0) := X"21";
	constant MMIX_ADDU: std_logic_vector(7 downto 0) := X"22";
	constant MMIX_ADDUI: std_logic_vector(7 downto 0) := X"23";
	constant MMIX_SUB: std_logic_vector(7 downto 0) := X"24";
	constant MMIX_SUBI: std_logic_vector(7 downto 0) := X"25";
	constant MMIX_SUBU: std_logic_vector(7 downto 0) := X"26";
	constant MMIX_SUBUI: std_logic_vector(7 downto 0) := X"27";
	constant MMIX_2ADDU: std_logic_vector(7 downto 0) := X"28";
	constant MMIX_2ADDUI: std_logic_vector(7 downto 0) := X"29";
	constant MMIX_4ADDU: std_logic_vector(7 downto 0) := X"2A";
	constant MMIX_4ADDUI: std_logic_vector(7 downto 0) := X"2B";
	constant MMIX_8ADDU: std_logic_vector(7 downto 0) := X"2C";
	constant MMIX_8ADDUI: std_logic_vector(7 downto 0) := X"2D";
	constant MMIX_16ADDU: std_logic_vector(7 downto 0) := X"2E";
	constant MMIX_16ADDUI: std_logic_vector(7 downto 0) := X"2F";
	constant MMIX_CMP: std_logic_vector(7 downto 0) := X"30";
	constant MMIX_CMPI: std_logic_vector(7 downto 0) := X"31";
	constant MMIX_CMPU: std_logic_vector(7 downto 0) := X"32";
	constant MMIX_CMPUI: std_logic_vector(7 downto 0) := X"33";
	constant MMIX_NEG: std_logic_vector(7 downto 0) := X"34";
	constant MMIX_NEGI: std_logic_vector(7 downto 0) := X"35";
	constant MMIX_NEGU: std_logic_vector(7 downto 0) := X"36";
	constant MMIX_NEGUI: std_logic_vector(7 downto 0) := X"37";
	constant MMIX_SL: std_logic_vector(7 downto 0) := X"38";
	constant MMIX_SLI: std_logic_vector(7 downto 0) := X"39";
	constant MMIX_SLU: std_logic_vector(7 downto 0) := X"3A";
	constant MMIX_SLUI: std_logic_vector(7 downto 0) := X"3B";
	constant MMIX_SR: std_logic_vector(7 downto 0) := X"3C";
	constant MMIX_SRI: std_logic_vector(7 downto 0) := X"3D";
	constant MMIX_SRU: std_logic_vector(7 downto 0) := X"3E";
	constant MMIX_SRUI: std_logic_vector(7 downto 0) := X"3F";
	constant MMIX_BN: std_logic_vector(7 downto 0) := X"40";
	constant MMIX_BNB: std_logic_vector(7 downto 0) := X"41";
	constant MMIX_BZ: std_logic_vector(7 downto 0) := X"42";
	constant MMIX_BZB: std_logic_vector(7 downto 0) := X"43";
	constant MMIX_BP: std_logic_vector(7 downto 0) := X"44";
	constant MMIX_BPB: std_logic_vector(7 downto 0) := X"45";
	constant MMIX_BOD: std_logic_vector(7 downto 0) := X"46";
	constant MMIX_BODB: std_logic_vector(7 downto 0) := X"47";
	constant MMIX_BNN: std_logic_vector(7 downto 0) := X"48";
	constant MMIX_BNNB: std_logic_vector(7 downto 0) := X"49";
	constant MMIX_BNZ: std_logic_vector(7 downto 0) := X"4A";
	constant MMIX_BNZB: std_logic_vector(7 downto 0) := X"4B";
	constant MMIX_BNP: std_logic_vector(7 downto 0) := X"4C";
	constant MMIX_BNPB: std_logic_vector(7 downto 0) := X"4D";
	constant MMIX_BEV: std_logic_vector(7 downto 0) := X"4E";
	constant MMIX_BEVB: std_logic_vector(7 downto 0) := X"4F";
	constant MMIX_PBN: std_logic_vector(7 downto 0) := X"50";
	constant MMIX_PBNB: std_logic_vector(7 downto 0) := X"51";
	constant MMIX_PBZ: std_logic_vector(7 downto 0) := X"52";
	constant MMIX_PBZB: std_logic_vector(7 downto 0) := X"53";
	constant MMIX_PBP: std_logic_vector(7 downto 0) := X"54";
	constant MMIX_PBPB: std_logic_vector(7 downto 0) := X"55";
	constant MMIX_PBOD: std_logic_vector(7 downto 0) := X"56";
	constant MMIX_PBODB: std_logic_vector(7 downto 0) := X"57";
	constant MMIX_PBNN: std_logic_vector(7 downto 0) := X"58";
	constant MMIX_PBNNB: std_logic_vector(7 downto 0) := X"59";
	constant MMIX_PBNZ: std_logic_vector(7 downto 0) := X"5A";
	constant MMIX_PBNZB: std_logic_vector(7 downto 0) := X"5B";
	constant MMIX_PBNP: std_logic_vector(7 downto 0) := X"5C";
	constant MMIX_PBNPB: std_logic_vector(7 downto 0) := X"5D";
	constant MMIX_PBEV: std_logic_vector(7 downto 0) := X"5E";
	constant MMIX_PBEVP: std_logic_vector(7 downto 0) := X"5F";
	constant MMIX_CSN: std_logic_vector(7 downto 0) := X"60";
	constant MMIX_CSNI: std_logic_vector(7 downto 0) := X"61";
	constant MMIX_CSZ: std_logic_vector(7 downto 0) := X"62";
	constant MMIX_CSZI: std_logic_vector(7 downto 0) := X"63";
	constant MMIX_CSP: std_logic_vector(7 downto 0) := X"64";
	constant MMIX_CSPI: std_logic_vector(7 downto 0) := X"65";
	constant MMIX_CSOD: std_logic_vector(7 downto 0) := X"66";
	constant MMIX_CSODI: std_logic_vector(7 downto 0) := X"67";
	constant MMIX_CSNN: std_logic_vector(7 downto 0) := X"68";
	constant MMIX_CSNNI: std_logic_vector(7 downto 0) := X"69";
	constant MMIX_CSNZ: std_logic_vector(7 downto 0) := X"6A";
	constant MMIX_CSNZI: std_logic_vector(7 downto 0) := X"6B";
	constant MMIX_CSNP: std_logic_vector(7 downto 0) := X"6C";
	constant MMIX_CSNPI: std_logic_vector(7 downto 0) := X"6D";
	constant MMIX_CSEV: std_logic_vector(7 downto 0) := X"6E";
	constant MMIX_CSEVI: std_logic_vector(7 downto 0) := X"6F";
	constant MMIX_ZSN: std_logic_vector(7 downto 0) := X"70";
	constant MMIX_ZSNI: std_logic_vector(7 downto 0) := X"71";
	constant MMIX_ZSZ: std_logic_vector(7 downto 0) := X"72";
	constant MMIX_ZSZI: std_logic_vector(7 downto 0) := X"73";
	constant MMIX_ZSP: std_logic_vector(7 downto 0) := X"74";
	constant MMIX_ZSPI: std_logic_vector(7 downto 0) := X"75";
	constant MMIX_ZSOD: std_logic_vector(7 downto 0) := X"76";
	constant MMIX_ZSODI: std_logic_vector(7 downto 0) := X"77";
	constant MMIX_ZSNN: std_logic_vector(7 downto 0) := X"78";
	constant MMIX_ZSNNI: std_logic_vector(7 downto 0) := X"79";
	constant MMIX_ZSNZ: std_logic_vector(7 downto 0) := X"7A";
	constant MMIX_ZSNZI: std_logic_vector(7 downto 0) := X"7B";
	constant MMIX_ZSNP: std_logic_vector(7 downto 0) := X"7C";
	constant MMIX_ZSNPI: std_logic_vector(7 downto 0) := X"7D";
	constant MMIX_ZSEV: std_logic_vector(7 downto 0) := X"7E";
	constant MMIX_ZSEVI: std_logic_vector(7 downto 0) := X"7F";
	constant MMIX_LDB: std_logic_vector(7 downto 0) := X"80";
	constant MMIX_LDBI: std_logic_vector(7 downto 0) := X"81";
	constant MMIX_LDBU: std_logic_vector(7 downto 0) := X"82";
	constant MMIX_LDBUI: std_logic_vector(7 downto 0) := X"83";
	constant MMIX_LDW: std_logic_vector(7 downto 0) := X"84";
	constant MMIX_LDWI: std_logic_vector(7 downto 0) := X"85";
	constant MMIX_LDWU: std_logic_vector(7 downto 0) := X"86";
	constant MMIX_LDWUI: std_logic_vector(7 downto 0) := X"87";
	constant MMIX_LDT: std_logic_vector(7 downto 0) := X"88";
	constant MMIX_LDTI: std_logic_vector(7 downto 0) := X"89";
	constant MMIX_LDTU: std_logic_vector(7 downto 0) := X"8A";
	constant MMIX_LDTUI: std_logic_vector(7 downto 0) := X"8B";
	constant MMIX_LDO: std_logic_vector(7 downto 0) := X"8C";
	constant MMIX_LDOI: std_logic_vector(7 downto 0) := X"8D";
	constant MMIX_LDOU: std_logic_vector(7 downto 0) := X"8E";
	constant MMIX_LDOUI: std_logic_vector(7 downto 0) := X"8F";
	constant MMIX_LDSF: std_logic_vector(7 downto 0) := X"90";
	constant MMIX_LDSFI: std_logic_vector(7 downto 0) := X"91";
	constant MMIX_LDHT: std_logic_vector(7 downto 0) := X"92";
	constant MMIX_LDHTI: std_logic_vector(7 downto 0) := X"93";
	constant MMIX_CSWAP: std_logic_vector(7 downto 0) := X"94";
	constant MMIX_CSWAPI: std_logic_vector(7 downto 0) := X"95";
	constant MMIX_LDUNC: std_logic_vector(7 downto 0) := X"96";
	constant MMIX_LDUNCI: std_logic_vector(7 downto 0) := X"97";
	constant MMIX_LDVTS: std_logic_vector(7 downto 0) := X"98";
	constant MMIX_LDVTSI: std_logic_vector(7 downto 0) := X"99";
	constant MMIX_PRELD: std_logic_vector(7 downto 0) := X"9A";
	constant MMIX_PRELDI: std_logic_vector(7 downto 0) := X"9B";
	constant MMIX_PREGO: std_logic_vector(7 downto 0) := X"9C";
	constant MMIX_PREGOI: std_logic_vector(7 downto 0) := X"9D";
	constant MMIX_GO: std_logic_vector(7 downto 0) := X"9E";
	constant MMIX_GOI: std_logic_vector(7 downto 0) := X"9F";
	constant MMIX_STB: std_logic_vector(7 downto 0) := X"A0";
	constant MMIX_STBI: std_logic_vector(7 downto 0) := X"A1";
	constant MMIX_STBU: std_logic_vector(7 downto 0) := X"A2";
	constant MMIX_STBUI: std_logic_vector(7 downto 0) := X"A3";
	constant MMIX_STW: std_logic_vector(7 downto 0) := X"A4";
	constant MMIX_STWI: std_logic_vector(7 downto 0) := X"A5";
	constant MMIX_STWU: std_logic_vector(7 downto 0) := X"A6";
	constant MMIX_STWUI: std_logic_vector(7 downto 0) := X"A7";
	constant MMIX_STT: std_logic_vector(7 downto 0) := X"A8";
	constant MMIX_STTI: std_logic_vector(7 downto 0) := X"A9";
	constant MMIX_STTU: std_logic_vector(7 downto 0) := X"AA";
	constant MMIX_STTUI: std_logic_vector(7 downto 0) := X"AB";
	constant MMIX_STO: std_logic_vector(7 downto 0) := X"AC";
	constant MMIX_STOI: std_logic_vector(7 downto 0) := X"AD";
	constant MMIX_STOU: std_logic_vector(7 downto 0) := X"AE";
	constant MMIX_STOUI: std_logic_vector(7 downto 0) := X"AF";
	constant MMIX_STSF: std_logic_vector(7 downto 0) := X"B0";
	constant MMIX_STSFI: std_logic_vector(7 downto 0) := X"B1";
	constant MMIX_STHT: std_logic_vector(7 downto 0) := X"B2";
	constant MMIX_STHTI: std_logic_vector(7 downto 0) := X"B3";
	constant MMIX_STCO: std_logic_vector(7 downto 0) := X"B4";
	constant MMIX_STCOI: std_logic_vector(7 downto 0) := X"B5";
	constant MMIX_STUNC: std_logic_vector(7 downto 0) := X"B6";
	constant MMIX_STUNCI: std_logic_vector(7 downto 0) := X"B7";
	constant MMIX_SYNCD: std_logic_vector(7 downto 0) := X"B8";
	constant MMIX_SYNCDI: std_logic_vector(7 downto 0) := X"B9";
	constant MMIX_PREST: std_logic_vector(7 downto 0) := X"BA";
	constant MMIX_PRESTI: std_logic_vector(7 downto 0) := X"BB";
	constant MMIX_SYNCID: std_logic_vector(7 downto 0) := X"BC";
	constant MMIX_SYNCIDI: std_logic_vector(7 downto 0) := X"BD";
	constant MMIX_PUSHGO: std_logic_vector(7 downto 0) := X"BE";
	constant MMIX_PUSHGOI: std_logic_vector(7 downto 0) := X"BF";
	constant MMIX_OR: std_logic_vector(7 downto 0) := X"C0";
	constant MMIX_ORI: std_logic_vector(7 downto 0) := X"C1";
	constant MMIX_ORN: std_logic_vector(7 downto 0) := X"C2";
	constant MMIX_ORNI: std_logic_vector(7 downto 0) := X"C3";
	constant MMIX_NOR: std_logic_vector(7 downto 0) := X"C4";
	constant MMIX_NORI: std_logic_vector(7 downto 0) := X"C5";
	constant MMIX_XOR: std_logic_vector(7 downto 0) := X"C6";
	constant MMIX_XORI: std_logic_vector(7 downto 0) := X"C7";
	constant MMIX_AND: std_logic_vector(7 downto 0) := X"C8";
	constant MMIX_ANDI: std_logic_vector(7 downto 0) := X"C9";
	constant MMIX_ANDN: std_logic_vector(7 downto 0) := X"CA";
	constant MMIX_ANDNI: std_logic_vector(7 downto 0) := X"CB";
	constant MMIX_NAND: std_logic_vector(7 downto 0) := X"CC";
	constant MMIX_NANDI: std_logic_vector(7 downto 0) := X"CD";
	constant MMIX_NXOR: std_logic_vector(7 downto 0) := X"CE";
	constant MMIX_NXORI: std_logic_vector(7 downto 0) := X"CF";
	constant MMIX_BDIF: std_logic_vector(7 downto 0) := X"D0";
	constant MMIX_BDIFI: std_logic_vector(7 downto 0) := X"D1";
	constant MMIX_WDIF: std_logic_vector(7 downto 0) := X"D2";
	constant MMIX_WDIFI: std_logic_vector(7 downto 0) := X"D3";
	constant MMIX_TDIF: std_logic_vector(7 downto 0) := X"D4";
	constant MMIX_TDIFI: std_logic_vector(7 downto 0) := X"D5";
	constant MMIX_ODIF: std_logic_vector(7 downto 0) := X"D6";
	constant MMIX_ODIFI: std_logic_vector(7 downto 0) := X"D7";
	constant MMIX_MUX: std_logic_vector(7 downto 0) := X"D8";
	constant MMIX_MUXI: std_logic_vector(7 downto 0) := X"D9";
	constant MMIX_SADD: std_logic_vector(7 downto 0) := X"DA";
	constant MMIX_SADDI: std_logic_vector(7 downto 0) := X"DB";
	constant MMIX_MOR: std_logic_vector(7 downto 0) := X"DC";
	constant MMIX_MORI: std_logic_vector(7 downto 0) := X"DD";
	constant MMIX_MXOR: std_logic_vector(7 downto 0) := X"DE";
	constant MMIX_MXORI: std_logic_vector(7 downto 0) := X"DF";
	constant MMIX_SETH: std_logic_vector(7 downto 0) := X"E0";
	constant MMIX_SETMH: std_logic_vector(7 downto 0) := X"E1";
	constant MMIX_SETML: std_logic_vector(7 downto 0) := X"E2";
	constant MMIX_SETL: std_logic_vector(7 downto 0) := X"E3";
	constant MMIX_INCH: std_logic_vector(7 downto 0) := X"E4";
	constant MMIX_INCMH: std_logic_vector(7 downto 0) := X"E5";
	constant MMIX_INCML: std_logic_vector(7 downto 0) := X"E6";
	constant MMIX_INCL: std_logic_vector(7 downto 0) := X"E7";
	constant MMIX_ORH: std_logic_vector(7 downto 0) := X"E8";
	constant MMIX_ORMH: std_logic_vector(7 downto 0) := X"E9";
	constant MMIX_ORML: std_logic_vector(7 downto 0) := X"EA";
	constant MMIX_ORL: std_logic_vector(7 downto 0) := X"EB";
	constant MMIX_ANDNH: std_logic_vector(7 downto 0) := X"EC";
	constant MMIX_ANDNMH: std_logic_vector(7 downto 0) := X"ED";
	constant MMIX_ANDNML: std_logic_vector(7 downto 0) := X"EE";
	constant MMIX_ANDNL: std_logic_vector(7 downto 0) := X"EF";
	constant MMIX_JMP: std_logic_vector(7 downto 0) := X"F0";
	constant MMIX_JMPB: std_logic_vector(7 downto 0) := X"F1";
	constant MMIX_PUSHJ: std_logic_vector(7 downto 0) := X"F2";
	constant MMIX_PUSHJB: std_logic_vector(7 downto 0) := X"F3";
	constant MMIX_GETA: std_logic_vector(7 downto 0) := X"F4";
	constant MMIX_GETAB: std_logic_vector(7 downto 0) := X"F5";
	constant MMIX_PUT: std_logic_vector(7 downto 0) := X"F6";
	constant MMIX_PUTI: std_logic_vector(7 downto 0) := X"F7";
	constant MMIX_POP: std_logic_vector(7 downto 0) := X"F8";
	constant MMIX_RESUME: std_logic_vector(7 downto 0) := X"F9";
	constant MMIX_SAVE: std_logic_vector(7 downto 0) := X"FA";
	constant MMIX_UNSAVE: std_logic_vector(7 downto 0) := X"FB";
	constant MMIX_SYNC: std_logic_vector(7 downto 0) := X"FC";
	constant MMIX_SWYM: std_logic_vector(7 downto 0) := X"FD";
	constant MMIX_GET: std_logic_vector(7 downto 0) := X"FE";
	constant MMIX_TRIP: std_logic_vector(7 downto 0) := X"FF";
		
end package opcode;