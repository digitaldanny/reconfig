-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: Fib.vhd                              |
-- | This component calculates the nth fibonacci   |
-- | number.                                       |
-- |                                               |
-- | This component includes 2 architectures       |
-- | modeling the algorithm as an FSMD and FSM+D.  |
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fib is
  port (
    clk : in std_logic;
    rst : in std_logic;
    go	: in std_logic;
	n   : in std_logic_vector(7 downto 0);
	
	done : out std_logic;
	result : out std_logic_vector(7 downto 0)
	);
end Fib;

-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: FsmPlusD                             |
-- | This architecture implements the fibonacci    |
-- | algorithm as a datapath and fsm controller.   |
-- +-----+-----+-----+-----+-----+-----+-----+-----+
architecture FSMPLUSD of Fib is
begin

end FSMPLUSD;

-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: Fsmd                                 |
-- | This architecture implements the fibonacci    |
-- | algorithm as a datapath and fsm controller.   |
-- +-----+-----+-----+-----+-----+-----+-----+-----+
architecture FSMD of Fib is
begin

end FSMD;