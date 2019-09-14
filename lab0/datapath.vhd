library ieee;
use ieee.std_logic_1164.all;

entity datapath is
  generic (
    width     :     positive := 16);
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    en        : in  std_logic;
    valid_in  : in  std_logic;
    valid_out : out std_logic;
    in1       : in  std_logic_vector(width-1 downto 0);
    in2       : in  std_logic_vector(width-1 downto 0);
    in3       : in  std_logic_vector(width-1 downto 0);
    in4       : in  std_logic_vector(width-1 downto 0);
    output    : out std_logic_vector(width*2 downto 0));
end datapath;

-- TODO: Implement the structural description of the datapath shown in
-- datapath.pdf by instantiating your add_pipe and mult_pipe entities. You may
-- also use the provided reg entity, or you can create your own.

architecture STR of datapath is
	signal out_mult_l_s : std_logic_vector(width*2-1 downto 0);
	signal out_mult_r_s : std_logic_vector(width*2-1 downto 0);
	signal out_add_s : std_logic_vector(width*2 downto 0);
	signal in_valid_s : std_logic_vector(0 downto 0);
	signal out_valid_1_s : std_logic_vector(0 downto 0);
	signal out_valid_2_s : std_logic_vector(0 downto 0);
begin

	-- left side multiplier
	U_MULT_L : entity work.mult_pipe
		generic map (WIDTH => WIDTH)
		port map
		(
			clk    => clk,
			rst    => rst,
			en     => en,
			in1    => in1,
			in2    => in2,
			output => out_mult_l_s
		);
	
	-- right side multiplier
	U_MULT_R : entity work.mult_pipe
		generic map (WIDTH => WIDTH)
		port map
		(
			clk    => clk,
			rst    => rst,
			en     => en,
			in1    => in3,
			in2    => in4,
			output => out_mult_r_s
		);
		
	-- adder 
	U_ADD : entity work.add_pipe
		generic map (WIDTH => 2*WIDTH)
		port map 
		(
			clk    => clk,
			rst    => rst,
			en     => '1',
			in1    => out_mult_l_s,
			in2    => out_mult_r_s,
			output => out_add_s
		);
		
	-- first valid register
	U_REG_1 : entity work.reg
		generic map (WIDTH => 1)
		port map
		(
			clk    => clk,
			rst    => rst,
			en     => en,
			input  => in_valid_s,
			output => out_valid_1_s
		);
	
	-- second valid register
	U_REG_2 : entity work.reg
		generic map (WIDTH => 1)
		port map
		(
			clk    => clk,
			rst    => rst,
			en     => en,
			input  => out_valid_1_s,
			output => out_valid_2_s
		);
		
	output <= out_add_s;
	in_valid_s(0) <= valid_in;
	valid_out <= out_valid_2_s(0);
		
end STR;
