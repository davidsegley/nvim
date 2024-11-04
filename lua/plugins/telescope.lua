local util = require("util.telescope")

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = vim.fn.executable("cmake") == 1,
    },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  keys = {
    { "<C-p>", "<cmd>Telescope git_files<CR>", desc = "Telescope Git Files" },
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },

    { "<leader><space>", util.find_files, desc = "Find Files" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find String" },
    { "<leader>fc", util.config_files, desc = "Find Config File" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    {
      "<leader>:",
      "<cmd>Telescope command_history<cr>",
      desc = "Command History",
    },
    {
      "<leader>ss",
      "<cmd>Telescope grep_string<cr>",
      desc = "Search string under cursor",
    },

    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Buffers",
    },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    {
      "<leader>sb",
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      desc = "Buffer",
    },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    {
      "<leader>sd",
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      desc = "Document diagnostics",
    },
    {
      "<leader>sD",
      "<cmd>Telescope diagnostics<cr>",
      desc = "Workspace diagnostics",
    },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
    {
      "<leader>cs",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = {
            "Class",
            "Function",
            "Interface",
            "Method",
            "Struct",
            "Trait",
          },
        })
      end,
      desc = "Goto Symbol",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        path_display = { "filename_first", "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
          },
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
