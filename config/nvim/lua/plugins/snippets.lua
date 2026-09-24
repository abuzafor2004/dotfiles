return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local d = ls.dynamic_node
    local sn = ls.snippet_node

    ls.config.setup({
      enable_autosnippets = true,
      -- Save visual selection into memory when triggering a snippet from visual mode
      store_selection_keys = "<Tab>",
    })

    -- Helper function to fetch visual selection or default insert node
    local get_visual = function(args, parent)
      if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
      else
        return sn(nil, i(1))
      end
    end

    ls.add_snippets("tex", {
      -- 1. Bold text (\textbf{...})
      s({ trig = "tb", snippetType = "autosnippet" }, {
        t("\\textbf{"),
        d(1, get_visual),
        t("}"),
      }),

      -- 2. Fraction (\frac{selected}{...})
      s({ trig = "ff", snippetType = "autosnippet" }, {
        t("\\frac{"),
        d(1, get_visual),
        t("}{"),
        i(2, "denominator"),
        t("}"),
      }),

      -- 3. Inline Math ($ selected $)
      s({ trig = "mk", snippetType = "autosnippet" }, {
        t("$"),
        d(1, get_visual),
        t("$"),
      }),

      -- 4. Text in Math Mode (\text{...})
      s({ trig = "ti", snippetType = "autosnippet" }, {
        t("\\text{"),
        d(1, get_visual),
        t("}"),
      }),
    })
  end,
}
