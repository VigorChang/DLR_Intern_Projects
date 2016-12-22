library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity waveCtrl is
	port(
		clk : in std_logic; --TXCLK
		reset : in std_logic;
		--8 bit data input
		dataInput : in std_logic_vector(7 downto 0);
		--Data clk output
		data_clk_out : out std_logic;
		--TX output
		TXD : out std_logic_vector(11 downto 0);
		TXIQSEL : out std_logic
	);
end waveCtrl;

architecture behave of waveCtrl is

	component sinewave is
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
	end component;
	
	signal clk_in : std_logic;
	signal clk_half : std_logic := '0';
	signal counter : std_logic_vector(5 downto 0) := (others => '0');
	signal dataInner : std_logic_vector(7 downto 0);
	signal in_bit : std_logic := '0';
	signal qu_bit : std_logic := '0';
	
	signal last_in_bit : std_logic := '0';
	signal last_qu_bit : std_logic := '0';
	signal now_in_bit : std_logic := '0';
	signal now_qu_bit : std_logic := '0';
	
	signal TXI : std_logic_vector(11 downto 0);
	signal TXQ : std_logic_vector(11 downto 0);

begin
	
	--half clk process
	clk_in <= clk;
	halfCLK_pro : process(clk_in) begin
		if rising_edge(clk_in) then
			clk_half <= not clk_half;
		end if;
	end process;
	TXIQSEL <= clk_half;
	TXD <= TXI when(clk_half = '1') else
			 TXQ;
	--Counter part
	conter_pro : process(clk_half) begin
		if rising_edge(clk_half) then
			counter <= counter + 1;
		end if;
	end process;
	--connect signal
	dataInner <= dataInput;
	--connect component sinewave
	sinewave_generate : sinewave port map(clk_half,reset,in_bit,qu_bit,TXI,TXQ);
	--last bit process
	last_bit_pro : process(counter(3)) begin
		if falling_edge(counter(3)) then
			last_in_bit <= in_bit;
			last_qu_bit <= qu_bit;
			--now in/qu bit
			--if (counter(5 downto 4) = "00") then
			--	now_in_bit <= dataInner(0);
			--	now_qu_bit <= dataInner(1);
			--elsif (counter(5 downto 4) = "01") then
			--	now_in_bit <= dataInner(2);
			--	now_qu_bit <= dataInner(3);
			--elsif (counter(5 downto 4) = "10") then
			--	now_in_bit <= dataInner(4);
			--	now_qu_bit <= dataInner(5);
			--elsif (counter(5 downto 4) = "11") then
			--	now_in_bit <= dataInner(6);
			--	now_qu_bit <= dataInner(7);
			--end if;
		end if;
	end process;
	--in_bit output
	now_in_bit <= dataInner(0) when(counter(5 downto 4) = "00") else
					  dataInner(2) when(counter(5 downto 4) = "01") else
				     dataInner(4) when(counter(5 downto 4) = "10") else
				     dataInner(6) when(counter(5 downto 4) = "11") else
				     '0';
	in_bit <= now_in_bit xor last_in_bit;
	--qu_bit output
	now_qu_bit <= dataInner(1) when(counter(5 downto 4) = "00") else
					  dataInner(3) when(counter(5 downto 4) = "01") else
					  dataInner(5) when(counter(5 downto 4) = "10") else
					  dataInner(7) when(counter(5 downto 4) = "11") else
					  '0';
	qu_bit <= now_qu_bit xor last_qu_bit;
	--data clk output part
	data_clk_out <= not counter(5);

end behave;