return {
    -- Molten: Jupyter kernel integration with inline output
    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        build = ":UpdateRemotePlugins",
        dependencies = {
            {
                "3rd/image.nvim",
                opts = {
                    backend = "kitty", -- or "ueberzug" for X11
                    max_width = 100,
                    max_height = 12,
                    max_height_window_percentage = math.huge,
                    max_width_window_percentage = math.huge,
                    window_overlap_clear_enabled = true,
                    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
                },
            },
        },
        init = function()
            vim.g.python3_host_prog = vim.fn.expand("~/.local/share/venvs/nvim/bin/python")
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
            vim.g.molten_auto_open_output = false
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
        end,
    },

    -- NotebookNavigator: Cell navigation and execution
    {
        "GCBallesteros/NotebookNavigator.nvim",
        dependencies = {
            "nvim-mini/mini.comment",
            "benlubas/molten-nvim",
        },
        event = "VeryLazy",
        keys = {
            {
                "]h",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
                desc = "Next cell",
            },
            {
                "[h",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
                desc = "Prev cell",
            },
            {
                "<leader>x",
                function()
                    require("notebook-navigator").run_and_move()
                end,
                desc = "Run cell",
            },
            {
                "<leader>X",
                function()
                    require("notebook-navigator").run_cell()
                end,
                desc = "Run cell (stay)",
            },
        },
        opts = {
            repl_provider = "molten",
            cell_markers = {
                python = "# %%",
            },
        },
    },

    -- jupytext.nvim: Transparent .ipynb handling
    {
        "goerz/jupytext.nvim",
        version = "0.2.0",
        opts = {}, -- see Options
    },

    -- mini.ai: Text objects including cell objects
    {
        "nvim-mini/mini.ai",
        event = "VeryLazy",
        dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
        opts = function()
            local nn = require("notebook-navigator")
            return {
                custom_textobjects = {
                    h = nn.miniai_spec, -- `ih` and `ah` for cells
                },
            }
        end,
    },

    -- mini.hipatterns: Visual cell highlighting (optional)
    {
        "nvim-mini/mini.hipatterns",
        event = "VeryLazy",
        dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
        opts = function()
            local nn = require("notebook-navigator")
            return {
                highlighters = {
                    cells = nn.minihipatterns_spec,
                },
            }
        end,
    },
}
