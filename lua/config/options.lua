vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.editorconfig = true

-- Netrw
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- Terminal
if vim.fn.has("win32") == 1 then
  vim.cmd("let $LANG = 'en_US.UTF-8'", true)

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
opt.mouse = "a"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.completeopt = "menu,menuone,noselect"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.autowrite = true -- Enable auto write
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.ignorecase = true -- Ignore case
opt.smartcase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.list = true -- Show some invisible characters

opt.number = true
opt.relativenumber = true -- Relative line numbers

opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.splitright = true -- Put new windows right of current

opt.hlsearch = false

opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftround = true -- Round indent
opt.autoindent = true
opt.breakindent = true

-- Disable swap file
opt.swapfile = false
opt.backup = false

opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
opt.splitbelow = true -- Put new windows below current
opt.termguicolors = true -- True color support
opt.undofile = true
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wrap = false -- Disable line wrap
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
}

opt.cc = "80"

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

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMonoNL Nerd Font:h10"
end
