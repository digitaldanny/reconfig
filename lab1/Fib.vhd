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

	-- controller signals
	signal ctrl_clkSig 		: std_logic;
	signal ctrl_rstSig 		: std_logic;
	signal ctrl_goSig 		: std_logic;
	signal ctrl_doneSig 	: std_logic;
	
	signal ctrl_iSelSig 	: std_logic;
	signal ctrl_xSelSig 	: std_logic;
	signal ctrl_ySelSig 	: std_logic;
	
	signal ctrl_iLdSig 		: std_logic;
	signal ctrl_xLdSig 		: std_logic;
	signal ctrl_yLdSig 		: std_logic;
	signal ctrl_nLdSig 		: std_logic;
	signal ctrl_resultLdSig : std_logic;
	
	signal ctrl_iLeN		: std_logic;
	
	-- datapath signals 
	signal dp_clkSig 		: std_logic;
	signal dp_rstSig 		: std_logic;
	signal dp_nSig 			: std_logic_vector(7 downto 0);
	signal dp_resultSig 	: std_logic_vector(7 downto 0);
	
	signal dp_iSelSig 		: std_logic;
	signal dp_xSelSig 		: std_logic;
	signal dp_ySelSig 		: std_logic;
	signal dp_iLdSig 		: std_logic;
	signal dp_xLdSig 		: std_logic;
	signal dp_yLdSig 		: std_logic;
	signal dp_nLdSignal 	: std_logic;
	signal dp_resultLdSig 	: std_logic;
	signal dp_iLeN 			: std_logic;
	
begin

	-- +-----+-----+-----+-----+-----+-----+
	-- internal signal drivers
	-- +-----+-----+-----+-----+-----+-----+

	-- controller signals
	ctrl_clkSig <= clk;		
	ctrl_rstSig <= rst;		
	ctrl_goSig 	<= go;	
	
	-- datapath signals 
	dp_clkSig <= clk;		
	dp_rstSig <= rst;		
	dp_nSig <= n;	
	
	dp_iSelSig 		<= ctrl_iSelSig; 	
	dp_xSelSig 		<= ctrl_xSelSig; 	
	dp_ySelSig 		<= ctrl_ySelSig; 	
	dp_iLdSig 		<= ctrl_iLdSig; 		
	dp_xLdSig 		<= ctrl_xLdSig; 		
	dp_yLdSig 		<= ctrl_yLdSig; 		
	dp_nLdSignal 	<= ctrl_nLdSig; 		
	dp_resultLdSig 	<= ctrl_resultLdSig;
	dp_iLeN 		<= ctrl_iLeN;	
	
	-- +-----+-----+-----+-----+-----+-----+
	-- external port drivers
	-- +-----+-----+-----+-----+-----+-----+
	
	result <= dp_resultSig;
	done <= ctrl_doneSig;

	-- +-----+-----+-----+-----+-----+-----+
	-- component instantiation
	-- +-----+-----+-----+-----+-----+-----+
	
	U_CONTROLLER : entity work.Controller
		port map (
			-- Fib pins
			clk   => ctrl_clkSig,
			rst   => ctrl_rstSig,
			go    => ctrl_goSig,
			      
			done  => ctrl_doneSig,
			
			-- datapath pins
			i_sel 	    => ctrl_iSelSig,	
			x_sel 		=> ctrl_xSelSig,	
			y_sel 		=> ctrl_ySelSig,	
			i_ld 		=> ctrl_iLdSig,
			x_ld 		=> ctrl_xLdSig,
			y_ld 		=> ctrl_yLdSig,
			n_ld 		=> ctrl_nLdSig,
			result_ld 	=> ctrl_resultLdSig,
			            
			i_le_n      => ctrl_iLeN
		);		
		
	U_DATAPATH : entity work.Datapath
		port map (
			-- Fib pins
			clk    => dp_clkSig,
			rst    => dp_rstSig,
			n      => dp_nSig,
			       
			result => dp_resultSig,
			
			-- controller pins
			i_sel      => dp_iSelSig,
			x_sel      => dp_xSelSig,
			y_sel      => dp_ySelSig,
			i_ld       => dp_iLdSig, 		
			x_ld       => dp_xLdSig, 		
			y_ld       => dp_yLdSig,		
			n_ld       => dp_nLdSignal,	
			result_ld  => dp_resultLdSig,
			
			i_le_n     => dp_iLeN
		);

end FSMPLUSD;

-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: Fsmd                                 |
-- | This architecture implements the fibonacci    |
-- | algorithm as a datapath and fsm controller.   |
-- +-----+-----+-----+-----+-----+-----+-----+-----+
architecture FSMD of Fib is
begin

end FSMD;