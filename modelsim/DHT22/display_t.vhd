LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY display_t IS
END ENTITY;

architecture testbench of display_t is

component display is
port(
	display_in: in integer;
	display_ssd_0, display_ssd_1, display_ssd_2: out std_logic_vector(6 downto 0)
);
end component;

signal display_t_in: integer;
signal display_t_ssd_0, display_t_ssd_1, display_t_ssd_2: std_logic_vector(6 downto 0);
 
begin
	displ: display port map (
		display_in => display_t_in,
		display_ssd_0 => display_t_ssd_0,
		display_ssd_1 => display_t_ssd_1,
		display_ssd_2 => display_t_ssd_2
	);

	process
	begin
		WAIT FOR 10 ns;
		display_t_in <= 641;

		WAIT FOR 10 ns;
		display_t_in <= 394;

		WAIT FOR 10 ns;
		display_t_in <= 73;

		WAIT FOR 10 ns;
		display_t_in <= 8;

 		report "Test completed.";
		wait;
	end process;
end architecture;