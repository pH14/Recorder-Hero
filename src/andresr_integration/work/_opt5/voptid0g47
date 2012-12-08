library verilog;
use verilog.vl_types.all;
entity my_fft is
    port(
        ce              : in     vl_logic;
        rfd             : out    vl_logic;
        start           : in     vl_logic;
        fwd_inv         : in     vl_logic;
        dv              : out    vl_logic;
        done            : out    vl_logic;
        clk             : in     vl_logic;
        busy            : out    vl_logic;
        fwd_inv_we      : in     vl_logic;
        edone           : out    vl_logic;
        xn_re           : in     vl_logic_vector(7 downto 0);
        xk_im           : out    vl_logic_vector(20 downto 0);
        xn_index        : out    vl_logic_vector(11 downto 0);
        xk_re           : out    vl_logic_vector(20 downto 0);
        xn_im           : in     vl_logic_vector(7 downto 0);
        xk_index        : out    vl_logic_vector(11 downto 0)
    );
end my_fft;
