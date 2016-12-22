library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sinewave is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--Output Data Switch
		inphase_data : in std_logic;
		quardra_data : in std_logic;
		--Wave Data
		TXI : out std_logic_vector(11 downto 0);
		TXQ : out std_logic_vector(11 downto 0)
	);
end sinewave;

architecture behave of sinewave is

	signal counter : std_logic_vector(3 downto 0) := "0000";
	
	signal nextSinOut : std_logic_vector(11 downto 0);
	signal nextNegSinOut : std_logic_vector(11 downto 0);
	signal nextCosOut : std_logic_vector(11 downto 0);
	signal nextNegCosOut : std_logic_vector(11 downto 0);

begin

	output_pro : process(clk) begin
		if rising_edge(clk) then
			counter <= counter + 1;
			--Inphase Data
			if(inphase_data = '0') then
				TXI <= nextSinOut;
			else
				TXI <= nextNegSinOut;
			end if;
			--Quardra Data
			if(quardra_data = '0') then
				TXQ <= nextCosOut;
			else
				TXQ <= nextNegCosOut;
			end if;
		end if;
	end process;

	nextSinOut <= x"000" when(counter = "1111") else
	              x"30F" when(counter = "0000") else
					  x"5A7" when(counter = "0001") else
					  x"763" when(counter = "0010") else
					  x"7FF" when(counter = "0011") else
					  x"763" when(counter = "0100") else
					  x"5A7" when(counter = "0101") else
					  x"30F" when(counter = "0110") else
					  
					  x"000" when(counter = "0111") else
					  x"CF1" when(counter = "1000") else
					  x"A59" when(counter = "1001") else
					  x"89D" when(counter = "1010") else
					  x"801" when(counter = "1011") else
					  x"89D" when(counter = "1100") else
					  x"A59" when(counter = "1101") else
					  x"CF1" when(counter = "1110") else
					  
					  x"000";
					  
	nextNegSinOut <= x"000" when(counter = "1111") else
						  x"CF1" when(counter = "0000") else
						  x"A59" when(counter = "0001") else
					     x"89D" when(counter = "0010") else
					     x"801" when(counter = "0011") else
					     x"89D" when(counter = "0100") else
					     x"A59" when(counter = "0101") else
					     x"CF1" when(counter = "0110") else
					  
					     x"000" when(counter = "0111") else
					     x"30F" when(counter = "1000") else
					     x"5A7" when(counter = "1001") else
					     x"763" when(counter = "1010") else
					     x"7FF" when(counter = "1011") else
					     x"763" when(counter = "1100") else
					     x"5A7" when(counter = "1101") else
					     x"30F" when(counter = "1110") else
					  
					     x"000";
						  
	nextCosOut <= x"7FF" when(counter = "1111") else
					  x"763" when(counter = "0000") else
					  x"5A7" when(counter = "0001") else
					  x"30F" when(counter = "0010") else
					  x"000" when(counter = "0011") else
					  x"CF1" when(counter = "0100") else
					  x"A59" when(counter = "0101") else
					  x"89D" when(counter = "0110") else
				  
					  x"801" when(counter = "0111") else
					  x"89D" when(counter = "1000") else
					  x"A59" when(counter = "1001") else
					  x"CF1" when(counter = "1010") else
					  x"000" when(counter = "1011") else
					  x"30F" when(counter = "1100") else
					  x"5A7" when(counter = "1101") else
					  x"763" when(counter = "1110") else
				  
					  x"000";
					  
	nextNegCosOut <= x"801" when(counter = "1111") else
						  x"89D" when(counter = "0000") else
						  x"A59" when(counter = "0001") else
						  x"CF1" when(counter = "0010") else
						  x"000" when(counter = "0011") else
						  x"30F" when(counter = "0100") else
						  x"5A7" when(counter = "0101") else
						  x"763" when(counter = "0110") else
						  
						  x"7FF" when(counter = "0111") else
						  x"763" when(counter = "1000") else
						  x"5A7" when(counter = "1001") else
						  x"30F" when(counter = "1010") else
						  x"000" when(counter = "1011") else
						  x"CF1" when(counter = "1100") else
						  x"A59" when(counter = "1101") else
						  x"89D" when(counter = "1110") else
					  
						  x"000";

end behave;