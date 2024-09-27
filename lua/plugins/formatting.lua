return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- javascript = { { "eslint", "" } },
        -- typescript = { { "eslint", "" } },
        -- vue = { "eslint" },
        svelte = { "prettier" },
        css = { "prettier" },
        -- html = { "volar" },
        json = { "prettier" },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
