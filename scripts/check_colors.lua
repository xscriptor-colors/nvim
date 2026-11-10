-- Headless checks for every Xscriptor theme.
--
-- Run with:
--   nvim --headless -u NONE --cmd "set rtp+=." -l scripts/check_colors.lua
--
-- The script applies each palette and verifies that the most important syntax
-- and UI highlight groups have enough contrast against their background.

local colors = require("themes.colors")
local palettes = require("themes.palettes")
local themes = require("themes")

local failures = {}

local function fail(message)
  table.insert(failures, message)
end

local function to_hex(value)
  if type(value) ~= "number" then
    return nil
  end
  return string.format("#%06x", value)
end

local function check_group(name, group, minimum, default_bg)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  local fg = to_hex(hl.fg)
  local bg = to_hex(hl.bg) or default_bg
  if not fg then
    fail(("%s: %s has no foreground colour"):format(name, group))
    return
  end
  local ratio = colors.contrast(fg, bg)
  if ratio < minimum then
    fail(("%s: %s contrast %.2f < %.2f (%s on %s)"):format(name, group, ratio, minimum, fg, bg))
  end
end

if type(palettes.strip_alpha) ~= "function" then
  fail("palettes.strip_alpha is missing")
end

if #themes.names ~= 12 then
  fail(("expected 12 palettes, found %d"):format(#themes.names))
end

for _, name in ipairs(themes.names) do
  if type(palettes[name]) ~= "table" then
    fail(("%s: not a palette table"):format(name))
  else
    local ok = themes.apply(name)
    if not ok then
      fail(("%s: themes.apply returned false"):format(name))
    else
      local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      local bg = to_hex(normal.bg)
      if not bg then
        fail(("%s: Normal has no background"):format(name))
      else
        if vim.g.colors_name ~= name then
          fail(("%s: colors_name is %s"):format(name, tostring(vim.g.colors_name)))
        end

        local minimums = {
          Comment = 3.0,
          LineNr = 3.0,
          String = 4.5,
          Function = 4.5,
          Keyword = 4.5,
          Type = 4.5,
          Constant = 4.5,
          Number = 4.5,
          Identifier = 4.5,
          Operator = 4.5,
          Statement = 4.5,
          PreProc = 4.5,
          DiagnosticError = 4.5,
          DiagnosticWarn = 4.5,
          DiagnosticInfo = 4.5,
          DiagnosticHint = 4.5,
          StatusLine = 4.5,
          StatusLineNC = 3.0,
          TabLine = 3.0,
          CursorLineNr = 4.5,
          WinBar = 4.5,
          Pmenu = 4.5,
          Visual = 4.5,
          Search = 4.5,
          PmenuSel = 4.5,
        }

        for group, minimum in pairs(minimums) do
          check_group(name, group, minimum, bg)
        end

        for slot = 0, 15 do
          local value = vim.g["terminal_color_" .. slot]
          if type(value) ~= "string" or not value:match("^#%x%x%x%x%x%x$") then
            fail(("%s: terminal_color_%d is %s"):format(name, slot, tostring(value)))
          end
        end
      end
    end
  end
end

if themes.apply("this-theme-does-not-exist") then
  fail("unknown palette should return false")
end

if #failures > 0 then
  print(("Theme checks failed (%d):"):format(#failures))
  for _, message in ipairs(failures) do
    print("  - " .. message)
  end
  vim.cmd("cquit 1")
else
  print(("Theme checks passed for %d palettes."):format(#themes.names))
end
