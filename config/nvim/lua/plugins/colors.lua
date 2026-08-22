return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- Choose between: storm, moon, night, day
      transparent = true, -- Enables transparency for the main window
      styles = {
        sidebars = "transparent", -- Makes sidebars (like Neo-tree) transparent
        floats = "transparent",   -- Makes floating windows transparent
      },
    },
    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
}

