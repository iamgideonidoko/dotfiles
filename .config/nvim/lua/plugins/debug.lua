---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		---@diagnostic disable: redundant-parameter
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		-- START: JS
		{
			"microsoft/vscode-js-debug",
			build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
		{
			"mxsdev/nvim-dap-vscode-js",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		{
			"nvim-lua/plenary.nvim",
		},
		-- END: JS
	},
	config = function()
		-- Add debug adapters here
		local debug_adapters = {}
		local dap = require("dap")
		local dapui = require("dapui")

		-- For more information, see |:help nvim-dap-ui|
		---@diagnostic disable: missing-fields
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			icons = vim.g.have_nerd_font and {} or { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = vim.g.have_nerd_font and {} or {
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
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- SETUP JS
		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			-- adapters to register in nvim-dap
			adapters = {
				"pwa-node",
				"pwa-chrome",
				"pwa-msedge",
				"node-terminal",
				"pwa-extensionHost",
			},
		})

		-- Langugage onfiguration
		local js_related_language = require("utils").js_related_languages
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		for _, language in ipairs(js_related_language) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = vim.fn.getcwd(),
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = vim.fn.getcwd(),
				},
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
					userDataDir = false,
				},
				{
					type = "pwa-chrome",
					request = "attach",
					name = "Attach & Debug Chrome",
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

		-- Debugging keymaps
		local set = vim.keymap.set
		set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Breakpoint Condition" })
		set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
		set("n", "<leader>da", function()
			dap.continue({ before = get_args })
		end, { desc = "Debug: Run with Args" })
		set("n", "<leader>dC", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
		set("n", "<leader>dg", dap.goto_, { desc = "Debug: Go to Line (No Execute)" })
		set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
		set("n", "<leader>dj", dap.down, { desc = "Debug: Down" })
		set("n", "<leader>dk", dap.up, { desc = "Debug: Up" })
		set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
		set("n", "<leader>do", dap.step_out, { desc = "Debug: Step Out" })
		set("n", "<leader>dO", dap.step_over, { desc = "Debug: Step Over" })
		set("n", "<leader>dp", dap.pause, { desc = "Debug: Pause" })
		set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
		set("n", "<leader>ds", dap.session, { desc = "Debug: Session" })
		set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
		set("n", "<leader>dw", require("dap.ui.widgets").hover, { desc = "Debug: Widgets" })
		set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle last result." })
		set("n", "<leader>dn", dapui.open, { desc = "Debug: Open session result." })
		set("n", "<leader>dx", dapui.close, { desc = "Debug: Close session result." })

		-- Bridge between `mason.nvim` and `nvim-dap`
		require("mason-nvim-dap").setup({
			ensure_installed = debug_adapters,
			-- Automtically install all adapters set up via dap
			automatic_installation = false,
			handlers = {},
		})

		-- Set up dap config by VsCode launch.json file
		local vscode = require("dap.ext.vscode")
		local _filetypes = require("mason-nvim-dap.mappings.filetypes")
		local filetypes = vim.tbl_deep_extend("force", _filetypes, {
			["node"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
			["pwa-node"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
		})
		local json = require("plenary.json")
		---@diagnostic disable: duplicate-set-field
		vscode.json_decode = function(str)
			---@diagnostic disable: missing-parameter
			return vim.json.decode(json.json_strip_comments(str))
		end
		vscode.load_launchjs(nil, filetypes)
	end,
}

-- vim: ts=2 sts=2 sw=2 et
