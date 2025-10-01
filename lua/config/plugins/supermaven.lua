return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      opts = {
        keymaps = {
          accept_suggestion = nil,
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true },
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = false,
        condition = function()
          return false
        end
      }
      require("supermaven-nvim").setup(opts)
    end,
  }
}
