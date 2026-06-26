-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Maximize
wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

-- changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- Font
config.font_size = 14.5
config.line_height = 1.08
config.cell_width = 1.0
config.font = wezterm.font 'Hack Nerd Font'

-- Theme
config.color_scheme = 'Tokyo Night'

-- Backgound
-- config.background = {
--   {
--     source = {
--       File = "",
--     },
--     width = "100%",
--     height = "100%",
--     horizontal_align = "Center",
--     vertical_align = "Middle",
--     repeat_x = "NoRepeat",
--     repeat_y = "NoRepeat",
--     hsb = {
--       brightness = 0.2,
--       saturation = 0.8,
--     },
--   },
-- }

-- Launch
config.default_prog = { 'ssh.exe', 'ky9oss@127.0.0.1', '-p', '27777' }

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
  font = wezterm.font { family = 'Hack Nerd Font', weight = 'Bold' },
  font_size = 10.0,
}

-- Palette
config.command_palette_font_size = 12.0
config.command_palette_bg_color = '#1a1b26'

-- Bell
config.audible_bell = "Disabled" -- SystemBeep
-- config.visual_bell = {
--   fade_in_function = "EaseIn",
--   fade_out_function = "EaseOut",
--   fade_in_duration_ms = 150,
--   fade_out_duration_ms = 300,
-- }

-- Padding
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 12, right = 12,
  top = 8, bottom = 8,
}

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600
config.force_reverse_video_cursor = true

-- Finally, return the configuration to wezterm:
return config

