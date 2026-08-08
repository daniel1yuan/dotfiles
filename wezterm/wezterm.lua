-- @file: WezTerm Terminal Configuration File
-- @author: Daniel Yuan (daniel1yuan@gmail.com)

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Mac muscle memory: Cmd on macOS. There is no Cmd key on Linux, and GNOME
-- claims most Super combos, so Linux uses Alt instead (it sits where Cmd does
-- on a Mac keyboard). Same scheme as the ghostty config. Heads up: alt+<key>
-- normally sends Meta to the shell, so these shadow some readline keys
-- (notably alt+d, usually delete-word).
local is_mac = wezterm.target_triple:find("darwin") ~= nil
local mod = is_mac and "SUPER" or "ALT"

-- Start in fullscreen (swap toggle_fullscreen() for maximize() to keep the
-- titlebar). WezTerm has no config knob for this, so hook the first window.
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

-- Other config
config.scrollback_lines = 5000
config.window_close_confirmation = "NeverPrompt"

-- Colors: Catppuccin Mocha (built into wezterm)
config.color_scheme = "Catppuccin Mocha"

-- Font: Requires NerdFont installation
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")

-- SSH domains are machine-specific and belong in custom.lua (see below).
-- Initialized empty so custom.lua can table.insert into it.
config.ssh_domains = {}

config.keys = {
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = act.Multiple({
      act.ClearScrollback("ScrollbackAndViewport"),
      act.SendKey({ key = "l", mods = "CTRL" }),
    }),
  },

  -- New tab (Cmd+T on mac, Alt+T on Linux)
  { key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },

  -- New split (Cmd+D / Cmd+Shift+D)
  { key = "d", mods = mod, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = mod .. "|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Split navigation (hjkl)
  { key = "h", mods = mod, action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = mod, action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = mod, action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = mod, action = act.ActivatePaneDirection("Right") },
}

-- Switch to tab N (Cmd+1-9 / Alt+1-9). Also overrides wezterm's macOS default
-- of Cmd+9 = last tab, for parity with ghostty.
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = mod, action = act.ActivateTab(i - 1) })
end

-- Machine-specific overrides: wezterm/custom.lua (gitignored) may return a
-- function that mutates the config (ssh_domains, extra keys, font size, etc).
local ok, custom = pcall(require, "custom")
if ok and type(custom) == "function" then
  custom(config)
end

return config
