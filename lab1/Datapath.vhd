-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: Datapath.vhd                         |
-- | This component is the datapath used in the    |
-- | FSM+D architecture of the fibonacci calculator|
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is
  port (
	-- Fib pins
    clk : in std_logic;
    rst : in std_logic;
	n   : in std_logic_vector(7 downto 0);
	
	result : out std_logic_vector(7 downto 0);
	
	-- controller pins
	i_sel : in std_logic;
	x_sel : in std_logic;
	y_sel : in std_logic;
	i_ld : in std_logic;
	x_ld : in std_logic;
	y_ld : in std_logic;
	n_ld : in std_logic;
	result_ld : in std_logic;
	
	i_le_n : out std_logic
	);
end Datapath;

architecture STR of Datapath is

	-- MUX 0 
	signal mux0_aSig 	: std_logic_vector(7 downto 0);
	signal mux0_bSig 	: std_logic_vector(7 downto 0);
	signal mux0_selSig 	: std_logic;
	signal mux0_outSig 	: std_logic_vector(7 downto 0);
	constant mux0_aConst : integer := 3;
	
	-- MUX 1
	signal mux1_aSig 	: std_logic_vector(7 downto 0);
	signal mux1_bSig 	: std_logic_vector(7 downto 0);
	signal mux1_selSig 	: std_logic;
	signal mux1_outSig 	: std_logic_vector(7 downto 0);
	constant mux1_aConst : integer := 1;
	
	-- MUX 2
	signal mux2_aSig 	: std_logic_vector(7 downto 0);
	signal mux2_bSig 	: std_logic_vector(7 downto 0);
	signal mux2_selSig 	: std_logic;
	signal mux2_outSig 	: std_logic_vector(7 downto 0);
	constant mux2_aConst : integer := 1;
	
	-- I REG 
	signal iReg_enSig : std_logic;
	signal iReg_inputSig : std_logic_vector(7 downto 0);
	signal iReg_outputSig : std_logic_vector(7 downto 0);
	
	-- X REG
	signal xReg_enSig : std_logic;
	signal xReg_inputSig : std_logic_vector(7 downto 0);
	signal xReg_outputSig : std_logic_vector(7 downto 0);
	
	-- Y REG
	signal yReg_enSig : std_logic;
	signal yReg_inputSig : std_logic_vector(7 downto 0);
	signal yReg_outputSig : std_logic_vector(7 downto 0);
	
	-- N REG
	signal nReg_enSig : std_logic;
	signal nReg_inputSig : std_logic_vector(7 downto 0);
	signal nReg_outputSig : std_logic_vector(7 downto 0);
	
	-- COMPARATOR
	signal comp_aSig : std_logic_vector(7 downto 0);
	signal comp_bSig : std_logic_vector(7 downto 0);
	signal comp_aLtBSig : std_logic;
	
	-- ADDER 0
	signal adder0_aSig : std_logic_vector(7 downto 0);
	signal adder0_bSig : std_logic_vector(7 downto 0);
	signal adder0_outSig : std_logic_vector(7 downto 0);
	constant adder0_bConst : integer := 1;
	
	-- ADDER 1
	signal adder1_aSig : std_logic_vector(7 downto 0);
	signal adder1_bSig : std_logic_vector(7 downto 0);
	signal adder1_outSig : std_logic_vector(7 downto 0);
	
	-- RESULT REG
	signal resultReg_enSig : std_logic;
	signal resultReg_inputSig : std_logic_vector(7 downto 0);
	signal resultReg_outputSig : std_logic_vector(7 downto 0);
	
