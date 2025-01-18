local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
      require('dap.ext.vscode').load_launchjs('.vscode/launch.json', {})
    end
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()   -- Mapping tab is already used by NvChad
      vim.g.copilot_no_tab_map = true;
      vim.g.copilot_assume_mapped = true;
      vim.g.copilot_tab_fallback = ""; -- The mapping is set to other key, see custom/lua/mappings
      -- or run <leader>ch to see copilot mapping section
    end
  },
  {
    "nvim-neotest/nvim-nio",
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {},
    init = function(_, opts)
      -- setup dap config by VsCode launch.json file
      -- require("dap.ext.vscode").load_launchjs()
      -- local dap = require("dap")
      require("core.utils").load_mappings("dapui")
      local dapui = require("dapui")
      dapui.setup(opts)
      -- dap.listeners.after.event_initialized["dapui_config"] = function()
      --   dapui.open({})
      -- end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
    end,
  },
  {
    "f-person/git-blame.nvim",
    lazy = false
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local defaults = require("plugins.configs.treesitter") -- Load default NvChad config
      defaults.highlight = {
        enable = true,
        disable = function(lang, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 5000 or lang == "csv" -- Disable for files >5000 lines or any CSV
        end,
        additional_vim_regex_highlighting = false,
      }
      return defaults
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  }
}

return plugins
