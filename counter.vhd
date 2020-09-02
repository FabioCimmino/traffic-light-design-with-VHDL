library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity counter is
port(clk, enable, reset: in std_logic;
 mode: in std_logic_vector(1 downto 0);
 seconds: out std_logic_vector(5 downto 0));
end counter;

architecture counter_behavior of counter is
signal sec: integer := 0;
signal count: integer := 1;
signal clk1: std_logic :='0';
signal mode0: std_logic;
signal mode1: std_logic;

begin
seconds <= std_logic_vector(to_unsigned(sec, seconds'length));
mode1 <= mode(1);
mode0 <= mode(0);
process(clk, mode1, mode0, enable, reset) --conta clock per 1 millisecondo
begin
 if ((mode0'event or mode1'event or enable='0' or (reset'event and reset = '0')) and (mode /= "11")) then
       count <= 1; clk1 <= not clk1;
 elsif(clk'event and clk='1') then
  count <= count+1;
   if(count = 100000) then
   clk1 <= not clk1;
   count <= 1;
   end if;
 end if;
end process;


process(clk1, mode0, mode1, enable, reset)   --period of clk is 1 millisecond.
begin
 if ((mode0'event or mode1'event or enable='0' or (reset'event and reset='0'))and (mode /= "11")) then
		sec <= 0;
 elsif (clk1'event and clk='1') then
		sec <= sec+1;
 end if;
end process;

end counter_behavior;

