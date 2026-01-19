return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'
      local dap_go = require 'dap-go'
      local dap_python = require 'dap-python'


      ui.setup()

      local dlv_path = vim.fn.exepath("dlv")
      if dlv_path == "" then
        dlv_path = vim.fn.expand("~/go/bin/dlv")
      end

      local dap_go_opts = {
        delve = {
          path = dlv_path,
          build_flags = { "-tags=integration" },
        },
      }
      dap_go.setup(dap_go_opts)

      dap_python.setup('~/.virtualenv/bin/python')

      local codelldb_path = vim.fn.exepath("codelldb")
      if codelldb_path == "" then
        codelldb_path = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb")
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-dap-virtual-text').setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if #variable.value > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. variable.value
        end,
      }

      -- Handled by nvim-dap-go

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F11>', dap.stop)
      vim.keymap.set('n', '<F12>', dap.restart)

      vim.keymap.set('n', '<F7>', ui.toggle)

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        desc = 'prevent colorscheme clears self-defined DAP icon colors.',
        callback = function()
          vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
          vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
          vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
        end,
      })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
        end,
      },
    },
    config = function()
      local dlv_path = vim.fn.exepath("dlv")
      if dlv_path == "" then
        dlv_path = vim.fn.expand("~/go/bin/dlv")
      end

      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            runner = "gotestsum",
            go_test_args = { "-v", "-race", "-count=1", "-tags=integration" },
            warn_test_name_dupes = false,
            dap_go_enabled = true,
            dap_go_opts = {
              delve = {
                path = dlv_path,
                build_flags = { "-tags=integration" },
              },
            },
          }),
        },
        log_level = vim.log.levels.DEBUG,
      })

      vim.keymap.set("n", "<leader>dt", function()
        require("neotest").run.run({ strategy = "dap" })
      end)

      vim.keymap.set("n", "<leader>dr", function()
        require("neotest").run.run()
      end)

      vim.keymap.set("n", "<leader>dT", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end)

      vim.keymap.set("n", "<leader>ds", function()
        require("neotest").summary.toggle()
      end)

      vim.keymap.set("n", "<leader>do", function()
        require("neotest").output.open({ enter = true })
      end)
    end,
  },
}
