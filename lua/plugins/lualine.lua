return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = function()
      local hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end

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
            {
              "branch",
              cond = hide_in_width,
            },
          },
          lualine_x = {
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
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
              function()
                local msg = "no active lsp"
                local buf_ft =
                  vim.api.nvim_get_option_value("filetype", { buf = 0 })
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = "  LSP ~",
              cond = hide_in_width,
            },
            {
              "o:encoding",
              fmt = string.upper,
              color = { gui = "bold" },
            },
            {
              "fileformat",
              icons_enabled = false,
              fmt = string.upper,
              color = { gui = "bold" },
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
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
