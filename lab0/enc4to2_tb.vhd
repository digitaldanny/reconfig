-- Greg Stitt
-- University of Florida


library ieee;
use ieee.std_logic_1164.all;

entity enc4to2_tb is
end enc4to2_tb;

architecture TB of enc4to2_tb is

  signal input       : std_logic_vector(3 downto 0);
  signal output_if   : std_logic_vector(1 downto 0);
  signal output_case : std_logic_vector(1 downto 0);
  signal valid_if    : std_logic;
  signal valid_case  : std_logic;

begin  -- TB

  U_IF : entity work.enc4to2(IF_STATEMENT)
    port map (
      input  => input,
      output => output_if,
      valid  => valid_if);

  U_CASE : entity work.enc4to2(CASE_STATEMENT)
    port map (
      input  => input,
      output => output_case,
      valid  => valid_case);

  process
  begin

    input <= "0000";
    wait for 10 ns;
    assert(valid_if = '0');
    assert(valid_case = '0');

    input <= "0001";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "00");
    assert(valid_case = '1');
    assert(output_case = "00");

    input <= "0010";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "01");
    assert(valid_case = '1');
    assert(output_case = "01");

    input <= "0011";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "01");
    assert(valid_case = '1');
    assert(output_case = "01");

    input <= "0100";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "10");
    assert(valid_case = '1');
    assert(output_case = "10");

    input <= "0101";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "10");
    assert(valid_case = '1');
    assert(output_case = "10");

    input <= "0110";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "10");
    assert(valid_case = '1');
    assert(output_case = "10");

    input <= "0111";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "10");
    assert(valid_case = '1');
    assert(output_case = "10");

    input <= "1000";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1001";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1010";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1011";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1100";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1101";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1110";
    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    input <= "1111";

    wait for 10 ns;
    assert(valid_if = '1');
    assert(output_if = "11");
    assert(valid_case = '1');
    assert(output_case = "11");

    report "SIMULATION FINISHED";
    wait;

  end process;

end TB;
