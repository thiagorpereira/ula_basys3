library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sum_3bits is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (4 downto 0));
end sum_3bits;

architecture Behavioral of sum_3bits is
    signal aux1,aux2,aux3:std_logic;
    component somador is
        Port(a,b,cin : in  std_logic;
            s       : out std_logic_vector (1 downto 0));
    end component;
begin
    soma1 : somador port map(
        a    => a(0),
        b    => b(0),
        cin  => sel,
        s(0) => s(0),
        s(1) => aux1
        );
    soma2 : somador port map(
        a    => a(1),
        b    => b(1),
        cin  => aux1,
        s(0) => s(1),
        s(1) => aux2
        );
    soma3 : somador port map(
        a    => a(2),
        b    => b(2),
        cin  => aux2,
        s(0) => s(2),
        s(1) => aux3
        );
    soma4 : somador port map(
        a    => a(3),
        b    => b(3),
        cin  => aux3,
        s(0) => s(3),
        s(1) => s(4)
        );
end Behavioral;
