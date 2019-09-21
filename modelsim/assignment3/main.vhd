LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

ARCHITECTURE driver OF segment IS
	PORT (
		sw_9to6, sw_3to0 : IN STD_LOGIC_VECTOR(3 downto 0);
		key_0 : IN STD_LOGIC;
		hex_5, hex_3, hex_1, hex_0 : OUT STD_LOGIC_VECTOR(6 downto 0)
	);

BEGIN


END driver;