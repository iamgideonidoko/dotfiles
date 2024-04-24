local base = require("plugins.configs.lspconfig")
local on_attach = base.onattach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

local servers = { "tsserver", "tailwindcss", "eslint", "cssls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.phpactor.setup {
  on_attach = on_attach,
    init_options = {
      ["language_server_phpstan.enabled"] = false,
      ["language_server_psalm.enabled"] = false,
    }
}
