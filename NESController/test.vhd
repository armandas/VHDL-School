library ieee;
use ieee.std_logic_1164.all;

entity test is
    port(
        clk, reset: in std_logic;
        data_1, data_2: in std_logic;
        clk_out: out std_logic;
        ps_control: out std_logic;
        LED: out std_logic_vector(7 downto 0)
    );
end test;

architecture behaviour of test is
    signal nes1_a, nes2_a, nes1_b, nes2_b,
           nes1_select, nes2_select, nes1_start, nes2_start,
           nes1_up, nes2_up, nes1_down, nes2_down,
           nes1_left, nes2_left, nes1_right, nes2_right: std_logic;

    signal register_1, register_2: std_logic_vector(7 downto 0);
begin

    NES_controllers:
        entity work.controller(arch)
        port map(
            clk => clk, reset => reset,
            data_1 => data_1, data_2 => data_2,
            clk_out => clk_out,
            ps_control => ps_control,
            nes1_a => nes1_a, nes2_a => nes2_a,
            nes1_b => nes1_b, nes2_b => nes2_b,
            nes1_select => nes1_select, nes2_select => nes2_select,
            nes1_start => nes1_start, nes2_start => nes2_start,
            nes1_up => nes1_up, nes2_up => nes2_up,
            nes1_down => nes1_down, nes2_down => nes2_down,
            nes1_left => nes1_left, nes2_left => nes2_left,
            nes1_right => nes1_right, nes2_right => nes2_right
        );

    register_1 <= nes1_a & nes1_b &
                  nes1_start & nes1_select &
                  nes1_up & nes1_down &
                  nes1_left & nes1_right;

    register_2 <= nes2_a & nes2_b &
                  nes2_start & nes2_select &
                  nes2_up & nes2_down &
                  nes2_left & nes2_right;

    LED <= register_1 xor register_2;
    
end behaviour;

