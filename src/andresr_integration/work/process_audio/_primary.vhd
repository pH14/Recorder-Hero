library verilog;
use verilog.vl_types.all;
entity process_audio is
    generic(
        sel             : integer := 8
    );
    port(
        clock_27mhz     : in     vl_logic;
        reset           : in     vl_logic;
        ready           : in     vl_logic;
        from_ac97_data  : in     vl_logic_vector(15 downto 0);
        haddr           : out    vl_logic_vector(11 downto 0);
        hdata           : out    vl_logic_vector(9 downto 0);
        hwe             : out    vl_logic
    );
end process_audio;
