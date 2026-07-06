vim.g.mapleader = " "

local pack_hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
    vim.system({ 'make' }, { cwd = ev.data.path })
  end
end

local gh = function(plug_name)
  return 'https://github.com/' .. plug_name
end

vim.pack.add({
  gh('nvim-mini/mini.nvim'),
  gh('nvim-mini/mini.nvim'),
  gh('stevearc/oil.nvim'),
  gh('mason-org/mason.nvim'),
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-telescope/telescope-fzf-native.nvim'),
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main', },
})


vim.api.nvim_create_autocmd('PackChanged', { callback = pack_hooks })


require('config.lsp')
require('config.telescope')

-- quickfix keymaps
vim.keymap.set("n", "]c", ":cnext<CR>")
vim.keymap.set("n", "[c", ":cprev<CR>")
-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- opts
local set = vim.opt
set.shiftwidth = 4
set.tabstop = 4
set.number = true
set.relativenumber = true
set.clipboard = "unnamedplus"
set.scrolloff = 10
set.colorcolumn = "120"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})



-- Oil setup
require("oil").setup(
  {
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
  }
)
vim.keymap.set("n", "-", "<cmd>Oil<CR>")


-- autocomplete
vim.o.complete = '.,w,b,o'
vim.o.completeopt = 'menuone,noselect,fuzzy'
vim.o.autocomplete = true
vim.o.autocompletedelay = 250
