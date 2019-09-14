-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: adder.vhd                            |
-- | Generic unsigned adder without carry.         |
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  generic ( width : positive := 8);
  port (
    a       : in  std_logic_vector(width-1 downto 0);
	b       : in  std_logic_vector(width-1 downto 0);
    output  : out std_logic_vector(width-1 downto 0));
end adder;

architecture BHV of adder is
begin
	output <= std_logic_vector(unsigned(a) + unsigned(b));
end BHV;