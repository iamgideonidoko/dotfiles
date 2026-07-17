local ft = { "css", "scss", "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua", "vim" }

return {
  "catgoose/nvim-colorizer.lua",
  ft = ft,
  cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
  opts = {
    filetypes = ft,
    user_commands = true,
    options = {
      parsers = {
        css = true,
        css_fn = true,
        names = { enable = false },
        hex = { default = true, rrggbbaa = true },
      },
      display = {
        mode = "background",
      },
    },
  },
}
