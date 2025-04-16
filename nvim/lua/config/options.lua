-- Neovim global options
local opt = vim.opt

-- Line numbers
opt.number = true                -- Show line numbers
opt.relativenumber = true        -- Show relative line numbers
opt.numberwidth = 4              -- Width of number column
opt.signcolumn = "yes"           -- Always show sign column

-- Tabs & Indentation
opt.tabstop = 2                  -- Number of spaces tabs count for
opt.softtabstop = 2              -- Number of spaces for a tab while editing
opt.shiftwidth = 2               -- Size of an indent
opt.expandtab = true             -- Use spaces instead of tabs
opt.smartindent = true           -- Insert indents automatically
opt.wrap = false                 -- Disable line wrap
opt.breakindent = true           -- Indent wrapped lines

-- Search
opt.hlsearch = true              -- Highlight all matches on previous search pattern
opt.ignorecase = true            -- Ignore case in search patterns
opt.smartcase = true             -- Override ignore case if search contains uppercase

-- Appearance
opt.termguicolors = true         -- True color support
opt.background = "dark"          -- Set background
opt.cursorline = true            -- Highlight current line
opt.conceallevel = 0             -- Show text normally
opt.fillchars = { eob = " " }    -- Remove ~ at the end of buffer
opt.showmode = false             -- Don't show mode since we have a statusline
opt.pumheight = 10               -- Maximum number of entries in a popup
opt.showtabline = 2              -- Always show tabs
opt.scrolloff = 8                -- Minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8            -- Minimal number of screen columns to keep to the left and right of the cursor

-- Behavior
opt.clipboard = "unnamedplus"    -- Use system clipboard
opt.mouse = "a"                  -- Enable mouse mode
opt.updatetime = 250             -- Faster completion
opt.timeoutlen = 300             -- Time to wait for a mapped sequence to complete (in milliseconds)
opt.completeopt = {              -- Better completion experience
  "menuone",                     -- Show the popup menu even when there is only one match
  "noselect",                    -- Don't automatically select a match in the menu
  "noinsert"                     -- Don't automatically insert text
}
opt.undofile = true              -- Enable persistent undo
opt.swapfile = false             -- Don't use swapfile
opt.backup = false               -- Don't create backup file
opt.writebackup = false          -- Don't write backup file
opt.autoread = true              -- Reload files changed outside of Vim
opt.confirm = true               -- Prompt to save before destructive actions
opt.cmdheight = 1                -- Height of the command line
opt.fileencoding = "utf-8"       -- The encoding written to a file
opt.splitbelow = true            -- Horizontal splits go below current window
opt.splitright = true            -- Vertical splits go to the right of current window

-- Performance
opt.lazyredraw = true            -- Don't redraw while executing macros
opt.hidden = true                -- Enable background buffers
opt.history = 100                -- Remember N lines in history
opt.synmaxcol = 240              -- Max column for syntax highlight

-- Prevent screen jumping when searching
opt.incsearch = true

-- Disable builtin plugins we don't need
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Set spellchecking for certain filetypes
vim.cmd [[
  autocmd FileType markdown,text,gitcommit setlocal spell
]]