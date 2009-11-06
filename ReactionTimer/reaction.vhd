library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reaction is
    port(
        clk, reset: in std_logic;
        start, stop: in std_logic;
        sseg_en: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0);
        led: out std_logic
    );
end reaction;

architecture measure of reaction is
    constant MILLISECOND: integer := 50000;
    type state_type is (idle, rand_wait, count);

    signal state, state_next: state_type;
    signal m3, m2, m1, m0: std_logic_vector(7 downto 0);
    signal timer, timer_next: std_logic_vector(15 downto 0);
    -- t will be increased when timer reaches 50000 (i.e. 1ms at 50MHz)
    signal t, t_next: std_logic_vector(9 downto 0);
    signal lol, lol_next, fail, fail_next: std_logic;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= idle;
        elsif (clk'event and clk = '0') then
            state <= state_next;
            timer <= timer_next;
            t <= t_next;
            lol <= lol_next;
            fail <= fail_next;
        end if;
    end process;

    process(start, stop, state, timer, t, lol, fail)
    begin
        led <= '0';
        if timer = (MILLISECOND - 1) then
            if t = 999 then
                --led <= '1';
                lol_next <= '1';
                state_next <= idle;
            else
                t_next <= t + 1;
                timer_next <= (others => '0');
            end if;
        else
            timer_next <= timer + 1;
            led <= '1';
        end if;
    end process;

    disp: entity work.sseg_mux(mux_arch)
        port map(
            clk => clk, reset => reset,
            in0 => m0, in1 => m1, in2 => m2, in3 => m3,
            en => sseg_en,
            sseg => sseg
        );

end measure;

