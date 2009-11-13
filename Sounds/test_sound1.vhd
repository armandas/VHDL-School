library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_sound1 is
    generic(
        ADDR_WIDTH: integer := 4
    );
    port(
        addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        data: out std_logic_vector(5 downto 0)
    );
end test_sound1;

architecture content of test_sound1 is
    type tune is array(0 to 2 ** ADDR_WIDTH - 1)
        of std_logic_vector(5 downto 0);
    constant TEST: tune :=
    (
        "011010",
        "000001",
        "011010",
        "000001",
        "100010",
        "000001",
        "100010",
        "000001",
        "101010",
        "000001",
        "101010",
        "000000",
        "000000",
        "000000",
        "000000",
        "000000"

    );
begin
    data <= TEST(conv_integer(addr));
end content;

