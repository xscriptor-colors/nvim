# Changelog

## 2026-08-23

- Migrate all customizations to xscriptor-colors

## 2026-06-26

### Bugfixes
- Fixed deprecated `vim.loop.fs_stat` -> `vim.uv.fs_stat` in lazy.lua
- Fixed selene config from `lua52` to `luajit`

### Configuration improvements
- Updated Neovim requirement to >= 0.11 (README + badge)
- Enabled `update_in_insert = true` for real-time diagnostics
- Added `cmdheight = 0` for cleaner UI with noice.nvim
- Created `.luarc.json` for LuaLS project configuration
- Removed `lazy-lock.json` from gitignore (reproducible installs)
- Created `.editorconfig` for cross-editor consistency

### New keymaps
- Window navigation: `<C-h/j/k/l>` for moving between splits
- Clipboard: `<leader>y` (yank selection), `<leader>Y` (yank line) to system clipboard
- Terminal: `<Esc><Esc>` to exit terminal mode
- DAP: `<leader>db/dC/dx/dr/di/dO>` for debugger control
- Harpoon: `<leader>ha` (add), `<leader>hh` (menu), `<leader>h1-4` (quick jump)
- Sessions: `<leader>qs` (save), `<leader>ql` (load), `<leader>qd` (stop)

### New plugins
- `stevearc/dressing.nvim` - improved UI for vim.ui.select/input
- `ThePrimeagen/harpoon` (harpoon2) - quick file navigation
- `folke/persistence.nvim` - session save/restore
- `OXY2DEV/markview.nvim` - inline markdown rendering

### LSP expansion
- Added 6 new language servers: `dockerls`, `emmet_ls`, `gopls`, `sqlls`, `taplo`, `vimls`

### Formatters and linters
- Formatters: `shfmt` (shell), `taplo` (TOML), `sqlfluff` (SQL)
- Linters: `shellcheck` (sh/bash/zsh), `markdownlint` (markdown)

### Dashboard
- Removed V character from alpha-nvim ASCII art
- Added flame accents (`~`) around the X
- Added quote: "The eternal withers and the ephemeral marks our memories."
- Added diagnostics section to lualine statusline

### Nvim 0.12 features
- Enabled `vim.lsp.completion.enable()` for inline LSP completion

### CI
- Pinned Neovim version to v0.12 (stable instead of nightly)
- Added StyLua formatting check job
- Added Lua syntax validation step via `loadfile`
