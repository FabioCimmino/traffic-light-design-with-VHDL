library ieee;
use ieee.std_logic_1164.all;

entity generator is
port(clk, enable, reset: out std_logic;
	mode, mm: out std_logic_vector(1 downto 0));
end generator;


architecture generator_behavior of generator is
begin

process
begin
 clk <= '0'; wait for 5 ns;
 clk <= '1'; wait for 5 ns;
end process;

process
begin
 mode <= "00"; wait for 1000000 ns;
 mode <= "10"; wait for 3000000 ns;
 mode <= "00"; wait for 1000000 ns;
 mode <= "10"; wait for 8000000 ns;
end process;

process
begin
 enable <= '1'; wait for 5000000 ns;
 --enable <= '0'; wait for 3000000 ns;
end process;

process
begin
 reset <= '1'; wait for 1 sec;
end process;

process
begin
 mm <= "00"; wait for 2000000 ns;
 mm <= "11"; wait for 5000000 ns;
end process;

end generator_behavior;

