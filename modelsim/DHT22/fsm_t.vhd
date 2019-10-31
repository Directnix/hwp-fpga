LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fsm_t IS
END ENTITY;

architecture testbench of fsm_t is

component fsm is
port(
	fsm_sda: inout std_logic;
	fsm_clk, fsm_btn_0: in std_logic;
	fsm_ssd_0, fsm_ssd_1, fsm_ssd_2: out std_logic_vector(6 downto 0)
);
end component;

constant clk_period : time := 20 ns;

signal fsm_sda_t:  std_logic;
signal fsm_clk_t:  std_logic := '0';
signal fsm_btn_0_t: std_logic := '1';
signal fsm_ssd_0_t, fsm_ssd_1_t, fsm_ssd_2_t: std_logic_vector(6 downto 0);

begin
	dht22_fsm: fsm port map (
		fsm_sda => fsm_sda_t,
		fsm_clk => fsm_clk_t,
		fsm_btn_0 => fsm_btn_0_t,
		fsm_ssd_0 => fsm_ssd_0_t,
		fsm_ssd_1 => fsm_ssd_1_t,
		fsm_ssd_2 => fsm_ssd_2_t
	);

	process
	begin
		report "Start the test!";

		-- PRESS AND RELEASE BUTTON
		fsm_sda_t <= 'Z';

		wait for 1 ns;
		fsm_btn_0_t <= '0';
		wait for 2 ms;
		fsm_btn_0_t <= '1';
		
		-- WAIT FOR WRITE
		wait for 1 ms;
		wait for 40 us;

		-- DHT22 RESOLVE
		fsm_sda_t <= '0';
		wait for 80 us;
		fsm_sda_t <= '1';
		wait for 80 us;

		-- WRITE HUM H BYTE 
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;		
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		
		-- WRITE HUM L BYTE 
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;		
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;

		-- WRITE TEMP H BYTE 
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
			
		-- WRITE TEMP L BYTE 
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;

		-- WRITE PARITY BYTE 
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 1;
		wait for 68 us;
		fsm_sda_t <= '0';  
		wait for 50 us;
		fsm_sda_t <= '1';  -- 0;
		wait for 24 us;

		-- WAIT Ten
		fsm_sda_t <= '0';
		wait for 50 us;
		fsm_sda_t <= '1';
		
		wait for 1 us;
		fsm_sda_t <= 'Z';

		report "Test done";
		wait;
	end process;

	fsm_clk_t <= not fsm_clk_t after clk_period / 2;

end architecture;