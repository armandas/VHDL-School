library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
    port(
        clk, reset: in std_logic;
        switch: in std_logic;
        output: out std_logic
    );
end debouncer;

architecture debounce of debouncer is
    -- 2^N * 20ns = 10ms
    constant N: integer := 19;
    signal counter, counter_next: std_logic_vector(N-1 downto 0);
    signal pause_tick: std_logic;
    type state_type is (zero, wait1_0, wait1_1, test1,
                        one, wait0_0, wait0_1, test0);
    signal state, state_next: state_type;
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            state <= zero;
        elsif (clk'event and clk = '0') then
            state <= state_next;
            counter <= counter_next;
        end if;
    end process;
    
    counter_next <= counter + 1;
    pause_tick <= '1' when (counter = 0) else '0';
    
    process(switch, state, pause_tick)
    begin
        case state is
            when zero =>
                if pause_tick = '1' then
                    state_next <= wait1_0;
                end if;
            when wait1_0 =>
                if pause_tick = '1' then
                    state_next <= wait1_1;
                end if;
            when wait1_1 =>
                if pause_tick = '1' then
                    state_next <= test1;
                end if;
            when test1 =>
                if switch = '1' then
                    output <= '1';
                    state_next <= one;
                end if;
            when one =>
                if pause_tick = '1' then
                    state_next <= wait0_0;
                end if;
            when wait0_0 =>
                if pause_tick = '1' then
                    state_next <= wait0_1;
                end if;
            when wait0_1 =>
                if pause_tick = '1' then
                    state_next <= test0;
                end if;
            when test0 =>
                if switch = '0' then
                    output <= '0';
                    state_next <= zero;
                end if;
        end case;
    end process;
    
end debounce;

