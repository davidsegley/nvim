return {
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    cmd = { "LspInfo", "LspInstall", "LspStart", "Mason" },
    event = { "BufReadPre", "BufNewFile" },
    branch = "v4.x",
    config = function()
      local lsp_zero = require("lsp-zero")

      local lsp_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
          --stylua: ignore start
          vim.keymap.set('n', 'K', function ()
            vim.lsp.buf.hover({
              border = "single"
            })
          end, opts)

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
      require("mason").setup({})

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" },
        general = {
          positionEncodings = { "utf-16" },
        },
      })

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = capabilities,
      })

      lsp_zero.ui({
        sign_text = {
          error = "✘",
          warn = " ",
          hint = "⚑",
          info = "»",
        },
      })

      local gdscript_config = {
        on_attach = function()
          local pipe = [[\\.\pipe\godot.pipe]]
          if vim.fn.has("win32") == 0 then
            pipe = "/tmp/godot.pipe"
          end

          local success = pcall(
            vim.api.nvim_command,
            [[echo serverstart(']] .. pipe .. [[')]]
          )

          if success then
            print("Godot Language Server Connected")
          end
        end,
      }

      if vim.fn.has("win32") == 1 then
        gdscript_config.cmd = { "ncat", "localhost", "6005" }
        gdscript_config.root_dir = function()
          return vim.fs.dirname(
            vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]
          )
        end
      end

      -- Put this flags in godot
      -- Use External Editor: On
      -- Exec Path: full_path_to_nvim
      -- Exec Flags(windows): --server "\\\\.\\pipe\\godot.pipe" --remote-send "<cmd>:n {file}<cr>:call cursor({line},{col})<cr>"
      -- Exec Flags(linux): --server "/tmp/godot.pipe" --remote-send "<cmd>:n {file}<cr>:call cursor({line},{col})<cr>"

      lsp_zero.configure("gdscript", gdscript_config)

      local lua_opts = lsp_zero.nvim_lua_ls()
      vim.lsp.config("lua_ls", lua_opts)

      vim.lsp.config("ts_ls", {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
              languages = { "javascript", "typescript", "vue" },
            },
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      })

      vim.lsp.config("volar", {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
      })

      vim.lsp.config("eslint", {})

      vim.lsp.config("clangd", {
        on_attach = function(_, bufnr)
          vim.keymap.set(
            "n",
            "<leader>t",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            {
              noremap = true,
              silent = true,
              buffer = bufnr,
              desc = "Toggle Header/Source",
            }
          )
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

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_enable = true,
      })
    end,
  },
}
