return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "saghen/blink.cmp",
    },
    cmd = { "LspInfo", "LspInstall", "LspStart", "Mason" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason").setup({})

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities = vim.tbl_deep_extend("force", capabilities, {
        require("blink.cmp").get_lsp_capabilities({}, false),
      })

      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" },
        general = {
          positionEncodings = { "utf-16" },
        },
      })

      vim.lsp.config("*", capabilities)

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

      vim.lsp.config("gdscript", gdscript_config)

      vim.lsp.config("ts_ls", {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
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
                  location = "/home/starb/.local/share/nvm/v22.17.1/lib/node_modules/@vue/typescript-plugin",
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

      vim.lsp.enable("gopls")
      vim.lsp.enable("ts_ls", false)
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("eslint")
      vim.lsp.enable("vtsls")
      vim.lsp.enable("vue_ls")
      vim.lsp.enable("basedpyright")
      vim.lsp.enable("ruff")
    end,
  },
}
