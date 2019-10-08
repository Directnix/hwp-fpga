LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity counter is 
--generic (sec: integer := 50_000_000);
generic (sec: integer := 2); -- test
port(
	clk, cnt: in std_logic;
	ssd_counter: out std_logic_vector(6 downto 0);
	is_done: out std_logic
);
end counter;

architecture driver of counter is
component ssd is
port(
	inputs: in std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
end component;
SIGNAL hex : std_logic_vector(3 DOWNTO 0); 
signal done: std_logic;
begin
display: ssd PORT MAP (inputs => hex, segments => ssd_counter);
process(clk)
variable tick: natural range 0 to sec := 0;
variable count: integer := 0;
begin
	if rising_edge(clk) then
		if cnt = '1' then
			if tick = sec then
				tick := 0;
				if count >= 9 then
					count := 0;
					done <= '1';
					report "count done";
				else
					count := count + 1;
				end if;
				hex <= std_logic_vector(to_unsigned(count, 4));
			end if;
			tick := tick + 1;
		else
			--done <= '0';
			tick:= 0;
			count := 0;		
			hex <= "----";
		end if;
	end if;
end process;	
	
is_done <= done;

end driver;