library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity rfDemo is
	port(
		CLK_50 : in std_logic;
		
		memory_mem_a             : out   std_logic_vector(14 downto 0);
		memory_mem_ba            : out   std_logic_vector(2 downto 0);
		memory_mem_ck            : out   std_logic;
		memory_mem_ck_n          : out   std_logic;
		memory_mem_cke           : out   std_logic;
		memory_mem_cs_n          : out   std_logic;
		memory_mem_ras_n         : out   std_logic;
		memory_mem_cas_n         : out   std_logic;
		memory_mem_we_n          : out   std_logic;
		memory_mem_reset_n       : out   std_logic;
		memory_mem_dq            : inout std_logic_vector(31 downto 0);
		memory_mem_dqs           : inout std_logic_vector(3 downto 0);
		memory_mem_dqs_n         : inout std_logic_vector(3 downto 0);
		memory_mem_odt           : out   std_logic;
		memory_mem_dm            : out   std_logic_vector(3 downto 0);
		memory_oct_rzqin         : in    std_logic;
		reset_reset_n            : in    std_logic;
		
		TXD : out std_logic_vector(11 downto 0);
		TXEN : out std_logic;
		TXIQSEL : out std_logic;
		TXCLK : in std_logic
	);
end rfDemo;

architecture behave of rfDemo is

	signal mainclk : std_logic;
	signal sendEnable : std_logic := '0';
	
	component soc is
		port(
			clk_clk                     : in    std_logic                     := '0';             --                 clk.clk
			memory_mem_a                : out   std_logic_vector(14 downto 0);                    --              memory.mem_a
			memory_mem_ba               : out   std_logic_vector(2 downto 0);                     --                    .mem_ba
			memory_mem_ck               : out   std_logic;                                        --                    .mem_ck
			memory_mem_ck_n             : out   std_logic;                                        --                    .mem_ck_n
			memory_mem_cke              : out   std_logic;                                        --                    .mem_cke
			memory_mem_cs_n             : out   std_logic;                                        --                    .mem_cs_n
			memory_mem_ras_n            : out   std_logic;                                        --                    .mem_ras_n
			memory_mem_cas_n            : out   std_logic;                                        --                    .mem_cas_n
			memory_mem_we_n             : out   std_logic;                                        --                    .mem_we_n
			memory_mem_reset_n          : out   std_logic;                                        --                    .mem_reset_n
			memory_mem_dq               : inout std_logic_vector(31 downto 0) := (others => '0'); --                    .mem_dq
			memory_mem_dqs              : inout std_logic_vector(3 downto 0)  := (others => '0'); --                    .mem_dqs
			memory_mem_dqs_n            : inout std_logic_vector(3 downto 0)  := (others => '0'); --                    .mem_dqs_n
			memory_mem_odt              : out   std_logic;                                        --                    .mem_odt
			memory_mem_dm               : out   std_logic_vector(3 downto 0);                     --                    .mem_dm
			memory_oct_rzqin            : in    std_logic                     := '0';             --                    .oct_rzqin
			reset_reset_n               : in    std_logic                     := '0';             --               reset.reset_n
			rfsend_conduit_en_in        : in    std_logic;                                        --      rfsend_conduit.en_in
			rfsend_conduit_rftxdata     : out   std_logic_vector(11 downto 0);                    --                    .rftxdata
			rfsend_conduit_rftxen       : out   std_logic;                                        --                    .rftxen
			rfsend_conduit_rftxiqsel    : out   std_logic;                                        --                    .rftxiqsel
			rfsend_txclk_clk            : in    std_logic                     := '0';             --        rfsend_txclk.clk
			sendcontrol_conduit_send_en : out   std_logic                                         -- sendcontrol_conduit.send_en
		);
	end component;

begin
	
	mainclk <= CLK_50;
	soc_u : soc port map(
		mainclk,
		
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
		reset_reset_n,
		
		sendEnable,
		TXD,
		TXEN,
		TXIQSEL,
		TXCLK,
		sendEnable
	);

end behave;