
entity dht2_tb is end dht2_tb;

library ieee;
architecture behavior of dht2_tb is 
    use ieee.std_logic_1164.all;
    --inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    --bidirs
    signal singer_bus : std_logic := 'H';
    --outputs
    signal tick_done : std_logic;
    -- clock period definitions
    constant clk_period : time := 20 ns;    -- 50mhz

    use ieee.math_real.all;
    -- This function generates a 'slv_length'-bit std_logic_vector with
    --  random values.
    function random_slv(slv_length : positive) return std_logic_vector is
        variable output : std_logic_vector(slv_length-1 downto 0);
        variable seed1, seed2 : positive := 65; -- required for the uniform function
        variable rand : real;
        -- Assume mantissa of 23, according to IEEE-754:
        --  as UNIFORM returns a 32-bit floating point value between 0 and 1
        --  only 23 bits will be random: the rest has no value to us.
        constant rand_bits : positive := 23;
        -- for simplicity, calculate remaining number of bits here
        constant end_bits : natural := slv_length rem rand_bits;
        use ieee.numeric_std.all;
    begin
        -- fill sets of 23-bit of the output with the random values.
        for i in 0 to slv_length/rand_bits-1 loop
            uniform(seed1, seed2, rand); -- create random float
            -- convert float to int and fill output
            output((i+1)*rand_bits-1 downto i*rand_bits) :=
                std_logic_vector(to_unsigned(integer(rand*(2.0**rand_bits)), rand_bits));
        end loop;
        -- fill final bits (< 23, so above loop will not work.
        uniform(seed1, seed2, rand);
        if end_bits /= 0 then
            output(slv_length-1 downto slv_length-end_bits) :=
                std_logic_vector(to_unsigned(integer(rand*(2.0**end_bits)), end_bits));
        end if;
        return output;
    end function;

    -- input + output definitions
    constant test_data_length : positive := 40;
    constant test_data : std_logic_vector(test_data_length-1 downto 0) := random_slv(test_data_length);
    signal data_out : std_logic_vector(test_data_length-1 downto 0);
begin
    -- instantiate the unit under test (uut)
    uut: entity work.dht2 -- use entity instantiation: no component declaration needed
        generic map (
            clk_period_ns => clk_period / 1 ns,
            data_width => test_data_length)
        port map (
            clk => clk,
            rst => rst,
            singer_bus => singer_bus,
            dataout => data_out,
            tick_done => tick_done
            );

    -- clock stimuli
    clk_process: process begin
        clk <= '0', '1' after clk_period/2;
        wait for clk_period;
    end process;

    -- reset stimuli
    rst_proc : process begin
        rst <= '1', '0' after 100 us;
        wait;
    end process;

    -- bidir bus pull-up
    -- as you drive the bus from the uut and this test bench, it is a bidir
    -- you need to simulate a pull-up ('H' = weak '1'). slv will resolve this.
    singer_bus <= 'H';

    -- stimulus process
    bus_proc: process
        -- we use procedures for stimuli. Increases maintainability of test bench

        -- procedure bus_init initializes the slave device. (copied this from your code)
        procedure bus_init is begin
            wait for 6 ms;  
            singer_bus <= 'Z'; -- wait response for slave 
            wait for 40 us; 
            singer_bus <= '0'; -- slave pull low  
            wait for 80 us; 
            singer_bus <= 'Z'; -- slave pull up
            wait for 80 us; 
        end procedure;

        function to_string(input : std_logic_vector) return string is
            variable output : string(1 to input'length);
            variable j : positive := 1;
        begin
            for i in input'range loop
                output(j) := std_logic'image(input(i))(2);
                j := j + 1;
            end loop;
            return output;
        end function;

        -- procedure send_data 
        procedure send_data(data : std_logic_vector) is begin
            -- we can now send a vector of data,length detected automatically
            for i in data'range loop
                singer_bus <= '0';  -- slave start data transmission 
                wait for 50 us;
                singer_bus <= 'Z';  -- slave send bit;
                -- I found the only difference between sending bit '0'
                --  and '1' is the length of the delay after a '0' was send.
                case data(i) is
                    when '0' => wait for 24 us; 
                    when '1' => wait for 68 us;
                    when others =>
                        report "metavalues not supported for bus_proc send_data"
                            severity failure;
                end case;
                singer_bus <= '0';
            end loop;
        end procedure;
    begin       
        wait until rst = '0';
        bus_init; -- call procedure

        send_data(test_data); -- call procedure

        wait for 100 us; -- final delay
        singer_bus <= 'Z'; -- release bus

        report "received: "&to_string(data_out);
        assert data_out = test_data
            report "data output does not match send data"
            severity error;
        report "end of simulation" severity failure;
    end process;
end architecture;