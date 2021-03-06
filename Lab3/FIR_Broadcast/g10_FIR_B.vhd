library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_FIR_B is
port( x		:in std_logic_vector(15 downto 0); -- Input Signal
		clk	:in std_logic; -- Clock
		rst	:in std_logic; -- Asynchronous active-high reset
		y		:out std_logic_vector(16 downto 0) -- Outpput signal
);
end g10_FIR_B;

architecture a0 of g10_FIR_B is
type arr is array(24 downto 0) of signed(15 downto 0);
signal temp_weights: arr;
type arrtemp is array(24 downto 0) of signed(31 downto 0);
signal arrout: arrtemp;

begin
-- Input weights, truncated
temp_weights(0) <= "0000001001110010";
temp_weights(1) <= "0000000000010001";
temp_weights(2) <= "1111111111010011";
temp_weights(3) <= "1111111011011110";
temp_weights(4) <= "0000001100011001";
temp_weights(5) <= "1111110110100111";
temp_weights(6) <= "1111110000001110";
temp_weights(7) <= "0000110110111100";
temp_weights(8) <= "1110110001110011";
temp_weights(9) <= "0000110111110111";
temp_weights(10) <= "0000001100000111";
temp_weights(11) <= "1110101000001010";
temp_weights(12) <= "0001111000110011";
temp_weights(13) <= "1110101000001010";
temp_weights(14) <= "0000001100000111";
temp_weights(15) <= "0000110111110111";
temp_weights(16) <= "1110110001110011";
temp_weights(17) <= "0000110110111100";
temp_weights(18) <= "1111110000001110";
temp_weights(19) <= "1111110110100111";
temp_weights(20) <= "0000001100011001";
temp_weights(21) <= "1111111011011110";
temp_weights(22) <= "1111111111010011";
temp_weights(23) <= "0000000000010001";
temp_weights(24) <= "0000001001110010";
	
process(clk, rst)
	variable temp: signed(31 downto 0) := (others => '0');
	variable output: signed(16 downto 0) := (others => '0');
begin
	-- Reset on reset
	if rst = '1' then
		temp := (others => '0');
		output := (others => '0');
		y <= (others => '0');
	-- On rising edge of the clock
	elsif rising_edge(clk) then
		output := (others => '0');
		-- Do the multiplication and store in array
		for i in 0 to 24 loop
			arrout(i) <= temp_weights(i)*signed(x);
		end loop;
		
		-- Sum the results of the multipliation between the weight and input
		for i in 0 to 24 loop
			temp := arrout(i);
			output := output + temp(31 downto 15);
		end loop;
		-- Set output
		y <= std_logic_vector(output);
	end if;
end process;
end a0;