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

    -- The REPL itself is iron.nvim (<leader>r*), configured in iron.nvim.lua.

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
