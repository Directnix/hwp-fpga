LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 
 
entity fled is 
generic (sec: integer := 50_000_000);
--generic (sec: integer := 2); -- test
port(
	clk, oe, speed_select: in std_logic;
	led: out std_logic
);
end fled;

architecture driver of fled is
begin

process(clk)
variable tck: natural range 0 to sec := 0;
variable cnt: integer range 0 to 7 := 0;
begin
	if rising_edge(clk) then
		if oe = '1' then
			if tck = sec then
				cnt := cnt + 1;
				tck := 0;
			end if;

			if cnt >= 7 then
				cnt := 0;
			end if;

			if speed_select = '0' then
				if cnt > 5 then
					led <= '1';
				else
					led <= '0';
				end if;
			else 
				if cnt = 1 then
					led <= '0';
				elsif cnt = 4 then
					led <= '0';
				else
					led <= '1';
				end if;
			end if;
			tck := tck + 1;
		else
			led <= '0';
			tck := 0;
		end if;
	end if;
end process;
		
end driver;