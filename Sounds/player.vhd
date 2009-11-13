library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity player is
    port(
        clk, reset: in std_logic;
        -- test
        start: in std_logic;
        tune_number: in std_logic_vector(2 downto 0);
        led: out std_logic;
        -- /test
        speaker: out std_logic
    );
end player;

architecture arch of player is
    signal pitch: std_logic_vector(18 downto 0);
    signal duration: std_logic_vector(25 downto 0);

    signal enable: std_logic;

    signal d_counter, d_counter_next: std_logic_vector(25 downto 0);

    signal note, note_next: std_logic_vector(5 downto 0);
    signal note_addr, note_addr_next: std_logic_vector(3 downto 0);
    signal change_note: std_logic;

    signal data, data_1, data_2: std_logic_vector(5 downto 0);

    type state_type is (off, playing);
    signal state, state_next: state_type;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= off;
            note_addr <= (others => '0');
            note <= (others => '0');
            d_counter <= (others => '0');
        elsif clk'event and clk = '1' then
            state <= state_next;
            note_addr <= note_addr_next;
            note <= note_next;
            d_counter <= d_counter_next;
        end if;
    end process;

    process(state, start, enable, duration, d_counter, note_addr, change_note)
    begin
        state_next <= state;
        note_addr_next <= note_addr;

        case state is
            when off =>
                led <= '0';
                note_addr_next <= (others => '0');

                if start = '1' then
                    state_next <= playing;
                end if;
            when playing =>
                led <= '1';
                if duration = 0 then
                    state_next <= off;
                elsif change_note = '1' then
                    note_addr_next <= note_addr + 1;
                end if;
        end case;
    end process;

    with tune_number select
        data <= data_1 when "000",
                data_2 when others;

    note_next <= data;

    enable <= '1' when state = playing else '0';
    change_note <= '1' when d_counter = duration else '0';

    d_counter_next <= d_counter + 1 when (enable = '1' and
                                          d_counter < duration) else
                      (others => '0');

    with note(5 downto 3) select
        pitch <= "1101110111110010001" when "001", --  110 Hz
                 "0110111011111001000" when "010", --  220 Hz
                 "0011011101111100100" when "011", --  440 Hz
                 "0001101110111110010" when "100", --  880 Hz
                 "0000110111011111001" when "101", -- 1760 Hz
                 "0000011011101111100" when "110", -- 3520 Hz
                 "0000001101110111110" when "111", -- 7040 Hz
                 "0000000000000000000" when others;

    with note(2 downto 0) select
        duration <= "00000010111110101111000010" when "001", -- 1/64
                    "00000101111101011110000100" when "010", -- 1/32
                    "00001011111010111100001000" when "011", -- 1/16
                    "00010111110101111000010000" when "100", -- 1/8
                    "00101111101011110000100000" when "101", -- 1/4
                    "01011111010111100001000000" when "110", -- 1/2
                    "10111110101111000010000000" when "111", -- 1/1
                    "00000000000000000000000000" when others;

    test_sound1:
        entity work.test_sound1(content)
        port map(
            addr => note_addr,
            data => data_1
        );

    test_sound2:
        entity work.test_sound2(content)
        port map(
            addr => note_addr,
            data => data_2
        );

    sounds:
        entity work.sounds(generator)
        port map(
            clk => clk, reset => reset,
            enable => enable,
            period => pitch,
            speaker => speaker
        );
end arch;

