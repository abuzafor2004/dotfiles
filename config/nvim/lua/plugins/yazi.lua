return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 Open yazi at the current file's path
      {
        "<leader>e",
        function()
          require("yazi").yazi()
        end,
        desc = "Open yazi at current file",
      },
      -- 👇 Open yazi in your current working directory
      {
        "<leader>w",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open yazi in cwd",
      },
    },
    opts = {
      -- If you want yazi to open instead of netrw/neo-tree for directories:
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
