library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity rfDemo is
	port(
		clk : in std_logic;
		--interface for lms6002d
		TXD : out std_logic_vector(11 downto 0);
		TXEN : out std_logic;
		TXIQSEL : out std_logic;
		TXCLK : in std_logic;
		
		RXD : in std_logic_vector(11 downto 0);
		RXEN : out std_logic;
		RXIQSEL : in std_logic;
		RXCLK : in std_logic;
		--LED test
		LED : out std_logic_vector(3 downto 0);
		--memory
		memory_mem_a       : out   std_logic_vector(14 downto 0);                    --     memory.mem_a
		memory_mem_ba      : out   std_logic_vector(2 downto 0);                     --           .mem_ba
		memory_mem_ck      : out   std_logic;                                        --           .mem_ck
		memory_mem_ck_n    : out   std_logic;                                        --           .mem_ck_n
		memory_mem_cke     : out   std_logic;                                        --           .mem_cke
		memory_mem_cs_n    : out   std_logic;                                        --           .mem_cs_n
		memory_mem_ras_n   : out   std_logic;                                        --           .mem_ras_n
		memory_mem_cas_n   : out   std_logic;                                        --           .mem_cas_n
		memory_mem_we_n    : out   std_logic;                                        --           .mem_we_n
		memory_mem_reset_n : out   std_logic;                                        --           .mem_reset_n
		memory_mem_dq      : inout std_logic_vector(31 downto 0) := (others => '0'); --           .mem_dq
		memory_mem_dqs     : inout std_logic_vector(3 downto 0)  := (others => '0'); --           .mem_dqs
		memory_mem_dqs_n   : inout std_logic_vector(3 downto 0)  := (others => '0'); --           .mem_dqs_n
		memory_mem_odt     : out   std_logic;                                        --           .mem_odt
		memory_mem_dm      : out   std_logic_vector(3 downto 0);                     --           .mem_dm
		memory_oct_rzqin   : in    std_logic                     := '0';             --           .oct_rzqin
		reset_reset_n      : in    std_logic                     := '0'
	);
end rfDemo;

architecture behave of rfDemo is

	component waveCtrl is
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
	end component;
	
	component soc is
		port(
			clk_clk            : in    std_logic                     := '0';             --        clk.clk
			memory_mem_a       : out   std_logic_vector(14 downto 0);                    --     memory.mem_a
			memory_mem_ba      : out   std_logic_vector(2 downto 0);                     --           .mem_ba
			memory_mem_ck      : out   std_logic;                                        --           .mem_ck
			memory_mem_ck_n    : out   std_logic;                                        --           .mem_ck_n
			memory_mem_cke     : out   std_logic;                                        --           .mem_cke
			memory_mem_cs_n    : out   std_logic;                                        --           .mem_cs_n
			memory_mem_ras_n   : out   std_logic;                                        --           .mem_ras_n
			memory_mem_cas_n   : out   std_logic;                                        --           .mem_cas_n
			memory_mem_we_n    : out   std_logic;                                        --           .mem_we_n
			memory_mem_reset_n : out   std_logic;                                        --           .mem_reset_n
			memory_mem_dq      : inout std_logic_vector(31 downto 0) := (others => '0'); --           .mem_dq
			memory_mem_dqs     : inout std_logic_vector(3 downto 0)  := (others => '0'); --           .mem_dqs
			memory_mem_dqs_n   : inout std_logic_vector(3 downto 0)  := (others => '0'); --           .mem_dqs_n
			memory_mem_odt     : out   std_logic;                                        --           .mem_odt
			memory_mem_dm      : out   std_logic_vector(3 downto 0);                     --           .mem_dm
			memory_oct_rzqin   : in    std_logic                     := '0';             --           .oct_rzqin
			reccontrol_enrec   : out   std_logic;                                        -- reccontrol.enrec
			reset_reset_n      : in    std_logic                     := '0';             --      reset.reset_n
			rfrec_rxclock      : in    std_logic                     := '0';             --      rfrec.rxclock
			rfrec_rxdata       : in    std_logic_vector(11 downto 0) := (others => '0'); --           .rxdata
			rfrec_rxenable     : out   std_logic;                                        --           .rxenable
			rfrec_rxiq         : in    std_logic                     := '0';             --           .rxiq
			rfrec_recen        : in    std_logic                     := '0';             --           .recen
			rfrec_testled      : out   std_logic_vector(3 downto 0)                      --           .testled
		);
	end component;
	
	signal TXCLK_in : std_logic;
	signal now_data : std_logic_vector(7 downto 0);
	signal dataCounterCLK : std_logic;
	signal dataCoutner : std_logic_vector(1 downto 0) := (others => '0');
	
	signal sig_rxenable : std_logic;

begin

	--TX part
	TXEN <= '1';
	TXCLK_in <= TXCLK;
	outputWave : waveCtrl port map(TXCLK_in,reset_reset_n,now_data,dataCounterCLK,TXD,TXIQSEL);
	
	--TX data processing
	data_counter_pro : process(dataCounterCLK) begin
		if rising_edge(dataCounterCLK) then
			dataCoutner <= dataCoutner + 1;
		end if;
	end process;
	
	now_data <= x"F0" when(dataCoutner = "00") else
					x"F0" when(dataCoutner = "01") else
					x"C6" when(dataCoutner = "10") else
					x"A3" when(dataCoutner = "11") else
					x"00";

	--RX part
	u1 : soc port map(
		clk,
		
		memory_mem_a,
		memory_mem_ba,
		memory_mem_ck,
		memory_mem_ck_n,
		memory_mem_cke,
		memory_mem_cs_n,
		memory_mem_ras_n,
		memory_mem_cas_n,
		memory_mem_we_n,
		memory_mem_reset_n,
		memory_mem_dq,
		memory_mem_dqs,
		memory_mem_dqs_n,
		memory_mem_odt,
		memory_mem_dm,
		memory_oct_rzqin,
		
		sig_rxenable,
		
		reset_reset_n,
		
		RXCLK,
		RXD,
		RXEN,
		RXIQSEL,
		sig_rxenable,
		LED
	);
	
	
end behave;