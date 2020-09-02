library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic is
port(clk, enable, reset: in std_logic;
	mode, mm: in std_logic_vector(1 downto 0);
	seconds: in std_logic_vector(5 downto 0);
	green , yellow, red: out std_logic);
end traffic;

architecture fsm of traffic is
type state_type is (maintenance, nominal, standby, off);
signal state: state_type := maintenance;
--signal g, y, r: std_logic;
signal next_state : state_type;
signal sec: integer:= 0;
signal mm_var: std_logic_vector (1 downto 0) := "00";

begin
sec <= to_integer(unsigned(seconds));

process(clk)
begin
if(rising_edge(clk)) then 
 state <= next_state;
end if;
end process;

process (clk)
begin
	case state is
		when maintenance => if (enable='0') then next_state <= off; elsif (mode="01") then next_state <= nominal; elsif (mode="10") then next_state <= standby; end if;
		when nominal => if (enable='0') then next_state <= off; elsif(mode="00") then next_state <= maintenance; elsif (mode="10" and mm_var="10") then next_state <= nominal; elsif ( mode = "10") then next_state <= standby; end if;
		when standby => if (enable='0') then next_state <= off; elsif(mode="01") then next_state <= nominal; elsif (mode="00") then next_state <= maintenance; elsif (mode = "10" and mm_var = "10" and sec = 10) then next_state <= nominal; end if;
		when off => if (enable='0') then next_state <= off; elsif(mode="01") then next_state <= nominal; elsif (mode="00") then next_state <= maintenance; elsif (mode="10") then next_state <= standby; end if;
		--when other => state <= maintenance;
	end case;
end process;

process (clk, reset)
begin
	case state is
		when maintenance => red<='1'; yellow<='1'; green<='1'; 
					if (mm /= "11") then 
						mm_var  <= mm;
					end if;
		when nominal => if ((sec mod 10) < 3) then
					red<='0'; yellow<='0'; green<='1';
				elsif ((sec mod 10) < 5) then
					red<='0'; yellow<='1'; green<='1';
				elsif ((sec mod 10) < 10) then
					red<='1'; yellow<='0'; green<='0';
				end if;
		when standby => if (mm_var = "00") then
					if ((sec mod 3) < 1) then
						red<='0'; yellow<='1'; green<='0';
					elsif ((sec mod 3) < 3) then
						red<='0'; yellow<='0'; green<='0';
					end if;
				elsif (mm_var = "01") then
					if ((sec mod 2) = 0) then
						red<='0'; yellow<='0'; green<='1';
					elsif ((sec mod 2) = 1) then
						red<='1'; yellow<='0'; green<='0';
					end if;
				elsif ( mm_var = "10") then
					if ((sec mod 2) = 0) then
						red<='0'; yellow<='0'; green<='1';
					elsif ((sec mod 2) = 1) then
						red<='1'; yellow<='0'; green<='0';
					end if;
				end if;
		when off => red<='0'; yellow<='0'; green<='0';
		end case;
		if (reset'event and reset='0') then
			mm_var <= "00";
		end if;
end process;

end architecture;

