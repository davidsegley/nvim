return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
    },
    cmd = { "LspInfo", "LspInstall", "LspStart", "Mason" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason").setup({})
    end,
  },
}
