
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

-- STATES:
-- 0 - Idle
-- 1 - Button (waiting for debounce)
-- 2 - Counting
-- 3 - Done
 
entity assignment5 is 
--generic (sec: integer := 50_000_000);
generic (sec: integer := 8); -- test
port(
	clk_50mHz, btn_bgn, btn_rst: in std_logic;
	led_0: out std_logic;
	ssd_0,ssd_6: out std_logic_vector(6 downto 0)
);
end assignment5;

architecture driver of assignment5 is

constant idle : std_logic_vector(3 downto 0) := "0000";
constant btn: std_logic_vector(3 downto 0) := "0001";
constant cnting: std_logic_vector(3 downto 0) := "0010";
constant done : std_logic_vector(3 downto 0) := "0011";

component counter is
port(
	clk, cnt: in std_logic;
	ssd_counter: out std_logic_vector(6 downto 0);
	is_done: out std_logic
);
end component;
component ssd is
port(
	inputs: in std_logic_vector(3 downto 0);
	segments: out std_logic_vector(6 downto 0)
);
end component;
component fled is
port(
	clk, oe, speed_select: in std_logic;
	led: out std_logic
);
end component;

signal state : std_logic_vector(3 DOWNTO 0); 
signal led_on, led_speed: std_logic; 
signal cnt_running, cnt_done : std_logic; 

signal present_state,next_state : std_logic_vector(3 downto 0);

begin
cnter: counter PORT MAP (clk => clk_50mHz, cnt => cnt_running, ssd_counter => ssd_0, is_done => cnt_done);
ssd_state: ssd PORT MAP (inputs => state, segments => ssd_6);
led_status: fled PORT MAP (clk => clk_50mHz, oe => led_on, speed_select => led_speed, led => led_0);

process (btn_rst, clk_50mHz)
begin
	if btn_rst = '0' then present_state <= idle;
	elsif rising_edge(clk_50mHz) then present_state <= next_state;
	end if;
end process;

process (present_state, btn_bgn, cnt_done)
begin
	case present_state is
		when idle => if btn_bgn = '0' then next_state <= btn; else next_state <= idle; end if;
		when btn => if btn_bgn = '1' then next_state <= cnting; else next_state <= btn; end if;
		when cnting =>if cnt_done = '1' then next_state <= done; else next_state <= cnting;  end if;
		when done => if btn_rst = '0' then next_state <= idle; else next_state <= done; end if;
		when others => next_state <= idle;
	end case;
end process;

process (present_state)
begin
	case present_state is
		when idle => 
			led_on <= '1';
			led_speed <= '0';
			cnt_running <= '0';
		when btn => 
			led_on <= '0';
			led_speed <= '0';	
         cnt_running <= '0';
		when cnting => 
			led_on <= '0';
			led_speed <= '0';	
         cnt_running <= '1';
		when done => 
			led_on <= '1';
			led_speed <= '1';	
         cnt_running <= '0';
		when others => led_on <= '0';
	end case;
	state <= present_state;
end process;

end driver;