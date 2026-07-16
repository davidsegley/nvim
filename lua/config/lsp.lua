vim.lsp.config("*", {
  offsetEncoding = { "utf-16" },
  general = {
    positionEncodings = { "utf-16" },
  },
})

-- Put this flags in godot
-- Use External Editor: On
-- Exec Path: full_path_to_nvim
-- Exec Flags(windows): --server "\\\\.\\pipe\\godot.pipe" --remote-send "<cmd>:n {file}<cr>:call cursor({line},{col})<cr>"
-- Exec Flags(linux): --server "/tmp/godot.pipe" --remote-send "<cmd>:n {file}<cr>:call cursor({line},{col})<cr>"

vim.lsp.config("gdscript", {
  on_attach = function()
    local pipe = [[\\.\pipe\godot.pipe]]
    if vim.fn.has("win32") == 0 then
      pipe = "/tmp/godot.pipe"
    end

    local success =
        pcall(vim.api.nvim_command, [[echo serverstart(']] .. pipe .. [[')]])

    if success then
      print("Godot Language Server Connected")
    end
  end,
})

vim.lsp.config("ruff", {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
        },
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location =
            "/home/starb/.local/share/nvm/v22.17.1/lib/node_modules/@vue/typescript-plugin",
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
})

vim.lsp.config("vue_ls", {
  on_init = function(client)
    client.handlers["tsserver/request"] = function(_, result, context)
      local clients =
          vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
      if #clients == 0 then
        vim.notify(
          "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
          vim.log.levels.ERROR
        )
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = "typescript.tsserverRequest",
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r.body } }
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify("tsserver/response", response_data)
      end)
    end
  end,
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "-j",
    "8",
  },
})

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "clangd",
  "eslint",
  "vtsls",
  "vue_ls",
  "basedpyright",
  "ruff",
  "bashls",
  "gdscript",
  "gn_language_server",
})

local function setup_client(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)

  if client == nil then
    return
  end

  vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })

  local no_formatting = { "vtsls", "vue_ls" }
  if no_formatting[client.name] ~= nil then
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

  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(
      true,
      client.id,
      args.buf,
      { autotrigger = false }
    )
  end


  if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
      buffer = args.buf,
      callback = function()
        if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
          return
        end

        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
      end,
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
  vim.keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({ 'n', 'x' }, '<leader>cf',
    '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca',
    '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  --stylua: ignore end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    setup_client(args)
    setup_keymaps(args)
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disabe autoformat on save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat on save",
})
