local parsers = {
  "astro",
  "bash",
  "blade",
  "c",
  "c_sharp",
  "cpp",
  "css",
  "dart",
  "diff",
  "dockerfile",
  "eex",
  "elixir",
  "erlang",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "graphql",
  "hcl",
  "heex",
  "html",
  "hyprlang",
  "java",
  "javascript",
  "json",
  "json5",
  "kotlin",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "ocaml",
  "ocaml_interface",
  "php",
  "prisma",
  "python",
  "query",
  "razor",
  "regex",
  "rust",
  "scss",
  "sql",
  "svelte",
  "templ",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = vim.env.NVIM_SKIP_TOOL_INSTALL ~= "1" and ":TSUpdate" or nil,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      local function as_set(items)
        local result = {}
        for _, item in ipairs(items) do
          result[item] = true
        end
        return result
      end

      require("ts_context_commentstring").setup({ enable_autocmd = false })
      vim.treesitter.language.register("json", "jsonc")

      local available = as_set(treesitter.get_available())
      local installed = as_set(treesitter.get_installed("parsers"))
      local pending = {}

      local function parser_for_buffer(buffer)
        local filetype = vim.bo[buffer].filetype
        if filetype == "" then
          return
        end
        return vim.treesitter.language.get_lang(filetype) or filetype
      end

      local function start_parser(buffer, language)
        if not vim.api.nvim_buf_is_valid(buffer) or vim.b[buffer].bigfile then
          return
        end

        local ok = pcall(vim.treesitter.start, buffer, language)
        if ok then
          vim.bo[buffer].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local function start_installed_parsers()
        installed = as_set(treesitter.get_installed("parsers"))
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buffer) then
            local language = parser_for_buffer(buffer)
            if language and installed[language] then
              start_parser(buffer, language)
            end
          end
        end
      end

      local function install_languages(languages)
        if vim.env.NVIM_SKIP_TOOL_INSTALL == "1" or #languages == 0 then
          return
        end

        for _, language in ipairs(languages) do
          pending[language] = true
        end

        treesitter.install(languages):await(function(error_message, success)
          vim.schedule(function()
            for _, language in ipairs(languages) do
              pending[language] = nil
            end

            if error_message or not success then
              vim.notify(
                "Tree-sitter parser installation failed: "
                  .. tostring(error_message or "unknown error"),
                vim.log.levels.WARN
              )
              return
            end

            start_installed_parsers()
          end)
        end)
      end

      local missing = vim.tbl_filter(function(language)
        return available[language] and not installed[language]
      end, parsers)
      install_languages(missing)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
        callback = function(event)
          if vim.b[event.buf].bigfile then
            return
          end

          local language = parser_for_buffer(event.buf)
          if not language or not available[language] then
            return
          end

          if installed[language] then
            start_parser(event.buf, language)
          elseif not pending[language] then
            install_languages({ language })
          end
        end,
      })

      vim.keymap.set("n", "gnn", function()
        vim.treesitter.select("parent")
      end, { desc = "Start Tree-sitter selection" })
      vim.keymap.set("x", "grn", function()
        vim.treesitter.select("parent")
      end, { desc = "Expand Tree-sitter selection" })
      vim.keymap.set("x", "grm", function()
        vim.treesitter.select("child")
      end, { desc = "Shrink Tree-sitter selection" })
      vim.keymap.set("x", "grc", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end, { desc = "Select Tree-sitter scope" })

      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
        select = {
          include_surrounding_whitespace = false,
          lookahead = true,
          selection_modes = {
            ["@class.outer"] = "V",
            ["@function.outer"] = "V",
            ["@parameter.outer"] = "v",
          },
        },
      })

      local function select_textobject(capture)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
        end
      end

      vim.keymap.set({ "x", "o" }, "aa", select_textobject("@parameter.outer"), {
        desc = "Around parameter",
      })
      vim.keymap.set({ "x", "o" }, "ia", select_textobject("@parameter.inner"), {
        desc = "Inside parameter",
      })
      vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"), {
        desc = "Around function",
      })
      vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"), {
        desc = "Inside function",
      })
      vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"), {
        desc = "Around class",
      })
      vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"), {
        desc = "Inside class",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      line_numbers = true,
      max_lines = 3,
      mode = "cursor",
      multiline_threshold = 20,
      multiwindow = false,
      trim_scope = "outer",
      zindex = 20,
    },
  },
}
