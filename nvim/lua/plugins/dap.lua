---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "rcarriga/cmp-dap",
    "nvim-telescope/telescope-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("telescope").load_extension("dap") -- Initialize Telescope extension

    -- Gutter Sign Definitions
    local signs = {
      DapBreakpoint = { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
      DapBreakpointCondition = { text = "◉", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
      DapLogPoint = { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" },
      DapStopped = { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStoppedLine" },
      DapBreakpointRejected = { text = "◌", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
    }
    for name, sign in pairs(signs) do
      vim.fn.sign_define(name, sign)
    end

    -- Highlight Groups
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e85903" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#3bc9db" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#94d82d", bold = true })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2f3336" })

    -- UI Auto-open/close
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- REPL Completion
    require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = { { name = "dap" } },
    })

    -- ADAPTERS
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
    }

    -- LANGUAGES & PATH MAPPING
    -- JavaScript / TypeScript
    local js_config = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Next.js: Debug Server-side",
        runtimeExecutable = "npm",
        runtimeArgs = { "run", "dev" },
        sourceMaps = true,
        nwroot = "${workspaceFolder}",
        webRoot = "${workspaceFolder}",
        protocol = "inspector",
        port = 9229,
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Next.js: Debug Client-side (Chrome)",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        userDataDir = false,
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "React (Vite): Debug in Chrome",
        url = "http://localhost:5173", -- Default Vite port
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        userDataDir = false,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to React Native (Metro 8081)",
        address = "localhost",
        port = 8081,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        runtimeExecutable = "node",
        runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
      },
    }
    for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[lang] = js_config
    end

    -- Python
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = "python",
        -- Docker mapping example:
        -- pathMappings = { { localRoot = "${workspaceFolder}", remoteRoot = "/app" } },
      },
    }

    -- PHP
    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        -- Robust path mapping for Docker/Virtual Machines
        pathMappings = {
          ["/var/www/html"] = "${workspaceFolder}",
          ["/app"] = "${workspaceFolder}",
        },
      },
    }

    -- Go
    dap.configurations.go = {
      { type = "go", name = "Debug", request = "launch", program = "${file}" },
      { type = "go", name = "Debug (Args)", request = "launch", program = "${file}", args = get_args },
    }

    -- Rust
    dap.configurations.rust = {
      {
        name = "Launch Rust Binary",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        args = get_args,
      },
    }

    require("mason-nvim-dap").setup({
      ensure_installed = { "delve", "js-debug-adapter", "codelldb", "php-debug-adapter", "debugpy" },
      automatic_installation = true,
    })

    -- KEYMAPS (Including Telescope DAP)
    local set = vim.keymap.set
    set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Condition: "))
    end, { desc = "Debug: Condition" })
    set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
    set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
    set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
    set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: REPL" })
    set("n", "<leader>dw", require("dap.ui.widgets").hover, { desc = "Debug: Widgets" })

    -- Telescope DAP fuzzy search
    local ts_dap = require("telescope").extensions.dap
    set("n", "<leader>dsb", ts_dap.list_breakpoints, { desc = "Debug: Search Breakpoints" })
    set("n", "<leader>dsc", ts_dap.configurations, { desc = "Debug: Search Configs" })
    set("n", "<leader>dsv", ts_dap.variables, { desc = "Debug: Search Variables" })
    set("n", "<leader>dsf", ts_dap.frames, { desc = "Debug: Search Frames" })
  end,
}
