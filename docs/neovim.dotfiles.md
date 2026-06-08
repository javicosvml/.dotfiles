# Neovim Configuration

Lua-based Neovim config with `lazy.nvim` as plugin manager. Entry point: `nvim/init.lua`.

## Structure

```text
nvim/
├── init.lua                    # Bootstrap: leader, lazy.nvim, core modules
├── lazy-lock.json              # Plugin version lockfile
└── lua/
    ├── config/
    │   ├── options.lua         # vim.opt settings
    │   ├── keymaps.lua         # Global keymaps (no plugin deps)
    │   └── autocmds.lua        # Autocommands
    └── plugins/
        ├── editor.lua          # Theme, file explorer, telescope, statusline, git
        ├── lsp.lua             # Mason + nvim-lspconfig + mason-lspconfig
        ├── completion.lua      # nvim-cmp + LuaSnip + sources
        └── treesitter.lua      # Treesitter parsers
```

## Plugin Loading Strategy

`lazy.nvim` is bootstrapped from `~/.local/share/nvim/lazy/lazy.nvim`. All plugins default to `lazy = true`. Several built-in plugins are disabled for performance: `gzip`, `matchit`, `matchparen`, `netrwPlugin`, `tarPlugin`, `tohtml`, `tutor`, `zipPlugin`.

## LSP Servers (auto-installed via Mason)

| Server | Language |
|--------|---------|
| `lua_ls` | Lua (with Neovim globals) |
| `pyright` | Python (typeCheckingMode: basic) |
| `ts_ls` | TypeScript / JavaScript |
| `gopls` | Go |
| `rust_analyzer` | Rust |
| `bashls` | Bash |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `dockerls` | Dockerfile |
| `terraformls` | Terraform |

All servers share a common `on_attach` function and `cmp_nvim_lsp` capabilities.

## Key Plugins

| Plugin | Trigger | Purpose |
|--------|---------|---------|
| `folke/tokyonight.nvim` | eager | Colorscheme (night style) |
| `nvim-neo-tree/neo-tree.nvim` | `Neotree` cmd | File explorer |
| `nvim-telescope/telescope.nvim` | `Telescope` cmd | Fuzzy finder |
| `nvim-lualine/lualine.nvim` | `VeryLazy` | Statusline (tokyonight theme) |
| `akinsho/bufferline.nvim` | `VeryLazy` | Buffer tabs |
| `lewis6991/gitsigns.nvim` | `BufReadPost` | Git diff signs |
| `hrsh7th/nvim-cmp` | `InsertEnter` | Autocompletion |
| `L3MON4D3/LuaSnip` | via cmp | Snippet engine (friendly-snippets) |
| `christoomey/vim-tmux-navigator` | keys | Tmux pane navigation |
| `folke/which-key.nvim` | `VeryLazy` | Keybinding helper |
| `numToStr/Comment.nvim` | `gcc`/`gc` | Code commenting |
| `kylechui/nvim-surround` | `VeryLazy` | Surround text objects |
| `windwp/nvim-autopairs` | `InsertEnter` | Auto-close brackets |

## Key Bindings

Leader key: `<Space>`

### Navigation

| Key | Action |
|-----|--------|
| `C-h/j/k/l` | Navigate splits (tmux-aware) |
| `S-h` / `S-l` | Previous / next buffer |
| `C-d` / `C-u` | Scroll half-page (cursor centered) |
| `n` / `N` | Next/prev search (cursor centered) |

### Files & Search

| Key | Action |
|-----|--------|
| `C-p` / `<leader>ff` | Telescope: find files |
| `<leader>fg` | Telescope: live grep |
| `<leader>fb` | Telescope: buffers |
| `<leader>fr` | Telescope: recent files |
| `<leader>fd` | Telescope: diagnostics |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>n` / `C-n` | Toggle Neo-tree |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |
| `<leader>D` | Type definition |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Show diagnostic float |

### Git

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Full blame line |

### Editing

| Key | Action |
|-----|--------|
| `jk` / `kj` | Exit insert mode |
| `A-j` / `A-k` | Move line up/down |
| `<` / `>` (visual) | Indent and stay in visual |
| `p` (visual) | Paste without yanking selection |
| `<leader>w` / `<leader>W` | Save / save all |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |

## Completion Sources (priority order)

1. `nvim_lsp` — LSP completions
2. `luasnip` — Snippets (from `friendly-snippets`)
3. `buffer` — Current buffer words
4. `path` — Filesystem paths

`Tab` cycles completions or jumps snippet placeholders. `CR` confirms selection.

## Reset Neovim

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim   # fresh install via lazy.nvim
```

## Update Plugins

```bash
nvim +"Lazy sync" +qa    # update + quit
# or inside nvim:
:Lazy sync
:Lazy update
:Mason                   # manage LSP servers
```
