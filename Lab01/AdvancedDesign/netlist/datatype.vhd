library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package datatype is
    
constant  Nb: integer := 10;
constant  N: integer := 11;
type data is array (11-1 downto 0) of signed (10-1 downto 0);
type arr is array (integer range <>) of signed(10-1 downto 0);
type arr2 is array (integer range <>) of signed((2*10)-1 downto 0);

end datatype;



