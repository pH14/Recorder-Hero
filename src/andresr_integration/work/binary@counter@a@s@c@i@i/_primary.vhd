library verilog;
use verilog.vl_types.all;
entity binaryCounterASCII is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        score           : in     vl_logic;
        asciiScore      : out    vl_logic_vector(47 downto 0)
    );
end binaryCounterASCII;
