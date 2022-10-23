return {
    keys = {{key = "=", mods = "CTRL", action = "IncreaseFontSize"}},
    font_size = 16.0,
    -- Hide tabs.
    enable_tab_bar = false,
    enable_scroll_bar = false,
    -- color_scheme = "Dracula",
    color_scheme = "Catppuccin Mocha",
    -- No top but resizable for yabai.
    window_decorations = "RESIZE",
    -- Default folder to open.
    cwd = '/Users/endrevegh/Repos',
    window_padding = {left = 6, right = 0, top = 0, bottom = 0},
    -- That makes wezterm not to consume lalt, so it can be used by yabai.
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true
}
