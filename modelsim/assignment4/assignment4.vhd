
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

ENTITY assignment4 IS 
	GENERIC (limit: INTEGER := 50_000_000); -- release
	--GENERIC (limit: INTEGER := 5); -- test
	PORT (
		CLK: in std_logic;
		LEDR_0: out std_logic;
		HEX_0: out std_logic_vector(6 downto 0)
	);
END assignment4; 

ARCHITECTURE driver OF assignment4 IS
COMPONENT seven_segment is 
port(
	inputs: in std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
end COMPONENT;
SIGNAL hex : std_logic_vector(3 DOWNTO 0); 
BEGIN
ss: seven_segment PORT MAP (inputs => hex, segments => HEX_0);
PROCESS(CLK)
variable tick: natural range 0 to limit := 0;
variable count : integer := 0;
variable state: std_logic := '0';
BEGIN
	IF rising_edge(CLK) THEN
		IF tick = limit THEN
			tick := 0;
			state := not state;
			LEDR_0 <= state;
			
			IF count >= 9 THEN
				count := 0;
			ELSE
				count := count + 1;			
			END IF;

			hex <= std_logic_vector(to_unsigned(count, 4));
		END IF;
		tick := tick + 1;
	END IF;
END PROCESS;

END driver;