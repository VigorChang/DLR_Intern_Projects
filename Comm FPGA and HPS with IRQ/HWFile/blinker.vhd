library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity blinker is
	port(
		clk   : in std_logic;
		delay : in std_logic_vector (3 downto 0);
		led   : out std_logic_vector (3 downto 0);
		reset : in std_logic;
		pause : in std_logic
	);
end blinker;

architecture behave of blinker is

	signal counter : std_logic_vector (23 downto 0) := (others => '0');
	signal posi    : std_logic_vector (2 downto 0) := "000";
	signal running : std_logic := '1';

begin

	led <= "0001" when (posi = "000") else
	       "0010" when (posi = "001") else
			 "0100" when (posi = "010") else
			 "1000" when (posi = "011") else
			 "0100" when (posi = "100") else
			 "0010" when (posi = "101") else
			 "0000";
	running <= pause;
	position_decision : process(clk) begin
		if rising_edge(clk) then
			if (reset = '1') then
				counter <= (others => '0');
				posi <= "000";
			elsif (reset = '0' and running = '1') then
				if (counter = 0) then
					counter(23 downto 20) <= delay;
					counter(19 downto 0) <= (others => '0');
					if (posi = "101") then
						posi <= "000";
					else
						posi <= posi+1;
					end if;
				else
					counter <= counter -1;
				end if;
			end if;
		end if;
	end process;

end behave;