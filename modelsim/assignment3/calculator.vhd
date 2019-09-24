LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

ENTITY assignment3 IS 
	PORT (
 		SW_2, SW_1: in std_logic_vector(3 downto 0);	-- rename to sw range
		BTN_0: in std_logic;
		HEX_6, HEX_3, HEX_1, HEX_0: out std_logic_vector(6 downto 0)
	);
END assignment3; 

ARCHITECTURE calc OF assignment3 IS
COMPONENT seven_segment is 
port(
	inputs: in std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
end COMPONENT;
SIGNAL hex_a_1, hex_a_0 : std_logic_vector(3 DOWNTO 0); 
BEGIN

hex_first: seven_segment PORT MAP (inputs => SW_1, segments => HEX_6);
hex_second: seven_segment PORT MAP (inputs => SW_2, segments => HEX_3);

hex_a_second: seven_segment PORT MAP (inputs => hex_a_0, segments => HEX_0);

PROCESS(BTN_0)
variable sum: integer := 0;
BEGIN
	IF FALLING_EDGE(BTN_0) THEN
		sum := to_integer(unsigned('0' & SW_1) + unsigned('0' & SW_2));
		IF sum > 15 THEN
			HEX_1 <= "1111001";
			hex_a_0 <= std_logic_vector(to_unsigned(sum - 16, 4));
		ELSE
			HEX_1 <= "1111111";
			hex_a_0 <= std_logic_vector(to_unsigned(sum, 4));	
		END IF;	
	END IF;
END PROCESS;

-- PROCESS(SW_1, SW_2)
-- BEGIN
--	hex_a_0 <= "UUUU";
--	hex_a_1 <= "UUUU";
-- END PROCESS;

END calc;