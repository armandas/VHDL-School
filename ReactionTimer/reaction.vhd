library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reaction is
    port(
        clk: in std_logic;
        start, stop, clear: in std_logic;       
    );
end reaction;

architecture measure of reaction is
    const MILLISECOND: integer := 50000;
    type state_type is (idle, rand_wait, count);
    signal state, state_next: state_type;
    signal timer, timer_next: std_logic_vector(15 downto 0);
    -- t will be increased when timer reaches 50000 (i.e. 1ms)
    signal t, t_next: std_logic_vector(9 downto 0);
    signal lol, fail: std_logic;
begin

end measure;

