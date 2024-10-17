return {
  {
    "no-clown-fiesta/no-clown-fiesta.nvim",
    enabled = true,
    priority = 1000,
    opts = {
      transparent = false,
      styles = {
        type = { fg = "#c49c64" },
      },
    },
    config = function(_, opts)
      require("no-clown-fiesta").setup(opts)
      vim.cmd.colorscheme("no-clown-fiesta")

      local color_column_bg = "#202020"
      local bg = "#101010"

      local set_hl = function(hl, styles)
        return vim.api.nvim_set_hl(0, hl, styles)
      end

      set_hl("ColorColumn", { bg = color_column_bg })
      set_hl("ColorColumn", { bg = color_column_bg })
      set_hl("StatusLineNC", { fg = "gray", bg = bg })
      set_hl("StatusLine", { bg = bg })
      set_hl("NormalFloat", { bg = bg })
    end,
  },

  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    enabled = false,
    opts = {
      term_colors = false,
      show_end_of_buffer = true,
      transparent_background = false,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
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
          "lazyterm",
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

  -- Focus splits and sets signcolumn automatically
  {
    "nvim-focus/focus.nvim",
    event = { "VeryLazy" },
    enabled = false,
    opts = {},
    config = true,
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
