library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reaction is
    port(
        clk: in std_logic;
        start, stop, clear: in std_logic
    );
end reaction;

architecture measure of reaction is
    constant MILLISECOND: integer := 50000;
    
    type state_type is (idle, rand_wait, count);
    type sseg_msg is array(3 downto 0) of std_logic_vector(7 downto 0);

    signal state, state_next: state_type;
    signal message: sseg_msg;
    signal timer, timer_next: std_logic_vector(15 downto 0);
    -- t will be increased when timer reaches 50000 (i.e. 1ms at 50MHz)
    signal t, t_next: std_logic_vector(9 downto 0);
    signal lol, fail: std_logic;
begin
    
    process(clk)
    begin
        if clk'event and clk = '0' then
            state <= state_next;
            timer <= timer_next;
            t <= t_next;
        end if;
    end process;

    process(start, stop, clear, state)
    begin
        case state is
            when idle =>
                if start = '1' then
                    state_next <= rand_wait;
                    -- clear stuff
                    message <= (others => (others => '0'));
                    fail <= '0';
                    lol <= '0';
                    t_next <= (others => '0');
                else
                    if t < 999 then
                        message(3) <= "11111110"; -- 0.
                        -- need to implement binary-to-bcd converter
                    elsif lol = '1' then
                        message(3) <= "00001110"; -- L
                        message(2) <= "01111110"; -- O
                        message(1) <= "00001110"; -- L
                        message(0) <= (others => '0'); -- off
                    elsif fail = '1' then
                        message(3) <= "01000111"; -- F
                        message(2) <= "01110111"; -- A
                        message(1) <= "00000110"; -- I
                        message(0) <= "00001110"; -- L
                    else
                        message(3) <= "00110111"; -- H
                        message(2) <= "00000110"; -- I
                        message(1) <= (others => '0'); -- off
                        message(0) <= (others => '0'); -- off
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
                 end if;

            when count =>
                if stop = '1' then
                    state_next <= idle;
                else
                    if timer = MILLISECOND - 1 then
                        t_next <= t + 1;
                        timer_next <= (others => '0');
                    elsif t = 999 then
                        lol <= '1';
                        state_next <= idle;
                    else
                        timer_next <= timer + 1;
                    end if;
                end if;
        end case;
    
    end process;

    --sseg:display(message);

end measure;

