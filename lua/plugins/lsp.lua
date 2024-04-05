return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local keymap = vim.keymap -- for conciseness

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "starb-lsp-attach",
          { clear = true }
        ),
        callback = function(_)
          local opts = { noremap = true, silent = true }

          -- Set keybindings
          opts.desc = "Show LSP references"
          keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          opts.desc = "Show LSP definitions"
          -- stylua: ignore
          keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, opts) -- show lsp definitions

          opts.desc = "Show LSP implementations"
          -- stylua: ignore
          keymap.set("n", "gi", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, opts) -- show lsp implementations

          opts.desc = "Show LSP type definitions"
          -- stylua: ignore
          keymap.set("n", "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, opts) -- show lsp type definitions

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

          opts.desc = "Rename"
          keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts) -- smart rename

          opts.desc = "Show buffer diagnostics"
          keymap.set(
            "n",
            "<leader>cD",
            "<cmd>Telescope diagnostics bufnr=0<CR>",
            opts
          ) -- show  diagnostics for file
        end,
      })

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      local signs =
        { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local servers = {
        html = {},
        tsserver = {
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
        },
        cssls = {},
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        lua_ls = {
          settings = { -- custom settings for lua
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                -- make language server aware of runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        },
        gdscript = {
          -- NOTE: This only works for windows
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
        },
        volar = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      }

      local ensure_installed = {
        "volar",
        "tsserver",
        "html",
        "eslint",
        "cssls",
        "lua_ls",

        "stylua", -- lua formatter

        -- debuggers
        "js-debug-adapter",
      }

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      require("mason-lspconfig").setup({
        automatic_installation = true, -- not the same as ensure_installed
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_extend(
              "force",
              {},
              vim.deepcopy(capabilities),
              server.capabilities or {}
            )
          end,
        },
      })

      for server_name, config in pairs(servers) do
        require("lspconfig")[server_name].setup(config)
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "VeryLazy",
    config = true,
  },
}
