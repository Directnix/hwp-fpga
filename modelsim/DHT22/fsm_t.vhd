library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fsm_t is
end entity;

architecture testbench of fsm_t is

	component fsm is
		port (
			fsm_sda : inout std_logic;
			fsm_clk, fsm_btn_0 : in std_logic;
			fsm_ssd_0, fsm_ssd_1, fsm_ssd_2 : out std_logic_vector(6 downto 0)
		);
	end component;
 
	constant clk_period : time := 20 ns;
 
	signal singer_bus : std_logic := 'H';
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal fsm_ssd_0_t, fsm_ssd_1_t, fsm_ssd_2_t : std_logic_vector(6 downto 0);
 
	function random_slv(slv_length : positive) return std_logic_vector is
	constant rand_bits : positive := 23;
	constant end_bits : natural := slv_length rem rand_bits;
 
	variable output : std_logic_vector(slv_length - 1 downto 0);
	variable seed1, seed2 : positive := 65; -- required for the uniform function
	variable rand : real;
begin
	for i in 0 to slv_length/rand_bits - 1 loop
		uniform(seed1, seed2, rand); -- create random float
		output((i + 1) * rand_bits - 1 downto i * rand_bits) := std_logic_vector(to_unsigned(integer(rand * (2.0 ** rand_bits)), rand_bits));
	end loop;
	-- fill final bits (< 23, so above loop will not work
	uniform(seed1, seed2, rand);
	if end_bits /= 0 then
		output(slv_length - 1 downto slv_length - end_bits) := std_logic_vector(to_unsigned(integer(rand * (2.0 ** end_bits)), end_bits));
	end if; return output;
end function;

constant test_data_length : positive := 40;
constant test_data : std_logic_vector(test_data_length - 1 downto 0) := random_slv(test_data_length);

begin
	uut : fsm
	port map(
		fsm_sda => singer_bus, 
		fsm_clk => clk, 
		fsm_btn_0 => rst, 
		fsm_ssd_0 => fsm_ssd_0_t, 
		fsm_ssd_1 => fsm_ssd_1_t, 
		fsm_ssd_2 => fsm_ssd_2_t
	);

	-- clock stimuli
	clk_process : process begin
		clk <= '0', '1' after clk_period/2;
		wait for clk_period;
	end process;

	singer_bus <= 'H';

	bus_proc : process

		function to_string(input : std_logic_vector) return string is
		variable output : string(1 to input'length);
		variable j : positive := 1;
	begin
		for i in input'range loop
			output(j) := std_logic'image(input(i))(2);
			j := j + 1;
		end loop; return output;
	end function;

	begin
		wait for 1 ms;
		rst <= '0';
		wait for 1 ms;
		rst <= '1';

		wait for 6 ms; 
		singer_bus <= 'Z'; -- wait response for slave
		wait for 40 us;
		singer_bus <= '0'; -- slave pull low 
		wait for 80 us;
		singer_bus <= 'Z'; -- slave pull up
		wait for 80 us;

		for i in test_data'range loop
			singer_bus <= '0'; -- slave start data transmission
			wait for 50 us;
			singer_bus <= 'Z'; -- slave send bit;

			case test_data(i) is
				when '0' => wait for 24 us;
				when '1' => wait for 68 us;
				when others => 
					report "metavalues NOT supported FOR bus_proc send_data" severity failure;
			end case;

			singer_bus <= '0';
		end loop;

		wait for 100 us; -- final delay
		singer_bus <= 'Z'; -- release bus

		wait;
	end process;

end architecture;