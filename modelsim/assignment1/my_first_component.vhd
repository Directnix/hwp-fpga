library ieee;
use ieee.std_logic_1164.all;

entity my_first_component is
port (
 inputs: in std_logic_vector(3 downto 0);
 outputs: out std_logic_vector(6 downto 0)
);
end my_first_component;

architecture implementation of my_first_component is
begin
	i0:= not(inputs(0));

	outputs(0) <= i0;
	outputs(1) <= not(inputs(1));
	outputs(2) <= not(inputs(0)) or  not(inputs(1));
	outputs(3) <= not(inputs(0)) and  not(inputs(1));
	outputs(4) <= not(inputs(0)) and  not(inputs(1)) and  not(inputs(2)) and  not(inputs(3));
	outputs(5) <= not(inputs(0)) or  not(inputs(1)) or  not(inputs(2)) or  not(inputs(3));
	outputs(6) <=  not( not(inputs(0)) or  not(inputs(1)) or  not(inputs(2)) or  not(inputs(3));
end implementation;

