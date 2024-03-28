return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      autochdir = true,
      start_in_insert = true,
      size = function(term)
        if term.direction == "horizontal" then
          return 18
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      shell = function()
        return vim.o.shell .. vim.g.shellflag
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        close_on_exit = true,
      })

      local function lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set(
        "n",
        "<leader>gg",
        lazygit_toggle,
        { noremap = true, silent = true, desc = "Lazygit" }
      )
    end,
  },
}
