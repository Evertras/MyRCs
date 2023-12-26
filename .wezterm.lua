local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_tab_bar = false

config.window_background_opacity = 0.5

config.color_scheme = 'catppuccin-mocha'

-- Fonts
config.font = wezterm.font 'Hasklug Nerd Font Mono'
config.font_size = 18

return config
