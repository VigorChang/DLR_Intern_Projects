library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity RFSend is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--Inphase, Streaming interface, FIFO
		rfSend_i_clk : out std_logic;
		rfSend_i_ready : out std_logic;
		rfSend_i_valid : in std_logic;
		rfSend_i_data : in std_logic_vector(15 downto 0);
		--Quardra, Streaming interface, FIFO
		rfSend_q_clk : out std_logic;
		rfSend_q_ready : out std_logic;
		rfSend_q_valid : in std_logic;
		rfSend_q_data : in std_logic_vector(15 downto 0);
		--RF Board interface
		TXD : out std_logic_vector(11 downto 0);
		TXEN : out std_logic;
		TXIQSEL : out std_logic;
		TXCLK : in std_logic;
		--Send control interface
		SendEnable : in std_logic
	);
end RFSend;

architecture behave of RFSend is

	signal TX_CLK_IN : std_logic;
	signal send_en : std_logic := '0';
	signal TXID : std_logic_vector(15 downto 0) := (others => '0');
	signal TXQD : std_logic_vector(15 downto 0) := (others => '0');
	signal TX_IQ : std_logic := '0';

begin

	TX_CLK_IN <= TXCLK;
	--TX enable
	send_en <= SendEnable;
	TXEN <= send_en;
	rfSend_i_ready <= send_en;
	rfSend_q_ready <= send_en;
	
	--TX IQ Select part
	--Use falling edge to make sure the tSETUP
	tx_iq_select_pro : process(TX_CLK_IN) begin
		if falling_edge(TX_CLK_IN) then
			TX_IQ <= not TX_IQ;
		end if;
	end process;
	TXIQSEL <= TX_IQ;
	TXD <= TXID(15 downto 4) when(TX_IQ = '1' and send_en = '1') else
			 TXQD(15 downto 4) when(TX_IQ = '0' and send_en = '1') else
			 (others => '0');
	
	--TX Inphase data
	tx_inphase_data_pro : process(TX_IQ) begin
		if rising_edge(TX_IQ) then
			if(rfSend_i_valid = '1') then
				TXID(15 downto 8) <= rfSend_i_data(7 downto 0);
				TXID(7 downto 0) <= rfSend_i_data(15 downto 8);
			else
				TXID <= (others => '0');
			end if;
		end if;
	end process;
	
	--TX Quardra data
	tx_quardra_data_pro : process(TX_IQ) begin
		if rising_edge(TX_IQ) then
			if(rfSend_q_valid = '1') then
				TXQD(15 downto 8) <= rfSend_q_data(7 downto 0);
				TXQD(7 downto 0) <= rfSend_q_data(15 downto 8);
			else
				TXQD <= (others => '0');
			end if;
		end if;
	end process;
	
	--TX inphase and quardra clock
	rfSend_i_clk <= TX_IQ;
	rfSend_q_clk <= TX_IQ;
	

end behave;