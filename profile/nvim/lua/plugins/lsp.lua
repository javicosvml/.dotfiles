-- LSP Configuration
return {
  -- Mason: LSP/DAP/Linter/Formatter installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- LSP keymaps (only when LSP attaches)
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", vim.lsp.buf.references, "Go to references")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
        map("<leader>fs", vim.lsp.buf.document_symbol, "Document symbols")
        map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
      end

      -- Capabilities for autocompletion
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Setup mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "gopls",
          "rust_analyzer",
          "bashls",
          "jsonls",
          "yamlls",
          "dockerls",
          "terraformls",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          -- Lua specific settings
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
                  diagnostics = { globals = { "vim" } },
                },
              },
            })
          end,

          -- Python specific settings
          ["pyright"] = function()
            lspconfig.pyright.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
