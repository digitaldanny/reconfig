-- +-----+-----+-----+-----+-----+-----+-----+-----+
-- | SUMMARY: tb.vhd                               |
-- | This testbench tests the outputs of the first |
-- | 5 fibonacci outputs using both FSM+D and FSMD |
-- | architectures.                                |
-- +-----+-----+-----+-----+-----+-----+-----+-----+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture both of tb is

	-- testbench signals 
	signal tb_clk 	: std_logic := '0';
	signal tb_rst 	: std_logic;
	signal tb_go 	: std_logic;
	signal tb_n 	: std_logic_vector(7 downto 0);
	
	signal tb_DONE_fsmplusd 	: std_logic;
	signal tb_RESULT_fsmplusd 	: std_logic_vector(7 downto 0);
	
	signal tb_DONE_fsmd 		: std_logic;
	signal tb_RESULT_fsmd 		: std_logic_vector(7 downto 0);
	
begin

	-- +-----+-----+-----+-----+-----+-----+-----+
	-- component instantiation
	-- +-----+-----+-----+-----+-----+-----+-----+
	
	U_FSMPLUSD : entity work.Fib(FSMPLUSD)
		port map (
			clk    => tb_clk,
			rst    => tb_rst,
			go	   => tb_go,
			n      => tb_n,
			done   => tb_DONE_fsmplusd, -- signals to check in testbench
			result => tb_RESULT_fsmplusd -- signals to check in testbench
		);
		
	U_FSMD : entity work.Fib(FSMD)
		port map (
			clk    => tb_clk,
			rst    => tb_rst,
			go	   => tb_go,
			n      => tb_n,
			done   => tb_DONE_fsmd, -- signals to check in testbench
			result => tb_RESULT_fsmd -- signals to check in testbench
		);

	-- +-----+-----+-----+-----+-----+-----+-----+
	-- testbench process 
	-- +-----+-----+-----+-----+-----+-----+-----+
	
	tb_clk <= not(tb_clk) after 5 ns; 


	-- input some 'n' value and wait long enough for the FSM to 
	-- run through and calculate the fibonacci value.
	process
	begin
		
		-- +-----+-----+-----+-----+-----+
		-- reset system
		-- +-----+-----+-----+-----+-----+
		tb_rst <= '1';
		tb_n <= std_logic_vector(to_unsigned(1, 8));
		tb_go <= '0';
		wait for 100 ns;
		tb_rst <= '0';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 1
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(1, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(1, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(1, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 2
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(2, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(1, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(1, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 3
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(3, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(2, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(2, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 4
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(4, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(3, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(3, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 5
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(5, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(5, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(5, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 6
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(6, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(8, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(8, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		-- +-----+-----+-----+-----+-----+
		-- test n = 7
		-- +-----+-----+-----+-----+-----+
		tb_n <= std_logic_vector(to_unsigned(7, 8));
		tb_go <= '1';
		wait until tb_DONE_fsmplusd = '1';
		tb_go <= '0';
		wait for 10 ns; -- delay for 'go' to set low
		
		assert (unsigned(tb_RESULT_fsmplusd) = to_unsigned(13, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmplusd))) severity warning;
		assert (unsigned(tb_RESULT_fsmd) = to_unsigned(13, 8)) report "ERROR (FSM PLUS D): " &integer'image(to_integer(unsigned(tb_RESULT_fsmd))) severity warning;
		
		wait; -- eop
	end process;

end both;







