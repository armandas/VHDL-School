library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pwm is
    generic(
        N: integer := 4
    );
    port(
        clk: in std_logic;
        value: in std_logic_vector(N-1 downto 0);
        output: out std_logic
    );
end pwm;

architecture pwm_arch of pwm is
    signal accumulator: std_logic_vector(N-1 downto 0);
    signal accum_next: std_logic_vector(N-1 downto 0);
    signal pwm_next: std_logic;
begin
    process(clk)
    begin
        if (clk'event and clk = '0') then
            accumulator <= accum_next;
            output <= pwm_next;
        end if;
    end process;
    
    accum_next <= accumulator + '1';
    pwm_next <= '1' when (accumulator < value) else '0';
    
end pwm_arch;