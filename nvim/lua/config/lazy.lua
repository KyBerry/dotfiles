-- Initialize the plugin manager
local lazy = require("lazy")

-- Configure lazy.nvim
lazy.setup({
  spec = {
    -- Import all plugin modules
    { import = "plugins" },
  },
  defaults = {
    lazy = true, -- Every plugin is lazy-loaded by default
    version = false, -- Try to use the latest git commit
  },
  install = {
    -- Try to use the latest stable version of plugins
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  ui = {
    border = "rounded", -- Display borders in the UI
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✓ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  checker = {
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Don't automatically notify about updates
    frequency = 86400, -- Check for updates once a day
  },
  change_detection = {
    enabled = true, -- Automatically check for config changes
    notify = false, -- Don't automatically notify about config changes
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  debug = false,
})