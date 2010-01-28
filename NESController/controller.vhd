library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controller is
    port(
        clk, reset: in std_logic;
        data_1, data_2: in std_logic;
        clk_out: out std_logic;
        ps_control: out std_logic;
        nes1_a, nes2_a, nes1_b, nes2_b,
        nes1_select, nes2_select, nes1_start, nes2_start,
        nes1_up, nes2_up, nes1_down, nes2_down,
        nes1_left, nes2_left, nes1_right, nes2_right: out std_logic
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
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
            quad_counter <= (others => '0');
            ps_counter <= (others => '0');
        elsif falling_edge(clk) then
            counter <= counter_next;
            quad_counter <= quad_counter_next;
            ps_counter <= ps_counter_next;
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

    nes1_a      <= '1' when data_1 = '0' and ps_counter = 0 and quad_counter = 1 else '0';
    nes1_b      <= '1' when data_1 = '0' and ps_counter = 1 and quad_counter = 1 else '0';
    nes1_select <= '1' when data_1 = '0' and ps_counter = 2 and quad_counter = 1 else '0';
    nes1_start  <= '1' when data_1 = '0' and ps_counter = 3 and quad_counter = 1 else '0';
    nes1_up     <= '1' when data_1 = '0' and ps_counter = 4 and quad_counter = 1 else '0';
    nes1_down   <= '1' when data_1 = '0' and ps_counter = 5 and quad_counter = 1 else '0';
    nes1_left   <= '1' when data_1 = '0' and ps_counter = 6 and quad_counter = 1 else '0';
    nes1_right  <= '1' when data_1 = '0' and ps_counter = 7 and quad_counter = 1 else '0';

    nes2_a      <= '1' when data_2 = '0' and ps_counter = 0 and quad_counter = 1 else '0';
    nes2_b      <= '1' when data_2 = '0' and ps_counter = 1 and quad_counter = 1 else '0';
    nes2_select <= '1' when data_2 = '0' and ps_counter = 2 and quad_counter = 1 else '0';
    nes2_start  <= '1' when data_2 = '0' and ps_counter = 3 and quad_counter = 1 else '0';
    nes2_up     <= '1' when data_2 = '0' and ps_counter = 4 and quad_counter = 1 else '0';
    nes2_down   <= '1' when data_2 = '0' and ps_counter = 5 and quad_counter = 1 else '0';
    nes2_left   <= '1' when data_2 = '0' and ps_counter = 6 and quad_counter = 1 else '0';
    nes2_right  <= '1' when data_2 = '0' and ps_counter = 7 and quad_counter = 1 else '0';

    clk_out <= (not quad_counter(1));
    ps_control <= (not quad_counter(1)) when ps_counter = 8 else '1';
end arch;

