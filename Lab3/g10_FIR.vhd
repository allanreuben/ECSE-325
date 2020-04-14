library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration
entity g10_FIR is
port(	x : in std_logic_vector (7 downto 0); -- input Signal
		clk : in std_logic; -- clock
		rst : in std_logic; -- asynchronous active-high reset
		y : out std_logic_vector (9 downto 0) -- output signal
 );
end g10_FIR;

architecture a0 of g10_FIR is

-- CONSTANTS
constant taps : integer := 25; -- Number of weights/taps

-- TYPES OF ARRAYS
type t_weights is array (0 to taps - 1) of signed(7 downto 0); -- For each tap
type t_pipeline is array (0 to taps - 1) of std_logic_vector(7 downto 0); -- For the pipeline
type t_products is array (0 to taps - 1) of signed(15 downto 0); -- For storing the multiplication of the pipeline value and the weight

-- FUNCTIONS

-- Initializes the weights array to the appropriate values
function init_weights
	return t_weights is
variable temp_weights : t_weights;
begin
-- TRUNCATED - 8 bits
	temp_weights(0) := "00000010";
	temp_weights(1) := "00000000";
	temp_weights(2) := "11111111";
	temp_weights(3) := "11111110";
	temp_weights(4) := "00000011";
	temp_weights(5) := "11111101";
	temp_weights(6) := "11111100";
	temp_weights(7) := "00001101";
	temp_weights(8) := "11101100";
	temp_weights(9) := "00001101";
	temp_weights(10) := "00000011";
	temp_weights(11) := "11101010";
	temp_weights(12) := "00011110";
	temp_weights(13) := "11101010";
	temp_weights(14) := "00000011";
	temp_weights(15) := "00001101";
	temp_weights(16) := "11101100";
	temp_weights(17) := "00001101";
	temp_weights(18) := "11111100";
	temp_weights(19) := "11111101";
	temp_weights(20) := "00000011";
	temp_weights(21) := "11111110";
	temp_weights(22) := "11111111";
	temp_weights(23) := "00000000";
	temp_weights(24) := "00000010";
-- ROUNDED
--	temp_weights(0) := "0000001001110011";
--	temp_weights(1) := "0000000000010001";
--	temp_weights(2) := "1111111111010011";
-- temp_weights(3) := "1111111011011110";
--	temp_weights(4) := "0000001100011010";
--	temp_weights(5) := "1111110110100111";
--	temp_weights(6) := "1111110000001110";
--	temp_weights(7) := "0000110110111101";
--	temp_weights(8) := "1110110001110011";
--	temp_weights(9) := "0000110111111000";
--	temp_weights(10) := "0000001100001000";
--	temp_weights(11) := "1110101000001010";
--	temp_weights(12) := "0001111000110100";
--	temp_weights(13) := "1110101000001010";
--	temp_weights(14) := "0000001100001000";
--	temp_weights(15) := "0000110111111000";
--	temp_weights(16) := "1110110001110011";
--	temp_weights(17) := "0000110110111101";
--	temp_weights(18) := "1111110000001110";
--	temp_weights(19) := "1111110110100111";
--	temp_weights(20) := "0000001100011010";
--	temp_weights(21) := "1111111011011110";
--	temp_weights(22) := "1111111111010011";
--	temp_weights(23) := "0000000000010001";
--	temp_weights(24) := "0000001001110011";

-- NOT ROUNDED
--	temp_weights(0) := "0000001001110010";
--	temp_weights(1) := "0000000000010001";
--	temp_weights(2) := "1111111111010011";
--	temp_weights(3) := "1111111011011110";
--	temp_weights(4) := "0000001100011001";
--	temp_weights(5) := "1111110110100111";
--	temp_weights(6) := "1111110000001110";
--	temp_weights(7) := "0000110110111100";
--	temp_weights(8) := "1110110001110011";
--	temp_weights(9) := "0000110111110111";
--	temp_weights(10) := "0000001100000111";
--	temp_weights(11) := "1110101000001010";
--	temp_weights(12) := "0001111000110011";
--	temp_weights(13) := "1110101000001010";
--	temp_weights(14) := "0000001100000111";
--	temp_weights(15) := "0000110111110111";
--	temp_weights(16) := "1110110001110011";
--	temp_weights(17) := "0000110110111100";
--	temp_weights(18) := "1111110000001110";
--	temp_weights(19) := "1111110110100111";
--	temp_weights(20) := "0000001100011001";
--	temp_weights(21) := "1111111011011110";
--	temp_weights(22) := "1111111111010011";
--	temp_weights(23) := "0000000000010001";
--	temp_weights(24) := "0000001001110010";
	return temp_weights;
end function init_weights;

-- Rounds a 32-bit input to a 17-bit output value
function round (input : signed(15 downto 0))
	return signed is
variable rounded : signed(12 downto 0); -- The rounded value
begin
	-- Copy the 17 most significant bits from the input to the rounded value
	rounded := input(23 downto 11);
	-- If the next most significant bit from the input is '1', round up. Otherwise, round down.
	-- COMMENT THIS SECTION OUT TO GET TRUNCATED RESULTS
	--if (input(14) = '1') then
	--	if (input(31) = '0') then -- If number is positive, add 1. If negative, subtract 1.
	--		rounded := rounded + 1;
	--	else
	--		rounded := rounded - 1;
	--	end if;
	--end if;
	-- END OF ROUNDING SECTION
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
	variable sum_result : signed(15 downto 0) := (others => '0'); -- Temporarily stores the result of the sum
	variable temp	    : signed (9 downto 0) := (others => '0');
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
			temp := sum_result(15 downto 6);
			y <= std_logic_vector(temp); -- Round the sum before setting it to the input
		end if;
	end process;

	-- Generate statement for the products
	products: for i in 0 to taps - 1 generate
		-- Multiply each pipeline value with its corresponding weight
		r_products(i) <= (signed(r_pipeline(i)) * r_weights(i));
	end generate;

end a0;