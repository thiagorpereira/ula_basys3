library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sum_Sub is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (4 downto 0));
end Sum_Sub;

architecture Behavioral of Sum_Sub is
    component sum_3bits is
        Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
               b : in STD_LOGIC_VECTOR (3 downto 0);
               sel : in STD_LOGIC;
               s : out STD_LOGIC_VECTOR (4 downto 0));
        end component;
        
    component comp1 is
        Port ( b : in STD_LOGIC_VECTOR (3 downto 0);
               sel : in STD_LOGIC;
               bout : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal baux : std_logic_vector (3 downto 0);
begin
    complemento1 : comp1 port map(b, sel, baux);
    Operador: sum_3bits port map (a, baux, sel,s);
    
end Behavioral;
