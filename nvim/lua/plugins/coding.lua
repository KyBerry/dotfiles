-- Coding-specific plugins
return {
  -- Web development specific plugins
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "*",
        css = { css = true, css_fn = true },
        scss = { css = true, css_fn = true },
        sass = { css = true, css_fn = true },
        less = { css = true, css_fn = true },
        html = { css = true, css_fn = true },
        javascript = { css = true, css_fn = true },
        javascriptreact = { css = true, css_fn = true },
        typescript = { css = true, css_fn = true },
        typescriptreact = { css = true, css_fn = true },
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = false,
        mode = "background",
        tailwind = true,
        sass = { enable = true },
        virtualtext = "■",
      },
    },
  },

  -- Improved JSON file handling
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Improved markdown support
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    ft = { "markdown" },
  },

  -- Playground for Treesitter
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gvdiffsplit", "Gdiffsplit", "Gclog", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Git browse" },
      { "<leader>gC", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gP", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },
    },
  },

  -- GitLab/GitHub integration
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "GBrowse" },
  },

  -- Testing
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tt", "<cmd>TestNearest<cr>", desc = "Run nearest test" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Run test file" },
      { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Run test suite" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Run last test" },
      { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Visit test file" },
    },
    opts = {
      setup = {},
    },
    config = function(plugin, opts)
      vim.g["test#strategy"] = "neovim"
      vim.g["test#javascript#jest#options"] = "--color=always"
      vim.g["test#javascript#runner"] = "jest"
      vim.g["test#enabled_runners"] = {
        "javascript#jest",
        "typescript#jest",
        "javascript#mocha",
      }
      
      for k, v in pairs(opts.setup) do
        vim.g["test#" .. k] = v
      end
    end,
  },

  -- Git diff view
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffView close" },
    },
    opts = {
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = { 80 }
        end,
      },
      enhanced_diff_hl = true,
    },
  },

  -- HTML/JSX tag manipulation
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
  },

  -- Better JSX indentation
  {
    "MaxMEllon/vim-jsx-pretty",
    ft = { "javascriptreact", "typescriptreact" },
    init = function()
      vim.g.vim_jsx_pretty_colorful_config = 1
    end,
  },

  -- Emmet for HTML/CSS expansion
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "vue" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-e>"
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
      }
    end,
  },

  -- Improved CSS syntax highlighting
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
      
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },

  -- Improved HTML/JSX tag manipulation
  {
    "AndrewRadev/tagalong.vim",
    ft = { "html", "xml", "jsx", "javascriptreact", "typescriptreact", "vue" },
  },

  -- Tailwind CSS integration
  {
    "laytan/tailwind-sorter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm i && npm run build",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    opts = {
      on_save_enabled = true,
    },
  },

  -- Prettier integration
  {
    "MunifTanjim/prettier.nvim",
    dependencies = { "jose-elias-alvarez/null-ls.nvim", "neovim/nvim-lspconfig" },
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "vue", "markdown" },
    opts = {
      bin = "prettier",
      auto_format = true,
      filetypes = {
        "css",
        "scss",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "vue",
        "markdown",
      },
    },
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
        },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text for DAP
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      -- JavaScript/TypeScript Debugging Extension
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
          })
          
          for _, language in ipairs({ "typescript", "javascript" }) do
            require("dap").configurations[language] = {
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
              {
                type = "pwa-chrome",
                request = "launch",
                name = "Launch Chrome against localhost",
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
              },
            }
          end
        end,
      },
      -- VSCode JS Debug
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#993939", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "#31353f" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
    end,
  },

  -- Database integration
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    keys = {
      { "<leader>db", "<cmd>DBUI<cr>", desc = "Database UI" },
    },
    config = function()
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 35
      
      -- Add completion for SQL in specific filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })
    end,
  },

  -- Multiple cursor support
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
    init = function()
      vim.g.VM_leader = '\\'
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
    end,
  },

  -- Advanced text objects
  {
    "kana/vim-textobj-user",
    event = "BufReadPost",
    dependencies = {
      "kana/vim-textobj-entire", -- ae/ie for entire buffer
      "kana/vim-textobj-line",   -- al/il for line
      "kana/vim-textobj-indent", -- ai/ii for indent level
    },
  },
}