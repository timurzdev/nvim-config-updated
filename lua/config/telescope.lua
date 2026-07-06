require('telescope').setup {
  pickers = {
    find_files = {
      theme = "ivy"
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
}

require('telescope').load_extension('fzf')
local builtin = require('telescope.builtin')

vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>fd", builtin.find_files)

vim.keymap.set("n", "<leader>fi", function()
  builtin.find_files {
    hidden = true,
    no_ignore = true,
  }
end)

vim.keymap.set("n", "<leader>en", function()
  builtin.find_files {
    cwd = vim.fn.stdpath("config")
  }
end)

vim.keymap.set("n", "<leader>ep", function()
  builtin.find_files {
    ---@diagnostic disable-next-line: param-type-mismatch
    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
  }
end)

vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set('n', '<leader>fe', builtin.diagnostics, { desc = '[F]ind [E]rrors' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
vim.keymap.set('n', '<leader>fv', builtin.git_files, { desc = '[F]ind [V]ersioned' })
vim.keymap.set('n', '<leader>fu', builtin.git_status, { desc = '[F]ind [U]ncommitted' })
vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, { desc = '[S]pell [S]uggest' })

require "config.telescope.multigrep".setup()
