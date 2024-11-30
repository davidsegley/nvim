return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = false,
          disabled_filetypes = { "alpha" },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1,
            },
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
