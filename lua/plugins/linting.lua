return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    -- lint.linters.gdlint = {
    --   cmd = "gdlint",
    --   stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
    --   ignore_exitcode = false, -- set this to true if the linter exits with a code != 0 and that's considered normal.
    --   stream = "both",
    -- }
    --
    -- lint.linters_by_ft = {
    --   gdscript = { "gdlint" },
    -- }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
