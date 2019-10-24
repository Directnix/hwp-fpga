
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity dht22 is 
--generic (sec: integer := 50_000_000);
generic (sec: integer := 8); -- test
port(
	dht22_clk, dht22_reading: in std_logic;
	dht22_done: out std_logic;
	dht22_result: out integer
);
end dht22;

architecture driver of dht22 is
begin

process(dht22_clk)
begin
	if rising_edge(dht22_clk) then
			
	end if;
end process;	
	
end driver;