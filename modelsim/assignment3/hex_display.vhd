LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ARCHITECTURE driver OF segment IS
	COMPONENT hex IS
		PORT (
			inputs : IN STD_LOGIC_VECTOR;
			segments : OUT STD_LOGIC_VECTOR
		);
	END COMPONENT;

	SIGNAL sw_c : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL hex_c : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

	PORT MAP(inputs => sw_c, segments => hex_c);
	
	WITH to_integer(unsigned(sw_c)) SELECT
	hex_c <= NOT "0111111" WHEN 0, 
	            NOT "0000110" WHEN 1, 
	            NOT "1011011" WHEN 2, 
	            NOT "1001111" WHEN 3, 
	            NOT "1100110" WHEN 4, 
	            NOT "1101101" WHEN 5, 
	            NOT "1111101" WHEN 6, 
	            NOT "0000111" WHEN 7, 
	            NOT "1111111" WHEN 8, 
	            NOT "1101111" WHEN 9, 
	            NOT "1110111" WHEN 10, 
	            NOT "1111100" WHEN 11, 
	            NOT "0111001" WHEN 12, 
	            NOT "1011110" WHEN 13, 
	            NOT "1111001" WHEN 14, 
	            NOT "1110001" WHEN 15, 
	            NOT "1000000" WHEN OTHERS;
END driver;