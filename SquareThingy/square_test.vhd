library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity square_test is
    port(
        clk: in std_logic;
        cw: in std_logic;
        en: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0)
    );
end square_test;

architecture test of square_test is
begin
    sq0: entity work.circle(rotate)
        port map(
            clk => clk,
            cw => cw,
            disp => en,
            value => sseg
        );
end test;