library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

entity g10_lab2_tb is
end g10_lab2_tb;


architecture test of g10_lab2_tb is
-----------------------------------------------------------------------------
-- Declare the Component Under Test
-----------------------------------------------------------------------------
component g10_lab2 is
 port ( x : in std_logic_vector(9 downto 0);
 y : in std_logic_vector(9 downto 0);
 N : in std_logic_vector(9 downto 0);
 clk : in std_logic;
 rst : in std_logic;
 mac : out std_logic_vector (22 downto 0);
 ready : out std_logic);
end component g10_lab2;
-----------------------------------------------------------------------------
-- Testbench Internal Signals
-----------------------------------------------------------------------------
file file_VECTORS_X : text;
file file_VECTORS_Y : text;
file file_RESULTS : text;
constant clk_PERIOD : time := 100 ns;
signal x_in : std_logic_vector(9 downto 0);
signal y_in : std_logic_vector(9 downto 0);
signal N_in : std_logic_vector(9 downto 0);
signal clk_in : std_logic;
signal rst_in : std_logic;
signal mac_out : std_logic_vector (22 downto 0);
signal ready_out : std_logic;

begin -- Instantiate MAC
 g10_lab2_INST : g10_lab2
 port map (
 x => x_in,
 y => y_in,
 N => N_in,
 clk => clk_in,
 rst => rst_in,
 mac => mac_out,
 ready => ready_out
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
 variable v_Iline1 : line;
 variable v_Iline2 : line;
 variable v_Oline : line;
 variable v_x_in : std_logic_vector(9 downto 0);
 variable v_y_in : std_logic_vector(9 downto 0);

 begin
 --reset the circuit
 N_in <= "1111101000"; -- N = 1000
 rst_in <= '1';
 wait until rising_edge(clk_in);
 wait until rising_edge(clk_in);
 rst_in <= '0';
 file_open(file_VECTORS_X, "P:\ECSE-325\Lab 2\lab2-x-fixed-point.txt", read_mode);
 file_open(file_VECTORS_Y, "P:\ECSE-325\Lab 2\lab2-y-fixed-point.txt", read_mode);
 file_open(file_RESULTS, "P:\ECSE-325\Lab 2\lab2-out.txt", write_mode);
 while not endfile(file_VECTORS_X) loop
 	readline(file_VECTORS_X, v_Iline1);
 	read(v_Iline1, v_x_in);
 	readline(file_VECTORS_Y, v_Iline2);
 	read(v_Iline2, v_y_in);
 	x_in <= v_x_in;
 	y_in <= v_y_in;
 	wait until rising_edge(clk_in);
 end loop;
 if ready_out = '1' then
 	write(v_Oline, mac_out);
 	writeline(file_RESULTS, v_Oline);
 	wait;
 end if;
 end process;
end test;