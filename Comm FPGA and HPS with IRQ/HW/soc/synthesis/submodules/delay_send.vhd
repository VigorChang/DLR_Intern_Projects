library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity delay_send is
	port(
		clk       : in std_logic;
		reset     : in std_logic;
		delay_in  : in std_logic_vector(3 downto 0);
		
		read_sig  : in std_logic;
		irq       : out std_logic;
		delay_out : out std_logic_vector(7 downto 0)
	);
end delay_send;

architecture behave of delay_send is

	signal delay_last : std_logic_vector(3 downto 0);
	signal delay_now  : std_logic_vector(3 downto 0);

begin

	detect_change : process(clk) begin
		if rising_edge(clk) then
			delay_last <= delay_now;
			delay_now <= delay_in;
			if (reset = '1') then
				irq <= '0';
			elsif (delay_last /= delay_now) then
				irq <= '1';
			elsif (read_sig = '1') then
				irq <= '0';
			end if;
		end if;
	end process;
	
	delay_out(3 downto 0) <= delay_now;

end behave;