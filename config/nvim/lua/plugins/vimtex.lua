return {
  "lervag/vimtex",
  lazy = false, -- VimTeX manages its own lazy loading via filetypes
  init = function()
    -- 1. PDF Viewer Options (Zathura)
    vim.g.vimtex_view_method = "zathura"

    -- 2. Compiler Options (continuous compilation on save)
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "build", -- Keeps your project folder clean from temp files (.aux, .log, .toc)
      out_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      hooks = {},
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- 3. Quickfix / Error Window Tweaks
    -- Don't open the quickfix window automatically on minor warnings
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- Filter out annoying/unimportant LaTeX warnings
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }

    -- 4. Concealment (Makes raw LaTeX look like clean math symbols inside Neovim)
    -- E.g., turns \alpha in your editor into α automatically!
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      styles = 1,
    }
  end,
}
