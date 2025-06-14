return {
  {
    'tzachar/cmp-tabnine',
    build = './install.sh',
    dependencies = 'hrsh7th/nvim-cmp',
    config = function()
      local tabnine = require('cmp_tabnine.config')

      tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
        show_prediction_strength = false,
        min_percent = 0
      })
    end
  },
  {
    'codota/tabnine-nvim',
    -- build = "./dl_binaries.sh",
    build = function()
      -- сначала скачиваем основной дви­жок
      vim.fn.system { 'bash', './dl_binaries.sh' }
      -- затем Chat
      vim.fn.system { 'bash', '-c', 'cd chat && cargo build --release' }
    end,
    config = function()
      require('tabnine').setup({
        disable_auto_comment = true,
        accept_keymap = "<Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
        ignore_certificate_errors = false,
        workspace_folders = {
          -- статический список — достаточно для одиночного репо
          paths = { vim.fn.getcwd() },

          -- динамический: ищем git-корень или LSP-workspace
          get_paths = function()
            local util = require("lspconfig.util")
            local root = util.root_pattern(".git")(vim.fn.expand("%:p"))
                or vim.fn.getcwd()
            return { root }
          end,
        },
      })
    end
  },
}
