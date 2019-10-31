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
	fsm_ssd_0, fsm_ssd_1, fsm_ssd_2, fsm_ssd_5: out std_logic_vector(6 downto 0)
);
end fsm;

architecture driver of fsm is

constant state_idle : std_logic_vector(3 downto 0) := "0000";
constant state_btn: std_logic_vector(3 downto 0) := "0001";
constant state_read: std_logic_vector(3 downto 0) := "0010";
constant state_done : std_logic_vector(3 downto 0) := "0011";

component ssd is
port(
	ssd_in: in std_logic_vector(3 downto 0);
	ssd_seg: out std_logic_vector(6 downto 0)
);
end component;

component display is
port(
	display_ei: in std_logic;
	display_in: in integer;
	display_ssd_0, display_ssd_1, display_ssd_2: out std_logic_vector(6 downto 0)
);
end component;

--component dht22 is
--port(
--	dht22_sda: inout std_logic;
--	dht22_clk, dht22_reading: in std_logic;
--	dht22_done: out std_logic;
--	dht22_hum_result, dht22_temp_result: out integer;
--	dht22_state_ssd: out std_logic_vector(6 downto 0)
--);
--end component;
component dht2 is
port(		
		clk,rst : in std_logic ;
		singer_bus: inout std_logic; 
		dataout: out std_logic_vector (39 downto 0);
		tick_done: out std_logic;
		dht2_hum_result, dht2_temp_result: out integer
);
end component;

signal fsm_dht22_reading, fsm_dht22_read_done, fsm_error, fsm_display_ei: std_logic := '0'; 
signal fsm_cur_state, fsm_next_state : std_logic_vector(3 downto 0);
signal fsm_dht22_hum_result_out, fsm_dht22_temp_result_out: integer := 100;
signal fsm_dht22_hum_result, fsm_dht22_temp_result: integer := 100;

signal reset: std_logic := '0';
signal fsm_data_out: std_logic_vector (39 downto 0);

begin

state_ssd: ssd port map (
	ssd_in => fsm_cur_state,
	ssd_seg => fsm_ssd_5
);

displ: display port map (
	display_ei    => fsm_display_ei,
	display_in    => fsm_dht22_hum_result,
	display_ssd_0 => fsm_ssd_0,
	display_ssd_1 => fsm_ssd_1,
	display_ssd_2 => fsm_ssd_2
);

--sensor: dht22 port map (
--	dht22_sda     => fsm_sda,
--	dht22_clk     => fsm_clk,
--	dht22_reading => fsm_dht22_reading,
--	dht22_done    => fsm_dht22_read_done,
--	dht22_hum_result  => fsm_dht22_hum_result,
--	dht22_temp_result  => fsm_dht22_temp_result,
--	dht22_state_ssd => fsm_ssd_4
--);

sensor: dht2 port map(
		clk => fsm_clk,
		rst => fsm_dht22_reading,
		singer_bus => fsm_sda,
		dataout => fsm_data_out,
		tick_done => fsm_dht22_read_done,
		dht2_hum_result => fsm_dht22_hum_result_out, 
		dht2_temp_result => fsm_dht22_temp_result_out
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
		when state_read	=> if fsm_dht22_read_done = '1' then fsm_next_state <= state_done; else fsm_next_state <= state_read; end if;
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

fsm_dht22_hum_result <= to_integer(unsigned(fsm_data_out(39 downto 32) & fsm_data_out(31 downto 24)));
fsm_dht22_temp_result <= to_integer(unsigned(fsm_data_out(23 downto 16) & fsm_data_out(15 downto 8)));

end driver;