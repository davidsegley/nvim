return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = {
            -- statusline = { "dashboard", "alpha", "starter" },
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              "filename",
            },
            {
              "filetype",
              padding = { left = 1, right = 1 },
              colored = false,
            },
            {
              "branch",
              cond = hide_in_width,
            },
            {
              "diff",
              colored = false,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict

                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
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
              "progress",
              padding = { left = "2", right = "2" },
              icon = "",
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
