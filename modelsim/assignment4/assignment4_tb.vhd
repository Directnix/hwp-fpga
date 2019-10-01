LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY assignment4_tb IS
END ENTITY;

ARCHITECTURE testbench OF assignment4_tb IS

COMPONENT assignment4 IS
	PORT (
		CLK: in std_logic;
		LEDR_0: out std_logic;
		HEX_0: out std_logic_vector(6 downto 0)
	);
END COMPONENT;

SIGNAL CLK_tb, LEDR_tb : std_logic;
SIGNAL HEX_0_tb: std_logic_vector(6 downto 0);
 
BEGIN
	a: assignment4 PORT MAP (
		CLK => CLK_tb,
		LEDR_0 => LEDR_tb,
		HEX_0 => HEX_0_tb
	);

	PROCESS
	BEGIN
		CLK_tb <= '0';
		FOR I IN 0 TO 10000 LOOP
			WAIT FOR 10 ns;
 			CLK_tb <= not CLK_tb;
		END LOOP;

 		REPORT "Test completed.";
		WAIT;
	END PROCESS;
END ARCHITECTURE; 