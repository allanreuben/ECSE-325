library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration
entity g10_FIR is
port(	x : in std_logic_vector (15 downto 0); -- input Signal
		clk : in std_logic; -- clock
		rst : in std_logic; -- asynchronous active-high reset
		y : out std_logic_vector (16 downto 0) -- output signal
 );
end g10_FIR;

architecture a0 of g10_FIR is

-- CONSTANTS
constant taps : integer := 25; -- Number of weights/taps

-- TYPES OF ARRAYS
type t_weights is array (0 to taps - 1) of signed(15 downto 0); -- For each tap
type t_pipeline is array (0 to taps - 1) of std_logic_vector(15 downto 0); -- For the pipeline
type t_products is array (0 to taps - 1) of signed(31 downto 0); -- For storing the multiplication of the pipeline value and the weight

-- FUNCTIONS

-- Initializes the weights array to the appropriate values
function init_weights
	return t_weights is
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

-- Rounds a 32-bit input to a 17-bit output value
function round (input : signed(31 downto 0))
	return signed is
variable rounded : signed(16 downto 0); -- The rounded value
begin
	-- Copy the 17 most significant bits from the input to the rounded value
	rounded := input(31 downto 15);
	-- If the next most significant bit from the input is '1', round up. Otherwise, round down.
	if (input(14) = '1') then
		if (input(31) = '0') then -- If number is positive, add 1. If negative, subtract 1.
			rounded := rounded + 1;
		else
			rounded := rounded - 1;
		end if;
	end if;
	return rounded;
end function round;

-- ARRAYS
signal r_weights : t_weights;
signal r_pipeline : t_pipeline := (others => (others => '0'));
signal r_products : t_products := (others => (others => '0'));

begin
	-- Map the empty array of weights to their actual values using the function init_weights
	r_weights <= init_weights;
	
	-- Main process
	process (rst, clk)
	variable sum_result : signed(31 downto 0) := (others => '0'); -- Temporarily stores the result of the sum
	begin
		-- Asynchronous reset: setting the pipeline and the output to all '0's
		if (rst = '1') then
			r_pipeline <= (others => (others => '0'));
			y <= (others => '0');
		elsif (rising_edge(clk)) then
			r_pipeline <= (x & r_pipeline(0 to taps - 2)); -- Take the new input and shift it into the pipeline
			sum_result := (others => '0'); -- Reset the sum variable
			for i in 0 to taps - 1 loop
				sum_result := sum_result + r_products(i); -- Sum the products produced by each tap
			end loop;
			y <= std_logic_vector(round(sum_result)); -- Round the sum before setting it to the input
		end if;
	end process;

	-- Generate statement for the products
	products: for i in 0 to taps - 1 generate
		-- Multiply each pipeline value with its corresponding weight
		r_products(i) <= (signed(r_pipeline(i)) * r_weights(i));
	end generate;

end a0;