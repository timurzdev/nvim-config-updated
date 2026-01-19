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
    "nanotee/sqls.nvim",
    ft = { "sql" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
      local function setup_sqls(client, bufnr)
        local api = vim.api
        local sqls = require('sqls')
        local sqls_commands = require('sqls.commands')

        client.server_capabilities.executeCommandProvider = true
        client.server_capabilities.codeActionProvider = { resolveProvider = false }
        client.commands = sqls.commands

        local client_id = client.id
        api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQuery', function(args)
          sqls_commands.exec(
            client_id,
            'executeQuery',
            args.smods,
            args.range ~= 0,
            nil,
            args.line1,
            args.line2
          )
        end, { range = true })
        api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQueryVertical', function(args)
          sqls_commands.exec(
            client_id,
            'executeQuery',
            args.smods,
            args.range ~= 0,
            '-show-vertical',
            args.line1,
            args.line2
          )
        end, { range = true })
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowDatabases', function(args)
          sqls_commands.exec(client_id, 'showDatabases', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowSchemas', function(args)
          sqls_commands.exec(client_id, 'showSchemas', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowConnections', function(args)
          sqls_commands.exec(client_id, 'showConnections', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowTables', function(args)
          sqls_commands.exec(client_id, 'showTables', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchDatabase', function(args)
          sqls_commands.switch_database(client_id, args.args ~= '' and args.args or nil)
        end, { nargs = '?' })
        api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchConnection', function(args)
          sqls_commands.switch_connection(client_id, args.args ~= '' and args.args or nil)
        end, { nargs = '?' })

        api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<Plug>(sqls-execute-query)',
          "<Cmd>let &opfunc='{type -> sqls_nvim#query(type, " .. client_id .. ")}'<CR>g@",
          { silent = true }
        )
        api.nvim_buf_set_keymap(
          bufnr,
          'x',
          '<Plug>(sqls-execute-query)',
          "<Cmd>let &opfunc='{type -> sqls_nvim#query(type, " .. client_id .. ")}'<CR>g@",
          { silent = true }
        )
        api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<Plug>(sqls-execute-query-vertical)',
          "<Cmd>let &opfunc='{type -> sqls_nvim#query_vertical(type, " .. client_id .. ")}'<CR>g@",
          { silent = true }
        )
        api.nvim_buf_set_keymap(
          bufnr,
          'x',
          '<Plug>(sqls-execute-query-vertical)',
          "<Cmd>let &opfunc='{type -> sqls_nvim#query_vertical(type, " .. client_id .. ")}'<CR>g@",
          { silent = true }
        )
      end

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

      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', '.git' },
        single_file_support = true,
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = 'clippy',
            },
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

      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        single_file_support = true,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config('sqls', {
        cmd = { 'sqls' },
        filetypes = { 'sql' },
        root_markers = { '.git' },
        single_file_support = true,
      })

      vim.lsp.enable({ 'lua_ls', 'pyright', 'gopls', 'rust_analyzer', 'briefls', 'jsonls', 'sqls' })

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

          if client.name == 'sqls' then
            setup_sqls(client, args.buf)
          end

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
