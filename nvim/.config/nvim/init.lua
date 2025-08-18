vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.clipboard = "unnamedplus"
-- vim.keymap.set("n", "<leader>a", function() print "leader works" end)
vim.o.number = true
vim.o.relativenumber = true

-- key mappings
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>a", function() print "leader works" end)

-- vscode stuff
if vim.g.vscode then
    require("vscode")
else
-- plugins and other functionality for standalone use
	vim.o.tabstop = 4
	vim.o.shiftwidth = 4
	vim.o.expandtab = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
    vim.cmd('syntax on')
    --require("kickstart")
end

