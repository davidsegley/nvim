return {
  {
    "no-clown-fiesta/no-clown-fiesta.nvim",
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup({
        styles = {
          type = {
            fg = "#F4BF75",
          },
        },
      })

      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  {
    -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      triggers = {
        { "<auto>", mode = "nxso" },
      },
      plugins = {
        spelling = {
          enabled = false, -- some bugs with this
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "files" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "trouble" },
        { "<leader><tab>", group = "tabs" },
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
    main = "ibl",
  },

  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    version = false, -- wait till new 0.7.0 release to put it back on semver
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      user_default_options = {
        names = false,
      },
    },
  },
}
