library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sounds is
    port(
        clk, reset: in std_logic;
        enable: in std_logic;
        period: in std_logic_vector(18 downto 0);
        speaker: out std_logic
    );
end sounds;

architecture generator of sounds is
    signal counter, counter_next: std_logic_vector(18 downto 0);
    signal pulse_width: std_logic_vector(17 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
        elsif clk'event and clk = '0' then
            counter <= counter_next;
        end if;
    end process;

    -- 50% duty cycle
    pulse_width <= period(18 downto 1);

    counter_next <= (others => '0') when counter = period else
                    counter + 1;
    speaker <= '1' when (enable = '1' and counter < pulse_width) else '0';
end generator;