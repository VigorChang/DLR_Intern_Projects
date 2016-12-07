library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity delay_ctrl is
	port(
		clk    : in std_logic;
		faster : in std_logic;
		slower : in std_logic;
		delay  : out std_logic_vector (3 downto 0);
		reset  : in std_logic
	);
end delay_ctrl;

architecture behave of delay_ctrl is

	signal delay_ori : std_logic_vector (3 downto 0) := "1000";

begin
	
	delay <= delay_ori;
	
	adjust : process(clk) begin
		if rising_edge(clk) then
			if (reset = '1') then
				delay_ori <= "1000";
			elsif (reset = '0' and slower = '1') then
				if (delay_ori = "0001") then
					delay_ori <= "0001";
				else
					delay_ori <= delay_ori - 1;
				end if;
			elsif (reset = '0' and faster = '1') then
				if (delay_ori = "1111") then
					delay_ori <= "1111";
				else
					delay_ori <= delay_ori + 1;
				end if;
			else
				delay_ori <= delay_ori;
			end if;
		end if;
	end process;
	
end behave;