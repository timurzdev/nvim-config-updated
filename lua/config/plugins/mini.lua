return {
  {
    'echasnovski/mini.nvim',
    enabled = true,
    config = function()
      local statusline = require 'mini.statusline'

      local function spell_indicator()
        if not vim.wo.spell then
          return ''
        end

        local lang = vim.bo.spelllang
        local is_ru = lang:match('ru') ~= nil
        local full = is_ru and '🇷🇺 RU' or '🇺🇸 EN'
        local short = is_ru and 'RU' or 'EN'

        return statusline.is_truncated(120) and short or full
      end

      local function active_content()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git = statusline.section_git({ trunc_width = 40 })
        local diff = statusline.section_diff({ trunc_width = 75 })
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
        local lsp = statusline.section_lsp({ trunc_width = 75 })
        local filename = statusline.section_filename({ trunc_width = 140 })
        local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
        local location = statusline.section_location({ trunc_width = 75 })
        local search = statusline.section_searchcount({ trunc_width = 75 })
        local spell = spell_indicator()

        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
          '%<',
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=',
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, spell } },
          { hl = mode_hl, strings = { search, location } },
        })
      end

      statusline.setup {
        use_icons = true,
        content = {
          active = active_content,
        },
      }
    end
  }
}
