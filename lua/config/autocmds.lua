local ignore_filetypes = {
  "neo-tree",
  "NvimTree",
  "dap-repl",
  "dapui-console",
  "dapui-watches",
  "dapui-stacks",
  "dapui-breakpoints",
  "dapui-scopes",
  "toggleterm",
  "help",
}

local ignore_buftypes = { "nofile", "prompt", "popup" }
local function augroup(name)
  return vim.api.nvim_create_augroup("starb_" .. name, { clear = true })
end

local g_focus_disable = augroup("focus_disable")
vim.api.nvim_create_autocmd("WinEnter", {
  group = g_focus_disable,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd("FileType", {
  group = g_focus_disable,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.focus_disable = true
    else
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check if we need to reload the file when it changed",
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_no_spell"),
  pattern = "term://*toggleterm*",
  command = "setlocal nospell",
  desc = "Set nospell in toggleterm",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Resize splits if window got resize",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
  desc = "Check for spell in text filetypes",
})

vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local max_filesize = 1 * 1024 * 1024 -- 1 MB
    local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if file_size > max_filesize then
      vim.opt_local.foldmethod = "manual"
    end
  end,
  desc = "Disable treesitter foldexpr if the file is too large",
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    vim.opt.cursorline = true
  end,
  desc = "Enable cursorline on win enter",
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.opt.cursorline = false
  end,
  desc = "Disable cursorline on win leave",
})
