
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity dht22 is 
generic (CLK_NS: positive := 20); -- 50 MHZ
port(
	dht22_sda: inout std_logic;
	dht22_clk, dht22_reading: in std_logic;
	dht22_done: out std_logic;
	dht22_hum_result, dht22_temp_result: out integer
);
end dht22;

architecture driver of dht22 is

constant DELAY_26_US: positive := 26 * 10**3 / CLK_NS + 1;
constant DELAY_30_US: positive := 30 * 10**3 / CLK_NS + 1;
constant DELAY_50_US: positive := 50 * 10**3 / CLK_NS + 1;
constant DELAY_70_US: positive := 70 * 10**3 / CLK_NS + 1;
constant DELAY_80_US: positive := 80 * 10**3 / CLK_NS + 1;
constant DELAY_1_MS:  positive := 1 * 10**6 / CLK_NS + 1;

constant state_idle : std_logic_vector(3 downto 0) := "0000";
constant state_start: std_logic_vector(3 downto 0) := "0001";
constant state_rslv: std_logic_vector(3 downto 0) := "0010";
constant state_read: std_logic_vector(3 downto 0) := "0011";
constant state_end: std_logic_vector(3 downto 0) := "0100";
constant state_check : std_logic_vector(3 downto 0) := "0101";

signal dht22_cur_state, dht22_next_state : std_logic_vector(3 downto 0);

signal count_write, count_rslv, count_read, count_end, index : integer := 0;
signal cur_rslv, prev_rslv, cur_read, prev_read,cur_end, prev_end : std_logic := '0';

signal ready : std_logic := '1';
signal bits : std_logic_vector(39 downto 0);

begin

-- PROCESS THAT SWITCHES BETWEEN STATES
process (dht22_clk)
begin
	if rising_edge(dht22_clk) then 
		dht22_cur_state <= dht22_next_state;
	end if;
end process;

-- PROCESS STATE LOGIC
process (dht22_clk)
variable result_hum_h, result_hum_l, result_temp_h, result_temp_l, result_parity: std_logic_vector(7 downto 0);
variable total : std_logic_vector(31 downto 0);
variable new_count : integer := 0;
begin
	if rising_edge(dht22_clk) then
	case dht22_cur_state is
		when state_idle => 	
			dht22_sda <= '1';
			count_write <= 0;
			count_rslv <= 0;
			count_read <= 0;
			count_end <= 0;

			dht22_done <= '0';

			if dht22_reading = '0' then
				ready <= '1';
			end if;
			
			if dht22_reading = '1' and ready = '1' then 
				dht22_next_state <= state_start;
			else
				dht22_next_state <= state_idle;
			end if;
		when state_start =>
			if count_write = 0 then
				dht22_sda <= '0';		 		-- Pull down for start
			end if;
		
			if count_write = DELAY_1_MS then 		-- Hold down 1MS for Tbe
				dht22_sda <= '1';
			end if;

			if count_write = DELAY_1_MS + DELAY_30_US then 	-- 1 MS for expired time and 30US for Tgo
				dht22_sda <= '0';
				dht22_next_state <= state_rslv;
			else
				dht22_next_state <= state_start;
			end if;

			count_write <= count_write + 1;
		when state_rslv =>
			dht22_sda <= 'Z';
			cur_rslv <= dht22_sda;

			if count_rslv > DELAY_80_US and prev_rslv = '1' and cur_rslv = '0' then -- If Trel and Theh > 80 US and SDA is falling
				cur_rslv <= '0';
				prev_rslv <= '0';
				dht22_next_state <= state_read;
			else
				dht22_next_state <= state_rslv;
			end if;

			prev_rslv <= cur_rslv;
			count_rslv <= count_rslv + 1;
		when state_read =>  
			dht22_sda <= 'Z';
			cur_read <= dht22_sda;
			new_count := 1;

			if prev_read = '1' and cur_read = '0' then 		-- Check SDA is falling
		
				if count_read < DELAY_50_US + DELAY_30_US then 	-- 50US for Tlow and 30US for Thi0
					bits(39 - index) <= '0';
					index <= index + 1;
					new_count := 0;
				end if;
		
				if (count_read > DELAY_50_US + DELAY_30_US) and count_read < DELAY_50_US + DELAY_70_US then  -- 50US for Tlow and 70US for Thi1
					bits(39 - index) <= '1';
					index <= index + 1;
					new_count := 0;
				end if;

			end if;
		
			if index > 39 then
				cur_read <= '0';
				prev_read <= '0';
				index <= 0;
				dht22_next_state <= state_end;
			else
				dht22_next_state <= state_read;
			end if;
	
			prev_read <= cur_read;
			if new_count = 1 then
				count_read <= count_read + 1;
			else
				count_read <= 0;
			end if;
		when state_end => 
			dht22_sda <= 'Z';
			cur_end <= dht22_sda;

			if prev_end = '0' and cur_end = '1' then 
				dht22_next_state <= state_check;
				report "check";
			else
				dht22_next_state <= state_end;
			end if;
			
			prev_end <= cur_end;
			count_end <= count_end + 1;
		when state_check => 
			dht22_sda <= '1';

			result_hum_h := bits(39 downto 32);
			result_hum_l := bits(31 downto 24);
			result_temp_h := bits(23 downto 16);
			result_temp_l := bits(15 downto 8);
			result_parity := bits(7 downto 0);

			total := result_hum_h & result_hum_l & result_temp_h & result_temp_l;

			if total(7 downto 0) = not result_parity then
				report "PARITY CHECK FAILED";
			end if;

			dht22_hum_result <= to_integer(unsigned(result_hum_h & result_hum_l));
			dht22_temp_result <= to_integer(unsigned(result_temp_h & result_temp_l));
			
			dht22_done <= '1';

			ready <= '0';
			dht22_next_state <= state_idle;

		when others => dht22_next_state <= state_idle;
	end case;
	end if;
end process;

end driver;