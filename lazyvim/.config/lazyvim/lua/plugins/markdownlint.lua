-- Use a global markdownlint config (disables MD013 line-length, etc.)
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml", "-" },
      },
    },
  },
}
