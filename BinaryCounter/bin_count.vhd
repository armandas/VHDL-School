library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bin_count is
    generic(N: integer := 3);
    port (
        clk, reset: in std_logic;
        count: out std_logic_vector((2 ** N) - 1 downto 0)
    );
end bin_count;

architecture bin_count_arch of bin_count is
    signal bin: std_logic_vector(N - 1 downto 0);
begin
    bled: entity work.bin_led(bin_led_arch)
        port map(binary => bin, unary => count);

    process(clk, reset)
    begin
        if (reset = '1') then
            bin <= (others => '0');
        elsif (clk'event and clk = '0') then
            bin <= bin + 1;
        end if;
    end process;
end bin_count_arch;

