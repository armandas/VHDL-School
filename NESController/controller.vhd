library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controller is
    port(
        clk, reset: in std_logic;
        data_1, data_2: in std_logic;
        clk_out: out std_logic;
        ps_control: out std_logic;
        gamepad_1, gamepad_2: out std_logic_vector(7 downto 0);
        LED: out std_logic_vector(7 downto 0)
    );
end controller;

architecture arch of controller is
    constant M: integer := 12500; -- 4kHz
    signal counter, counter_next: std_logic_vector(13 downto 0);
    
    -- counts from 0 to 4 @ 4kHz,
    -- clk_out uses MSB to output 1kHz signal
    -- sampling should be done when quad_counter = 3
    signal quad_counter, quad_counter_next: std_logic_vector(1 downto 0);
    signal ps_counter, ps_counter_next: std_logic_vector(3 downto 0);

    signal register_1, register_1_next: std_logic_vector(7 downto 0);
    signal register_2, register_2_next: std_logic_vector(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
            quad_counter <= (others => '0');
            ps_counter <= (others => '0');
            register_1 <= (others => '1');
            register_2 <= (others => '1');
        elsif falling_edge(clk) then
            counter <= counter_next;
            quad_counter <= quad_counter_next;
            ps_counter <= ps_counter_next;
            register_1 <= register_1_next;
            register_2 <= register_2_next;
        end if;
    end  process;

    counter_next <= (counter + 1) when counter < M else
                    (others => '0');

    quad_counter_next <= (quad_counter + 1) when counter = 0 else
                          quad_counter;

    ps_counter_next <= (others => '0') when (ps_counter = 8 and
                                             quad_counter = 1) else
                       (ps_counter + 1) when (quad_counter = 1 and
                                              counter = 0) else ps_counter;

    register_1_next(0) <= data_1 when (ps_counter = 0 and quad_counter = 1) else register_1(0);
    register_1_next(1) <= data_1 when (ps_counter = 1 and quad_counter = 1) else register_1(1);
    register_1_next(2) <= data_1 when (ps_counter = 2 and quad_counter = 1) else register_1(2);
    register_1_next(3) <= data_1 when (ps_counter = 3 and quad_counter = 1) else register_1(3);
    register_1_next(4) <= data_1 when (ps_counter = 4 and quad_counter = 1) else register_1(4);
    register_1_next(5) <= data_1 when (ps_counter = 5 and quad_counter = 1) else register_1(5);
    register_1_next(6) <= data_1 when (ps_counter = 6 and quad_counter = 1) else register_1(6);
    register_1_next(7) <= data_1 when (ps_counter = 7 and quad_counter = 1) else register_1(7);

    register_2_next(0) <= data_2 when (ps_counter = 0 and quad_counter = 1) else register_2(0);
    register_2_next(1) <= data_2 when (ps_counter = 1 and quad_counter = 1) else register_2(1);
    register_2_next(2) <= data_2 when (ps_counter = 2 and quad_counter = 1) else register_2(2);
    register_2_next(3) <= data_2 when (ps_counter = 3 and quad_counter = 1) else register_2(3);
    register_2_next(4) <= data_2 when (ps_counter = 4 and quad_counter = 1) else register_2(4);
    register_2_next(5) <= data_2 when (ps_counter = 5 and quad_counter = 1) else register_2(5);
    register_2_next(6) <= data_2 when (ps_counter = 6 and quad_counter = 1) else register_2(6);
    register_2_next(7) <= data_2 when (ps_counter = 7 and quad_counter = 1) else register_2(7);

    LED <= (register_1 or register_2) when ps_counter = 8 else (others => '0');

    gamepad_1 <= register_1 when ps_counter = 8 else (others => '1');
    gamepad_2 <= register_2 when ps_counter = 8 else (others => '1');

    clk_out <= (not quad_counter(1));
    ps_control <= (not quad_counter(1)) when ps_counter = 8 else '1';
end arch;

