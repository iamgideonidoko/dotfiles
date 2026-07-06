return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  ft = { "css", "scss", "html", "javascript", "typescript", "jsx", "tsx", "lua", "vim" },
  cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
  opts = {
    filetypes = {
      "css",
      "scss",
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "lua",
      "vim",
    },
    user_commands = true,
    options = {
      parsers = {
        css = true, -- preset: names + hex + rgb + hsl + oklch + css_var
        css_fn = true, -- preset: rgb() / hsl() / oklch() functions
        names = { enable = false }, -- disable named colors for performance
        hex = { default = true, rrggbbaa = true }, -- #RGB, #RRGGBB, #RRGGBBAA
      },
      display = {
        mode = "background", -- faster than 'foreground'
      },
    },
  },
}