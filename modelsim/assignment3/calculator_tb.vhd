LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY calculator_tb IS
END ENTITY;

ARCHITECTURE testbench OF calculator_tb IS

COMPONENT assignment3 IS
	PORT (
 		SW_2, SW_1: in std_logic_vector(3 downto 0);
		BTN_0: in std_logic;
		HEX_6, HEX_3, HEX_1, HEX_0: out std_logic_vector(6 downto 0)
	);
END COMPONENT;

SIGNAL INPUTS_tb: std_logic_vector(8 downto 0);
SIGNAL HEX_6_tb, HEX_3_tb, HEX_1_tb, HEX_0_tb: std_logic_vector(6 downto 0);
 
BEGIN
 
	calc: assignment3 PORT MAP (
		SW_2 => INPUTS_tb(8 downto 5),
		SW_1 => INPUTS_tb(4 downto 1),
		BTN_0 => INPUTS_tb(0),
		HEX_6 => HEX_6_tb,
		HEX_3 => HEX_3_tb,
		HEX_1 => HEX_1_tb,
		HEX_0 => HEX_0_tb
	);

	PROCESS
	BEGIN
		INPUTS_tb <= "000000000";

		FOR I IN 0 TO 511 LOOP
			WAIT FOR 10 ns;
 			INPUTS_tb <= STD_LOGIC_VECTOR(UNSIGNED(INPUTS_tb) + 1);
		END LOOP;
 		REPORT "Test completed.";
		WAIT;
	END PROCESS;
END ARCHITECTURE; 
