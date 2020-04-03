library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_FIR is
port(	x : in std_logic_vector (15 downto 0); -- input Signal
		clk : in std_logic; -- clock
		rst : in std_logic; -- asynchronous active-high reset
		y : out std_logic_vector (16 downto 0) -- output signal
 );
end g10_FIR;

architecture a0 of g10_FIR is

constant taps : integer := 25;

type t_weights is array (0 to taps - 1) of signed(15 downto 0);
signal r_weights : t_weights := ("0000001001110010","0000000000010001",
"1111111111010011","1111111011011110","0000001100011001","1111110110100111",
"1111110000001110","0000110110111100","1110110001110011","0000110111110111",
"0000001100000111","1110101000001010","0001111000110011","1110101000001010",
"0000001100000111","0000110111110111","1110110001110011","0000110110111100",
"1111110000001110","1111110110100111","0000001100011001","1111111011011110",
"1111111111010011","0000000000010001","0000001001110010");

type t_pipeline is array (0 to taps - 1) of std_logic_vector(15 downto 0);
signal r_pipeline : t_pipeline := (others => (others => '0'));
signal sum_result : signed(16 downto 0);
signal mult_result : signed(31 downto 0);

begin
	
	process (rst, clk)
	begin
		if (rst = '1') then
			r_pipeline <= (others => (others => '0'));
			y <= (others => '0');
		elsif (rising_edge(clk)) then
			r_pipeline <= x & r_pipeline(0 to taps - 2);
			sum_result <= (others => '0');
			for i in 0 to taps - 1 loop
				mult_result <= signed(r_pipeline(i)) * r_weights(i);
				sum_result <= sum_result + mult_result(31 downto 15);
			end loop;
			y <= std_logic_vector(sum_result);
		end if;
	end process;

end a0;