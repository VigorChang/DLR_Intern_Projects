	component soc is
		port (
			clk_clk                     : in    std_logic                     := 'X';             -- clk
			memory_mem_a                : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba               : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck               : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n             : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke              : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n             : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n            : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n            : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n             : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n          : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq               : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs              : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n            : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt              : out   std_logic;                                        -- mem_odt
			memory_mem_dm               : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin            : in    std_logic                     := 'X';             -- oct_rzqin
			reset_reset_n               : in    std_logic                     := 'X';             -- reset_n
			rfsend_conduit_en_in        : in    std_logic                     := 'X';             -- en_in
			rfsend_conduit_rftxdata     : out   std_logic_vector(11 downto 0);                    -- rftxdata
			rfsend_conduit_rftxen       : out   std_logic;                                        -- rftxen
			rfsend_conduit_rftxiqsel    : out   std_logic;                                        -- rftxiqsel
			rfsend_txclk_clk            : in    std_logic                     := 'X';             -- clk
			sendcontrol_conduit_send_en : out   std_logic                                         -- send_en
		);
	end component soc;

	u0 : component soc
		port map (
			clk_clk                     => CONNECTED_TO_clk_clk,                     --                 clk.clk
			memory_mem_a                => CONNECTED_TO_memory_mem_a,                --              memory.mem_a
			memory_mem_ba               => CONNECTED_TO_memory_mem_ba,               --                    .mem_ba
			memory_mem_ck               => CONNECTED_TO_memory_mem_ck,               --                    .mem_ck
			memory_mem_ck_n             => CONNECTED_TO_memory_mem_ck_n,             --                    .mem_ck_n
			memory_mem_cke              => CONNECTED_TO_memory_mem_cke,              --                    .mem_cke
			memory_mem_cs_n             => CONNECTED_TO_memory_mem_cs_n,             --                    .mem_cs_n
			memory_mem_ras_n            => CONNECTED_TO_memory_mem_ras_n,            --                    .mem_ras_n
			memory_mem_cas_n            => CONNECTED_TO_memory_mem_cas_n,            --                    .mem_cas_n
			memory_mem_we_n             => CONNECTED_TO_memory_mem_we_n,             --                    .mem_we_n
			memory_mem_reset_n          => CONNECTED_TO_memory_mem_reset_n,          --                    .mem_reset_n
			memory_mem_dq               => CONNECTED_TO_memory_mem_dq,               --                    .mem_dq
			memory_mem_dqs              => CONNECTED_TO_memory_mem_dqs,              --                    .mem_dqs
			memory_mem_dqs_n            => CONNECTED_TO_memory_mem_dqs_n,            --                    .mem_dqs_n
			memory_mem_odt              => CONNECTED_TO_memory_mem_odt,              --                    .mem_odt
			memory_mem_dm               => CONNECTED_TO_memory_mem_dm,               --                    .mem_dm
			memory_oct_rzqin            => CONNECTED_TO_memory_oct_rzqin,            --                    .oct_rzqin
			reset_reset_n               => CONNECTED_TO_reset_reset_n,               --               reset.reset_n
			rfsend_conduit_en_in        => CONNECTED_TO_rfsend_conduit_en_in,        --      rfsend_conduit.en_in
			rfsend_conduit_rftxdata     => CONNECTED_TO_rfsend_conduit_rftxdata,     --                    .rftxdata
			rfsend_conduit_rftxen       => CONNECTED_TO_rfsend_conduit_rftxen,       --                    .rftxen
			rfsend_conduit_rftxiqsel    => CONNECTED_TO_rfsend_conduit_rftxiqsel,    --                    .rftxiqsel
			rfsend_txclk_clk            => CONNECTED_TO_rfsend_txclk_clk,            --        rfsend_txclk.clk
			sendcontrol_conduit_send_en => CONNECTED_TO_sendcontrol_conduit_send_en  -- sendcontrol_conduit.send_en
		);

