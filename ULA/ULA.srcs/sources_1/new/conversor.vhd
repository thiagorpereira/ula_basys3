library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conversor is
    Port ( res: in STD_LOGIC_VECTOR (3 downto 0);
           sel_tipo : in STD_LOGIC_VECTOR (1 downto 0);
           overflow: in STD_LOGIC_VECTOR (3 downto 0);
           sinal: in STD_LOGIC;
           dig1, dig2, dig3, dig4: out STD_LOGIC_VECTOR (3 downto 0));
end conversor;

architecture Behavioral of conversor is

    signal bcd1, bcd2, bcd3, bcd4: STD_LOGIC_VECTOR (3 downto 0);
    signal oct1, oct2, oct3, oct4: STD_LOGIC_VECTOR (3 downto 0);
    
begin


process (res)
      -- Internal variable for storing bits
      variable shift : unsigned(27 downto 0);
	  -- Alias for parts of shift register
      alias bin is shift(3 downto 0);
      alias d0 is shift(bin'Length+3  downto bin'Length+0);
      alias d1 is shift(bin'Length+7  downto bin'Length+4);
      alias d2 is shift(bin'Length+11 downto bin'Length+8);
	  alias d3 is shift(bin'Length+15 downto bin'Length+12);
	begin
		-- Clear previous number and store new number in shift register
		bin := unsigned(res);
		d0 := X"0";
		d1 := X"0";
		d2 := X"0";
		d3 := X"0";

		-- Loop bin'Length times
		for i in 1 to bin'Length loop
			-- Check if any digit is greater than or equal to 5
			if d0 >= 5 then
				d0 := d0 + 3;
			end if;
			if d1 >= 5 then
				d1 := d1 + 3;
			end if;
			if d2 >= 5 then
				d2 := d2 + 3;
			end if;
			if d3 >= 5 then
				d3 := d3 + 3;
			end if;
			-- Shift entire register left once
			shift := shift_left(shift, 1);
		end loop;
		
		-- Push decimal numbers to output
		bcd4 <= std_logic_vector(d3);
		bcd3 <= std_logic_vector(d2);
		bcd2 <= std_logic_vector(d1);
		bcd1 <= std_logic_vector(d0);
	end process;
    
    process (sel_tipo)
        begin
            if (overflow = "0000") then
                if (sinal = '0') then
                    if (sel_tipo="00") then -- MOSTRA EM DECIMAL
                        dig1<=bcd1; dig2<=bcd2; dig3<=bcd3; dig4<=bcd4;
                    elsif (sel_tipo="01") then -- MOSTRA EM HEXADECIMAL
                        dig1<=res; dig2<="0000"; dig3<="0000"; dig4<="0000";
                    elsif (sel_tipo="10")then -- MOSTRA EM OCTAL
                        dig1<="0000"; dig2<="0000"; dig3<="0000"; dig4<="0000";
                    elsif (sel_tipo="11")then -- MOSTRA EM BINARIO
                        dig1<="000"&res(0); dig2<="000"&res(1); dig3<="000"&res(2); dig4<="000"&res(3);      
                    end if;
                else 
                    if (sel_tipo="00") then -- MOSTRA EM DECIMAL
                        dig1<=bcd1; dig2<=bcd2; dig3<="0000"; dig4<=bcd4;
                    elsif (sel_tipo="01") then -- MOSTRA EM HEXADECIMAL
                        dig1<=res; dig2<="0000"; dig3<="0000"; dig4<="0000";
                    elsif (sel_tipo="10")then -- MOSTRA EM OCTAL
                        dig1<="0000"; dig2<="0000"; dig3<="0000"; dig4<="0000";
                    elsif (sel_tipo="11")then -- MOSTRA EM BINARIO
                        dig1<="000"&res(0); dig2<="000"&res(1); dig3<="000"&res(2); dig4<="000"&res(3);      
                    end if;
              end if;
                    
            else
                dig1<="0011"; dig2<="0010"; dig3<="0001"; dig4<="0000";
            end if;
    end process;

end Behavioral;
