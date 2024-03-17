-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This will hold the configuration.
local config = config or wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  config.font_size  = 12.5
  config.color_scheme = "Google Dark (Gogh)"
  config.inactive_pane_hsb = {
    hue        = 1,
    saturation = 1,
    brightness = 1,
  }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.font = wezterm.font_with_fallback {
    "NotoMono Nerd Font",  -- font_size = 9.0
  }
  config.font_size  = 9.0 -- default 8.5
  config.color_scheme = "Google Dark (base16)"
  config.inactive_pane_hsb = {
    hue        = 1,
    saturation = 1,
    brightness = 1,
  }
end

config.enable_tab_bar = false

config.leader = { mods = "CTRL", key = "Space", timeout_milliseconds = 5000 }
config.keys   = {
  { mods   = "LEADER|SHIFT",   key = "\"",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }},
  { mods   = "LEADER|SHIFT",   key = "%",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }},
  { mods   = "LEADER",         key = "k",
    action = wezterm.action { ActivatePaneDirection = "Up" }},
  { mods   = "LEADER",         key = "j",
    action = wezterm.action { ActivatePaneDirection = "Down" }},
  { mods   = "LEADER",         key = "h",
    action = wezterm.action { ActivatePaneDirection = "Left" }},
  { mods   = "LEADER",         key = "l",
    action = wezterm.action { ActivatePaneDirection = "Right" }},
  { mods   = "LEADER",         key = "[",
    action = wezterm.action.ActivateCopyMode},
  { mods   = "LEADER",         key = "x",
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
  { mods   = "LEADER",         key = "N",
    action = wezterm.action.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = "Enter the name for the workspace" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            wezterm.action.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    }
  },
}

-- Ask for confirmation before closing any windows, panes, or tabs
config.skip_close_confirmation_for_processes_named = {}

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

