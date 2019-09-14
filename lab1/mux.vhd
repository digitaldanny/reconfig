-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: comparator.vhd                       |
-- | Generic 2x1 mux.                              |
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;

entity mux is
  generic ( width : positive := 8);
  port (
    sel     : in  std_logic;
    a       : in  std_logic_vector(width-1 downto 0);
	b       : in  std_logic_vector(width-1 downto 0);
    output  : out std_logic_vector(width-1 downto 0));
end mux;

architecture BHV of mux is
begin
  process(sel, a, b)
  begin
    if (sel = '0') then
		output <= a;
    else
		output <= b;
    end if;
  end process;
end BHV;
