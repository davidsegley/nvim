return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostics disable: missing-fields
    opts = {},
    ---@diagnostics enable: missing-fields
    config = function()
      local function find_config_files()
        return require("fzf-lua").files({
          cwd = vim.fn.stdpath("config"),
          previewer = false,
        })
      end

      require("fzf-lua").setup({
        "max-perf",
      })

      vim.keymap.set(
        "n",
        "<leader><space>",
        "<cmd>FzfLua files previewer=false<cr>",
        { desc = "Find Files" }
      )

      vim.keymap.set(
        "n",
        "<C-p>",
        "<cmd>FzfLua git_files previewer=false<cr>",
        { desc = "Find Git Files" }
      )

      vim.keymap.set(
        "n",
        "<leader>/",
        "<cmd>FzfLua grep<cr>",
        { desc = "Live Grep" }
      )

      vim.keymap.set(
        "n",
        "<leader>ss",
        "<cmd>FzfLua grep_cword<cr>",
        { desc = "Grep Current Word" }
      )

      vim.keymap.set(
        "n",
        "<leader>fb",
        "<cmd>FzfLua buffers previewer=false<cr>",
        { desc = "Search Buffers" }
      )

      vim.keymap.set(
        "n",
        "<leader>,",
        "<cmd>FzfLua buffers previewer=false<cr>",
        { desc = "Search Buffers" }
      )

      vim.keymap.set(
        "n",
        "<leader>sr",
        "<cmd>FzfLua resume<cr>",
        { desc = "Resume last search" }
      )

      vim.keymap.set(
        "n",
        "<leader>fr",
        "<cmd>FzfLua oldfiles previewer=false<cr>",
        { desc = "Search recent files" }
      )

      vim.keymap.set(
        "n",
        "<leader>fc",
        find_config_files,
        { desc = "Find Config Files" }
      )

      vim.keymap.set(
        "n",
        "<leader>cs",
        "<cmd>FzfLua lsp_document_symbols<cr>",
        { desc = "Lsp Document Symbols" }
      )
    end,
  },
}
