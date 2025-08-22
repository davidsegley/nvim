return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      signature = { enabled = true },
      completion = {
        accept = {
          auto_brackets = { enabled = true, default_brackets = { "(", ")" } },
        },

        menu = {
          draw = {
            padding = { 0, 1 }, -- padding only on right side
            components = {
              kind_icon = {
                text = function(ctx)
                  return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
                end,
              },
            },
          },
        },

        documentation = { auto_show = true },
        ghost_text = { enabled = false },
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
}
