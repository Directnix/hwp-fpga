
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- The entity of your testbench. No ports declaration in this case.
ENTITY assignment2_tb IS
END ENTITY;
ARCHITECTURE testbench OF assignment2_tb IS
 COMPONENT assignment2 IS
port(
	inputs: in std_logic_vector(3 downto 0);
	ledr: out std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
 END COMPONENT;
 -- Signal declaration. These signals are used to drive your inputs and
 -- store results (if required).
 SIGNAL SW_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL HEX0_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);
 SIGNAL LEDR_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
 BEGIN
 -- A port map is in this case nothing more than a construction to
-- connect your entity ports with your signals.
tb: assignment2 PORT MAP (inputs => SW_tb, segments => HEX0_tb, ledr => LEDR_tb);
PROCESS
BEGIN
 -- Initialize signals.
 SW_tb <= "0000";
 -- Loop through values.
 FOR I IN 0 TO 15 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 SW_tb <= STD_LOGIC_VECTOR(UNSIGNED(SW_tb) + 1);
 END LOOP;
 REPORT "Test completed.";
 -- Wait forever.
 WAIT;
END PROCESS;
END ARCHITECTURE; 