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
    signal lol, fail: std_logic;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= idle;
        elsif (clk'event and clk = '0') then
            state <= state_next;
            timer <= timer_next;
            t <= t_next;
        end if;
    end process;

    process(start, stop, state, timer, t, lol, fail)
    begin
        case state is
            when idle =>
                led <= lol;
                if start = '1' then
                    state_next <= rand_wait;
                    timer_next <= (others => '0');
                    t_next <= (others => '0');
                    -- clear stuff
                    m3 <= (others => '0');
                    m2 <= (others => '0');
                    m1 <= (others => '0');
                    m0 <= (others => '0');
                    fail <= '0';
                    lol <= '0';
                    led <= '0';
                else
                    if lol = '1' then
                        m3 <= "00001110"; -- L
                        m2 <= "01111110"; -- O
                        m1 <= "00001110"; -- L
                        m0 <= (others => '0'); -- off
                    elsif fail = '1' then
                        m3 <= "01000111"; -- F
                        m2 <= "01110111"; -- A
                        m1 <= "00000110"; -- I
                        m0 <= "00001110"; -- L
                    elsif t > 0 then --and t < 999 then
                        -- need to implement binary-to-bcd converter
                        m3 <= "11111111";
                        m2 <= "11111111";
                        m1 <= "11111111";
                        m0 <= "11111111";
                    else
                        m3 <= "00110111"; -- H
                        m2 <= "00000110"; -- I
                        m1 <= (others => '0'); -- off
                        m0 <= (others => '0'); -- off
                    end if;
                end if;

            when rand_wait =>
                if stop = '1' then
                    fail <= '1';
                    state_next <= idle;
                else
                    -- random waiting happens here
                    --
                    -- if already_random then
                    --     state_next <= count;
                    -- end if;
                    state_next <= count;
                end if;

            when count =>
                state_next <= count;
                led <= '1';

                if stop = '1' then
                    state_next <= idle;
                    led <= '0';
                else
                    if timer = (MILLISECOND - 1) then
                        --if t = 99 then
                            led <= '0';
                            lol <= '1';
                            state_next <= idle;
                        --else
                            --t_next <= t + 1;
                            --timer_next <= (others => '0');
                        --end if;
                    else
                        timer_next <= timer + 1;
                    end if;
                end if;
        end case;

    end process;

    disp: entity work.sseg_mux(mux_arch)
        port map(
            clk => clk, reset => reset,
            in0 => m0, in1 => m1, in2 => m2, in3 => m3,
            en => sseg_en,
            sseg => sseg
        );

end measure;

