return {
	{
		"codota/tabnine-nvim",
		event = "VeryLazy",
		build = "./dl_binaries.sh",
		config = function()
			require("tabnine").setup({
				-- Options here => https://github.com/codota/tabnine-nvim?tab=readme-ov-file#activate-mandatory
				disable_auto_comment = true,
				accept_keymap = "<A-Space>",
				dismiss_keymap = "<C-]>",
				debounce_ms = 1000,
				suggestion_color = { gui = "##768390", cterm = 244 },
				exclude_filetypes = { "TelescopePrompt", "NvimTree" },
				log_file_path = nil, -- absolute path to Tabnine log file
			})
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
