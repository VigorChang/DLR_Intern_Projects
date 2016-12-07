library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mem is
	port(
		CLK_50 : in std_logic;
		
		memory_mem_a       : out   std_logic_vector(14 downto 0);                    -- memory.mem_a
		memory_mem_ba      : out   std_logic_vector(2 downto 0);                     --       .mem_ba
		memory_mem_ck      : out   std_logic;                                        --       .mem_ck
		memory_mem_ck_n    : out   std_logic;                                        --       .mem_ck_n
		memory_mem_cke     : out   std_logic;                                        --       .mem_cke
		memory_mem_cs_n    : out   std_logic;                                        --       .mem_cs_n
		memory_mem_ras_n   : out   std_logic;                                        --       .mem_ras_n
		memory_mem_cas_n   : out   std_logic;                                        --       .mem_cas_n
		memory_mem_we_n    : out   std_logic;                                        --       .mem_we_n
		memory_mem_reset_n : out   std_logic;                                        --       .mem_reset_n
		memory_mem_dq      : inout std_logic_vector(31 downto 0);                    --       .mem_dq
		memory_mem_dqs     : inout std_logic_vector(3 downto 0);                     --       .mem_dqs
		memory_mem_dqs_n   : inout std_logic_vector(3 downto 0);                     --       .mem_dqs_n
		memory_mem_odt     : out   std_logic;                                        --       .mem_odt
		memory_mem_dm      : out   std_logic_vector(3 downto 0);                     --       .mem_dm
		memory_oct_rzqin   : in    std_logic;                                        --       .oct_rzqin
		reset_reset_n      : in    std_logic                                         --  reset.reset_n
	);
end mem;

architecture behave of mem is
	
	signal main_clk : std_logic;
	
	component soc is
		port(
			clk_clk            : in    std_logic;                                        --    clk.clk
			memory_mem_a       : out   std_logic_vector(14 downto 0);                    -- memory.mem_a
			memory_mem_ba      : out   std_logic_vector(2 downto 0);                     --       .mem_ba
			memory_mem_ck      : out   std_logic;                                        --       .mem_ck
			memory_mem_ck_n    : out   std_logic;                                        --       .mem_ck_n
			memory_mem_cke     : out   std_logic;                                        --       .mem_cke
			memory_mem_cs_n    : out   std_logic;                                        --       .mem_cs_n
			memory_mem_ras_n   : out   std_logic;                                        --       .mem_ras_n
			memory_mem_cas_n   : out   std_logic;                                        --       .mem_cas_n
			memory_mem_we_n    : out   std_logic;                                        --       .mem_we_n
			memory_mem_reset_n : out   std_logic;                                        --       .mem_reset_n
			memory_mem_dq      : inout std_logic_vector(31 downto 0);                    --       .mem_dq
			memory_mem_dqs     : inout std_logic_vector(3 downto 0);                     --       .mem_dqs
			memory_mem_dqs_n   : inout std_logic_vector(3 downto 0);                     --       .mem_dqs_n
			memory_mem_odt     : out   std_logic;                                        --       .mem_odt
			memory_mem_dm      : out   std_logic_vector(3 downto 0);                     --       .mem_dm
			memory_oct_rzqin   : in    std_logic;                                        --       .oct_rzqin
			reset_reset_n      : in    std_logic                                         --  reset.reset_n
		);
	end component;

begin
	
	main_clk <= CLK_50;
	
	soc_real : soc port map(
		main_clk,
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
		reset_reset_n
	);

end behave;