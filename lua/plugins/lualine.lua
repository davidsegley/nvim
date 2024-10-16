return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = false,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "filename",
              path = 0,
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              "filetype",
              padding = { left = 1, right = 1 },
              colored = false,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              colored = false,
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            {
              "o:encoding",
            },
            {
              "fileformat",
              icons_enabled = false,
            },
            {
              "location",
            },
            {
              "progress",
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy" },
      }
    end,
  },
}
