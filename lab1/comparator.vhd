-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: comparator.vhd                       |
-- | This component checks if input A is less than |
-- | or equal to the input B.     				   |
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
  generic ( width : positive := 8);
  port (
    a       : in  std_logic_vector(width-1 downto 0);
	b       : in  std_logic_vector(width-1 downto 0);
	a_lt_b 	: out std_logic);
end comparator;

architecture BHV of comparator is
begin
	process(a, b)
	begin
		if unsigned(a) <= unsigned(b) then
			a_lt_b <= '1';
		else
			a_lt_b <= '0';
		end if;
	end process;
end BHV;
