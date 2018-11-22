library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH;

entity somador is
  Port (a,b,cin : in  std_logic;
        s       : out std_logic_vector (1 downto 0));
end somador;

architecture Behavioral of somador is
    
begin
    s(0) <= a xor b xor cin;
    s(1) <= (a and b) or (a and cin) or (b and cin);
end Behavioral;
