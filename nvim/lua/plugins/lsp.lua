return {
  {
    "dchinmay2/clangd_extensions.nvim",
    lazy = false,
    opts = {
      ast = {
        role_icons = {
          type = "T",
          declaration = "D",
          expression = "E",
          specifier = "S",
          statement = ";",
          ["template argument"] = "T",
        },
        kind_icons = {
          Compound = "C",
          Recovery = "R",
          TranslationUnit = "U",
          PackExpansion = "P",
          TemplateTypeParm = "T",
          TemplateTemplateParm = "T",
          TemplateParamObject = "T",
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1" and ":MasonUpdate" or nil,
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ui = { border = "rounded" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      debounce_hours = 168,
      ensure_installed = require("config.tooling").mason_packages,
      run_on_start = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1",
      start_delay = 1000,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
      "mason-org/mason-lspconfig.nvim",
      "mason-org/mason.nvim",
    },
    config = function()
      local border = "rounded"

      local hover_handler = vim.lsp.handlers.hover
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", {
          border = border,
          silent = true,
        }, config or {})
        return hover_handler(err, result, ctx, config)
      end

      local signature_handler = vim.lsp.handlers.signature_help
      vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", {
          border = border,
          silent = true,
        }, config or {})
        return signature_handler(err, result, ctx, config)
      end

      vim.diagnostic.config({
        float = {
          border = border,
          header = "",
          prefix = "",
          source = "if_many",
        },
        severity_sort = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = { prefix = "●", source = "if_many", spacing = 2 },
      })

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local function configure(name, settings)
        settings = settings or {}
        settings.capabilities =
          vim.tbl_deep_extend("force", {}, capabilities, settings.capabilities or {})
        vim.lsp.config(name, settings)
      end

      local eslint_config_files = {
        ".eslintrc",
        ".eslintrc.cjs",
        ".eslintrc.js",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        "eslint.config.cjs",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.ts",
      }

      local function eslint_root_dir(buffer, on_dir)
        local filename = vim.api.nvim_buf_get_name(buffer)
        local start = vim.fs.dirname(filename)
        if not start then
          return
        end

        local config_file = vim.fs.find(eslint_config_files, {
          path = start,
          upward = true,
        })[1]
        if config_file then
          on_dir(vim.fs.dirname(config_file))
          return
        end

        local git_root = vim.fs.root(start, ".git")
        local package_files = vim.fs.find("package.json", {
          limit = 20,
          path = start,
          upward = true,
        })
        for _, package_file in ipairs(package_files) do
          if not git_root or vim.startswith(package_file, git_root) then
            local ok_read, lines = pcall(vim.fn.readfile, package_file)
            if ok_read then
              local ok_json, package = pcall(vim.json.decode, table.concat(lines, "\n"))
              if ok_json and package and package.eslintConfig then
                on_dir(vim.fs.dirname(package_file))
                return
              end
            end
          end
        end
      end

      local php_include_paths = vim.tbl_filter(function(path)
        return vim.uv.fs_stat(path) ~= nil
      end, { "/usr/lib/php", "/usr/local/lib/php" })
      local typescript = require("config.typescript")

      local servers = {
        astro = {
          before_init = function(_, config)
            local tsdk = typescript.sdk_path(config.root_dir)
            if not tsdk then
              return
            end

            config.init_options = config.init_options or {}
            config.init_options.typescript = config.init_options.typescript or {}
            config.init_options.typescript.tsdk = tsdk
          end,
        },
        bashls = {},
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                inlayHints = {
                  callArgumentNames = true,
                  functionReturnTypes = true,
                  genericTypes = false,
                  variableTypes = true,
                },
              },
              disableOrganizeImports = true,
            },
          },
        },
        bicep = {},
        bright_script = {},
        clangd = {
          capabilities = { offsetEncoding = { "utf-16" } },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--fallback-style=llvm",
            "--function-arg-placeholders",
            "--header-insertion=iwyu",
          },
          init_options = {
            clangdFileStatus = true,
            completeUnimported = true,
            usePlaceholders = true,
          },
        },
        cssls = {},
        denols = {},
        docker_compose_language_service = {},
        dockerls = {},
        emmet_language_server = {
          init_options = {
            html = { options = { ["bem.enabled"] = true } },
          },
        },
        elp = {},
        eslint = {
          root_dir = eslint_root_dir,
          settings = { workingDirectory = { mode = "auto" } },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, unusedwrite = true },
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },
        graphql = {},
        html = {
          filetypes = { "html", "blade" },
          init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = { css = true, javascript = true },
            provideFormatter = false,
          },
        },
        intelephense = {
          filetypes = { "php", "blade" },
          settings = {
            intelephense = {
              completion = {
                fullyQualifyGlobalConstantsAndFunctions = true,
                insertUseDeclaration = true,
                maxItems = 100,
                triggerParameterHints = true,
              },
              environment = { includePaths = php_include_paths },
              files = {
                associations = { "*.php", "*.blade.php" },
                maxSize = 5000000,
              },
              telemetry = { enabled = false },
            },
          },
        },
        jsonls = {},
        kotlin_lsp = {},
        lemminx = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "Snacks", "vim" } },
              hint = { enable = true },
              runtime = { version = "LuaJIT" },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
        marksman = {},
        ocamllsp = {},
        prismals = {},
        ruff = {
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
        sqruff = {},
        rust_analyzer = {},
        svelte = {},
        tailwindcss = {
          filetypes = {
            "astro",
            "blade",
            "html",
            "javascript",
            "javascriptreact",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
          },
        },
        taplo = {},
        templ = {},
        terraformls = {},
        tsc_native = {
          cmd = typescript.native_cmd,
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = typescript.native_root,
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        volar = {},
        yamlls = {},
        zls = {},
      }

      local server_names = vim.tbl_keys(servers)
      table.sort(server_names)
      for _, name in ipairs(server_names) do
        configure(name, servers[name])
        vim.lsp.enable(name)
      end

      if vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1" then
        require("mason-lspconfig").setup({
          automatic_enable = {
            exclude = require("config.tooling").lsp_auto_enable_exclusions,
          },
        })
      end

      local highlight_group = vim.api.nvim_create_augroup("dotfiles_lsp_highlight", {
        clear = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
        callback = function(event)
          local function map(keys, action, description)
            vim.keymap.set("n", keys, action, {
              buffer = event.buf,
              desc = "LSP: " .. description,
            })
          end

          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local function lsp_telescope(name)
            return function()
              require("telescope.builtin")[name]({
                file_ignore_patterns = {},
              })
            end
          end

          map("gd", lsp_telescope("lsp_definitions"), "Definition")
          map("gr", lsp_telescope("lsp_references"), "References")
          map("gI", lsp_telescope("lsp_implementations"), "Implementation")
          map("<leader>D", lsp_telescope("lsp_type_definitions"), "Type definition")
          map("<leader>ds", function()
            require("telescope.builtin").lsp_document_symbols()
          end, "Document symbols")
          map("<leader>ws", function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
          end, "Workspace symbols")
          map("gD", vim.lsp.buf.declaration, "Declaration")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", function()
            require("actions-preview").code_actions()
          end, "Code action")
          map("gK", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>uh", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
          end, "Toggle inlay hints")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          if client.name == "gopls" then
            map("<leader>ly", "<cmd>GoModTidy<cr>", "Go mod tidy")
            map("<leader>lc", "<cmd>GoCoverage<cr>", "Go test coverage")
            map("<leader>lt", "<cmd>GoTest<cr>", "Go test")
            map("<leader>lR", "<cmd>GoRun<cr>", "Go run")
          end

          if client:supports_method("textDocument/documentHighlight", event.buf) then
            vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("dotfiles_lsp_detach", { clear = true }),
        callback = function(event)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
              return
            end

            local clients = vim.lsp.get_clients({
              bufnr = event.buf,
              method = "textDocument/documentHighlight",
            })
            if #clients == 0 then
              vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
              pcall(vim.lsp.buf.clear_references)
            end
          end)
        end,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>tso",
        function()
          require("config.typescript").code_action("TSToolsOrganizeImports", {
            "source.organizeImports.ts",
            "source.organizeImports",
          })
        end,
        desc = "TS organize imports",
      },
      {
        "<leader>tss",
        function()
          require("config.typescript").code_action("TSToolsSortImports", {
            "source.sortImports.ts",
            "source.sortImports",
          })
        end,
        desc = "TS sort imports",
      },
      {
        "<leader>tsf",
        function()
          require("config.typescript").code_action("TSToolsFixAll", {
            "source.fixAll.ts",
            "source.fixAll",
          })
        end,
        desc = "TS fix all",
      },
      {
        "<leader>tsr",
        function()
          require("config.typescript").rename_file()
        end,
        desc = "TS rename file",
      },
    },
    config = function()
      require("typescript-tools").setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        root_dir = require("config.typescript").legacy_root,
        settings = {
          complete_function_calls = true,
          expose_as_code_action = "all",
          publish_diagnostic_on = "insert_leave",
          separate_diagnostic_server = false,
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "project-relative",
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "literals",
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = false,
          },
        },
      })
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      backend = { "telescope", "nui" },
      telescope = {
        layout_config = {
          height = 0.9,
          preview_cutoff = 20,
          prompt_position = "top",
          width = 0.8,
        },
        layout_strategy = "vertical",
        sorting_strategy = "ascending",
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    dependencies = { "antoinemadec/FixCursorHold.nvim" },
    opts = {
      autocmd = { enabled = true },
      sign = { enabled = true, priority = 10 },
      virtual_text = { enabled = true, pos = "eol", text = "💡" },
    },
  },
  { "j-hui/fidget.nvim", opts = {} },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer or selection",
      },
      {
        "<leader>mp",
        function()
          require("conform").format({ async = false, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer or selection",
      },
      {
        "<leader>uf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = function()
      local prettier = { "prettierd", "prettier", stop_after_first = true }
      local function javascript_formatter(buffer)
        local filename = vim.api.nvim_buf_get_name(buffer)
        if filename ~= "" and vim.fs.root(filename, { "deno.json", "deno.jsonc", "deno.lock" }) then
          return { "deno_fmt" }
        end
        return prettier
      end

      return {
        default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
        format_on_save = function()
          if vim.g.disable_autoformat or vim.b.disable_autoformat then
            return
          end
          return { lsp_format = "fallback", timeout_ms = 3000 }
        end,
        formatters_by_ft = {
          astro = prettier,
          bash = { "shfmt" },
          blade = { "blade-formatter" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          cs = { "csharpier" },
          css = prettier,
          cuda = { "clang_format" },
          dart = { "dart_format" },
          eelixir = { "mix" },
          elixir = { "mix" },
          erlang = { "erlfmt" },
          go = { "goimports", "gofumpt" },
          graphql = prettier,
          hcl = { "terraform_fmt" },
          heex = { "mix" },
          html = prettier,
          java = { "google-java-format" },
          javascript = javascript_formatter,
          javascriptreact = javascript_formatter,
          json = prettier,
          jsonc = prettier,
          kotlin = { "ktlint" },
          lua = { "stylua" },
          markdown = prettier,
          ["markdown.mdx"] = prettier,
          ml = { "ocamlformat" },
          mli = { "ocamlformat" },
          objc = { "clang_format" },
          objcpp = { "clang_format" },
          ocaml = { "ocamlformat" },
          opam = { "ocamlformat" },
          php = { "php_cs_fixer" },
          python = function(buffer)
            local conform = require("conform")
            if conform.get_formatter_info("ruff_format", buffer).available then
              return { "ruff_organize_imports", "ruff_format" }
            end
            return { "isort", "black" }
          end,
          rust = { "rustfmt", lsp_format = "fallback" },
          scss = prettier,
          sql = { "sqruff" },
          svelte = prettier,
          terraform = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          toml = { "taplo" },
          typescript = javascript_formatter,
          typescriptreact = javascript_formatter,
          vue = prettier,
          xml = { "xmlformatter" },
          yaml = prettier,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>cl",
        "<cmd>Lint<cr>",
        desc = "Lint current buffer",
      },
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        go = { "golangcilint" },
        kotlin = { "ktlint" },
        lua = { "luacheck" },
        markdown = { "markdownlint-cli2" },
        ["markdown.mdx"] = { "markdownlint-cli2" },
        php = { "phpstan" },
        sh = { "shellcheck" },
        terraform = { "tflint" },
        ["terraform-vars"] = { "tflint" },
        yaml = { "yamllint" },
        ["yaml.ghaction"] = { "actionlint", "yamllint" },
      }

      local function resolve_linter(name)
        local linter = lint.linters[name]
        if type(linter) == "function" then
          local ok, result = pcall(linter)
          linter = ok and result or nil
        end
        if not linter then
          return
        end

        local command = linter.cmd
        if type(command) == "function" then
          local ok, result = pcall(command)
          command = ok and result or nil
        end
        if type(command) == "table" then
          command = command[1]
        end
        return type(command) == "string" and command or nil
      end

      local function configured_linters()
        local filetype = vim.bo.filetype
        local names = lint.linters_by_ft[filetype]
        if not names then
          names = lint.linters_by_ft[filetype:match("^[^.]+") or filetype]
        end
        return names or {}
      end

      local function lint_if_available()
        local available = vim.tbl_filter(function(name)
          local command = resolve_linter(name)
          return command and vim.fn.executable(command) == 1
        end, configured_linters())

        if #available > 0 then
          lint.try_lint(available)
        end
      end

      vim.api.nvim_create_user_command("Lint", lint_if_available, {
        desc = "Lint the current buffer with available configured linters",
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("dotfiles_lint", { clear = true }),
        callback = lint_if_available,
      })
    end,
  },
}
