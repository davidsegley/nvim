vim.pack.add({
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/echasnovski/mini.bufremove",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.indentscope",
  "https://github.com/akinsho/toggleterm.nvim",
  "https://github.com/goolord/alpha-nvim",

  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },

  {
    src = "https://github.com/kylechui/nvim-surround",
    version = vim.version.range("4.x"),
  }
})

require("modus-themes").setup({
  line_nr_column_background = false
})

vim.cmd.colorscheme("modus_vivendi")

require("nvim-web-devicons").setup({})

require("ibl").setup({
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
})

require("mason").setup({})
require("fzf-lua").setup({
  "max-perf",
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  winopts = {
    preview = {
      layout = "vertical", -- valid options are "horizontal", "vertical", or "flex"
      vertical = "up:45%", -- set the position and size (e.g., "up:45%" or "down:60%")
    },
  },
  ui_select = {
  },
})

vim.keymap.set("n", "<leader><space>", "<cmd>FzfLua files previewer=false<cr>",
  { desc = "Find Files" })
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua git_files previewer=false<cr>",
  { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>ss", "<cmd>FzfLua grep_cword<cr>",
  { desc = "Grep Current Word" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers previewer=false<cr>",
  { desc = "Search Buffers" })
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers previewer=false<cr>",
  { desc = "Search Buffers" })
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<cr>",
  { desc = "Resume last search" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles previewer=false<cr>",
  { desc = "Search recent files" })
vim.keymap.set("n", "<leader>cs",
  "<cmd>FzfLua lsp_document_symbols previewer=false<cr>",
  { desc = "Lsp Document Symbols" })

local function find_config_files()
  return require("fzf-lua").files({
    cwd = vim.fn.stdpath("config"),
    previewer = false,
  })
end

vim.keymap.set("n", "<leader>fc", find_config_files,
  { desc = "Find Config Files" })

require('harpoon').setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
})

local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon File" })

for i = 1, 5 do
  vim.keymap.set("n", "<leader>" .. i, function()
    harpoon:list():select(i)
  end, { desc = "Harpoon to File " .. i })
end

require("nvim-autopairs").setup()
require("mini.bufremove").setup()

vim.keymap.set("n", "<leader>bd", function()
  local bd = require("mini.bufremove").delete
  if vim.bo.modified then
    local choice = vim.fn.confirm(
      ("Save changes to %q?"):format(vim.fn.bufname()),
      "&Yes\n&No\n&Cancel"
    )
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0)
  end
end, { desc = "Delete Buffer" })

require("nvim-treesitter").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "scss",
    "css",
    "vue",
    "gdscript",
    "gitcommit",
    "go",
  },
})

require("gitsigns").setup({
  signcolumn = false,
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  signs_staged = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
    map("n", "<leader>gb",
      function() gs.blame_line({ ignore_whitespace = true }) end, "Blame Line")
    map("n", "<leader>gR", "<cmd>Gitsigns refresh<CR>", "Refresh")
    map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", "Toggle Signs")
  end,
})

require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})

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

require("toggleterm").setup({
  open_mapping = "<c-\\>",
  autochdir = true,
  start_in_insert = true,
  size = function(term)
    if term.direction == "horizontal" then
      return 18
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  shell = function()
    return vim.o.shell .. vim.g.shellflag
  end,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  hidden = true,
  direction = "float",
  close_on_exit = true,
})

local function lazygit_toggle()
  local cwd = vim.uv.cwd()
  if cwd ~= nil then
    lazygit.dir = cwd
  end
  lazygit:toggle()
end

vim.keymap.set(
  "n",
  "<leader>gg",
  lazygit_toggle,
  { noremap = true, silent = true, desc = "Lazygit" }
)

local alpha = require("alpha")
local dashboard = require("alpha.themes.startify")
local logo = [[
  ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
  ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
  ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
  ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
  ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
  ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
  ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
  ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
  ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
  ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
  ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
  ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
  ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
  ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
]]

dashboard.section.header.val = vim.split(logo, "\n")
alpha.setup(dashboard.opts)
