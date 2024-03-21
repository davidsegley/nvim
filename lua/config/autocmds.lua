local ignore_filetypes = {
  "neo-tree",
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

-- disable focus
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

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- set spell of in toggleterm
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_no_spell"),
  pattern = "term://*toggleterm*",
  command = "setlocal nospell",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})
