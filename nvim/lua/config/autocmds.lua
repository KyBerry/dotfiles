-- Autocommands for Neovim
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
  desc = "Highlight text on yank",
})

-- Resize splits if window got resized
autocmd({ "VimResized" }, {
  group = general,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Resize splits on window resize",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Auto create dir when saving a file
autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Create directory if it doesn't exist when saving file",
})

-- Auto toggle relative line numbers when needed
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = general,
  callback = function()
    if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
      vim.wo.relativenumber = true
    end
  end,
  desc = "Enable relative line numbers when not in insert mode and the buffer has line numbers",
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = general,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
  desc = "Disable relative line numbers in insert mode or when the buffer loses focus",
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "startuptime",
    "checkhealth",
    "spectre_panel",
    "tsplayground",
    "neotest-output",
    "neotest-summary",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with q",
})

-- Web development specific settings
local webdev = augroup("WebDevelopment", { clear = true })

-- Set appropriate filetypes
autocmd({ "BufRead", "BufNewFile" }, {
  group = webdev,
  pattern = { "*.jsx", "*.tsx" },
  callback = function()
    vim.opt_local.filetype = vim.fn.expand("%:e") == "jsx" and "javascriptreact" or "typescriptreact"
  end,
  desc = "Set JSX/TSX filetypes properly",
})

-- Set MDX files to be treated as markdown
autocmd({ "BufRead", "BufNewFile" }, {
  group = webdev,
  pattern = "*.mdx",
  command = "setfiletype markdown",
  desc = "Set MDX files to be treated as markdown",
})

-- Auto formatting on save for web development files
autocmd("BufWritePre", {
  group = webdev,
  pattern = {
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.vue",
    "*.css",
    "*.scss",
    "*.html",
    "*.json",
    "*.yaml",
    "*.yml",
    "*.md",
    "*.mdx",
  },
  callback = function()
    -- Format with LSP if available
    vim.lsp.buf.format({ timeout_ms = 1000 })
  end,
  desc = "Format web development files on save",
})

-- Improved syntax highlighting for large files
autocmd("BufEnter", {
  group = webdev,
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync fromstart",
  desc = "Improve syntax highlighting for large JS/TS files",
})

autocmd("BufLeave", {
  group = webdev,
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync clear",
  desc = "Clear syntax sync when leaving JS/TS files",
})

-- Treesitter folding for supported filetypes
autocmd("FileType", {
  group = webdev,
  pattern = {
    "lua",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "yaml",
    "html",
    "css",
    "scss",
    "markdown",
    "mdx",
  },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = false
  end,
  desc = "Enable treesitter folding for supported filetypes",
})