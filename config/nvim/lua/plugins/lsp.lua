return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "clangd",
        "pyright",
        "lua_ls",
        "jsonls",
        "lemminx",
        "bashls",
        "rust_analyzer",
        "cssls",
        "html",
      },
      automatic_installation = true,
    })

    -- Setup auto-completion capabilities for all servers
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- Custom server overrides
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    vim.lsp.config("qmlls", {
      cmd = { "qmlls", "-E" },
      filetypes = { "qml", "qmljs" },
    })

    -- Enable servers
    local servers = {
      "clangd",
      "pyright",
      "lua_ls",
      "jsonls",
      "lemminx",
      "bashls",
      "rust_analyzer",
      "cssls",
      "html",
      "qmlls",
    }

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
