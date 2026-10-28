-- iron.nvim: send-to-REPL, a lighter replacement for the molten/jupyter stack.

-- iron only searches $PATH, and ipython lives in a venv, so resolve it
-- explicitly: activated venv, then the buffer's project .venv, then the
-- datascience scratch env from datascience-env.sh.
local function python_command()
    local candidates = {}
    if vim.env.VIRTUAL_ENV then
        table.insert(candidates, vim.env.VIRTUAL_ENV .. "/bin/ipython")
    end
    local root = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".venv", "pyproject.toml", ".git" })
    if root then
        table.insert(candidates, root .. "/.venv/bin/ipython")
    end
    table.insert(candidates, vim.fn.expand("~/.local/share/venvs/datascience/bin/ipython"))
    table.insert(candidates, "ipython")

    -- --no-autoindent: otherwise ipython re-indents pasted lines on top of
    -- their existing indentation and function bodies raise IndentationError.
    for _, exe in ipairs(candidates) do
        if vim.fn.executable(exe) == 1 then
            return { exe, "--no-autoindent" }
        end
    end
    return { "python3" }
end

return {
    {
        "hkupty/iron.nvim",
        event = "VeryLazy",
        config = function()
            local view = require("iron.view")
            local common = require("iron.fts.common")

            require("iron.core").setup({
                config = {
                    scratch_repl = true,
                    -- Replaces iron's lazy per-filetype lookup. send_code_block
                    -- reads this table directly, so any filetype that needs
                    -- `# %%` cells must be listed here.
                    repl_definition = {
                        python = {
                            command = python_command,
                            format = common.bracketed_paste_python,
                            block_dividers = { "# %%", "#%%" },
                        },
                        sh = {
                            command = { "zsh" },
                            format = common.bracketed_paste,
                        },
                    },
                    -- One toggle_repl_with_cmd_<n> map per entry; first is default.
                    repl_open_cmd = {
                        view.split.botright(0.3),
                        view.split.vertical.botright(0.4),
                    },
                },

                -- Kept under <leader>r; <leader>s* and <leader>c* collide with LazyVim.
                keymaps = {
                    send_code_block_and_move = "<leader>rn",
                    send_code_block = "<leader>rb",
                    send_motion = "<leader>rc",
                    visual_send = "<leader>rc",
                    send_line = "<leader>rl",
                    send_paragraph = "<leader>rp",
                    send_until_cursor = "<leader>ru",
                    send_file = "<leader>rF",

                    send_mark = "<leader>rm",
                    mark_motion = "<leader>rM",
                    mark_visual = "<leader>rM",
                    remove_mark = "<leader>rd",

                    toggle_repl_with_cmd_1 = "<leader>rr",
                    toggle_repl_with_cmd_2 = "<leader>rv",
                    restart_repl = "<leader>rR",
                    exit = "<leader>rq",

                    cr = "<leader>r<cr>",
                    interrupt = "<leader>rk",
                    clear = "<leader>rL",
                },

                highlight = { link = "Visual" },
            })

            vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "REPL focus" })
            vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "REPL hide" })
            vim.keymap.set("n", "<M-cr>", function()
                require("iron.core").send_code_block(true)
            end, { desc = "REPL send cell and move" })
        end,
    },

    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>r", group = "repl", mode = { "n", "v" } },
            },
        },
    },
}
