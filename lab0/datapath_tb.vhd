-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity datapath_tb is
end datapath_tb;

architecture TB of datapath_tb is

  constant TEST_WIDTH  : positive := 8;
  constant MAX_INT_VAL : positive := 2**TEST_WIDTH-1;

  signal clk       : std_logic := '0';
  signal rst       : std_logic;
  signal en        : std_logic;
  signal valid_in  : std_logic;
  signal valid_out : std_logic;
  signal in1       : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal in2       : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal in3       : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal in4       : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal output    : std_logic_vector(TEST_WIDTH*2 downto 0);

  signal done : integer := 0;

begin  -- TB

  UUT : entity work.datapath
    generic map (
      width     => TEST_WIDTH)
    port map (
      clk       => clk,
      rst       => rst,
      en        => en,
      valid_in  => valid_in,
      valid_out => valid_out,
      in1       => in1,
      in2       => in2,
      in3       => in3,
      in4       => in4,
      output    => output);

  clk <= clk when done = 1 else
         not clk after 5 ns;

  process

    procedure randInt(variable seed1, seed2 : inout positive;
                       min, max              : in    integer;
                       result                : out   integer) is
      
      variable                  rand         :       real;
    begin
      uniform(seed1, seed2, rand);
      result := integer(real(min)+(rand*(real(max)-real(min))));
    end procedure;

    function checkOutput (
      in1, in2, in3, in4 : std_logic_vector(TEST_WIDTH-1 downto 0))
      return unsigned is

      variable temp1, temp2 : unsigned(TEST_WIDTH*2-1 downto 0);
    begin
      temp1 := unsigned(in1)*unsigned(in2);
      temp2 := unsigned(in3)*unsigned(in4);
      return resize(temp1, TEST_WIDTH*2+1)+resize(temp2, TEST_WIDTH*2+1);
    end checkOutput;

    variable seed1, seed2 : positive;
    variable temp_int     : integer;

  begin
    rst      <= '1';
    en       <= '1';
    in1      <= (others => '0');
    in2      <= (others => '0');
    in3      <= (others => '0');
    in4      <= (others => '0');
    valid_in <= '0';

    for i in 0 to 4 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
    wait until clk'event and clk = '1';

    -- test overflows

    in1 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));
    in2 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));
    in3 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));
    in4 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));

    valid_in <= '1';
    wait until clk'event and clk = '1';
    valid_in <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    assert(valid_out = '1') report "Valid_out incorrect" severity warning;
    assert(unsigned(output) = checkOutput(in1, in2, in3, in4))
      report "Output incorrect : " &
      integer'image(to_integer(unsigned(output))) & " ! = " &
      integer'image(to_integer(checkOutput(in1, in2, in3, in4)))
      severity warning;
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    -- test a bunch of random numbers

    for i in 0 to 100 loop
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      in1 <= std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      in2 <= std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      in3 <= std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      in4 <= std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));

      valid_in <= '1';
      wait until clk'event and clk = '1';
      valid_in <= '0';
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';

      assert(valid_out = '1') report "Valid_out incorrect" severity warning;
      assert(unsigned(output) = checkOutput(in1, in2, in3, in4))
        report "Output incorrect : " &
        integer'image(to_integer(unsigned(output))) & " ! = " &
        integer'image(to_integer(checkOutput(in1, in2, in3, in4)))
        severity warning;
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';

    end loop;  -- i

    done <= 1;
    report "SIMULATION FINISHED!!!";
    wait;

  end process;

end TB;
