library verilog;
use verilog.vl_types.all;
entity scoreUpdater is
    generic(
        Z               : integer := 0;
        Cr              : integer := 1;
        Csr             : integer := 2;
        Dr              : integer := 3;
        Dsr             : integer := 4;
        Er              : integer := 5;
        Fr              : integer := 7;
        Fsr             : integer := 8;
        Gr              : integer := 9;
        Gsr             : integer := 10;
        Ar              : integer := 11;
        Asr             : integer := 12;
        Br              : integer := 13
    );
    port(
        clk             : in     vl_logic;
        currentNote     : in     vl_logic_vector(3 downto 1);
        A               : in     vl_logic;
        As              : in     vl_logic;
        B               : in     vl_logic;
        Bs              : in     vl_logic;
        C               : in     vl_logic;
        Cs              : in     vl_logic;
        D               : in     vl_logic;
        Ds              : in     vl_logic;
        E               : in     vl_logic;
        Es              : in     vl_logic;
        F               : in     vl_logic;
        Fs              : in     vl_logic;
        G               : in     vl_logic;
        Gs              : in     vl_logic;
        reset           : in     vl_logic;
        hit             : out    vl_logic;
        score           : out    vl_logic_vector(63 downto 0);
        note            : out    vl_logic_vector(3 downto 1)
    );
end scoreUpdater;
