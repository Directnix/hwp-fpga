LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity display is 

port(
	display_ei: in std_logic;
	display_in: in std_logic_vector(15 downto 0);
	display_ssd_0, display_ssd_1, display_ssd_2: out std_logic_vector(6 downto 0)
);
end display;

architecture driver of display is

component ssd is
port(
	ssd_in: in std_logic_vector(3 downto 0);
	ssd_seg: out std_logic_vector(6 downto 0)
);
end component;

signal display_0, display_1, display_2 : std_logic_vector(3 DOWNTO 0); 
signal display_integer: integer := 999;

begin

ssd_0: ssd PORT MAP (ssd_in => display_0, ssd_seg => display_ssd_0);
ssd_1: ssd PORT MAP (ssd_in => display_1, ssd_seg => display_ssd_1);
ssd_2: ssd PORT MAP (ssd_in => display_2, ssd_seg => display_ssd_2);

display_0 <= std_logic_vector(to_unsigned(display_integer mod 10, 4)) when display_ei = '1' else "----";
display_1 <= std_logic_vector(to_unsigned((display_integer / 10) mod 10, 4)) when display_ei = '1' else "----";
display_2 <= std_logic_vector(to_unsigned((display_integer / 100) mod 10, 4)) when display_ei = '1' else "----";

display_integer <= to_integer(unsigned(display_in)) when display_ei = '1' else 0;

end driver;