library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;

entity Mux_display is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           tipo : in STD_LOGIC_VECTOR (1 downto 0);
           clk: in STD_LOGIC;
           an: out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (0 to 6));
end Mux_display;

architecture Behavioral of Mux_display is
-- DECLARACAO DE COMPONENTS
    component operadores
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               sel : in STD_LOGIC_VECTOR (3 downto 0);
               S : out STD_LOGIC_VECTOR (3 downto 0);
               overflow: out STD_LOGIC_VECTOR (3 downto 0);
               sinal: out STD_LOGIC); 
    end component;
    
    component conversor
        Port ( res: in STD_LOGIC_VECTOR (3 downto 0);
               sel_tipo : in STD_LOGIC_VECTOR (1 downto 0);
               overflow: in STD_LOGIC_VECTOR (3 downto 0);
               sinal: in STD_LOGIC; 
               dig1, dig2, dig3, dig4: out STD_LOGIC_VECTOR (3 downto 0));
    end component;

-- SIGNAL E CONSTANTE PARA O DIVISOR DE CLOCK    
    constant clk_div:     integer:=200_000;
    signal aux_clk: STD_LOGIC:='0';
    signal clk0: STD_LOGIC;
-- SIGNAL DO MUTIPLEXADOR DO DISPLAY    
    signal dig1, dig2, dig3, dig4: STD_LOGIC_VECTOR (3 downto 0);
    signal dig: STD_LOGIC_VECTOR (4 downto 0);
-- SIGNAL PARA AS COMPONENTS    
    signal res: STD_LOGIC_VECTOR (3 downto 0);
    signal error: STD_LOGIC_VECTOR (3 downto 0);
    signal sinal: STD_LOGIC;
    signal compres: STD_LOGIC_VECTOR (3 downto 0);
    
    signal aux_sinal: STD_LOGIC;
    
begin

operador: operadores port map (A, B, sel, res, error, sinal); 
converte: conversor port map (res, tipo, error, sinal, dig1, dig2, dig3, dig4);
  


-- DIVISOR DE CLOCK
clk0 <= aux_clk;
    process(clk)
       variable counter :integer:=clk_div;
      begin
            if rising_edge(clk)then
                if (counter=0)then
                    aux_clk <=not aux_clk;  --para mudar o nível lógico do clk0.
                    counter := clk_div;
                else
                    counter := counter-1;
                end if;
            end if;
    end process;


--MUX DE UNIDADE, CENTENAS, DEZENAS E MILHARES
    process(aux_clk)
    variable count: integer:=0;
    begin
        if rising_edge(aux_clk)then
            if(count=0)then
                an <= "1110"; -- Unidades
                 dig<= '0' & dig1;
                count := count + 1;
            elsif(count=1)then
                an <= "1101"; -- Dezenas
                 dig <= '0' & dig2;
                count:=count + 1;
            elsif(count=2)then
                an<= "1011"; -- Centenas
                if(sel="11") then
                    dig <= '0' & dig3;
                else
                    dig <= sinal & dig3; -- negativo  
                end if;
                count:= count + 1;
            elsif(count=3)then
                an<= "0111"; -- Milhares
                dig <= '0' & dig4;
                count:=0;
            end if;
        end if;    
    end process;
    

-- IMPRIME DO DISPLAY DE 7 SEGUIMENTOS    
    process(dig)
    begin
        if error = "0000" then -- IMPRIME O DIGITO
             case dig is
                when "00000" => seg <= "0000001"; -- "0"     
                when "00001" => seg <= "1001111"; -- "1" 
                when "00010" => seg <= "0010010"; -- "2" 
                when "00011" => seg <= "0000110"; -- "3" 
                when "00100" => seg <= "1001100"; -- "4" 
                when "00101" => seg <= "0100100"; -- "5" 
                when "00110" => seg <= "0100000"; -- "6" 
                when "00111" => seg <= "0001111"; -- "7" 
                when "01000" => seg <= "0000000"; -- "8"     
                when "01001" => seg <= "0000100"; -- "9" 
                when "01010" => seg <= "0000010"; -- a
                when "01011" => seg <= "1100000"; -- b
                when "01100" => seg <= "0110001"; -- C
                when "01101" => seg <= "1000010"; -- d
                when "01110" => seg <= "0110000"; -- E
                when "01111" => seg <= "0111000"; -- F 
                when "10000" => seg <= "1111110"; -- Menos
                when others  => seg <= "1111111";
            end case;
        else -- IMPRIME ERROR
            case dig is
                when "00000" => seg <= "0110000"; -- "E"     
                when "00001" => seg <= "1111010"; -- "r" 
                when "00010" => seg <= "1111010"; -- "r" 
                when "00011" => seg <= "1100010"; -- "o" 
                when others => seg <= "1111111";
            end case;
        end if;    
    end process;

end Behavioral;
