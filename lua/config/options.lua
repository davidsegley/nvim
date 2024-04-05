vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.editorconfig = true

-- Terminal
if vim.fn.has("win32") == 1 then
  vim.o.shell = "pwsh"
  vim.g.shellflag = " -NoLogo"
  vim.o.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
else
  vim.g.shellflag = ""
end

local opt = vim.opt
opt.spelllang = {
  "es_mx",
  "en_us",
}

opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

opt.winminwidth = 5 -- Minimum window width
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.breakindent = true
opt.mouse = "a"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.completeopt = "menu,menuone,noselect"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.ignorecase = true -- Ignore case
opt.smartcase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters
opt.number = true
opt.relativenumber = true -- Relative line numbers
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.termguicolors = true -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
}

-- fold
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Neovide
vim.o.guifont = "JetBrainsMono Nerd Font:h10"
