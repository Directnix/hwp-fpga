LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

-- STATES:
-- 0 - Idle
-- 1 - Btn
-- 2 - Read
-- 3 - Done
 
entity fsm is 
--generic (sec: integer := 50_000_000);
generic (sec: integer := 8); -- test
port(
	fsm_clk, fsm_btn_0: in std_logic;
	fsm_ssd_0, fsm_ssd_1, fsm_ssd_2: out std_logic_vector(6 downto 0)
);
end fsm;

architecture driver of fsm is

constant state_idle : std_logic_vector(3 downto 0) := "0000";
constant state_btn: std_logic_vector(3 downto 0) := "0001";
constant state_read: std_logic_vector(3 downto 0) := "0010";
constant state_done : std_logic_vector(3 downto 0) := "0011";

--component dht22 is
--port(

--);
--end component;

component ssd is
port(
	ssd_in: in std_logic_vector(3 downto 0);
	ssd_seg: out std_logic_vector(6 downto 0)
);
end component;

signal dht22_reading, dht22_read_done,dht22_show_ssd, fsm_error : std_logic; 
signal fsm_cur_state, fsm_next_state : std_logic_vector(3 downto 0);

begin

-- PROCESS THAT SWITCHES BETWEEN STATES
process (fsm_clk)
begin
	if rising_edge(fsm_clk) then 
		fsm_cur_state <= fsm_next_state;
	end if;
end process;

-- PROCESS THAT HANDLES STATE TRANSITIONS
process (fsm_cur_state, fsm_btn_0, dht22_read_done)
begin
	case fsm_cur_state is
		when state_idle => if fsm_btn_0 	= '0' then fsm_next_state <= state_btn;  else fsm_next_state <= state_idle; end if;
		when state_btn 	=> if fsm_btn_0 	= '1' then fsm_next_state <= state_read; else fsm_next_state <= state_btn;  end if;
		when state_read	=> if dht22_read_done 	= '1' then fsm_next_state <= state_done; else fsm_next_state <= state_read; end if;
		when state_done => if fsm_btn_0		= '0' then fsm_next_state <= state_idle; else fsm_next_state <= state_done; end if;
		when others 	=> fsm_error <= '1';
	end case;
end process;

-- PROCESS THAT HANDLES STATE CONDITIONS
process (fsm_cur_state)
begin
	case fsm_cur_state is
		when state_idle => 
			dht22_show_ssd <= '0'; 
			dht22_reading <= '0';
			dht22_read_done <= '0';
		when state_btn => 
			dht22_show_ssd <= '0'; 
			dht22_reading <= '0';
			dht22_read_done <= '0';
		when state_read => 
			dht22_show_ssd <= '0'; 
			dht22_reading <= '1';
			dht22_read_done <= '0';
		when state_done => 
			dht22_show_ssd <= '1'; 
			dht22_reading <= '0';
			dht22_read_done <= '1';
		when others => fsm_error <= '1';
	end case;
end process;

end driver;