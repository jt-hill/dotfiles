-- Racket, set up for working through SICP.
--
-- Depends on two Racket packages, both installed with raco rather than dnf:
--   raco pkg install sicp racket-langserver
-- `sicp` provides `#lang sicp` (nil, true/false, inc/dec, runtime) and the
-- sicp-pict picture language used from exercise 2.44 on.

return {
    -- Also the parse tree nvim-paredit operates on.
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "racket" } },
    },

    -- racket-langserver: hover pulls the real Racket docs, plus go-to-definition
    -- and check-syntax diagnostics. Not a mason package, hence mason = false.
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                racket_langserver = { mason = false },
            },
        },
    },

    -- Conjure: evaluate forms straight from the buffer, results as virtual text
    -- and in the HUD. Localleader is `\`, so <localleader>ee is `\ee`.
    --
    --   \ee  eval form under cursor      \eb  eval buffer
    --   \er  eval root (top-level) form  \ef  eval file
    --   \lv  open log in a vsplit        \lg  toggle log
    {
        "Olical/conjure",
        ft = { "racket", "scheme" },
        init = function()
            -- Conjure otherwise claims python, lua, rust and sql buffers too.
            vim.g["conjure#filetypes"] = { "racket", "scheme" }

            -- `-I sicp` starts the REPL in the sicp language. The -e clause makes
            -- SICP's mutable lists print as `(1 2 3)` instead of mcons chains;
            -- those parameters live in racket/base, which sicp doesn't re-export
            -- (and `-l racket/base` would replace the sicp namespace).
            -- A list, not a string: Conjure splits strings on whitespace with no
            -- shell, which would break up the -e program.
            vim.g["conjure#client#racket#stdio#command"] = {
                "racket",
                "-I",
                "sicp",
                "-e",
                "(#%require (only racket/base print-as-expression print-mpair-curly-braces))"
                    .. " (print-as-expression #f) (print-mpair-curly-braces #f)",
                "-i",
            }

            -- Conjure binds bare K to its own REPL doc lookup, shadowing LSP
            -- hover. racket-langserver's hover is the better of the two.
            vim.g["conjure#mapping#doc_word"] = false
        end,
    },

    -- Structural editing. Racket is not an upstream-supported filetype, so it is
    -- added here and backed by queries/racket/paredit/forms.scm in this config.
    --
    --   >)  <)  >(  <(   slurp / barf      >e <e  drag element
    --   \o  raise form   \O  raise element  >f <f  drag form
    --   W B E gE  element-wise motions      (  )  jump to parent form edges
    {
        "julienvincent/nvim-paredit",
        ft = { "racket", "scheme" },
        opts = {
            filetypes = { "clojure", "fennel", "scheme", "lisp", "janet", "racket" },
            -- Reindent forms after slurp/barf instead of leaving them ragged.
            indent = { enabled = true },
        },
    },
}
