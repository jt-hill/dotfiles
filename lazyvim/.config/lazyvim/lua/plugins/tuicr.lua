-- tuicr: code-review TUI in a floating terminal, wired up like LazyVim's lazygit.
-- `e` in tuicr hides the float and opens the file here at the cursor line;
-- the same keymap brings the review back where you left it.

local shim = vim.fn.stdpath("config") .. "/tuicr/nvim"

-- Called by the shim over RPC. While tuicr is waiting on its editor, the
-- current window is still the tuicr float.
function _G.TuicrEdit(file, line)
    local buf = vim.api.nvim_get_current_buf()
    for _, term in ipairs(Snacks.terminal.list()) do
        if term.buf == buf then
            term:hide()
        end
    end
    vim.cmd("edit +" .. line .. " " .. vim.fn.fnameescape(file))
    return ""
end

local function tuicr(args, cwd)
    local cmd = { "tuicr", "--appearance", vim.o.background }
    vim.list_extend(cmd, args or {})
    Snacks.terminal(cmd, {
        cwd = cwd or LazyVim.root.git(),
        env = { EDITOR = shim },
        win = { style = "lazygit" },
    })
end

return {
    {
        "folke/snacks.nvim",
        keys = {
            { "<leader>gr", function() tuicr() end, desc = "Review (tuicr)" },
            {
                "<leader>gR",
                function()
                    local file = vim.api.nvim_buf_get_name(0)
                    local root = LazyVim.root.git()
                    tuicr({ "--path", vim.fs.relpath(root, file) or file }, root)
                end,
                desc = "Review Current File (tuicr)",
            },
        },
    },
}
