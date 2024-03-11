-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Google (dark) (terminal.sexy)"
config.font_size    = 8.5

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys   = {
  { mods   = "LEADER|SHIFT",   key = "\"",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }},
  { mods   = "LEADER|SHIFT",   key = "%",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }},
  { mods   = "LEADER|CTRL",    key = "k",
    action = wezterm.action { ActivatePaneDirection = "Up" }},
  { mods   = "LEADER|CTRL",    key = "j",
    action = wezterm.action { ActivatePaneDirection = "Down" }},
  { mods   = "LEADER|CTRL",    key = "h",
    action = wezterm.action { ActivatePaneDirection = "Left" }},
  { mods   = "LEADER|CTRL",    key = "l",
    action = wezterm.action { ActivatePaneDirection = "Right" }},
  { mods   = "LEADER",         key = "[",
    action = wezterm.action.ActivateCopyMode},
  { mods   = "LEADER",           key = "x",
    action = wezterm.action.CloseCurrentPane { confirm = true }},
  { mods   = "CTRL",           key = "w",
    action = wezterm.action.CloseCurrentTab { confirm = true }},
  { mods   = "CTRL",           key = "t",
    action = wezterm.action.SpawnTab "CurrentPaneDomain"},
  { mods   = "LEADER",         key = "w",
    action = wezterm.action.ShowTabNavigator},
  { mods   = "LEADER",         key = "z",
    action = wezterm.action.TogglePaneZoomState},
  { mods   = "LEADER",         key = "z",
    action = wezterm.action.TogglePaneZoomState},
}

-- config.key_tables = {
--   copy_mode = {
--     { mods   = "NONE",           key = "/",
--       action = wezterm.action.Search { CaseSensitiveString = "" }},
--     { mods   = "NONE",           key = "n",
--       action = wezterm.action.CopyMode "NextMatch"},
--     { mods   = "SHIFT",           key = "N",
--       action = wezterm.action.CopyMode "PriorMatch"},
--   },
--   search_mode = {
--     { mods   = "NONE",           key = "Escape",
--       action = wezterm.action.CopyMode "Close"},
--     { mods   = "NONE",           key = "Enter",
--       action = wezterm.action.ActivateCopyMode}
--   }
-- }

-- and finally, return the configuration to wezterm
return config

