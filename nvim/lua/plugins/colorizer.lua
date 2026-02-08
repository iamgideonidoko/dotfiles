return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  ft = { "css", "scss", "html", "javascript", "typescript", "jsx", "tsx", "lua", "vim" },
  cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
  config = function()
    require("colorizer").setup({
      "css",
      "scss",
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "lua",
      "vim",
    }, {
      RGB = true,
      RRGGBB = true,
      names = false, -- Disable name colors for performance
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background", -- Faster than 'foreground'
    })
  end,
}
