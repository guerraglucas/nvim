return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "java-debug-adapter",
        "java-test",
        "kotlin-debug-adapter",
        "js-debug-adapter",
        "delve",
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

      -- JS/TS adapter (pwa-node via js-debug-adapter)
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            mason_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Kotlin adapter
      dap.adapters.kotlin = {
        type = "executable",
        command = mason_path .. "/kotlin-debug-adapter/adapter/bin/kotlin-debug-adapter",
      }
      dap.configurations.kotlin = {
        {
          type = "kotlin",
          request = "launch",
          name = "Launch Kotlin",
          projectRoot = "${workspaceFolder}",
          mainClass = function()
            return vim.fn.input("Main class: ")
          end,
        },
      }
    end,
  },
}
