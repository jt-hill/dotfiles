-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.clipboard = "unnamedplus"

-- Key mappings
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true, silent = true })

-- VSCode check (if you need it)
if vim.g.vscode then
    require("vscode")
else
    -- Standalone neovim settings
    vim.opt.termguicolors = true
    vim.cmd('color default')
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.ruler = true
    vim.opt.errorbells = false
    vim.opt.visualbell = false
    vim.opt.laststatus = 2
    vim.opt.showmode = true
    vim.opt.splitbelow = true
    vim.opt.splitright = true
    
    -- Text searching
    vim.opt.incsearch = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.showmatch = true
    
    -- Syntax and formatting
    vim.opt.syntax = 'on'
    vim.opt.encoding = "utf-8"
    vim.opt.formatoptions = "tqrnl"
    vim.opt.hidden = true
    
    -- Tabs and indenting
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
    vim.opt.shiftround = false
    vim.opt.scrolloff = 5
    vim.opt.backspace = "indent,eol,start"
    
    -- Command line
    vim.opt.showcmd = true
    vim.opt.wildmenu = true
    
    -- Cursor highlight on insert
    vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave"}, {
        pattern = "*",
        command = "set cul!"
    })
end
