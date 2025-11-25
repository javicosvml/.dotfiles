<div align="center">

# Neovim Configuration

Modern Lua-based Neovim with LSP, Treesitter, and lazy.nvim

[Requirements](#requirements) •
[Plugins](#plugins) •
[Keybindings](#keybindings) •
[Commands](#commands) •
[Customization](#customization)

</div>

---

## Requirements

| Requirement | Description |
|:------------|:------------|
| **Neovim** | 0.10+ (tested on 0.11.5) |
| **Git** | For plugin management |
| **Nerd Font** | [Download](https://www.nerdfonts.com/) for icons |
| **ripgrep** | `brew install ripgrep` for Telescope |
| **fd** | `brew install fd` for faster file finding |

---

## File Structure

```
nvim/
├── init.lua                 # Entry point, lazy.nvim bootstrap
├── lazy-lock.json           # Plugin version lock
└── lua/
    ├── config/
    │   ├── options.lua      # Neovim options
    │   ├── keymaps.lua      # General keymaps
    │   └── autocmds.lua     # Autocommands
    └── plugins/
        ├── editor.lua       # UI: theme, statusline, bufferline
        ├── lsp.lua          # LSP configuration
        ├── completion.lua   # nvim-cmp setup
        └── treesitter.lua   # Syntax highlighting
```

---

## Plugins

### Plugin Manager

| Plugin | Description |
|:-------|:------------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Modern plugin manager with lazy loading |

### UI & Theme

| Plugin | Description |
|:-------|:------------|
| [dracula.nvim](https://github.com/Mofiqul/dracula.nvim) | Dracula color scheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |

### File Navigation

| Plugin | Description |
|:-------|:------------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter |

### LSP & Completion

| Plugin | Description |
|:-------|:------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configurations |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/Linter installer |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |

### Code Intelligence

| Plugin | Description |
|:-------|:------------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comment toggling |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text objects |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding help |

---

## LSP Servers

Auto-installed via Mason:

| Server | Language |
|:-------|:---------|
| `lua_ls` | Lua |
| `pyright` | Python |
| `ts_ls` | TypeScript/JavaScript |
| `gopls` | Go |
| `rust_analyzer` | Rust |
| `bashls` | Bash |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `dockerls` | Docker |
| `terraformls` | Terraform |

---

## Keybindings

**Leader key:** `<Space>`

### General

| Key | Action |
|:----|:-------|
| `jk` / `kj` | Exit insert mode |
| `<Esc>` | Clear search highlight |
| `<leader>w` | Save file |
| `<leader>q` | Quit |

### Navigation

| Key | Action |
|:----|:-------|
| `<C-h/j/k/l>` | Navigate windows |
| `<S-h>` / `<S-l>` | Previous/Next buffer |
| `<leader>bd` | Delete buffer |

### File Explorer (Neo-tree)

| Key | Action |
|:----|:-------|
| `<leader>n` / `<C-n>` | Toggle Neo-tree |

### Telescope (Fuzzy Finder)

| Key | Action |
|:----|:-------|
| `<C-p>` / `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | List buffers |
| `<leader>fr` | Recent files |
| `<leader>/` | Search in buffer |

### LSP

| Key | Action |
|:----|:-------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |

### Completion (Insert Mode)

| Key | Action |
|:----|:-------|
| `<Tab>` | Next item / Expand snippet |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion |

### Git (Gitsigns)

| Key | Action |
|:----|:-------|
| `]h` / `[h` | Next/Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### Comments

| Key | Action |
|:----|:-------|
| `gcc` | Toggle line comment |
| `gc` | Toggle comment (motion) |

### Surround

| Key | Action |
|:----|:-------|
| `ys{motion}{char}` | Add surround |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |

---

## Commands

| Command | Description |
|:--------|:------------|
| `:Lazy` | Plugin manager UI |
| `:Mason` | LSP/tool installer UI |
| `:Telescope` | Fuzzy finder |
| `:Neotree` | File explorer |
| `:checkhealth` | Verify installation |

---

## Customization

<details>
<summary><strong>Change Theme</strong></summary>

Edit `lua/plugins/editor.lua`:

```lua
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
</details>

<details>
<summary><strong>Add Plugins</strong></summary>

Create a file in `lua/plugins/`:

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
</details>

<details>
<summary><strong>Add LSP Servers</strong></summary>

Edit `lua/plugins/lsp.lua`:

```lua
ensure_installed = {
  "lua_ls",
  "pyright",
  "clangd",  -- Add C/C++ support
},
```
</details>

---

## Troubleshooting

<details>
<summary><strong>Sync plugins</strong></summary>

```bash
nvim +Lazy sync +qa
```
</details>

<details>
<summary><strong>Check LSP status</strong></summary>

```vim
:LspInfo
:Mason
```
</details>

<details>
<summary><strong>Health check</strong></summary>

```vim
:checkhealth
```
</details>

<details>
<summary><strong>Reset configuration</strong></summary>

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim  # Fresh start
```
</details>

---

<div align="center">

[Back to README](../README.md)

</div>
