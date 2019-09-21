LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity seven_segment is 
port(
	inputs: in std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
end seven_segment;

architecture driver of seven_segment is
begin
	with to_integer(unsigned(inputs)) select
	segments <= 	not "0111111" when 0,
			not "0000110" when 1,
			not "1011011" when 2,
			not "1001111" when 3,
			not "1100110" when 4,
			not "1101101" when 5,
			not "1111101" when 6,
			not "0000111" when 7,
			not "1111111" when 8,
			not "1101111" when 9,
			not "1110111" when 10,
			not "1111100" when 11,
			not "0111001" when 12,
			not "1011110" when 13,
			not "1111001" when 14,
			not "1110001" when 15,
			not "0000000" when others;
end driver;
