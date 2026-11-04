return {
  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
      "JavaHello/spring-boot.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local sdkman_jdk = vim.fn.expand("~/.sdkman/candidates/java/current")
      local has_sdkman_jdk = vim.uv.fs_stat(vim.fs.joinpath(sdkman_jdk, "bin", "java")) ~= nil

      require("java").setup({
        jdk = has_sdkman_jdk and {
          auto_install = false,
          path = sdkman_jdk,
        } or {
          auto_install = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1",
          version = "17",
        },
      })

      vim.lsp.config("jdtls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("jdtls")
    end,
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "ray-x/guihua.lua",
    },
    build = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1"
        and vim.fn.executable("go") == 1
        and ':lua require("go.install").update_all_sync()'
      or nil,
    opts = {
      lsp_cfg = false,
    },
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      {
        "<leader>dT",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Go test",
      },
    },
    opts = {},
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    ft = { "eelixir", "elixir", "heex" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        credo = {},
        nextls = { enable = false },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = true,
            enableTestLenses = false,
            fetchDeps = true,
            suggestSpecs = true,
          }),
        },
      })
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "RobertBrunhage/flutter-riverpod-snippets",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      debugger = { enabled = false, run_via_dap = false },
      decorations = {
        statusline = { app_version = true, device = true },
      },
      dev_log = { enabled = true, open_cmd = "tabedit" },
      lsp = {
        color = { background = true, enabled = true, virtual_text = false },
        settings = {
          completeFunctionCalls = true,
          lineLength = 100,
          renameFilesWithClasses = "always",
          showTodos = false,
          updateImportsOnRename = true,
        },
      },
      outline = { auto_open = false },
      widget_guides = { enabled = true },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason-org/mason.nvim",
    },
    init = function()
      vim.lsp.config("roslyn", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
          },
        },
      })
    end,
    opts = { broad_search = true },
  },
}
