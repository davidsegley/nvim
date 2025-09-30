return {
  {
    "no-clown-fiesta/no-clown-fiesta.nvim",
    name = "no-clown-fiesta",
    priority = 1000,
    enabled = true,
    config = function()
      require("no-clown-fiesta").setup({
        transparent = false,
      })

      vim.cmd.colorscheme("no-clown-fiesta")

      local palette = require("no-clown-fiesta.palettes")
      vim.api.nvim_set_hl(0, "StatusLine", { fg = palette.fg })
      vim.api.nvim_set_hl(0, "StatusLineNC", { fg = palette.gray })
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false,
    config = function()
      require("catppuccin").setup({
        transparent_background = not vim.g.neovide, -- disables setting the background color.
        show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        no_italic = true, -- Force no italic
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  {
    "echasnovski/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup({
        delay = 500,
      })
    end,
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
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "sql",
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
