---
name: neovim-setup
description: Neovim lazy.nvim plugin configuration, LSP setup, Mason servers
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: configuration
  tags: neovim,editor,lsp
---

# Neovim Setup Skill

Master the Neovim lazy.nvim configuration for this project.

## Architecture Overview

Neovim uses **lazy.nvim** as the plugin manager. Entry point is `init.lua` which bootstraps lazy, then loads config and plugins.

```
nvim/
├── init.lua                # Bootstraps lazy.nvim, loads config and plugins
├── lazy-lock.json         # Plugin version lockfile (commit this)
└── lua/
    ├── config/
    │   ├── options.lua    # Global options (vim.opt.*)
    │   ├── keymaps.lua    # Key bindings
    │   └── autocmds.lua   # Autocommands
    └── plugins/           # Plugin specs (lazy.nvim format)
        ├── editor/        # Editor plugins (completion, snippets, treesitter)
        ├── lsp/           # LSP and Mason servers
        ├── navigation/    # Navigation and file finding
        ├── ui/            # UI enhancements (theme, statusline, etc.)
        └── integrations/  # Integration with external tools (tmux, git, etc.)
```

## Key Components

### 1. init.lua (Bootstrap)

```lua
-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load config modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins via lazy.nvim
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
```

### 2. config/options.lua

```lua
-- Global options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
```

### 3. config/keymaps.lua

```lua
-- General keymaps
local map = vim.keymap.set
map("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
map("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })
```

### 4. config/autocmds.lua

```lua
-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto-format on save (if configured)
augroup("formatting", { clear = true })
autocmd("BufWritePre", {
  group = "formatting",
  pattern = { "*.lua", "*.ts", "*.tsx" },
  callback = function()
    -- Format command here
  end,
})
```

## Plugin Management with lazy.nvim

### Plugin Spec Example

```lua
-- lua/plugins/editor/completion.lua
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
}
```

### Lazy Loading

lazy.nvim supports lazy loading to improve startup time:

```lua
return {
  {
    "plugin/name",
    event = "InsertEnter",              -- Load on insert mode
    cmd = "CommandName",                -- Load on command
    keys = { "<leader>p" },             -- Load on keypress
    ft = "python",                      -- Load for filetype
    dependencies = { "other/plugin" },  -- Load dependencies first
  },
}
```

## LSP and Mason

**Mason** auto-installs LSP servers, formatters, linters.

```lua
-- lua/plugins/lsp/mason.lua
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "typescript-language-server" },
        automatic_installation = true,
      })
    end,
  },
}
```

## Theme: TokyoNight

```lua
-- lua/plugins/ui/theme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
```

## Common Operations

### Add a New Plugin

1. Create a file in `lua/plugins/<category>/<name>.lua`
2. Define plugin spec with lazy.nvim format
3. Run `:Lazy` to see plugin manager UI
4. Run `:Lazy sync` to install

### Update Plugins

```bash
nvim +"Lazy update" +qa
```

### Check lazy-lock.json

```bash
git diff lazy-lock.json  # See what changed
git add lazy-lock.json   # Commit version lockfile
```

## Troubleshooting

| Problem | Diagnosis | Solution |
|---|---|---|
| Plugin not loading | Lazy loading condition wrong | Check `event`, `cmd`, `keys` |
| Keymap conflict | Two plugins bind same key | Check keymaps in both plugins |
| LSP not starting | Mason server not installed | Run `:Mason` and install |
| Color scheme broken | Wrong colorscheme plugin | Run `:colorscheme tokyonight` |
| Startup slow | Too many plugins loading | Add lazy loading (`event`, `cmd`) |

## Before You Commit

```bash
# Check Neovim syntax
nvim +"Lazy check" +qa

# Check plugin changes
git diff lazy-lock.json

# Test plugins loaded
nvim +"Lazy" +qa
```

## Documentation

- `nvim/init.lua` (entry point, shows bootstrap)
- `nvim/lua/config/` (options, keymaps, autocmds)
- `nvim/lua/plugins/` (plugin specs)
- `docs/neovim.dotfiles.md` (comprehensive reference)
- [lazy.nvim docs](https://github.com/folke/lazy.nvim)
