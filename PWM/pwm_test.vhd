library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pwm_test is
    port(
        clk: in std_logic;
        btn: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(7 downto 0)
    );
end pwm_test;

architecture test of pwm_test is
    signal pwm_val: std_logic;
begin
    pwm0: entity work.pwm(pwm_arch)
        port map(clk => clk, value => btn, output => pwm_val);

    led <= (others => pwm_val);
end test;