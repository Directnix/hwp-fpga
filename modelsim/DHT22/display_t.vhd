LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY display_t IS
END ENTITY;

architecture testbench of display_t is

component display is
port(
	display_ei: in std_logic;
	display_in: in std_logic_vector(15 downto 0);
	display_ssd_0, display_ssd_1, display_ssd_2: out std_logic_vector(6 downto 0)
);
end component;

signal display_t_ei: std_logic;
signal display_t_in: std_logic_vector(15 downto 0);
signal display_t_ssd_0, display_t_ssd_1, display_t_ssd_2: std_logic_vector(6 downto 0);
 
begin
	displ: display port map (
		display_ei => display_t_ei,
		display_in => display_t_in,
		display_ssd_0 => display_t_ssd_0,
		display_ssd_1 => display_t_ssd_1,
		display_ssd_2 => display_t_ssd_2
	);

	process
	begin
		display_t_ei <= '1';

		WAIT FOR 10 ns;
		display_t_in <= "1000011010000110";

		WAIT FOR 10 ns;
		display_t_in <= "0001011100010111";

		WAIT FOR 10 ns;
		display_t_in <= "0000000000001010";

		WAIT FOR 10 ns;
		display_t_in <= "0000000000000100";

		display_t_ei <= '0';
		WAIT FOR 10 ns;
		display_t_in <= "1000011010000110";

 		report "Test completed.";
		wait;
	end process;
end architecture;