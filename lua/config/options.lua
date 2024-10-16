vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.editorconfig = true

-- Netrw
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

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
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

local opt = vim.opt

opt.mouse = "a" -- enable mouse
opt.termguicolors = true -- True color support
opt.confirm = true -- Confirm to save changes before exiting modified buffer

opt.number = true
opt.relativenumber = true -- Relative line numbers
opt.wrap = false -- Disable line wrap

-- ripgrep
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

opt.list = true -- Show some invisible characters
opt.cursorline = true -- Highlight of the current line

opt.sidescroll = 4
opt.sidescrolloff = 8 -- Columns of context
opt.splitright = true -- Put new windows right of current
opt.splitbelow = true -- Put new windows below current

opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftround = true -- Round indent
opt.autoindent = true
opt.smartindent = true

opt.ignorecase = true -- Ignore case
opt.smartcase = true

opt.hlsearch = false
opt.incsearch = true -- show matching patters as you type
opt.inccommand = "nosplit" -- preview incremental substitute

opt.undofile = true

-- Disable swap file
opt.swapfile = false
opt.backup = false

opt.cc = "80"
opt.signcolumn = "yes" -- always show the signcolumn

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

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldenable = false

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
