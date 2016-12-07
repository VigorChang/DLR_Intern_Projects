library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pause_rec is
	port(
		clk        : in std_logic;
		reset      : in std_logic;
		write_data : in std_logic_vector(7 downto 0);
		write_en   : in std_logic;
		pause      : out std_logic
	);
end pause_rec;

architecture behave of pause_rec is

	signal pause_in : std_logic := '0';

begin

	pause_in <= write_data(0);
	
	output_pause : process(clk) begin
		if rising_edge(clk) then
			pause <= pause_in;
		end if;
	end process;

end behave;