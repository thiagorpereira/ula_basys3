library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity operadores is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           S : out STD_LOGIC_VECTOR (3 downto 0);
           overflow: out STD_LOGIC_VECTOR (3 downto 0);
           sinal: out STD_LOGIC); 
end operadores;

architecture Behavioral of operadores is


-- Componente Para o Somador de 4 Bits:
    component sum_3bits
        Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
               b : in STD_LOGIC_VECTOR (3 downto 0);
               sel : in STD_LOGIC;
               s : out STD_LOGIC_VECTOR (4 downto 0));
    end component;

-- Componente Para o Subtrator de 4 Bits:    
    component Sum_Sub
            Port (a : in STD_LOGIC_VECTOR (3 downto 0);
                  b : in STD_LOGIC_VECTOR (3 downto 0);
                  sel : in STD_LOGIC;
                  s : out STD_LOGIC_VECTOR (4 downto 0));
    end component;      

-- Soma o vetor 1:    
    signal vetor_1: STD_LOGIC_VECTOR (3 downto 0);
    signal sum: STD_LOGIC_VECTOR (4 downto 0);
    signal sub: STD_LOGIC_VECTOR (4 downto 0);
    signal sum1: STD_LOGIC_VECTOR (4 downto 0);
    signal aux: STD_LOGIC;   
    signal sinal_aux: STD_LOGIC;
begin

-- Mux da saída S:



aux<='0';
vetor_1 <= "0001";



Soma: sum_3bits port map(A, B, sel(1), sum);
Subt: sum_sub port map (A, B, sel(0), sub);
Add1: sum_3bits port map (A, vetor_1, aux, sum1);


process(sel)
    variable A_aux: INTEGER RANGE 0 to 15;
    variable B_aux: INTEGER RANGE 0 to 15;
    variable S_aux: INTEGER RANGE -225 to 225; 
    variable S_resultado: STD_LOGIC_VECTOR (7 downto 0);
    
        begin
            
            sinal_aux <= '0';
            
            A_aux := CONV_INTEGER(A);
            B_aux := CONV_INTEGER(B); 
            
            if sel = "0000" then S<="0000"; -- Zera S
            elsif sel = "0001" then S<="1111"; -- S tudo 1
            elsif sel = "0010" then -- OPA
                S(0)<=A(3); S(1)<=A(2); S(2)<=A(1); S(3)<=A(0);
            elsif sel = "0011" then -- OPB
                S(0)<=B(3); S(1)<=B(2); S(2)<=B(1); S(3)<=B(0);
            elsif sel = "0100" then -- OR(A,B)
                S(0)<= A(0) or B(0); S(1)<= A(1) or B(1); S(2)<= A(2) or B(2); S(3)<= A(3) or B(3);
            elsif sel = "0101" then -- AND(A,B)
                S(0)<= A(0) and B(0); S(1)<= A(1) and B(1); S(2)<= A(2) and B(2); S(3)<= A(3) and B(3);
            elsif sel = "0110" then -- XOR(A,B)
                S(0)<= A(0) xor B(0); S(1)<= A(1) xor B(1); S(2)<= A(2) xor B(2); S(3)<= A(3) xor B(3);
            elsif sel = "0111" then -- NOT(A)
                S <= not(A);
            elsif sel = "1000" then -- Soma A e B
                S <= sum(3) & sum(2) & sum(1) & sum(0);
                overflow <= "000" & sum(4);
            elsif sel = "1001" then -- Subtrai A e B
                if (A<B) then 
                    sinal_aux <= '1';
                    S <= not(sub(3)) & not(sub(2)) & not(sub(1)) & not(sub(0)) + 1;
                    overflow <= "000" & sub(4);
                else
                    overflow <= "000" & not(sub(4));
                    S <= sub(3) & sub(2) & sub(1) & sub(0);
                end if;              
            elsif sel = "1010" then -- Multiplica A e B
                S_aux := A_aux * B_aux;
                S_resultado := CONV_STD_LOGIC_VECTOR(S_aux,8);
                S <= S_resultado(3) & S_resultado(2) & S_resultado(1) & S_resultado(0);
                overflow <= S_resultado(7) & S_resultado(6) & S_resultado(5) & S_resultado(4);
            elsif (sel = "1011" or B /= 0) then  -- Divide A e B
                S_aux := A_aux / B_aux;
                S_resultado := CONV_STD_LOGIC_VECTOR(S_aux,8);
                S <= S_resultado(3) & S_resultado(2) & S_resultado(1) & S_resultado(0);
                if b="0000" then overflow <= "0001"; end if;
            elsif sel = "1100" then -- Resto de A e B
                S_aux := A_aux MOD B_aux;
                S_resultado := CONV_STD_LOGIC_VECTOR(S_aux,8);
                S <= S_resultado(3) & S_resultado(2) & S_resultado(1) & S_resultado(0);
            elsif sel = "1101" then -- A ao quadrado
                S_aux := A_aux * A_aux;
                S_resultado := CONV_STD_LOGIC_VECTOR(S_aux,8);
                S <= S_resultado(3) & S_resultado(2) & S_resultado(1) & S_resultado(0);
                overflow <= S_resultado(7) & S_resultado(6) & S_resultado(5) & S_resultado(4);
            elsif sel = "1110" then -- Nega A
                S <= 0-A;
                sinal_aux <= '1';
            elsif sel = "1111" then -- A + 1
                S <= sum1(3) & sum1(2) & sum1(1) & sum1(0);
            end if;
            
    end process;
    
sinal <= sinal_aux;

end Behavioral;