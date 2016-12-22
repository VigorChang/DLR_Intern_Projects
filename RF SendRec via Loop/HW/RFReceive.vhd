library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity RFReceive is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--Inphase, Streaming interface, FIFO
		rfRec_i_clk : out std_logic;
		rfRec_i_ready : in std_logic;
		rfRec_i_valid : out std_logic;
		rfRec_i_data : out std_logic_vector(15 downto 0);
		--Quardra, Streaming interface, FIFO
		rfRec_q_clk : out std_logic;
		rfRec_q_ready : in std_logic;
		rfRec_q_valid : out std_logic;
		rfRec_q_data : out std_logic_vector(15 downto 0);
		--RF Board interface
		RXD : in std_logic_vector(11 downto 0);
		RXEN : out std_logic;
		RXIQSEL : in std_logic;
		RXCLK : in std_logic;
		--Test LED out
		LED : out std_logic_vector(3 downto 0);
		--Receive control interface
		RecEnable : in std_logic
	);
end RFReceive;

architecture behave of RFReceive is

	signal RX_CLK_IN : std_logic;
	signal rec_en : std_logic;
	signal RXID : std_logic_vector(15 downto 0) := (others => '0');
	signal RXQD : std_logic_vector(15 downto 0) := (others => '0');
	signal RXCLK_FIFO : std_logic := '0';
	signal RX_SEL : std_logic;
	
	signal LEDIN : std_logic_vector(3 downto 0) := (others => '0');

begin
	
	--rfRec_i_data(63 downto 16) <= (others => '0');
	--rfRec_q_data(63 downto 16) <= (others => '0');
	
	LED <= LEDIN;
	LEDIN(0) <= rfRec_i_ready;
	LEDIN(1) <= rfRec_q_ready;
	LEDIN(2) <= rec_en;
	
	RX_CLK_IN <= RXCLK;
	--RX enable
	rec_en <= RecEnable;
	RXEN <= '1';
	--RXEN <= RXCLK_FIFO;
	
	--RX CLK FIFO process, inphase use normal, quardra use negtive
	rxclk_fifo_pro : process(RX_CLK_IN) begin
		if rising_edge(RX_CLK_IN) then
			RXCLK_FIFO <= not RXCLK_FIFO;
		end if;
	end process;
	rfRec_i_clk <= RXCLK_FIFO;
	rfRec_q_clk <= RXCLK_FIFO;
	
	--Receive data from RF Board
	RX_SEL <= RXIQSEL;
	rx_iq_data_pro: process(RX_CLK_IN) begin
		if rising_edge(RX_CLK_IN) then
			if(RX_SEL = '1') then
				RXID(15 downto 4) <= RXD;
				RXID(3 downto 0) <= "0000";
			else
				RXQD(15 downto 4) <= RXD;
				RXQD(3 downto 0) <= "0000";
			end if;
		end if;
	end process;
	
	--Push data into FIFO
	pushdata_pro: process(RXCLK_FIFO) begin
		if rising_edge(RXCLK_FIFO) then
			rfRec_i_data(7 downto 0) <= RXID(15 downto 8);
			rfRec_i_data(15 downto 8) <= RXID(7 downto 0);
			rfRec_q_data(7 downto 0) <= RXQD(15 downto 8);
			rfRec_q_data(15 downto 8) <= RXQD(7 downto 0);
			rfRec_i_valid <= rec_en;
			rfRec_q_valid <= rec_en;
		end if;
	end process;
	

end behave;