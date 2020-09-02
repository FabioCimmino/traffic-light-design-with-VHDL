library ieee;
use ieee.std_logic_1164.all;

entity tb_traffic is
end tb_traffic;

architecture tb_traffic_behavior of tb_traffic is

component counter is 
port(clk, enable, reset: in std_logic;
	mode: in std_logic_vector(1 downto 0);
	seconds: out std_logic_vector(5 downto 0));
end component;

component generator is 
port(clk, enable, reset: out std_logic;
	mode, mm: out std_logic_vector(1 downto 0));
end component;

component traffic is 
port(clk, enable, reset: in std_logic;
	mode, mm: in std_logic_vector(1 downto 0);
	seconds: in std_logic_vector(5 downto 0);
	green , yellow, red: out std_logic);
end component;

signal tb_clk, tb_enable, tb_reset, tb_green, tb_yellow, tb_red: std_logic;
signal tb_mode, tb_mm: std_logic_vector(1 downto 0);
signal tb_seconds: std_logic_vector(5 downto 0);

begin

cpt1: generator
port map (tb_clk, tb_enable, tb_reset, tb_mode, tb_mm);

cpt2: counter
port map (tb_clk, tb_enable,tb_reset, tb_mode, tb_seconds);

cpt3: traffic
port map (tb_clk, tb_enable, tb_reset, tb_mode, tb_mm, tb_seconds, tb_green, tb_yellow, tb_red);

end tb_traffic_behavior;

