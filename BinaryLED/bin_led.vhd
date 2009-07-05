library ieee;
use ieee.std_logic_1164.all;

entity bin_led is
    port (
        bin: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(7 downto 0)
    );
end bin_led;

architecture bin_led_arch of bin_led is
begin
    with bin select
        led <= "00000000" when "0000",
               "00000001" when "0001",
               "00000011" when "0010",
               "00000111" when "0011",
               "00001111" when "0100",
               "00011111" when "0101",
               "00111111" when "0110",
               "01111111" when "0111",
               "11111111" when others;
end bin_led_arch;