begin

	-- +-----+-----+-----+-----+-----+-----+-----+-----+
	-- component instantiation 
	-- +-----+-----+-----+-----+-----+-----+-----+-----+
	
	MUX_0 : entity work.mux
		port map (
			sel     => mux0_selSig ,
			a       => mux0_aSig   ,
			b       => mux0_bSig   ,
			output  => mux0_outSig 
		);
		
	MUX_1 : entity work.mux
		port map (
			sel     => mux1_selSig ,
			a       => mux1_aSig   ,
			b       => mux1_bSig   ,
			output  => mux1_outSig 
		);
		
	MUX_2 : entity work.mux
		port map (
			sel     => mux2_selSig ,
			a       => mux2_aSig   ,
			b       => mux2_bSig   ,
			output  => mux2_outSig 
		);
		
	REG_I : entity work.reg
		port map (
			clk    => clk            ,
			rst    => rst            ,
			en     => iReg_enSig     ,
			input  => iReg_inputSig  ,
			output => iReg_outputSig
		);
		
	REG_X : entity work.reg
		port map (
			clk    => clk            ,
			rst    => rst            ,
			en     => xReg_enSig     ,
			input  => xReg_inputSig  ,
			output => xReg_outputSig
		);
		
	REG_Y : entity work.reg
		port map (
			clk    => clk            ,
			rst    => rst            ,
			en     => yReg_enSig     ,
			input  => yReg_inputSig  ,
			output => yReg_outputSig
		);
		
	REG_N : entity work.reg
		port map (
			clk    => clk            ,
			rst    => rst            ,
			en     => nReg_enSig     ,
			input  => nReg_inputSig  ,
			output => nReg_outputSig
		);
		
	REG_RESULT : entity work.reg
		port map (
			clk    => clk            ,
			rst    => rst            ,
			en     => resultReg_enSig     ,
			input  => resultReg_inputSig  ,
			output => resultReg_outputSig
		);
		
	COMP : entity work.comparator
		port map (
			a      => comp_aSig    ,
		    b      => comp_bSig    ,
		    a_lt_b => comp_aLtBSig 
		);
		
	ADDER_0 : entity work.adder
		port map (
			a      => adder0_aSig   ,
		    b      => adder0_bSig   ,
		    output => adder0_outSig 
		);
		
	ADDER_1 : entity work.adder
		port map (
			a      => adder1_aSig   ,
		    b      => adder1_bSig   ,
		    output => adder1_outSig 
		);
	
	-- +-----+-----+-----+-----+-----+-----+-----+-----+
	-- internal / external signal connections
	-- +-----+-----+-----+-----+-----+-----+-----+-----+
	
	-- MUX 0 
	mux0_aSig 	<= std_logic_vector(to_unsigned(mux0_aConst, 8));
	mux0_bSig 	<= adder0_outSig;
	mux0_selSig <= i_sel;
	
	-- MUX 1
	mux1_aSig 	<= std_logic_vector(to_unsigned(mux1_aConst, 8));
	mux1_bSig 	<= yReg_outputSig;
	mux1_selSig <= x_sel;
	
	-- MUX 2
	mux2_aSig   <= std_logic_vector(to_unsigned(mux2_aConst, 8));
	mux2_bSig   <= adder1_outSig;
	mux2_selSig <= y_sel;
	
	-- I REG 
	iReg_enSig 	   <= i_ld;
	iReg_inputSig  <= mux0_outSig;
	
	-- X REG
	xReg_enSig     <= x_ld;
	xReg_inputSig  <= mux1_outSig;
	
	-- Y REG
	yReg_enSig 	   <= y_ld;
	yReg_inputSig  <= mux2_outSig;
	
	-- N REG
	nReg_enSig     <= n_ld;
	nReg_inputSig  <= n;
	
	-- COMPARATOR
	comp_aSig   <= iReg_outputSig;
	comp_bSig   <= nReg_outputSig;
	
	-- ADDER 0
	adder0_aSig <= iReg_outputSig;
	adder0_bSig <= std_logic_vector(to_unsigned(adder0_bConst, 8));
	
	-- ADDER 1
	adder1_aSig <= xReg_outputSig;
	adder1_bSig <= yReg_outputSig;
	
	-- RESULT
	resultReg_enSig     <= result_ld;
	resultReg_inputSig  <= yReg_outputSig;
	
	-- output ports
	i_le_n <= comp_aLtBSig;
	result <= resultReg_outputSig;
	
end STR;