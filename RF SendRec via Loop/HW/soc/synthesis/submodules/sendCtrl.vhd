library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sendCtrl is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--HPS Avalon MM interface
		write_data : in std_logic_vector(7 downto 0);
		write_en : in std_logic;
		--RFSend interface
		SendEnable : out std_logic
	);
end sendCtrl;

architecture behave of sendCtrl is
	
	signal write_data_in : std_logic_vector(7 downto 0);
	signal send_en : std_logic := '0';
	signal en : std_logic := '0';

begin
	
	write_data_in <= write_data;
	send_en <= write_data_in(0);
	
	output_enable_pro : process(send_en) begin
		if rising_edge(send_en) then
			en <= not en;
		end if;
	end process;
	
	SendEnable <= en;
	
end behave;