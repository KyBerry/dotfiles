-- Keymaps for better default experience
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key (defined in init.lua already, but keeping it here for clarity)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== NORMAL MODE =====

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear search highlights
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
keymap("n", "<leader>fd", vim.diagnostic.open_float, { desc = "Show diagnostic error" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- Move lines up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste - doesn't overwrite register with the text that's replaced
keymap("v", "p", '"_dP', opts)

-- Move lines up and down in visual mode
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- File explorer (Neo-tree)
keymap("n", "<leader>e", ":Neotree toggle<CR>", opts)
keymap("n", "<leader>o", ":Neotree focus<CR>", opts)

-- Format document
keymap("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })

-- ===== TELESCOPE KEYMAPS =====
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fc", ":Telescope colorscheme<CR>", { desc = "Colorschemes" })
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
keymap("n", "<leader>fw", ":Telescope grep_string<CR>", { desc = "Grep word under cursor" })
keymap("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Git commits" })
keymap("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Git branches" })

-- ===== LSP KEYMAPS =====
-- These will be set up in the lsp on_attach function
-- See plugins/lsp.lua