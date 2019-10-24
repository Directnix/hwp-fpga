LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY assignment5_tb IS
END ENTITY;

architecture testbench of assignment5_tb is

component assignment5 is
port(
	clk_50mHz, btn_bgn, btn_rst: in std_logic;
	led_0: out std_logic;
	ssd_0,ssd_6: out std_logic_vector(6 downto 0)
);
end component;

signal clk_tb, btn_bgn_tb, btn_rst_tb: std_logic;
signal led_0_tb: std_logic;
signal ssd_0_tb,ssd_6_tb: std_logic_vector(6 downto 0);
 
begin
	a: assignment5 port map (
		clk_50mHz => clk_tb,
		btn_bgn => btn_bgn_tb,
		btn_rst => btn_rst_tb,
		led_0 => led_0_tb,
		ssd_0 => ssd_0_tb,
		ssd_6 => ssd_6_tb
	);

	process
	begin
		-- idle
		clk_tb <= '0';
		btn_bgn_tb <= '1';
		btn_rst_tb <= '1';

		for i in 0 to 800 loop
			WAIT FOR 10 ns;
 			clk_tb <= not clk_tb;
			
			-- press button for 8 clk cycles, then debounce
			if i > 50 and i < 60 then btn_bgn_tb <= '0'; 
			else btn_bgn_tb <= '1'; end if;

			-- reset
			if i > 300 and i < 302 then btn_rst_tb <= '0'; 
			else btn_rst_tb <= '1'; end if;

		end loop;

 		report "Test completed.";
		wait;
	end process;
end architecture;