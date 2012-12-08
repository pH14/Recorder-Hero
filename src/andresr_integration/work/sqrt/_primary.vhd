library verilog;
use verilog.vl_types.all;
entity sqrt is
    generic(
        NBITS           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        data            : in     vl_logic_vector;
        start           : in     vl_logic;
        answer          : out    vl_logic_vector;
        done            : out    vl_logic
    );
end sqrt;
