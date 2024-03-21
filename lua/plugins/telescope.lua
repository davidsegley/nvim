local util = require("util.telescope")

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
    },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  keys = {
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },

    { "<leader><space>", util.find_files, desc = "Find Files" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find String" },
    { "<leader>fc", util.config_files, desc = "Find Config File" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>ff", util.find_files, desc = "Recent" },
    {
      "<leader>uC",
      [[<cmd>lua require("telescope.builtin").colorscheme({ enable_preview = true })<cr>]],
      desc = "Colorscheme with preview",
    },
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
    {
      "<leader>fg",
      "<cmd>Telescope git_files<cr>",
      desc = "Find Files (git-files)",
    },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    {
      "<leader>sb",
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      desc = "Buffer",
    },
    {
      "<leader>sc",
      "<cmd>Telescope command_history<cr>",
      desc = "Command History",
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
    {
      "<leader>sH",
      "<cmd>Telescope highlights<cr>",
      desc = "Search Highlight Groups",
    },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
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
