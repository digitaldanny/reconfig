-- +-----+-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: Controller.vhd                       
-- | This component is the state machine used in 
-- | the FSM+D architecture of the fibonacci calculator
-- +-----+-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
  port (
	-- Fib pins
    clk : in std_logic;
    rst : in std_logic;
	go   : in std_logic;
	
	done : out std_logic;
	
	-- datapath pins
	i_sel 		: out std_logic;
	x_sel 		: out std_logic;
	y_sel 		: out std_logic;
	i_ld 		: out std_logic;
	x_ld 		: out std_logic;
	y_ld 		: out std_logic;
	n_ld 		: out std_logic;
	result_ld 	: out std_logic;
	
	i_le_n : in std_logic
	);
end Controller;

architecture BHV of Controller is

	-- fsm signals and types
	type state_t is (S_START, S_FIB_INIT, S_FIB_RUN, S_DONE);
	signal state, nextState : state_t;

begin

	-- next state process 
	process(clk, rst)
	begin
		if rst = '1' then
			state <= S_START;
		elsif rising_edge(clk) then
			state <= nextState;
		end if;
	end process;
	
	-- fibonacci state machine
	process(go, state)
	begin
		
		-- defaults to avoid latches 
		i_sel 	  <= '0';
		x_sel 	  <= '0';
		y_sel 	  <= '0';
		i_ld 	  <= '0';
		x_ld 	  <= '0';
		y_ld 	  <= '0';
		n_ld 	  <= '0';
		result_ld <= '0';
		
		-- state switching
		case state is 
			when S_START =>
				
				-- next state conditions
				if go = '0' then
					nextState <= S_START;
				else
					nextState <= S_FIB_INIT;
				end if;
			
			when S_FIB_INIT =>
			
				done <= '0'; -- done = 0
				n_ld <= '1'; -- regN = n
				
				-- i = 3
				i_sel <= '0'; 	-- mux out = 3
				i_ld <= '1'; 	-- load reg
				
				-- x = 1
				x_sel <= '0'; 	-- mux out = 1
				x_ld <= '1'; 	-- load reg
				
				-- y = 1
				y_sel <= '0'; 	-- mux out = 1
				y_ld <= '1'; 	-- load reg
			
				-- next state conditions
				nextState <= S_FIB_RUN;
			
			when S_FIB_RUN =>
			
				-- x = y
				x_sel <= '1'; -- mux out = y
				x_ld <= '1'; -- load reg
				
				-- y = xOrig + y
				y_sel <= '1'; -- mux out = x + y
				y_ld <= '1'; -- load reg
				
				-- i++
				i_sel <= '1'; -- mux out = i + 1
				i_ld <= '1'; -- load reg
			
				-- next state conditions
				if i_le_n = '1' then
					nextState <= S_FIB_RUN;
				else
					nextState <= S_DONE;
				end if;
			
			when S_DONE =>
			
				result_ld <= '1'; -- result = y
				done <= '1'; -- done = 1
				
				-- don't allow any more registers to load
				i_ld <= '0';
				x_ld <= '0';
				y_ld <= '0';
				n_ld <= '0';
			
				-- next state conditions
				if go = '1' then
					nextState <= S_DONE;
				else
					nextState <= S_START;
				end if;
			end case;
	end process;

end BHV;