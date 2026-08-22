return {
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        ---render options: 'background' (পুরো ব্যাকগ্রাউন্ড কালার), 'foreground' (শুধু লেখার কালার), 'virtual' (পাশে ছোট ডট দেখাবে)
        render = "background",

        -- কোন কোন কালার কোড সাপোর্ট করবে
        enable_hex = true,
        enable_rgb = true,
        enable_hsl = true,
        enable_var_usage = true, -- CSS variables (যেমন: var(--my-color)) সাপোর্ট করবে

        -- কোন কোন ফাইল টাইপে এটি স্বয়ংক্রিয়ভাবে চালু হবে
        enable_named_colors = true, -- "red", "blue" লেখার ওপরও কালার দেখাবে
        enable_tailwind = false,    -- আপনি যদি tailwind ব্যবহার করেন তবে এটি true করতে পারেন

        exclude_filetypes = { "lazy", "mason", "help" },
      })
    end,
  },
}

