library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity g10_complex_square is
	port (
		i_clk : in std_logic;
		i_rstb : in std_logic;
		i_x : in std_logic_vector(31 downto 0);
		i_y : in std_logic_vector(31 downto 0);
		o_xx, o_yy : out std_logic_vector(64 downto 0)
	);
end g10_complex_square;

architecture rtl of g10_complex_square is

signal r_x, r_y	: signed(31 downto 0);
signal r_xx, r_yy, r_xy	: signed(63 downto 0);

begin

	p_mult : process(i_clk,i_rstb)
	begin
		if(i_rstb='0') then
			o_xx <= (others => '0');
			o_yy <= (others => '0');
			r_x <= (others => '0');
			r_y <= (others => '0');
			r_xx <= (others => '0');
			r_yy <= (others => '0');
			r_xy <= (others => '0');
		elsif(rising_edge(i_clk)) then
			r_x <= signed(i_x);
			r_y <= signed(i_y);
			r_xx <= r_x * r_x;
			r_yy <= r_y * r_y;
			r_xy <= r_x * r_y;
			o_xx <= std_logic_vector(('0' & r_xx) - r_yy);
			o_yy <= std_logic_vector(r_xy & '0');
		end if;
	end process p_mult;
	
end rtl;