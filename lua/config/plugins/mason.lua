return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
        "jsonls",
        "rust_analyzer",
        "sqls",
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "gopls",
        "debugpy",
        "delve",
        "codelldb",
        "stylua",
        "goimports",
        "gofumpt",
        "golangci-lint",
        "ruff",
        "black",
        "isort",
        "shfmt",
        "shellcheck",
        "rust-analyzer",
        "sqls",
      },
      run_on_start = true,
    },
  },
}
