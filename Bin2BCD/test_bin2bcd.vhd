library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_bin2bcd is
    port(
        clk, reset: in std_logic;
        switch: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end test_bin2bcd;

architecture behaviour of test_bin2bcd is
    constant NUMBER: integer := 65535;

    signal binary: std_logic_vector(15 downto 0);

    signal bcd0, bcd1, bcd2, bcd3, bcd4: std_logic_vector(3 downto 0);
begin

    binary <= conv_std_logic_vector(NUMBER, 16);

    converter:
    entity work.bin2bcd(behaviour)
    port map(
        clk => clk, reset => reset,
        binary_in => binary,
        bcd0 => bcd0, bcd1 => bcd1,
        bcd2 => bcd2, bcd3 => bcd3,
        bcd4 => bcd4
    );

    with switch select
        led <= bcd0 when "0000",
               bcd1 when "0001",
               bcd2 when "0010",
               bcd3 when "0011",
               bcd4 when others;

end behaviour;