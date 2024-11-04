return { -- Collection of small independent packages
	"echasnovski/mini.nvim",
	config = function()
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		-- Set the section for cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			-- Macro recording indicator
			local recording = ""
			local record_reg = vim.fn.reg_recording()
			if record_reg ~= "" then
				recording = " %#ErrorMsg# recording @" .. record_reg -- red highlight for visibility
			end
			return "%2l:%-2v" .. recording
		end
	end,
}

-- " %s ",

-- vim: ts=2 sts=2 sw=2 et
