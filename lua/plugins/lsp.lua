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
      -- Exec Path: nvim
      -- Exec Flags(windows): --server "\\\\.\\pipe\\godot.pipe" --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"
      -- Exec Flags(linux): --server "/tmp/godot.pipe" --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"
      lsp_zero.configure("gdscript", gdscript_config)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      require("mason-lspconfig").setup_handlers({
        function(server_name, _)
          require("lspconfig")[server_name].setup({})
        end,

        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,

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
          require("lspconfig").eslint.setup({})
        end,

        ts_ls = function()
          local mason_registry = require("mason-registry")
          local vue_language_server_path = mason_registry
            .get_package("vue-language-server")
            :get_install_path() .. "/node_modules/@vue/language-server"

          require("lspconfig").ts_ls.setup({
            init_options = {
              plugins = {
                {
                  -- Vue
                  -- NOTE: location can be global or nothing if it points to the
                  -- local node_modules of the project
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
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
