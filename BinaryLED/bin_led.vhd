library ieee;
use ieee.std_logic_1164.all;

entity bin_led is
    port (
        binary: in std_logic_vector(2 downto 0);
        unary: out std_logic_vector(7 downto 0)
    );
end bin_led;

architecture bin_led_arch of bin_led is
begin
    with binary select
        unary <= "00000000" when "000",
                 "00000001" when "001",
                 "00000011" when "010",
                 "00000111" when "011",
                 "00001111" when "100",
                 "00011111" when "101",
                 "00111111" when "110",
                 "01111111" when others;
end bin_led_arch;
