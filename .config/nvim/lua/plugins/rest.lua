return {
	{
		"rest-nvim/rest.nvim",
		ft = {
			"http",
		},
		dependencies = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("rest-nvim").setup({
				-- Get config options at: https://github.com/rest-nvim/rest.nvim?tab=readme-ov-file#packernvim
			})
		end,
	},
}
