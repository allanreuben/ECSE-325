library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_FIR is
port(	x : in std_logic_vector (15 downto 0); -- input Signal
		clk : in std_logic; -- clock
		rst : in std_logic; -- asynchronous active-high reset
		y : out std_logic_vector (16 downto 0) -- output signal
 );
end gNN_FIR;

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

signal pipeline is array (0 to taps - 1) of std_logic_vector(15 downto 0);
signal sum_result : signed(16 downto 0);

begin

	reset:	process (rst)
	begin
		if (rst = '1') then
			pipeline <= (others => (others => '0'));
			y <= (others => '0')
		end if;
	end reset;
	
	shift:	process (clk)
	begin
		if (rising_edge(clk)) then
			pipeline <= x & pipeline(0 to taps - 2);
			sum_result <= 0;
			for i in 0 to taps - 1 loop
				sum_result <= sum_result + (signed(pipeline(i)) * r_weights(i));
			end loop
			y <= std_logic_vector(sum_result)
		end if;
	end shift;

end a0;