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
type t_pipeline is array (0 to taps - 1) of std_logic_vector(15 downto 0);
type t_products is array (0 to taps - 1) of signed(16 downto 0);

function init_weights return t_weights is
variable temp_weights : t_weights;
begin
	temp_weights(0) := "0000001001110010";
	temp_weights(1) := "0000000000010001";
	temp_weights(2) := "1111111111010011";
	temp_weights(3) := "1111111011011110";
	temp_weights(4) := "0000001100011001";
	temp_weights(5) := "1111110110100111";
	temp_weights(6) := "1111110000001110";
	temp_weights(7) := "0000110110111100";
	temp_weights(8) := "1110110001110011";
	temp_weights(9) := "0000110111110111";
	temp_weights(10) := "0000001100000111";
	temp_weights(11) := "1110101000001010";
	temp_weights(12) := "0001111000110011";
	temp_weights(13) := "1110101000001010";
	temp_weights(14) := "0000001100000111";
	temp_weights(15) := "0000110111110111";
	temp_weights(16) := "1110110001110011";
	temp_weights(17) := "0000110110111100";
	temp_weights(18) := "1111110000001110";
	temp_weights(19) := "1111110110100111";
	temp_weights(20) := "0000001100011001";
	temp_weights(21) := "1111111011011110";
	temp_weights(22) := "1111111111010011";
	temp_weights(23) := "0000000000010001";
	temp_weights(24) := "0000001001110010";
	return temp_weights;
end function init_weights;

function round (input : signed(31 downto 0))
	return signed is
variable rounded : signed(16 downto 0);
begin
	rounded := input(31 downto 15);
	if (input(14) = '1') then
		rounded := rounded + 1;
	end if;
	return rounded;
end function round;
	
signal r_weights : t_weights;
signal r_pipeline : t_pipeline := (others => (others => '0'));
signal r_products : t_products := (others => (others => '0'));

begin
	
	r_weights <= init_weights;
	
	process (rst, clk)
	variable sum_result : signed(16 downto 0) := (others => '0');

	begin
		if (rst = '1') then
			r_pipeline <= (others => (others => '0'));
			y <= (others => '0');
		elsif (rising_edge(clk)) then
			r_pipeline <= x & r_pipeline(0 to taps - 2);
			for i in 0 to taps - 1 loop
				sum_result := sum_result + r_products(i);
			end loop;
			y <= std_logic_vector(sum_result);
		end if;
	end process;

	products: for i in 0 to taps - 1 generate
		r_products(i) <= round(signed(r_pipeline(i)) * r_weights(i));
	end generate;

end a0;