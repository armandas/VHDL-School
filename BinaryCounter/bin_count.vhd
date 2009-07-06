library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bin_count is
    generic(N: integer := 4);
    port (
        clk: in std_logic;
        led: out std_logic_vector(N-1 downto 0)
    );
end bin_count;

architecture bin_count_arch of bin_count is
    signal val: std_logic_vector(N-1 downto 0);
begin
    process(clk)
    begin
        if (clk'event and clk = '0') then
            val <= val + 1;
        end if;
    end process;
    
    led <= val;
end bin_count_arch;

