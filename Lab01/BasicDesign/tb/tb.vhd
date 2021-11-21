
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
	 DIN:in signed (Nb-1 downto 0);
	 VIN: in std_logic;
 	 rst_n: in std_logic;
	 clk : in std_logic;
	 B:in data ;
	 DOUT: out signed (Nb-1 downto 0);
	 VOUT: out std_logic);
end component;
signal DIN: signed (Nb-1 downto 0);
signal VIN: std_logic :='0';
signal rst_n:std_logic :='0';
signal clk:std_logic :='0';
signal B:data;

signal DOUT: signed (Nb-1 downto 0);
signal VOUT: std_logic :='0';
constant data_inl : integer := 201;
type data_c is array (data_inl-1 downto 0) of signed (Nb-1 downto 0);
signal list_in:data_c ;

 begin
dut:Filter 
	port map (DIN=>DIN,
	VIN=>VIN,
	rst_n=>rst_n,
	clk=>clk,
	B=>B,
	DOUT=>DOUT,
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
file_open(mem_fp,"data.txt",READ_MODE);
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
			DIN<=list_in(idx);
			VIN<='1';
			idx:=idx+1;
		

		end if;
	end if;
end process;
out_f : process(Dout)
file mem_fp:text;
variable file_line:line;
variable index:integer:=0;
variable tmp_data_u: integer;
 begin
if(rst_n='0') then
	file_close(mem_fp);
  file_open(mem_fp,"inout_data/out_basic.txt",WRITE_MODE);

elsif(index < data_inl) then
	write(file_line,to_integer(Dout));
        writeline(mem_fp,file_line);      
        index := index + 1;
else
	  file_close(mem_fp);
end if;
end process;

end architecture;
