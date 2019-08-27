-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity mult_pipe_tb is
end mult_pipe_tb;

architecture TB of mult_pipe_tb is

  constant TEST_WIDTH  : positive := 8;
  constant MAX_INT_VAL : positive := 2**TEST_WIDTH-1;

  signal clk    : std_logic := '0';
  signal rst    : std_logic;
  signal en     : std_logic;
  signal in1    : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal in2    : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal output : std_logic_vector(TEST_WIDTH*2-1 downto 0);

  signal done : integer := 0;

begin  -- TB

  UUT : entity work.mult_pipe
    generic map (
      width  => TEST_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      in1    => in1,
      in2    => in2,
      output => output);

  clk <= clk when done = 1 else
         not clk after 5 ns;

  process

    procedure randInt(variable seed1, seed2 : inout positive;
                      min, max              : in    integer;
                      result                : out   integer) is

      variable rand : real;
    begin
      uniform(seed1, seed2, rand);
      result := integer(real(min)+(rand*(real(max)-real(min))));
    end procedure;

    function checkOutput (
      in1, in2 : std_logic_vector(TEST_WIDTH-1 downto 0))
      return unsigned is
    begin
      return unsigned(in1)*unsigned(in2);
    end checkOutput;

    function checkOutput (
      in1, in2 : integer)
      return unsigned is
    begin
      return to_unsigned(in1*in2, TEST_WIDTH*2);
    end checkOutput;

    variable seed1, seed2 : positive;
    variable temp_int     : integer;
    variable temp1, temp2 : std_logic_vector(TEST_WIDTH-1 downto 0);

  begin
    rst <= '1';
    en  <= '1';
    in1 <= (others => '0');
    in2 <= (others => '0');

    for i in 0 to 4 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
    wait until clk'event and clk = '1';

    -- test overflow

    in1 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));
    in2 <= std_logic_vector(to_unsigned(MAX_INT_VAL, TEST_WIDTH));

    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    assert(unsigned(output) = checkOutput(in1, in2))
      report "Output incorrect : " &
      integer'image(to_integer(unsigned(output))) & " ! = " &
      integer'image(to_integer(checkOutput(in1, in2)))
      severity warning;
    wait until clk'event and clk = '1';
    en  <= '0';
    in1 <= std_logic_vector(to_unsigned(0, TEST_WIDTH));
    in2 <= std_logic_vector(to_unsigned(0, TEST_WIDTH));
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    assert(unsigned(output) = checkOutput(MAX_INT_VAL, MAX_INT_VAL))
      report "Enable not working correctly." severity warning;

    -- test a bunch of random numbers

    for i in 0 to 100 loop
      en <= '1';
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      temp1 := std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      temp2 := std_logic_vector(to_unsigned(temp_int, TEST_WIDTH));
      randInt(seed1, seed2, 0, MAX_INT_VAL, temp_int);
      in1 <= temp1;
      in2 <= temp2;
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';
      assert(unsigned(output) = checkOutput(in1, in2))
        report "Output incorrect : " &
        integer'image(to_integer(unsigned(output))) & " ! = " &
        integer'image(to_integer(checkOutput(in1, in2)))
        severity warning;
      
      wait until clk'event and clk = '1';      
      en  <= '0';
      in1 <= std_logic_vector(to_unsigned(0, TEST_WIDTH));
      in2 <= std_logic_vector(to_unsigned(0, TEST_WIDTH));

      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';
      assert(unsigned(output) = checkOutput(temp1, temp2))
        report "Output incorrect : " &
        integer'image(to_integer(unsigned(output))) & " ! = " &
        integer'image(to_integer(checkOutput(temp1, temp2)))
        severity warning;

    end loop;  -- i

    done <= 1;                          -- needed to stop clock
    report "SIMULATION FINISHED!!!";
    wait;

  end process;

end TB;
