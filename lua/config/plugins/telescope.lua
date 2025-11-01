return {
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',              enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {},
        },
      }

      require('telescope').load_extension('fzf')
      local builtin = require('telescope.builtin')

      vim.keymap.set("n", "<space>fh", builtin.help_tags)
      vim.keymap.set("n", "<space>fd", builtin.find_files)

      vim.keymap.set("n", "<space>fi", function()
        builtin.find_files {
          hidden = true,
          no_ignore = true,
        }
      end)

      vim.keymap.set("n", "<space>en", function()
        builtin.find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)

      vim.keymap.set("n", "<space>ep", function()
        builtin.find_files {
          ---@diagnostic disable-next-line: param-type-mismatch
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

      vim.keymap.set("n", "<space>fb", builtin.buffers)
      vim.keymap.set('n', '<leader>fe', builtin.diagnostics, { desc = '[F]ind [E]rrors' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>fv', builtin.git_files, { desc = '[F]ind [V]ersioned' })
      vim.keymap.set('n', '<leader>fu', builtin.git_status, { desc = '[F]ind [U]ncommitted' })

      require "config.telescope.multigrep".setup()
    end
  }
}
