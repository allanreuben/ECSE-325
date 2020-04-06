library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

entity g10_FIR_tb is
end g10_FIR_tb;


architecture test of g10_FIR_tb is
-----------------------------------------------------------------------------
-- Declare the Component Under Test
-----------------------------------------------------------------------------
component g10_FIR is
 port ( x : in std_logic_vector(15 downto 0);
 clk : in std_logic;
 rst : in std_logic;
 y : out std_logic_vector(16 downto 0)
 );
end component g10_FIR;
-----------------------------------------------------------------------------
-- Testbench Internal Signals
-----------------------------------------------------------------------------
file file_VECTORS_X : text;
file file_RESULTS : text;
constant clk_PERIOD : time := 100 ns;
signal x_in : std_logic_vector(15 downto 0);
signal clk_in : std_logic;
signal rst_in : std_logic;
signal y_out : std_logic_vector(16 downto 0);

begin -- Instantiate FIR

	g10_FIR_INST : g10_FIR
	port map (
		x => x_in,
		clk => clk_in,
		rst => rst_in,
		y => y_out
	);
	-----------------------------------------------------------------------------
	-- Clock Generation
	-----------------------------------------------------------------------------
	clk_generation : process
	begin
		clk_in <= '1';
		wait for clk_PERIOD / 2;
		clk_in <= '0';
		wait for clk_PERIOD / 2;
	end process clk_generation;

	-----------------------------------------------------------------------------
	-- Providing Inputs
	-----------------------------------------------------------------------------
	feeding_instr : process
	
	variable v_Iline : line;
	variable v_Oline : line;
	variable v_x_in : std_logic_vector(15 downto 0);

	begin
		-- Reset the circuit
		rst_in <= '1';
		wait until rising_edge(clk_in);
		wait until rising_edge(clk_in);
		rst_in <= '0';
		-- Open the input file and create an output file
		file_open(file_VECTORS_X, "lab3-in-fixed-point.txt", read_mode);
		file_open(file_RESULTS, "lab3-out.txt", write_mode);
		-- Feed data into the design
		while not endfile(file_VECTORS_X) loop
			readline(file_VECTORS_X, v_Iline);
			read(v_Iline, v_x_in);
			x_in <= v_x_in;
			write(v_Oline, y_out);
			writeline(file_RESULTS, v_Oline);
			wait until rising_edge(clk_in);
		end loop;
		wait;
	end process;
end test;