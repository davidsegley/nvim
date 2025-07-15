local function setup_client(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)

  if client == nil then
    return
  end

  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "vtsls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "vue_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "clangd" then
    vim.keymap.set("n", "<leader>t", "<cmd>LspClangdSwitchSourceHeader<cr>", {
      noremap = true,
      silent = true,
      buffer = args.buf,
      desc = "Toggle Header/Source",
    })
  end

  if
    client:supports_method("textDocument/inlayHint")
    and client.name ~= "clangd"
  then
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
  end

  if client:supports_method("textDocument/documentHighlight") then
    local autocmd = vim.api.nvim_create_autocmd
    local augroup =
      vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

    vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })

    autocmd({ "CursorHold" }, {
      group = augroup,
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    autocmd({ "CursorMoved" }, {
      group = augroup,
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local function setup_keymaps(args)
  local opts = { noremap = true, silent = true, buffer = args.buf }

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({
      border = "single",
    })
  end, opts)

  --stylua: ignore start
  vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions reuse_win=true<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<leader>cf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
  --stylua: ignore end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    setup_client(args)
    setup_keymaps(args)
  end,
})
