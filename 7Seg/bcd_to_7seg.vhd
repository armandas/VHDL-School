library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_sseg is
    port(
        bcd: in std_logic_vector(3 downto 0);
        dp: in std_logic;
        sseg: out std_logic_vector(7 downto 0)
    );
end bcd_to_sseg;

architecture convert of bcd_to_sseg is
    signal segments: std_logic_vector(6 downto 0);
begin
    with bcd select
        segments <= "1111110" when "0000",
                    "0110000" when "0001",
                    "1101101" when "0010",
                    "1111001" when "0011",
                    "0110011" when "0100",
                    "1011011" when "0101",
                    "1011111" when "0110",
                    "1110000" when "0111",
                    "1111111" when "1000",
                    "1111011" when "1001",
                    "0000001" when others;
    sseg <= dp & segments;
end convert;