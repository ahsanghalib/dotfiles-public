return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      require("transparent").setup(opts)
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true },
        mason = true,
        native_lsp = { enabled = true },
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        trouble = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   lazy = false,
  --   config = function(_, opts)
  --     require("tokyonight").setup(opts)
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   priority = 1000,
  --   lazy = false,
  --   config = function(_, opts)
  --     require("kanagawa").setup(opts)
  --     vim.cmd.colorscheme("kanagawa")
  --   end,
  -- },
  -- {
  --   "dgox16/oldworld.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function(_, opts)
  --     require("oldworld").setup(opts)
  --     vim.cmd.colorscheme("oldworld")
  --   end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local lazy_status = require("lazy.status")

      local function macro_recording()
        local register = vim.fn.reg_recording()
        return register == "" and "" or "Recording @" .. register
      end

      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        callback = function()
          require("lualine").refresh()
        end,
      })

      return {
        options = {
          -- component_separators = { left = "│", right = "│" },
          globalstatus = true,
          -- section_separators = { left = "", right = "" },
          theme = "tomorrow_night",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              },
            },
          },
          lualine_x = {
            {
              lazy_status.updates,
              color = { fg = "#ff9e64" },
              cond = lazy_status.has_updates,
            },
            {
              macro_recording,
              color = { fg = "#ff9e64" },
            },
            {
              function()
                local ok, opencode = pcall(require, "opencode")
                return ok and opencode.statusline() or ""
              end,
              cond = function()
                return package.loaded.opencode ~= nil
              end,
            },
            "diagnostics",
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 400,
      preset = "modern",
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>ac", group = "Codex" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code/quickfix" },
        { "<leader>e", group = "Explorer" },
        { "<leader>f", group = "Find/files" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunks/Harpoon" },
        { "<leader>l", group = "Language" },
        { "<leader>r", group = "Refactor" },
        { "<leader>t", group = "Tabs/terminal" },
        { "<leader>ts", group = "TypeScript" },
        { "<leader>u", group = "UI/toggles" },
        { "<leader>w", group = "Windows/workspace" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer diagnostics",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer diagnostics",
      },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      {
        "<leader>xL",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP list",
      },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "trouble",
        },
      },
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = {
        enabled = true,
        actions = {
          opencode_send = function(picker)
            local items = vim.tbl_map(function(item)
              return item.file
                  and require("opencode").format({
                    path = item.file,
                    from = item.pos,
                    to = item.end_pos,
                  })
                or item.text
            end, picker:selected({ fallback = true }))
            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart file search",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command history",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification history",
      },
      {
        "<leader>E",
        function()
          Snacks.explorer()
        end,
        desc = "Snacks explorer",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Open git remote",
      },
      {
        "<leader>gL",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git blame line",
      },
      {
        "<leader>rf",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename file",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select scratch buffer",
      },
    },
  },
  {
    "3rd/time-tracker.nvim",
    event = "VeryLazy",
    dependencies = { "3rd/sqlite.nvim" },
    opts = { data_file = vim.fn.expand("~/time-tracker.db") },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
