
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.Std_Logic_Arith.all;
use std.textio.all;
use work.datatype.all;
entity tb is
end entity;
architecture beh of tb is
component Filter is
port(
	 DIN1,din2,din3:in signed (work.datatype.Nb-1 downto 0);
	 VIN: in std_logic;
 	 rst_n: in std_logic;
	 clk : in std_logic;
	 B : in std_logic_vector (109 downto 0);
	 DOUT1,dout2,dout3: out signed (work.datatype.Nb-1 downto 0);
	 VOUT: out std_logic);
end component;
signal DIN1,din2,din3: signed (Nb-1 downto 0);
signal VIN: std_logic :='0';
signal rst_n:std_logic :='0';
signal clk:std_logic :='0';
signal B : std_logic_vector (109 downto 0);

signal DOUT1,dout2,dout3: signed (Nb-1 downto 0);
signal VOUT: std_logic :='0';
constant data_inl : integer := 201;
type data_c is array (data_inl-1 downto 0) of signed (9 downto 0);
signal list_in:data_c ;

 begin
dut:Filter 
	port map (DIN1=>DIN1,DIN2=>DIN2,DIN3=>DIN3,
	VIN=>VIN,
	rst_n=>rst_n,
	clk=>clk,
	B=>B,
	DOUT1=>DOUT1,DOUT2=>DOUT2,DOUT3=>DOUT3,
	VOUT=>VOUT);

clk <= not clk after 10 ns;
rst_n<='0', '1' after 21 ns;
B(9 downto 0)<="1111111111";-- -1
B(19 downto 10)<="1111111001";-- -7
B(29 downto 20)<="1111110011";-- -13
B(39 downto 30)<="0000100000";-- 32
B(49 downto 40)<="0010001100";--140
B(59 downto 50)<="0011001011";-- 203
B(69 downto 60)<="0010001100";-- 140
B(79 downto 70)<="0000100000";-- 32
B(89 downto 80)<="1111110011"; -- -13
B(99 downto 90)<="1111111001";-- -7
B(109 downto 100)<="1111111111";-- -1


FILL_MEM : process (rst_n)
file mem_fp:text;
variable file_line:line;
variable index:integer:=0;
variable tmp_data_u: integer;
variable tmp: std_logic_vector(9 downto 0);
 begin
if(rst_n='0') then
file_open(mem_fp,"inout_data/data.txt",READ_MODE);
while (not endfile(mem_fp) and index <  data_inl) loop
        readline(mem_fp,file_line);
        read(file_line,tmp_data_u);
	tmp:=std_logic_vector(to_signed(tmp_data_u,10));
        list_in(index)(0) <=tmp(0); 
	list_in(index)(1) <=tmp(1); 
	list_in(index)(2) <=tmp(2); 
	list_in(index)(3) <=tmp(3); 
	list_in(index)(4) <=tmp(4); 
	list_in(index)(5) <=tmp(5); 
	list_in(index)(6) <=tmp(6); 
	list_in(index)(7) <=tmp(7); 
	list_in(index)(8) <=tmp(8); 
	list_in(index)(9) <=tmp(9);       
        index := index + 1;
      end loop;
end if;
end process;
data_in : process(clk,rst_n)
variable idx:integer:=0;
begin
	if(rst_n='1' and clk'event and clk='0' ) then 
		if( idx<data_inl) then
			DIN1(0)<=list_in(idx)(0);
			DIN1(1)<=list_in(idx)(1);
			DIN1(2)<=list_in(idx)(2);
			DIN1(3)<=list_in(idx)(3);
			DIN1(4)<=list_in(idx)(4);
			DIN1(5)<=list_in(idx)(5);
			DIN1(6)<=list_in(idx)(6);
			DIN1(7)<=list_in(idx)(7);
			DIN1(8)<=list_in(idx)(8);
			DIN1(9)<=list_in(idx)(9);
			DIN2(0)<=list_in(idx)(0);
			DIN2(1)<=list_in(idx+1)(1);
			DIN2(2)<=list_in(idx+1)(2);
			DIN2(3)<=list_in(idx+1)(3);
			DIN2(4)<=list_in(idx+1)(4);
			DIN2(5)<=list_in(idx+1)(5);
			DIN2(6)<=list_in(idx+1)(6);
			DIN2(7)<=list_in(idx+1)(7);
			DIN2(8)<=list_in(idx+1)(8);
			DIN2(9)<=list_in(idx+1)(9);
			DIN3(0)<=list_in(idx+2)(0);
			DIN3(1)<=list_in(idx+2)(1);
			DIN3(2)<=list_in(idx+2)(2);
			DIN3(3)<=list_in(idx+2)(3);
			DIN3(4)<=list_in(idx+2)(4);
			DIN3(5)<=list_in(idx+2)(5);
			DIN3(6)<=list_in(idx+2)(6);
			DIN3(7)<=list_in(idx+2)(7);
			DIN3(8)<=list_in(idx+2)(8);
			DIN3(9)<=list_in(idx+2)(9);
			VIN<='1';
			idx:=idx+3;
		

		end if;
	end if;
end process;
out_f : process(Dout1,dout2,dout3)
file mem_fp:text;
variable file_line:line;
variable index:integer:=0;
variable tmp_data_u: std_logic_vector(9 downto 0);
 begin
if(rst_n='0') then
file_open(mem_fp,"inout_data/out_post_adv.txt",WRITE_MODE);
else 
	tmp_data_u:=std_logic_vector(DOUT1);
	
	write(file_line,to_integer(ieee.numeric_std.signed(tmp_data_u)));
        writeline(mem_fp,file_line); 
	tmp_data_u:=std_logic_vector(DOUT2);
	
	write(file_line,to_integer(ieee.numeric_std.signed(tmp_data_u)));
        writeline(mem_fp,file_line); 
	tmp_data_u:=std_logic_vector(DOUT3);
	
	write(file_line,to_integer(ieee.numeric_std.signed(tmp_data_u)));
        writeline(mem_fp,file_line);      
        index := index + 3;
end if;
end process;

end architecture;
