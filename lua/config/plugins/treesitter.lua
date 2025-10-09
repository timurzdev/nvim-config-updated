return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').setup()

      -- Enable highlighting for all supported filetypes automatically
      vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
        pattern = { '*.go', '*.lua', '*.py', '*.c', '*.vim', '*.md', '*.brief' },
        callback = function(args)
          local buf = args.buf
          if vim.bo[buf].buftype == '' then
            vim.schedule(function()
              pcall(vim.treesitter.start, buf)
            end)
          end
        end,
      })
    end
  }
}
