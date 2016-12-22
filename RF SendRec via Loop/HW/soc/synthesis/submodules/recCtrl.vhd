library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity recCtrl is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--HPS Avalon MM interface
		write_data : in std_logic_vector(7 downto 0);
		write_en : in std_logic;
		--RFReceive interface
		RecEnable : out std_logic
	);
end recCtrl;

architecture behave of recCtrl is

	signal write_data_in : std_logic_vector(7 downto 0);
	signal rec_en : std_logic := '0';
	signal en : std_logic := '0';

begin

	write_data_in <= write_data;
	rec_en <= write_data_in(0);
	
	rec_en_pro : process(rec_en) begin
		if rising_edge(rec_en) then
			en <= not en;
		end if;
	end process;

	RecEnable <= en;
	
end behave;