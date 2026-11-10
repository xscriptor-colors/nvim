local colors = require("themes.colors")
local palettes = require("themes.palettes")

local M = {}

local function set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.apply(name)
  local p = palettes[name]
  if type(p) ~= "table" then
    return false
  end

  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end

  vim.cmd("syntax reset")

  vim.o.termguicolors = true
  vim.o.background = colors.is_light(p.background) and "light" or "dark"
  vim.g.colors_name = name

  local bg = colors.strip_alpha(p.background)
  local fg = colors.strip_alpha(p.foreground)
  local function readable(colour)
    return colors.readable(colour, bg, 4.5)
  end

  local c = {
    bg = bg,
    fg = fg,
    bg_alt = colors.surface(p),
    surface_fg = colors.readable(fg, colors.surface(p), 4.5),
    fg_alt = colors.readable(p.color15, colors.surface(p), 4.5),
    comment = colors.comment(p),
    red = readable(p.color1),
    green = readable(p.color2),
    yellow = readable(p.color3),
    orange = readable(p.color4),
    purple = readable(p.color5),
    blue = readable(p.color6),
    cyan = readable(p.color6),
    bright_red = readable(p.color9),
    bright_green = readable(p.color10),
    bright_yellow = readable(p.color11),
    bright_orange = readable(p.color12),
    bright_purple = readable(p.color13),
    bright_cyan = readable(p.color14),
  }

  set_hl("Normal", { fg = c.fg, bg = c.bg })
  set_hl("NormalFloat", { fg = c.fg, bg = c.bg })
  set_hl("FloatBorder", { fg = c.comment, bg = c.bg })
  set_hl("CursorLine", { bg = c.bg_alt })
  set_hl("CursorLineNr", { fg = c.fg_alt, bg = c.bg_alt, bold = true })
  set_hl("LineNr", { fg = c.comment })
  set_hl("SignColumn", { bg = c.bg })
  set_hl("VertSplit", { fg = c.bg_alt })
  set_hl("WinSeparator", { fg = c.bg_alt })

  set_hl("Pmenu", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("PmenuSel", { fg = c.bg, bg = c.bright_cyan, bold = true })
  set_hl("PmenuSbar", { bg = c.bg_alt })
  set_hl("PmenuThumb", { bg = c.comment })

  -- set_hl("Visual", { bg = c.bg_alt })
  -- Changed visual selection color to bright cyan for more visibility
  set_hl("Visual", { bg = c.bright_cyan, fg = c.bg })
  set_hl("Search", { fg = c.bg, bg = c.bright_yellow })
  set_hl("IncSearch", { fg = c.bg, bg = c.bright_orange })
  set_hl("MatchParen", { fg = c.bright_cyan, bold = true })

  set_hl("StatusLine", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("StatusLineNC", { fg = c.comment, bg = c.bg_alt })
  set_hl("TabLine", { fg = c.comment, bg = c.bg_alt })
  set_hl("TabLineSel", { fg = c.fg, bg = c.bg })
  set_hl("TabLineFill", { fg = c.comment, bg = c.bg_alt })

  set_hl("DiffAdd", { fg = c.green, bg = c.bg })
  set_hl("DiffChange", { fg = c.yellow, bg = c.bg })
  set_hl("DiffDelete", { fg = c.red, bg = c.bg })
  set_hl("DiffText", { fg = c.cyan, bg = c.bg })

  set_hl("DiagnosticError", { fg = c.red })
  set_hl("DiagnosticWarn", { fg = c.yellow })
  set_hl("DiagnosticInfo", { fg = c.cyan })
  set_hl("DiagnosticHint", { fg = c.purple })
  set_hl("DiagnosticVirtualTextError", { fg = c.red })
  set_hl("DiagnosticVirtualTextWarn", { fg = c.yellow })
  set_hl("DiagnosticVirtualTextInfo", { fg = c.cyan })
  set_hl("DiagnosticVirtualTextHint", { fg = c.purple })

  set_hl("LspReferenceText", { bg = c.bg_alt })
  set_hl("LspReferenceRead", { bg = c.bg_alt })
  set_hl("LspReferenceWrite", { bg = c.bg_alt })

  set_hl("Comment", { fg = c.comment, italic = true })
  set_hl("Constant", { fg = c.orange })
  set_hl("String", { fg = c.green })
  set_hl("Character", { fg = c.green })
  set_hl("Number", { fg = c.orange })
  set_hl("Boolean", { fg = c.orange })
  set_hl("Float", { fg = c.orange })

  set_hl("Identifier", { fg = c.cyan })
  set_hl("Function", { fg = c.blue, bold = true })

  set_hl("Statement", { fg = c.purple })
  set_hl("Conditional", { fg = c.purple })
  set_hl("Repeat", { fg = c.purple })
  set_hl("Label", { fg = c.purple })
  set_hl("Operator", { fg = c.red })
  set_hl("Keyword", { fg = c.purple })
  set_hl("Exception", { fg = c.red })

  set_hl("PreProc", { fg = c.yellow })
  set_hl("Include", { fg = c.yellow })
  set_hl("Define", { fg = c.yellow })
  set_hl("Macro", { fg = c.yellow })
  set_hl("PreCondit", { fg = c.yellow })

  set_hl("Type", { fg = c.cyan })
  set_hl("StorageClass", { fg = c.cyan })
  set_hl("Structure", { fg = c.cyan })
  set_hl("Typedef", { fg = c.cyan })

  set_hl("Special", { fg = c.bright_purple })
  set_hl("SpecialChar", { fg = c.bright_purple })
  set_hl("Tag", { fg = c.cyan })
  set_hl("Delimiter", { fg = c.comment })
  set_hl("SpecialComment", { fg = c.comment })
  set_hl("Debug", { fg = c.red })

  set_hl("Underlined", { underline = true })
  set_hl("Error", { fg = c.red, bold = true })
  set_hl("Todo", { fg = c.bright_yellow, bold = true })

  set_hl("@comment", { link = "Comment" })
  set_hl("@string", { link = "String" })
  set_hl("@string.regex", { fg = c.orange })
  set_hl("@string.escape", { fg = c.orange })
  set_hl("@string.special", { fg = c.orange })
  set_hl("@character", { link = "Character" })
  set_hl("@number", { link = "Number" })
  set_hl("@boolean", { link = "Boolean" })
  set_hl("@float", { link = "Float" })
  set_hl("@function", { link = "Function" })
  set_hl("@function.call", { link = "Function" })
  set_hl("@function.builtin", { fg = c.bright_cyan })
  set_hl("@method", { fg = c.cyan })
  set_hl("@method.call", { fg = c.cyan })
  set_hl("@constructor", { fg = c.yellow })
  set_hl("@parameter", { fg = c.fg })
  set_hl("@keyword", { link = "Keyword" })
  set_hl("@keyword.function", { fg = c.purple })
  set_hl("@keyword.operator", { fg = c.red })
  set_hl("@keyword.return", { fg = c.red })
  set_hl("@conditional", { link = "Conditional" })
  set_hl("@repeat", { link = "Repeat" })
  set_hl("@operator", { link = "Operator" })
  set_hl("@punctuation.delimiter", { fg = c.comment })
  set_hl("@punctuation.bracket", { fg = c.comment })
  set_hl("@punctuation.special", { fg = c.bright_purple })
  set_hl("@type", { link = "Type" })
  set_hl("@type.builtin", { fg = c.cyan })
  set_hl("@property", { fg = c.cyan })
  set_hl("@field", { fg = c.cyan })
  set_hl("@variable", { fg = c.fg })
  set_hl("@variable.builtin", { fg = c.bright_orange })
  set_hl("@constant", { link = "Constant" })
  set_hl("@constant.builtin", { fg = c.bright_orange })
  set_hl("@constant.macro", { fg = c.bright_orange })
  set_hl("@module", { fg = c.yellow })
  set_hl("@namespace", { fg = c.yellow })
  set_hl("@label", { fg = c.purple })
  set_hl("@tag", { fg = c.cyan })
  set_hl("@tag.attribute", { fg = c.yellow })
  set_hl("@tag.delimiter", { fg = c.comment })

  -- Captures added/moved in recent Neovim releases. Unknown groups are
  -- harmless on older versions, but having them keeps syntax highlighting
  -- consistent across supported versions.
  set_hl("@keyword.import", { link = "Keyword" })
  set_hl("@keyword.type", { link = "Type" })
  set_hl("@keyword.modifier", { link = "Keyword" })
  set_hl("@keyword.coroutine", { link = "Keyword" })
  set_hl("@function.method", { link = "Function" })
  set_hl("@function.method.call", { link = "Function" })
  set_hl("@type.qualifier", { link = "Type" })
  set_hl("@variable.member", { fg = c.cyan })
  set_hl("@variable.parameter", { fg = c.fg })
  set_hl("@string.documentation", { link = "String" })
  set_hl("@string.special.url", { fg = c.cyan, underline = true })
  set_hl("@comment.documentation", { link = "Comment" })
  set_hl("@markup.link.label", { fg = c.cyan })
  set_hl("@markup.link.url", { fg = c.cyan, underline = true })
  set_hl("@markup.raw.block", { fg = c.green })

  set_hl("VisualNOS", { bg = c.bright_cyan, fg = c.bg })
  set_hl("Cursor", { fg = c.bg, bg = c.fg })
  set_hl("lCursor", { fg = c.bg, bg = c.fg })
  set_hl("TermCursor", { fg = c.bg, bg = c.fg })
  set_hl("TermCursorNC", { fg = c.bg, bg = c.comment })
  set_hl("WinBar", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("WinBarNC", { fg = c.comment, bg = c.bg_alt })
  set_hl("PmenuMatch", { fg = c.bright_cyan, bold = true })
  set_hl("PmenuMatchSel", { fg = c.bg, bg = c.bright_cyan, bold = true })
  set_hl("DiagnosticUnnecessary", { fg = c.comment })
  set_hl("DiagnosticDeprecated", { fg = c.red, strikethrough = true })

  set_hl("TelescopeBorder", { fg = c.comment, bg = c.bg })
  set_hl("TelescopePromptBorder", { fg = c.comment, bg = c.bg_alt })
  set_hl("TelescopePromptNormal", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("TelescopePromptPrefix", { fg = c.cyan, bg = c.bg_alt })

  set_hl("GitSignsAdd", { fg = c.green })
  set_hl("GitSignsChange", { fg = c.yellow })
  set_hl("GitSignsDelete", { fg = c.red })

  set_hl("BufferLineFill", { bg = c.bg_alt })
  set_hl("BufferLineBackground", { fg = c.comment, bg = c.bg_alt })
  set_hl("BufferLineBufferVisible", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("BufferLineBufferSelected", { fg = c.fg, bg = c.bg })

  set_hl("NoiceCmdlinePopup", { fg = c.surface_fg, bg = c.bg_alt })
  set_hl("NoiceCmdlinePopupBorder", { fg = c.cyan, bg = c.bg_alt })
  set_hl("NoicePopup", { fg = c.surface_fg, bg = c.bg_alt })

  set_hl("NotifyERROR", { fg = c.red })
  set_hl("NotifyWARN", { fg = c.yellow })
  set_hl("NotifyINFO", { fg = c.cyan })
  set_hl("NotifyDEBUG", { fg = c.comment })
  set_hl("NotifyTRACE", { fg = c.purple })

  set_hl("TroubleNormal", { fg = c.fg, bg = c.bg })
  set_hl("TroubleText", { fg = c.fg })

  set_hl("TodoFgTODO", { fg = c.bright_yellow })
  set_hl("TodoFgFIX", { fg = c.red })
  set_hl("TodoFgHACK", { fg = c.purple })
  set_hl("TodoSignTODO", { fg = c.bright_yellow })
  set_hl("TodoSignFIX", { fg = c.red })

  set_hl("WhichKey", { fg = c.cyan })
  set_hl("WhichKeyGroup", { fg = c.yellow })
  set_hl("WhichKeyDesc", { fg = c.fg })
  set_hl("WhichKeySeparator", { fg = c.comment })

  set_hl("CmpItemAbbr", { fg = c.fg })
  set_hl("CmpItemAbbrMatch", { fg = c.bright_cyan, bold = true })
  set_hl("CmpItemKind", { fg = c.purple })
  set_hl("CmpItemMenu", { fg = c.comment })

  -- ANSI slots 1-6 and 9-14 keep the canonical palette. Slots 7, 8 and 15 use
  -- the readable foreground/comment colours because several palettes (notably
  -- Paris) define color7 as the background itself.
  vim.g.terminal_color_0 = colors.strip_alpha(p.color0)
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.orange
  vim.g.terminal_color_5 = c.purple
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.comment
  vim.g.terminal_color_9 = c.bright_red
  vim.g.terminal_color_10 = c.bright_green
  vim.g.terminal_color_11 = c.bright_yellow
  vim.g.terminal_color_12 = c.bright_orange
  vim.g.terminal_color_13 = c.bright_purple
  vim.g.terminal_color_14 = c.bright_cyan
  vim.g.terminal_color_15 = c.fg_alt

  return true
end

M.names = {}
for name, palette in pairs(palettes) do
  if type(palette) == "table" then
    table.insert(M.names, name)
  end
end
table.sort(M.names)

vim.api.nvim_create_user_command("Theme", function(opts)
  if not M.apply(opts.args) then
    vim.notify(("Unknown theme %q. Available: %s"):format(opts.args, table.concat(M.names, ", ")), vim.log.levels.ERROR)
    return
  end

  local lualine_ok, lualine = pcall(require, "lualine")
  if lualine_ok then
    lualine.setup({ options = { theme = require("themes.lualine").theme(opts.args) } })
  end
end, {
  nargs = 1,
  complete = function()
    return M.names
  end,
})

return M
