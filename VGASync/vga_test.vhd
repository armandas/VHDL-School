library ieee;
use ieee.std_logic_1164.all;

entity vga_test is
    port (
        clk, reset: in std_logic;
        hsync, vsync: out  std_logic;
        rgb: out std_logic_vector(2 downto 0)
    );
end vga_test;

architecture arch of vga_test is
    signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
    signal video_on: std_logic;
    signal px_x, px_y: std_logic_vector(9 downto 0);
    signal colour: std_logic_vector(2 downto 0);
begin

    vga_sync_unit: entity work.vga(sync)
        port map(
            clk => clk, reset => reset,
            hsync => hsync, vsync => vsync,
            video_on => video_on, p_tick=>open,
            pixel_x => px_x, pixel_y => px_y
        );

    process (clk, reset)
    begin
        if reset = '1' then
            rgb_reg <= (others => '0');
        elsif clk'event and clk = '0' then
            rgb_reg <= rgb_next;
        end if;
    end process;

    -- draws a white/black border and then selects a colour
    rgb_next <= "111" when px_x = 0 or
                           px_x = 639 or
                           px_y = 0 or
                           px_y = 479 else
                "000" when px_x = 1 or
                           px_x = 638 or
                           px_y = 1 or
                           px_y = 478 else
                colour;

    -- changes the colour accorging to x position
    colour <= "110" when px_x > 530 else
              "101" when px_x > 424 else
              "100" when px_x > 318 else
              "011" when px_x > 212 else
              "010" when px_x > 106 else
              "001";
    
    rgb <= rgb_reg when video_on = '1' else "000";
end arch;