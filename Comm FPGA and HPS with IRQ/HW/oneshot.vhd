library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity oneshot is
	port(
		clk       : in std_logic;
		edge_sig  : in std_logic_vector (3 downto 0);
		level_sig : out std_logic_vector (3 downto 0)
	);
end oneshot;

architecture behave of oneshot is

	signal cur_value    : std_logic_vector (3 downto 0);
	signal before_value : std_logic_vector (3 downto 0);

begin

	level_sig <= (not cur_value) and before_value;
	
	key_control : process(clk) begin
		if rising_edge(clk) then
			before_value <= cur_value;
			cur_value <= edge_sig;
		end if;
	end process;

end behave;