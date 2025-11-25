# Neovim Configuration

Modern Lua-based Neovim configuration with LSP, Treesitter, and lazy.nvim plugin manager.

## Requirements

- Neovim 0.10+ (tested on 0.11.5)
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- ripgrep (`brew install ripgrep`) for Telescope live grep
- fd (`brew install fd`) for faster file finding

## Installation

The configuration is installed via the dotfiles Makefile:

```bash
cd ~/.dotfiles
make profile
```

On first launch, lazy.nvim will automatically install all plugins.

## Plugins

### Plugin Manager
| Plugin | Description |
|--------|-------------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Modern plugin manager with lazy loading |

### UI & Theme
| Plugin | Description |
|--------|-------------|
| [dracula.nvim](https://github.com/Mofiqul/dracula.nvim) | Dracula color scheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |

### File Navigation
| Plugin | Description |
|--------|-------------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter for Telescope |

### LSP & Completion
| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configurations |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/Linter installer |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason-LSP bridge |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) | Cmdline completion |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |
| [neodev.nvim](https://github.com/folke/neodev.nvim) | Lua LSP enhancements |

### Treesitter
| Plugin | Description |
|--------|-------------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Text objects |

### Git
| Plugin | Description |
|--------|-------------|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |

### Editing
| Plugin | Description |
|--------|-------------|
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comment toggling |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto pairs |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text objects |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding help |

## LSP Servers

Automatically installed via Mason:

| Server | Language |
|--------|----------|
| lua_ls | Lua |
| pyright | Python |
| ts_ls | TypeScript/JavaScript |
| gopls | Go |
| rust_analyzer | Rust |
| bashls | Bash |
| jsonls | JSON |
| yamlls | YAML |
| dockerls | Docker |
| terraformls | Terraform |

## Keybindings

**Leader key:** `<Space>`

### Quick Reference

#### General
| Key | Action |
|-----|--------|
| `jk` / `kj` | Exit insert mode |
| `<Esc>` | Clear search highlight |
| `<leader>w` | Save file |
| `<leader>q` | Quit |

#### Navigation
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<S-h>` / `<S-l>` | Previous/Next buffer |
| `<leader>bd` | Delete buffer |

#### File Explorer
| Key | Action |
|-----|--------|
| `<leader>n` / `<C-n>` | Toggle Neo-tree |

#### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<C-p>` / `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>/` | Search in buffer |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `<leader>f` | Format |

#### Completion (Insert Mode)
| Key | Action |
|-----|--------|
| `<Tab>` | Next item / Expand snippet |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm |
| `<C-Space>` | Trigger completion |

#### Git
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

#### Comments
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` | Toggle comment (motion) |

#### Surround
| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |

### Full Documentation

For complete keybinding documentation:

```vim
:help keymaps
```

Or view the file directly: `doc/keymaps.txt`

## Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Plugin manager UI |
| `:Mason` | LSP/tool installer UI |
| `:Telescope` | Fuzzy finder |
| `:Neotree` | File explorer |
| `:checkhealth` | Verify installation |

## File Structure

```
nvim/
├── init.lua                 # Entry point, lazy.nvim bootstrap
├── lazy-lock.json           # Plugin version lock file
├── doc/
│   └── keymaps.txt          # Keybindings documentation
└── lua/
    ├── config/
    │   ├── options.lua      # Neovim options
    │   ├── keymaps.lua      # General keymaps
    │   └── autocmds.lua     # Autocommands
    └── plugins/
        ├── editor.lua       # UI plugins (theme, statusline, etc.)
        ├── lsp.lua          # LSP configuration
        ├── completion.lua   # nvim-cmp setup
        └── treesitter.lua   # Treesitter configuration
```

## Customization

### Change Theme

Edit `lua/plugins/editor.lua` and replace the colorscheme plugin:

```lua
-- Example: Switch to tokyonight
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "night" },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
},
```

### Add Plugins

Create a new file in `lua/plugins/` or add to existing files:

```lua
-- lua/plugins/myplugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",
    opts = {},
  },
}
```

### Add LSP Servers

Edit `lua/plugins/lsp.lua` and add to `ensure_installed`:

```lua
ensure_installed = {
  "lua_ls",
  "pyright",
  -- Add your server here
  "clangd",  -- C/C++
},
```

## Troubleshooting

### Plugins not loading
```bash
nvim +Lazy sync +qa
```

### LSP not working
```vim
:LspInfo
:Mason
```

### Check health
```vim
:checkhealth
```

### Reset configuration
```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim  # Fresh start
```
