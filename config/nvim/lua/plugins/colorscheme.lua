-- lua/plugins/colorschemes.lua
local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
local active_theme = "rose-pine"

if vim.fn.filereadable(theme_file) == 1 then
  local lines = vim.fn.readfile(theme_file)
  if #lines > 0 and lines[1] ~= "" then
    active_theme = lines[1]
  end
end

-- Safely strip backgrounds without wiping out highlight metadata
local function clear_backgrounds()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
    "NvimTreeNormal",
    "NvimTreeNormalNC",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "IblIndent",
    "IblWhitespace",
    "IblScope",
  }

  for _, group in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return {
  -- Popular colorschemes
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = { styles = { transparency = true } },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { transparent_background = true },
  },
  {
    "folke/tokyonight.nvim",
    opts = { transparent = true },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = { transparent_mode = true },
  },
  {
    "rebelot/kanagawa.nvim",
    opts = { transparent = true },
  },
  {
    "EdenEast/nightfox.nvim",
    opts = { options = { transparent = true } },
  },
  {
    "navarasu/onedark.nvim",
    opts = { transparent = true },
  },
  { "shaunsingh/nord.nvim" },
  { "neanias/everforest" },
  { "NLKNguyen/papercolor-theme" },

  {
    "lukas-reineke/indent-blankline.nvim",
    optional = true,
    opts = {
      scope = {
        show_exact_scope = false,
        highlight = { "IblScope" },
      },
    },
  },

  -- Autocommand setup
  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = clear_backgrounds,
      })

      vim.schedule(function()
        pcall(vim.cmd.colorscheme, active_theme)
      end)
    end,
  },
}
