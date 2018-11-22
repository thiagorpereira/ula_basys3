----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2018 11:39:41
-- Design Name: 
-- Module Name: comp1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp1 is
    Port ( b : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           bout : out STD_LOGIC_VECTOR (3 downto 0));
end comp1;

architecture Behavioral of comp1 is
    
begin
    bout <= b when sel='0'
            else not b;

end Behavioral;
