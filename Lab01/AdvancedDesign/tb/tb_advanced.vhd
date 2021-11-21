
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
	 B:in data ;
	 DOUT1,dout2,dout3: out signed (work.datatype.Nb-1 downto 0);
	 VOUT: out std_logic);
end component;
signal DIN1,din2,din3: signed (Nb-1 downto 0);
signal VIN: std_logic :='0';
signal rst_n:std_logic :='0';
signal clk:std_logic :='0';
signal B:data;

signal DOUT1,dout2,dout3: signed (Nb-1 downto 0);
signal VOUT: std_logic :='0';
constant data_inl : integer := 201;
type data_c is array (data_inl-1 downto 0) of signed (Nb-1 downto 0);
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
B(0)<=to_signed(-1,B(0)'length);
B(1)<=to_signed(-7,B(1)'length);
B(2)<=to_signed(-13,B(2)'length);
B(3)<=to_signed(32,B(3)'length);
B(4)<=to_signed(140,B(4)'length);
B(5)<=to_signed(203,B(5)'length);
B(6)<=to_signed(140,B(6)'length);
B(7)<=to_signed(32,B(7)'length);
B(8)<=to_signed(-13,B(8)'length);
B(9)<=to_signed(-7,B(9)'length);
B(10)<=to_signed(-1,B(10)'length);


FILL_MEM : process (rst_n)
file mem_fp:text;
variable file_line:line;
variable index:integer:=0;
variable tmp_data_u: integer;
 begin
if(rst_n='0') then
file_open(mem_fp,"inout_data/data.txt",READ_MODE);
while (not endfile(mem_fp) and index < data_inl) loop
        readline(mem_fp,file_line);
        read(file_line,tmp_data_u);
        list_in(index) <=to_signed(tmp_data_u,Nb);       
        index := index + 1;
      end loop;
file_close(mem_fp);
end if;
end process;
data_in : process(clk,rst_n)
variable idx:integer:=0;
begin
	if(rst_n='1' and clk'event and clk='1' ) then 
		if( idx<data_inl) then
			DIN1<=list_in(idx);
			DIN2<=list_in(idx+1);
			DIN3<=list_in(idx+2);
			--DIN2<=list_in(idx+1);
			--DIN3<=list_in(idx+2);
			VIN<='1';
			idx:=idx+3;
		

		end if;
	end if;
end process;
out_f : process(Dout1,dout2,dout3)
file mem_fp:text;
variable file_line:line;
variable index:integer:=0;
variable tmp_data_u: integer;
 begin
if(rst_n='0') then
	file_close(mem_fp);
  file_open(mem_fp,"inout_data/out_adv3_tes.txt",WRITE_MODE);

elsif(index < data_inl) then
	write(file_line,to_integer(Dout1));
        writeline(mem_fp,file_line); 
	write(file_line,to_integer(Dout2));
        writeline(mem_fp,file_line); 
	write(file_line,to_integer(Dout3));
        writeline(mem_fp,file_line);      
        index := index + 3;
	  
else
	  file_close(mem_fp);
end if;
end process;

end architecture;
