local colors = require("themes.colors")
local palettes = require("themes.palettes")

local M = {}

function M.theme(name)
  name = name or vim.g.colors_name or "x"
  local p = palettes[name]
  if type(p) ~= "table" then
    p = palettes.x
  end

  local bg = colors.strip_alpha(p.background)
  local function readable(colour)
    return colors.readable(colour, bg, 4.5)
  end

  local c = {
    bg = bg,
    fg = colors.strip_alpha(p.foreground),
    bg_alt = colors.surface(p),
    surface_fg = colors.readable(colors.strip_alpha(p.foreground), colors.surface(p), 4.5),
    comment = colors.comment(p),
    red = readable(p.color1),
    green = readable(p.color2),
    yellow = readable(p.color3),
    cyan = readable(p.color6),
  }

  return {
    normal = {
      a = { bg = c.cyan, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    insert = {
      a = { bg = c.green, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    visual = {
      a = { bg = c.yellow, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    replace = {
      a = { bg = c.red, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    command = {
      a = { bg = c.red, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    terminal = {
      a = { bg = c.bg_alt, fg = c.green, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.surface_fg },
      c = { bg = c.bg, fg = c.fg },
    },
    inactive = {
      a = { bg = c.bg_alt, fg = c.comment, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.comment },
      c = { bg = c.bg, fg = c.comment },
    },
  }
end

return M
