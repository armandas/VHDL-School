library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_sound2 is
    generic(
        ADDR_WIDTH: integer := 4
    );
    port(
        addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        data: out std_logic_vector(5 downto 0)
    );
end test_sound2;

architecture content of test_sound2 is
    type tune is array(0 to 2 ** ADDR_WIDTH - 1)
        of std_logic_vector(5 downto 0);
    constant TEST: tune :=
    (
        "111001",
        "001001",
        "110001",
        "001001",
        "101001",
        "001001",
        "100001",
        "001001",
        "011001",
        "001001",
        "010001",
        "001001",
        "001001",
        "001001",
        "000000",
        "000000"
    );
begin
    data <= TEST(conv_integer(addr));
end content;

