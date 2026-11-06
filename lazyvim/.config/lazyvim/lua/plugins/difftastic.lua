-- difftastic: structural `git diff HEAD` in a floating terminal, wired up like
-- LazyVim's lazygit (and tuicr.lua). Output is paged with less; `q` closes it.

local function difft(path, cwd)
    cwd = cwd or LazyVim.root.git()
    local args = { "diff", "HEAD" }
    if path then
        vim.list_extend(args, { "--", path })
    end
    -- An empty diff would just open a blank pager.
    if vim.system({ "git", "diff", "--quiet", unpack(args, 2) }, { cwd = cwd }):wait().code == 0 then
        vim.notify("No changes against HEAD", vim.log.levels.INFO, { title = "difftastic" })
        return
    end
    Snacks.terminal(vim.list_extend({ "git", "-c", "diff.external=difft" }, args), {
        cwd = cwd,
        env = {
            DFT_BACKGROUND = vim.o.background,
            -- Keep the pager open even when the diff fits on one screen.
            GIT_PAGER = "less",
            LESS = "R",
        },
        win = { style = "lazygit" },
    })
end

return {
    {
        "folke/snacks.nvim",
        keys = {
            { "<leader>gt", function() difft() end, desc = "Diff (difftastic)" },
            {
                "<leader>gT",
                function()
                    local file = vim.api.nvim_buf_get_name(0)
                    local root = LazyVim.root.git()
                    difft(vim.fs.relpath(root, file) or file, root)
                end,
                desc = "Diff Current File (difftastic)",
            },
        },
    },
}
