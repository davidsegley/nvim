local M = {}

function M.find_files()
  if vim.uv.fs_stat(vim.uv.cwd() .. "/.git") then
    return require("telescope.builtin").git_files({ show_untracked = true })
  end

  return require("telescope.builtin").find_files()
end

function M.config_files()
  return require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
  })
end

return M
