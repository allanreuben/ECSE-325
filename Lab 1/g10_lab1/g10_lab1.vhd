library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g10_lab1 is
	Port(	clk			:in	std_logic;
			countbytwo	:in	std_logic;
			rst			:in	std_logic;
			enable		:in	std_logic;
			output		:out	std_logic_vector(7 downto 0));
end g10_lab1;

architecture a1 of g10_lab1 is

signal tempOut : std_logic_vector(7 downto 0); --Temporary output variable for storing the output value

begin

	adder: process(clk)
	
	begin
		if (rising_edge(clk)) then --All operations should happen synchronously with the rising clock edge
			if (rst = '1') then
				tempOut <= "00000000"; --Synchronous reset (active high)
			elsif (enable = '1') then
			
			--Using this method of counting, the value of tempOut will reset when the value becomes too big
				if (countbytwo = '1') then
					if (tempOut(0) = '1') then --If the output is not even, we add 1 to the output once to make it even, then start adding 2
						tempOut <= std_logic_vector(unsigned(tempOut) + 1);
					else
						tempOut <= std_logic_vector(unsigned(tempOut) + 2); --Add 2 to the output if the countbytwo is high
					end if;
				else
					tempOut <= std_logic_vector(unsigned(tempOut) + 1); --Otherwise, add 1
				end if;
			end if;
			output <= tempOut; --Update the output with the value of the temporary variable
		end if;
	end process adder;
end architecture a1;

			