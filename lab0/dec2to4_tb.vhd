-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

entity dec2to4_tb is
end dec2to4_tb;

architecture TB of dec2to4_tb is

  signal input       : std_logic_vector(1 downto 0);
  signal output_ws   : std_logic_vector(3 downto 0);
  signal output_we   : std_logic_vector(3 downto 0);
  signal output_if   : std_logic_vector(3 downto 0);
  signal output_case : std_logic_vector(3 downto 0);

begin

  U_WITH_SELECT : entity work.dec2to4(WITH_SELECT)
    port map (
      input  => input,
      output => output_ws);

  U_WHEN_ELSE : entity work.dec2to4(WHEN_ELSE)
    port map (
      input  => input,
      output => output_we);

  U_IF : entity work.dec2to4(IF_STATEMENT)
    port map (
      input  => input,
      output => output_if);

  U_CASE : entity work.dec2to4(CASE_STATEMENT)
    port map (
      input  => input,
      output => output_case);

  process
  begin

    input <= "00";
    wait for 10 ns;
    assert(output_ws = "0001");
    assert(output_we = "0001");
    assert(output_if = "0001");
    assert(output_case = "0001");

    input <= "01";
    wait for 10 ns;
    assert(output_ws = "0010");
    assert(output_we = "0010");
    assert(output_if = "0010");
    assert(output_case = "0010");

    input <= "10";
    wait for 10 ns;
    assert(output_ws = "0100");
    assert(output_we = "0100");
    assert(output_if = "0100");
    assert(output_case = "0100");

    input <= "11";
    wait for 10 ns;
    assert(output_ws = "1000");
    assert(output_we = "1000");
    assert(output_if = "1000");
    assert(output_case = "1000");

    report "SIMULATION FINISHED";
    wait;

  end process;

end TB;
