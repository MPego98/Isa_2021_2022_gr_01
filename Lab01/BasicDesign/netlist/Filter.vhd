
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.datatype.all;
entity Filter is
port(
	 DIN:in signed (Nb-1 downto 0);
	 VIN: in std_logic;
 	 rst_n: in std_logic;
	 clk : in std_logic;
	 B:in data ;
	 DOUT: out signed (Nb-1 downto 0);
	 VOUT: out std_logic);
end entity;
architecture beh of filter is
signal x_vector :data;
signal y:signed (nb-1 downto 0);
begin
process(clk,rst_n,vin)
variable tmp:signed (nb-1 downto 0);
variable store :signed (nb-1 downto 0);
begin
	if(clk 'event and clk = '1') then

	if(rst_n='0') then --reset phase
		y<=(others=>'0');
		for i in 0 to N-1 loop
			x_vector(i)<=(others=>'0');
		end loop;
	else  
		if(VIN='1') then
			
			for i in N-1 downto 1 loop
				x_vector(i)<=x_vector(i-1);
			end loop;
			x_vector(0)<=DIN;
			store:=to_signed(0,store'length);
			for i in 0 to N-1 loop
				tmp:=shift_right(x_vector(i)*B(i),nb)(nb-1 downto 0) ; 
				--tmp:=to_signed(100,tmp'length);
				store:=store+tmp ;
			end loop;
			y<=store;
			DOUT<=store;
			VOUT<='1';	
	   else
			VOUT<='0';
	   end if;
	end if;
end if;
end process;
end architecture;
