LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

-- STATES:
-- 0 - Idle
-- 1 - Btn
-- 2 - Read
-- 3 - Done
 
entity fsm is 

port(
	fsm_sda: inout std_logic;
	fsm_clk, fsm_btn_0: in std_logic;
	fsm_ssd_0, fsm_ssd_1, fsm_ssd_2: out std_logic_vector(6 downto 0)
);
end fsm;

architecture driver of fsm is

constant state_idle : std_logic_vector(3 downto 0) := "0000";
constant state_btn: std_logic_vector(3 downto 0) := "0001";
constant state_read: std_logic_vector(3 downto 0) := "0010";
constant state_done : std_logic_vector(3 downto 0) := "0011";

component display is
port(
	display_ei: in std_logic;
	display_in: in integer;
	display_ssd_0, display_ssd_1, display_ssd_2: out std_logic_vector(6 downto 0)
);
end component;

component dht22 is
port(
	dht22_sda: inout std_logic;
	dht22_clk, dht22_reading: in std_logic;
	dht22_done: out std_logic;
	dht22_hum_result, dht22_temp_result: out integer
);
end component;

signal fsm_dht22_reading, fsm_dht22_read_done, fsm_error, fsm_display_ei: std_logic := '0'; 
signal fsm_cur_state, fsm_next_state : std_logic_vector(3 downto 0);
signal fsm_dht22_hum_result, fsm_dht22_temp_result: integer;

begin

displ: display port map (
	display_ei    => fsm_display_ei,
	display_in    => fsm_dht22_hum_result,
	display_ssd_0 => fsm_ssd_0,
	display_ssd_1 => fsm_ssd_1,
	display_ssd_2 => fsm_ssd_2
);

sensor: dht22 port map (
	dht22_sda     => fsm_sda,
	dht22_clk     => fsm_clk,
	dht22_reading => fsm_dht22_reading,
	dht22_done    => fsm_dht22_read_done,
	dht22_hum_result  => fsm_dht22_hum_result,
	dht22_temp_result  => fsm_dht22_temp_result
);

-- PROCESS THAT SWITCHES BETWEEN STATES
process (fsm_clk)
begin
	if rising_edge(fsm_clk) then 
		fsm_cur_state <= fsm_next_state;
	end if;
end process;

-- PROCESS THAT HANDLES STATE TRANSITIONS
process (fsm_cur_state, fsm_btn_0, fsm_dht22_read_done)
begin
	case fsm_cur_state is
		when state_idle => if fsm_btn_0 	  = '0' then fsm_next_state <= state_btn; else fsm_next_state <= state_idle; end if;
		when state_btn 	=> if fsm_btn_0 	  = '1' then fsm_next_state <= state_read; else fsm_next_state <= state_btn;  end if;
		when state_read	=> if fsm_dht22_read_done = '1' then fsm_next_state <= state_done; report "done"; else fsm_next_state <= state_read; end if;
		when state_done => if fsm_btn_0		  = '0' then fsm_next_state <= state_idle; else fsm_next_state <= state_done; end if;
		when others 	=> fsm_next_state <= state_idle;
	end case;
end process;

-- PROCESS THAT HANDLES STATE CONDITIONS
process (fsm_cur_state)
begin
	case fsm_cur_state is
		when state_idle => 
			fsm_display_ei <= '0';
			fsm_dht22_reading <= '0';
		when state_btn => 
			fsm_display_ei <= '0';
			fsm_dht22_reading <= '0';
		when state_read =>  
			fsm_display_ei <= '0';
			fsm_dht22_reading <= '1';
		when state_done => 
			fsm_display_ei <= '1';
			fsm_dht22_reading <= '0';
		when others => fsm_error <= '1';
	end case;
end process;

end driver;