return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').setup()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'go', 'lua', 'python', 'c', 'vim', 'markdown', 'brief' },
        callback = function(args)
          local buf = args.buf
          if vim.bo[buf].buftype == '' then
            pcall(vim.treesitter.start, buf)
          end
        end,
      })
    end
  }
}
