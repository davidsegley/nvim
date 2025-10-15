--stylua: ignore start
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<cr>", { desc = "Delete other buffers" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-command-line-history
vim.keymap.set("c", "<C-n>", function () return vim.fn.wildmenumode() == 1 and "C-n" or "<Down>" end, { expr = true, noremap = true })
vim.keymap.set("c", "<C-p>", function () return vim.fn.wildmenumode() == 1 and "C-p" or "<Up>" end, { expr = true, noremap = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
-- vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
-- vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
-- vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "LSP Info" })

-- diagnostic
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Explorer
vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open Explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Vexplore<cr>", { desc = "Open Explorer (split)" })

-- tabs
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabNext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
vim.keymap.set("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]], { desc = "Append to System Clipboard" })
vim.keymap.set("n", "<leader>p", [["+p]], { desc = "Paste from System Clipboard" })

--stylua: ignore end
