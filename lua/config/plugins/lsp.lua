return {
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        single_file_support = true,
      })

      vim.lsp.config('pyright', {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { 'python' },
        root_markers = { '.git' },
        single_file_support = true,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true
            }
          }
        }
      })

      vim.lsp.config('gopls', {
        cmd = { "gopls" },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        single_file_support = true,
        settings = {
          gopls = {
            buildFlags = { '-tags=integration' },
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              unusedvariable = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      })

      vim.lsp.config('briefls', {
        cmd = { 'briefls' },
        filetypes = { 'brief' },
        root_markers = { '.git' },
        single_file_support = true,
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
        flags = {
          debounce_text_changes = 150,
        },
      })

      vim.lsp.enable({ 'lua_ls', 'pyright', 'gopls', 'briefls' })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          -- keymaps
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')


          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
