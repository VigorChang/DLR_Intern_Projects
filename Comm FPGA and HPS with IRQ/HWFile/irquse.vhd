library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity irquse is
	port(
		CLOCK_50 : in std_logic;
		KEY      : in std_logic_vector (3 downto 0);
		LED      : out std_logic_vector (3 downto 0);
		
		memory_mem_a        : out   std_logic_vector(12 downto 0);
		memory_mem_ba       : out   std_logic_vector(2 downto 0);
		memory_mem_ck       : out   std_logic;
		memory_mem_ck_n     : out   std_logic;
		memory_mem_cke      : out   std_logic;
		memory_mem_cs_n     : out   std_logic;
		memory_mem_ras_n    : out   std_logic;
		memory_mem_cas_n    : out   std_logic;
		memory_mem_we_n     : out   std_logic;
		memory_mem_reset_n  : out   std_logic;
		memory_mem_dq       : inout std_logic_vector(7 downto 0);
		memory_mem_dqs      : inout std_logic;
		memory_mem_dqs_n    : inout std_logic;
		memory_mem_odt      : out   std_logic;
		memory_mem_dm       : out   std_logic;
		memory_oct_rzqin    : in    std_logic;
		reset_reset_n       : in    std_logic
	);
end irquse;

architecture behave of irquse is

	signal key_os   : std_logic_vector (3 downto 0);
	signal delay    : std_logic_vector (3 downto 0);
	signal main_clk : std_logic;
	signal running  : std_logic;
	
	--COMPONENT
	
	component soc is
		port (
			clk_clk                : in    std_logic                     := '0';             --        clk.clk
			delay_send_delay_input : in    std_logic_vector(3 downto 0)  := (others => '0'); -- delay_send.delay_input
			memory_mem_a           : out   std_logic_vector(12 downto 0);                    --     memory.mem_a
			memory_mem_ba          : out   std_logic_vector(2 downto 0);                     --           .mem_ba
			memory_mem_ck          : out   std_logic;                                        --           .mem_ck
			memory_mem_ck_n        : out   std_logic;                                        --           .mem_ck_n
			memory_mem_cke         : out   std_logic;                                        --           .mem_cke
			memory_mem_cs_n        : out   std_logic;                                        --           .mem_cs_n
			memory_mem_ras_n       : out   std_logic;                                        --           .mem_ras_n
			memory_mem_cas_n       : out   std_logic;                                        --           .mem_cas_n
			memory_mem_we_n        : out   std_logic;                                        --           .mem_we_n
			memory_mem_reset_n     : out   std_logic;                                        --           .mem_reset_n
			memory_mem_dq          : inout std_logic_vector(7 downto 0)  := (others => '0'); --           .mem_dq
			memory_mem_dqs         : inout std_logic                     := '0';             --           .mem_dqs
			memory_mem_dqs_n       : inout std_logic                     := '0';             --           .mem_dqs_n
			memory_mem_odt         : out   std_logic;                                        --           .mem_odt
			memory_mem_dm          : out   std_logic;                                        --           .mem_dm
			memory_oct_rzqin       : in    std_logic                     := '0';             --           .oct_rzqin
			pause_rec_pause_out    : out   std_logic;                                        --  pause_rec.pause_out
			reset_reset_n          : in    std_logic                     := '0'              --      reset.reset_n
		);
	end component;
	
	component blinker is
		port(
		   clk   : in std_logic;
		   delay : in std_logic_vector (3 downto 0);
		   led   : out std_logic_vector (3 downto 0);
		   reset : in std_logic;
		   pause : in std_logic
	 );
	end component;
	
	component delay_ctrl is
		port(
			clk    : in std_logic;
			faster : in std_logic;
			slower : in std_logic;
			delay  : out std_logic_vector (3 downto 0);
			reset  : in std_logic
		);
	end component;
	
	component oneshot is
		port(
			clk       : in std_logic;
			edge_sig  : in std_logic_vector (3 downto 0);
			level_sig : out std_logic_vector (3 downto 0)
		);
	end component;

begin

	--clock
	main_clk <= CLOCK_50;
	--control the blink
	control_blink : blinker port map(main_clk,delay,LED,key_os(3),running);
	--delay control
	control_delay : delay_ctrl port map(main_clk,key_os(1),key_os(0),delay,key_os(3));
	--key adjust : one shot
	one_shot_control : oneshot port map(main_clk,KEY,key_os);
	--Info output
	soc_sys_control : soc port map(
		main_clk,
		delay,
		
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
		
		running,
		
		reset_reset_n
	);

end behave;