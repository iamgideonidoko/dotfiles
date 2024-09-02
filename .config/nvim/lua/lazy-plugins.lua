-- [[Configure and install plugins]]

-- Check status with `:Lazy` and update plugins with `:Lazy update`
-- See `:help lazy.nvim-lazy.nvim-structuring-your-plugins` for more information on how to structure plugins
-- NOTE: Use `opts = {}` to force a plugin to be loaded. (equivalent to: `require('Comment').setup({})`)
require("lazy").setup({
	-- Package manager
	require("plugins.mason"),

	require("plugins.noice"),

	-- Helper plugins
	{ import = "plugins.utils" },

	require("plugins.gitsigns"),

	require("plugins.which-key"),

	require("plugins.telescope"),

	require("plugins.lspconfig"),

	require("plugins.conform"),

	require("plugins.cmp"),

	require("plugins.tokyonight"),

	require("plugins.todo-comments"),

	require("plugins.mini"),

	require("plugins.treesitter"),

	require("plugins.debug"),

	require("plugins.indent_line"),

	require("plugins.lint"),

	require("plugins.autopairs"),

	-- require("plugins.neo-tree"),

	require("plugins.tabnine"),

	require("plugins.autotag"),

	require("plugins.rest"),

	require("plugins.markdown"),

	require("plugins.server"),

	require("plugins.oil"),

	require("plugins.git-conflict"),

	require("plugins.dashboard"),
}, {
	ui = {
		-- If nerd font is enabled, set icons to an empty table which will use the
		-- default lazy.nvim defined nerd font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- vim: ts=2 sts=2 sw=2 et
