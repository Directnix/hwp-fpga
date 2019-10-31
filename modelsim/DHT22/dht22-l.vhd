library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity dht2 is
    generic (
        clk_period_ns : positive := 20;    -- 50mhz
        data_width: positive:= 40);
    port(
        clk,rst : in std_logic ;
        singer_bus: inout std_logic; 
        dataout: out std_logic_vector(data_width-1 downto 0);
        tick_done: out std_logic
        ); 
end entity;

architecture rtl of dht2 is
    constant delay_1_ms: positive := 1*10**6/clk_period_ns+1;
    constant delay_40_us: positive := 40*10**3/clk_period_ns+1;
    constant delay_80_us: positive := 80*10**3/clk_period_ns+1;
    constant delay_50_us: positive := 50*10**3/clk_period_ns+1; -- 
    constant time_70_us: positive := 70*10**3/clk_period_ns+1; --bit  > 70 us 
    constant time_28_us: positive := 28*10**3/clk_period_ns+1; -- bit 0 > 28 us 
    constant max_delay  : positive := 5*10**6/clk_period_ns+1; -- 5 ms

    signal input_sync : std_logic_vector(0 to 2); 

    type state_type is (reset,start_m,wait_res_sl,response_sl,delay_sl,start_sl,consider_logic,end_sl);
    signal state : state_type; 
    signal delay_counter : natural range 0 to max_delay; 
    signal data_out : std_logic_vector (data_width-1 downto 0);
    signal bus_rising_edge, bus_falling_edge : boolean;
    signal number_bit : natural range 0 to data_width; 
    signal oe: std_logic;  -- help to set input and output port.

begin
    input_syncronizer : process(clk) begin
        if rising_edge(clk) then
            input_sync <= to_x01(singer_bus)&input_sync(0 to 1);
        end if;
    end process;

    bus_rising_edge <= input_sync(1 to 2) = "10";
    bus_falling_edge <= input_sync(1 to 2) = "01";

    --register
    regis_state:process (clk)
	begin
        if rising_edge(clk) then
            case(state) is
                when reset =>   -- initial
                    if delay_counter = 0 then 
                        number_bit <= data_width;
                        oe <= '1'; 
                        delay_counter <= delay_1_ms;
                        state <= start_m; 
                    else
                        delay_counter <= delay_counter - 1;                    
                    end if;     
                when start_m =>  -- master send '1' in 1ms
                    if delay_counter = 0 then 
                        oe <= '0'; 
                        delay_counter <= delay_40_us;
                        state <= wait_res_sl;
                    else 
                        delay_counter <= delay_counter -1;
                    end if ;
                when wait_res_sl => -- wait for slave response in 40us  --
                    if bus_falling_edge then  -- 
                        state <= response_sl;
                    end if; 
                when response_sl => -- slave response in 80us 
                    if bus_rising_edge then 
                        state <= delay_sl;
                    end if;
                when delay_sl => -- wait for slave delay in 80us 
                    if bus_falling_edge then 
                        state <= start_sl;
                    end if;
                when start_sl => -- start to prepare in 50us                
                    if bus_rising_edge then
                        delay_counter <= 0;
                        state <= consider_logic;
                    elsif number_bit = 0 then 
                        delay_counter <= delay_50_us;
                        state <= end_sl;
                    end if;
                when consider_logic => -- determine 1 bit-data of slave 
                    if bus_falling_edge then -- the end of logic state
                        number_bit <= number_bit - 1;
                        if (delay_counter < time_28_us) then -- time ~ 28 us - logic = '0'
                            data_out <= data_out(data_width-2 downto 0) & '0';
                        elsif (delay_counter < time_70_us) then -- time ~70 us - logic ='1' 
                            data_out <= data_out(data_width-2 downto 0) & '1'; 
                        end if;
                        delay_counter <= delay_50_us;  
                        state <= start_sl; 
                    end if;
                    delay_counter <= delay_counter + 1;
                when end_sl => -- tick_done = '1' then dataout has full 40 bit. 
                    if delay_counter = 0 then 
                        delay_counter <= max_delay; 
                        state <= reset;    
                    else 							
                        dataout <= data_out;
			tick_done <= '1';
                        delay_counter <= delay_counter - 1; 											
                    end if;
            end case;
            if rst = '1' then 
                number_bit <= 0;
                data_out <= (others => '0');
                delay_counter <= max_delay; 
                state <= reset; 
            end if;
        end if; 
    end process regis_state; 
    --tristate iobuffer
    singer_bus <= '0' when oe ='1' else 'Z';
end architecture;
