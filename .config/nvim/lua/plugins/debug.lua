return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",
		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",
		-- Dependencies for managing debug adapters
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		-- Start: Go
		-- "leoluz/nvim-dap-go",
		-- End: Go
		-- Start: JS
		{
			"microsoft/vscode-js-debug",
			opt = {},
			build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
		{
			"mxsdev/nvim-dap-vscode-js",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		{
			"Joakker/lua-json5",
			build = "./install.sh",
		},
		-- End: JS
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with reasonable debug configurations
			automatic_installation = true,
			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},
			-- Check that you have the required things installed online
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})
		local js_related_language = require("utils").js_related_languages
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		for _, language in ipairs(js_related_language) do
			dap.configurations[language] = {
				-- Debug single nodejs files
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
				},
				-- Debug nodejs processes (make sure to add --inspect when you run the process)
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
				},
				-- Debug web applications (client side)
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch & Debug Chrome",
					url = function()
						local co = coroutine.running()
						return coroutine.create(function()
							vim.ui.input({
								prompt = "Enter URL: ",
								default = "http://localhost:3000",
							}, function(url)
								if url == nil or url == "" then
									return
								else
									coroutine.resume(co, url)
								end
							end)
						end)
					end,
					webRoot = vim.fn.getcwd(),
					protocol = "inspector",
					sourceMaps = true,
					userDataDir = false,
				},
				-- Divider for the launch.json derived configs
				{
					name = "----- ↓ launch.json configs ↓ -----",
					type = "",
					request = "launch",
				},
			}
		end

		local set = vim.keymap.set
		-- Debugging keymaps
		set("n", "<leader>drs", dap.continue, { desc = "Debug: Start/Continue" })
		set("n", "<leader>dri", dap.step_into, { desc = "Debug: Step Into" })
		set("n", "<leader>drO", dap.step_over, { desc = "Debug: Step Over" })
		set("n", "<leader>dro", dap.step_out, { desc = "Debug: Step Out" })
		set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })
		set("n", "<leader>dra", function()
			if vim.fn.filereadable(".vscode/launch.json") then
				local dap_vscode = require("dap.ext.vscode")
				dap_vscode.load_launchjs(nil, {
					["pwa-node"] = js_related_language,
					["chrome"] = js_related_language,
					["pwa-chrome"] = js_related_language,
				})
			end
			dap.continue()
		end, { desc = "Debug: Run with Args" })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		---@diagnostic disable: missing-fields
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "drt", dapui.toggle, { desc = "Debug: See last session result." })

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		-- require("dap-go").setup({
		-- 	delve = {
		-- 		-- On Windows delve must be run attached or it crashes.
		-- 		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		-- 		detached = vim.fn.has("win32") == 0,
		-- 	},
		-- })

		-- Install js specific config
		---@diagnostic disable: missing-fields
		require("dap-vscode-js").setup({
			-- Path of node executable. Defaults to $NODE_PATH, and then "node"
			-- node_path = "node",

			-- Path to vscode-js-debug installation.
			debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

			-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
			-- debugger_cmd = { "js-debug-adapter" },

			-- which adapters to register in nvim-dap
			adapters = {
				"chrome",
				"pwa-node",
				"pwa-chrome",
				"pwa-msedge",
				"pwa-extensionHost",
				"node-terminal",
			},

			-- Path for file logging
			-- log_file_path = "(stdpath cache)/dap_vscode_js.log",

			-- Logging level for output to file. Set to false to disable logging.
			-- log_file_level = false,

			-- Logging level for output to console. Set to false to disable console output.
			-- log_console_level = vim.log.levels.ERROR,
		})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
