return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = vim.fn.executable("make") == 1 and "make install_jsregexp" or nil,
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "dchinmay2/clangd_extensions.nvim",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({
        delete_check_events = "TextChanged",
        history = true,
      })

      local function has_words_before()
        local line, column = unpack(vim.api.nvim_win_get_cursor(0))
        if column == 0 then
          return false
        end
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return text:sub(column, column):match("%s") == nil
      end

      local function next_item(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local function previous_item(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        experimental = { ghost_text = true },
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 60,
            menu = {
              buffer = "[Buffer]",
              luasnip = "[Snippet]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
            },
            mode = "symbol_text",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<C-j>"] = cmp.mapping(next_item, { "i", "s" }),
          ["<C-k>"] = cmp.mapping(previous_item, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(next_item, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(previous_item, { "i", "s" }),
        }),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.exact,
            compare.kind,
            compare.length,
            compare.offset,
            compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            compare.score,
            compare.sort_text,
            compare.order,
          },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", group_index = 1 },
          { name = "codeium", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
        }, {
          { name = "buffer", group_index = 2, keyword_length = 3 },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, {
          { name = "cmdline" },
        }),
      })

      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          java = false,
          javascript = { "template_string" },
          lua = { "string" },
        },
      })
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
