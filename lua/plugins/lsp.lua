return {
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    branch = "v4.x",
    config = function()
      local lsp_zero = require("lsp-zero")

      local lsp_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
          --stylua: ignore start
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
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

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)

      lsp_zero.ui({
        float_border = "rounded",
        sign_text = {
          error = "✘",
          warn = "▲",
          hint = "⚑",
          info = "»",
        },
      })

      lsp_zero.configure("gdscript", {
        -- NOTE: This only works for windows

        -- Put this flags in godot
        -- Use External Editor: On
        -- Exec Path: nvim
        -- Exec Flags: --server "\\\\.\\pipe\\godot.pipe" --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"
        cmd = { "ncat", "localhost", "6005" },

        --cmd = vim.lsp.rpc.connect("172.19.240.1", 6005),
        root_dir = function()
          return vim.fs.dirname(
            vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]
          )
        end,
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
      })

      local nop = function() end

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        handlers = {
          function(server_name, _)
            require("lspconfig")[server_name].setup({})
          end,

          lua_ls = nop,

          ruff = function()
            require("lspconfig").ruff.setup({
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
          end,

          basedpyright = function()
            require("lspconfig").basedpyright.setup({
              settings = {
                basedpyright = {
                  analysis = {
                    typeCheckingMode = "standard",
                  },
                },
              },
            })
          end,

          eslint = function()
            require("lspconfig").eslint.setup({
              settings = {
                basedpyright = {
                  analysis = {
                    typeCheckingMode = "standard",
                  },
                },
              },
            })
          end,
        },

        ts_ls = function()
          require("lspconfig").ts_ls.setup({
            init_options = {
              plugins = {
                {
                  -- Vue
                  -- NOTE: location can be global or nothing if it points to the
                  -- local node_modules of the project
                  name = "@vue/typescript-plugin",
                  location = "",
                  languages = { "javascript", "typescript", "vue" },
                },
              },
            },
            filetypes = {
              "javascript",
              "typescript",
              "vue",
            },
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
            end,
          })
        end,
      })
    end,
  },
}
