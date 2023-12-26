local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_tab_bar = false

config.window_background_opacity = 0.5

config.color_scheme = 'catppuccin-mocha'
config.font = wezterm.font 'MartianMono Nerd Font Mono'

return config
