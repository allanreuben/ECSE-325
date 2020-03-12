library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_lab2 is
port ( x : in std_logic_vector (9 downto 0); -- first input, you have to first calculate length
 y : in std_logic_vector (9 downto 0); -- second input, replace ?? with your length
 N : in std_logic_vector (9 downto 0); -- total number of inputs
 clk : in std_logic; -- clock
 rst : in std_logic; -- asynchronous reset (active-high)
 mac : out std_logic_vector (22 downto 0); -- output of MAC unit, replace the length
 ready : out std_logic); -- denotes the validity of the mac signal
end g10_lab2;

architecture a0 of g10_lab2 is

signal tempMac : signed(22 downto 0) := "00000000000000000000000";
signal tempReady : std_logic := '0';
signal i : integer := 0;

begin
	
	process(clk, rst)
	begin
		if (rst = '1') then -- If resetting the MAC, then set output to 0
			tempMac <= "00000000000000000000000";
			ready <= '0';
		elsif (rising_edge(clk)) then
			tempMac <= tempMac + signed(x) * signed(y); -- Do the Multiply-accumulate operation
			i <= i + 1;
			if (i = 1000) then -- If 1000, then set tempReady to 1 and reset i
				tempReady <= '1';
				i <= 0;
			else
				tempReady <= '0';
			end if;
		end if;
		mac <= std_logic_vector(tempMac); -- Once operation is complete, send the 23 bit output to mac
		ready <= tempReady;
	end process;
	
end a0;