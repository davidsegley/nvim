local function augroup(name)
  return vim.api.nvim_create_augroup("starb_" .. name, { clear = true })
end

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
  pattern = { "qf", "term://*toggleterm*" },
  callback = function()
    vim.opt_local.spell = false
  end,
  desc = "Disable spell for some files",
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

local ignore_buftypes = { "nofile", "prompt", "popup" }
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#smarter-cursorline
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "dashboard" then
      return
    end

    if not vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.opt.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.opt.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gn",
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
  desc = "Enable treesitter on GN files"
})
