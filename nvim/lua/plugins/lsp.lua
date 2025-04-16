-- LSP Configuration
return {
  -- LSP Manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP
        "lua-language-server",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "eslint-lsp",
        "json-lsp",
        "yaml-language-server",
        "svelte-language-server",
        "astro-language-server",
        -- Linters
        "eslint_d",
        "stylelint",
        -- Formatters
        "prettierd",
        "prettier",
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Mason integration with null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier",
          "prettierd",
          "eslint_d",
          "stylelint",
          "stylua",
        },
        automatic_installation = true,
        automatic_setup = false,
      })
    end,
  },

  -- LSP servers manager
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "html",
          "cssls",
          "tailwindcss",
          "jsonls",
          "eslint",
          "yamlls",
          "svelte",
          "astro",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP status display
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      local lsp_status = require("lsp-status")
      lsp_status.register_progress()
      lsp_status.config({
        indicator_errors = " ",
        indicator_warnings = " ",
        indicator_info = " ",
        indicator_hint = "󰌵 ",
        indicator_ok = "✓",
        status_symbol = " ",
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "nvim-lua/lsp-status.nvim",
      "b0o/schemastore.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup icons for diagnostics
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = "󰌵 ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Setup diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      -- Setup handlers for hover and signature help
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- neodev setup (before lspconfig)
      require("neodev").setup({
        library = {
          plugins = { "nvim-dap-ui" },
          types = true,
        },
      })

      -- LSP capabilities with nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- LSP on_attach function for keymaps
      local function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Register lsp-status with client
        require("lsp-status").on_attach(client)

        -- LSP keymaps
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, bufopts)
        
        -- Enable inlay hints if supported and available
        if client.server_capabilities.inlayHintProvider and vim.fn.has("nvim-0.10") == 1 then
          vim.api.nvim_create_autocmd({ "InsertEnter", "BufEnter" }, {
            pattern = "*",
            callback = function()
              vim.lsp.inlay_hint.enable(true)
            end,
            once = true,
          })
        end

        -- Disable formatting for specific clients (let null-ls handle it)
        if client.name == "tsserver" or client.name == "lua_ls" or client.name == "jsonls" or client.name == "cssls" or client.name == "html" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end

      -- Configure LSP servers
      local lspconfig = require("lspconfig")

      -- Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })

      -- TypeScript/JavaScript
      lspconfig.tsserver.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            format = {
              enable = false, -- handled by prettier
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            format = {
              enable = false, -- handled by prettier
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },
        },
      })

      -- HTML
      lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "javascriptreact", "typescriptreact" },
      })

      -- CSS
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "css", "scss", "less", "stylus", "javascriptreact", "typescriptreact" },
      })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classNames", "class:list" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
            emmetCompletions = true,
          },
        },
      })

      -- JSON with schemastore support
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML with schemastore support
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- the Schemastore plugin instead
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- Svelte
      lspconfig.svelte.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "svelte" },
        settings = {
          svelte = {
            plugin = {
              svelte = {
                format = {
                  enable = false, -- Let prettier handle formatting
                },
              },
            },
          },
        },
      })

      -- Astro
      lspconfig.astro.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "astro" },
        init_options = {
          typescript = {
            tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
          },
        },
      })

      -- ESLint
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Auto-fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        capabilities = capabilities,
      })
    end,
  },

  -- Better development for neovim plugins
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    },
  },

  -- Better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
    },
  },

  -- LSP enhancements
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "<leader>la", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
      { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
      { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      { "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
      { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous Diagnostic" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },
    },
    opts = {
      ui = {
        border = "rounded",
        title = true,
        winblend = 0,
        colors = {
          normal_bg = "#1a1b26",
        },
      },
      symbol_in_winbar = {
        enable = true,
        separator = "  ",
        hide_keyword = true,
        show_file = true,
        folder_level = 1,
      },
      definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>s",
        tabe = "<C-c>t",
        quit = "q",
      },
      code_action = {
        num_shortcut = true,
        show_server_name = true,
        extend_gitsigns = true,
      },
      diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        border_follow = true,
        keys = {
          exec_action = "o",
          quit = "q",
          go_action = "g",
        },
      },
      rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
      },
      outline = {
        win_position = "right",
        win_with = "",
        win_width = 30,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {
          jump = "o",
          expand_collapse = "u",
          quit = "q",
        },
      },
      callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "s",
          split = "i",
          tabe = "t",
          jump = "o",
          quit = "q",
          expand_collapse = "u",
        },
      },
      beacon = {
        enable = true,
        frequency = 7,
      },
      lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
      },
    },
  },

  -- Null-ls for formatters and linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      
      -- Register sources
      null_ls.setup({
        debug = false,
        sources = {
          -- Formatters
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
              "astro",
              "css",
              "scss",
              "less",
              "html",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "markdown.mdx",
              "graphql",
            },
            prefer_local = "node_modules/.bin",
            timeout = 10000,
          }),
          null_ls.builtins.formatting.stylua.with({
            filetypes = { "lua" },
          }),
          
          -- Linters
          null_ls.builtins.diagnostics.eslint_d.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
              "astro",
            },
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return utils.root_has_file({
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                ".eslintrc.json",
              })
            end,
          }),
          null_ls.builtins.diagnostics.stylelint.with({
            filetypes = { "css", "scss", "less", "sass" },
            condition = function(utils)
              return utils.root_has_file({
                ".stylelintrc",
                ".stylelintrc.json",
                ".stylelintrc.yaml",
                ".stylelintrc.yml",
                ".stylelintrc.js",
                "stylelint.config.js",
                "stylelint.config.cjs",
              })
            end,
          }),
          
          -- Code actions
          null_ls.builtins.code_actions.eslint_d.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
              "astro",
            },
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return utils.root_has_file({
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                ".eslintrc.json",
              })
            end,
          }),
        },
        -- Set up format on save with a better approach that prevents conflicts
        on_attach = function(client, bufnr)
          -- Only proceed if the client supports formatting
          if client.supports_method("textDocument/formatting") then
            -- Create an autocmd group
            local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })
            
            -- Create an autocmd for this buffer to format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- Use the new vim.lsp.buf.format API
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(client)
                    -- Use null-ls for formatting instead of other LSP servers
                    return client.name == "null-ls"
                  end,
                  timeout_ms = 2000,
                })
              end,
            })
          end
        end,
      })
    end,
  },

  -- Rust tools for enhanced Rust development
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      return {
        tools = {
          on_initialized = function()
            vim.cmd([[
              augroup RustLSP
                autocmd CursorHold,CursorHoldI *.rs silent! lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved,CursorMovedI *.rs silent! lua vim.lsp.buf.clear_references()
                autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
              augroup END
            ]])
          end,
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- Set up LSP keymaps
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set("n", "<leader>wl", function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, bufopts)
            
            -- Register lsp-status with client
            require("lsp-status").on_attach(client)
            
            -- Additional rust-specific commands
            vim.keymap.set("n", "<leader>rr", "<cmd>RustRunnables<cr>", bufopts)
            vim.keymap.set("n", "<leader>rd", "<cmd>RustDebuggables<cr>", bufopts)
            vim.keymap.set("n", "<leader>re", "<cmd>RustExpandMacro<cr>", bufopts)
            vim.keymap.set("n", "<leader>rc", "<cmd>RustOpenCargo<cr>", bufopts)
            vim.keymap.set("n", "<leader>rp", "<cmd>RustParentModule<cr>", bufopts)
            vim.keymap.set("n", "<leader>rx", "<cmd>RustRun<cr>", bufopts)
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
              lens = {
                enable = true,
              },
              inlayHints = {
                chainingHints = {
                  enable = true,
                },
                parameterHints = {
                  enable = true,
                },
                typeHints = {
                  enable = true,
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
}