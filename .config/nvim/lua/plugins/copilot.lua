return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			-- suggestion = { enabled = false },
			-- panel = { enabled = false },
		})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
