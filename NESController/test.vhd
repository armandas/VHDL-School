library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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
    constant DELAY: integer := 500000;
    signal counter, counter_next: std_logic_vector(18 downto 0);

    type states is (start, count);
    signal state, state_next: states;

    signal nes1_a, nes2_a, nes1_b, nes2_b,
           nes1_select, nes2_select, nes1_start, nes2_start,
           nes1_up, nes2_up, nes1_down, nes2_down,
           nes1_left, nes2_left, nes1_right, nes2_right: std_logic;

    signal register_1, register_2: std_logic_vector(7 downto 0);
    signal reg_buf, reg_buf_next: std_logic_vector(7 downto 0);
begin

    process(clk, reset, state_next)
    begin
        if reset = '1' then
            state <= start;
            reg_buf <= (others => '0');
            counter <= (others => '0');
        elsif falling_edge(clk) then
            state <= state_next;
            reg_buf <= reg_buf_next;
            counter <= counter_next;
        end if;
    end process;

    process(state, state_next,
            register_1, register_2, reg_buf,
            counter)
    begin
        state_next <= state;
        counter_next <= counter;
        reg_buf_next <= reg_buf;

        case state is
            when start =>
                reg_buf_next <= (others => '0');
                counter_next <= (others => '0');
                if (register_1 xor register_2) > 0 then
                    reg_buf_next <= (register_1 xor register_2);
                    state_next <= count;
                end if;
            when count =>
                counter_next <= counter + 1;
                if counter_next = DELAY then
                    state_next <= start;
                end if;
        end case;
    end process;

    NES_controllers:
        entity work.controller(arch)
        port map(
            clk => clk, reset => reset,
            data_1 => data_1, data_2 => data_2,
            clk_out => clk_out,
            ps_control => ps_control,
            gamepad1(0) => nes1_a,      gamepad1(1) => nes1_b,
            gamepad1(2) => nes1_select, gamepad1(3) => nes1_start,
            gamepad1(4) => nes1_up,     gamepad1(5) => nes1_down,
            gamepad1(6) => nes1_left,   gamepad1(7) => nes1_right,
            gamepad2(0) => nes2_a,      gamepad2(1) => nes2_b,
            gamepad2(2) => nes2_select, gamepad2(3) => nes2_start,
            gamepad2(4) => nes2_up,     gamepad2(5) => nes2_down,
            gamepad2(6) => nes2_left,   gamepad2(7) => nes2_right
        );

    register_1 <= nes1_a & nes1_b &
                  nes1_start & nes1_select &
                  nes1_up & nes1_down &
                  nes1_left & nes1_right;

    register_2 <= nes2_a & nes2_b &
                  nes2_start & nes2_select &
                  nes2_up & nes2_down &
                  nes2_left & nes2_right;

    LED <= reg_buf;
end behaviour;

