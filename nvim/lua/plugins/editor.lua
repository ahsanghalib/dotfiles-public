return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume search" },
      { "<leader>fs", "<cmd>Telescope builtin<cr>", desc = "Telescope pickers" },
      { "<leader>f.", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fD", "<cmd>Telescope docker<cr>", desc = "Docker resources" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", desc = "File commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({
              previewer = false,
              winblend = 10,
            })
          )
        end,
        desc = "Search current buffer",
      },
      {
        "<leader>f/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live grep in open files",
          })
        end,
        desc = "Search open files",
      },
      {
        "<leader>fn",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Neovim config files",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "lpoto/telescope-docker.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "%.git/",
            "%.next/",
            "build/",
            "dist/",
            "node_modules/",
            "__virtual%.cs$",
          },
          layout_config = { prompt_position = "top" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
          },
          -- path_display = { "smart" },
          prompt_prefix = "   ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown(),
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "docker")
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = "VeryLazy",
    keys = {
      {
        "<leader>fc",
        function()
          require("telescope").extensions.neoclip.default()
        end,
        desc = "Clipboard history",
      },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("neoclip").setup({ history = 1000 })
      require("telescope").load_extension("neoclip")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeCollapse",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
      "NvimTreeToggle",
    },
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer at current file" },
      { "<leader>ec", "<cmd>NvimTreeCollapse<cr>", desc = "Collapse file explorer" },
      { "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh file explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = { enable = false },
        },
      },
      disable_netrw = true,
      filesystem_watchers = { enable = true },
      filters = { custom = { ".DS_Store" } },
      git = { ignore = false },
      hijack_cursor = true,
      hijack_netrw = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = {
        adaptive_size = false,
        preserve_window_proportions = true,
        side = "left",
        width = 30,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>fo", "<cmd>Oil<cr>", desc = "Open Oil" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      columns = { "icon" },
      delete_to_trash = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-s>"] = false,
      },
      lsp_file_methods = {
        autosave_changes = true,
        enabled = true,
        timeout_ms = 1000,
      },
      skip_confirm_for_simple_edits = false,
      view_options = { show_hidden = true },
      win_options = {
        winbar = "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = function()
      return {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  { "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "MattesGroeger/vim-bookmarks",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "dyng/ctrlsf.vim",
    cmd = { "CtrlSF", "CtrlSFClose", "CtrlSFOpen", "CtrlSFToggle", "CtrlSFUpdate" },
  },
  {
    "miyakogi/conoline.vim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = false },
      select = {
        backend = { "telescope", "builtin" },
        enabled = true,
      },
    },
  },
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewDisable", "CsvViewEnable", "CsvViewToggle" },
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
      },
    },
  },
  {
    "jiaoshijie/undotree",
    keys = {
      {
        "<leader>uu",
        function()
          require("undotree").toggle()
        end,
        desc = "Toggle undo tree",
      },
      {
        "<leader>uo",
        function()
          require("undotree").open()
        end,
        desc = "Open undo tree",
      },
      {
        "<leader>uc",
        function()
          require("undotree").close()
        end,
        desc = "Close undo tree",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  { "kevinhwang91/nvim-bqf", ft = "qf", opts = {} },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
      {
        "zK",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Preview folded lines",
      },
    },
    opts = function()
      local function fold_text(virtual_text, line_number, end_line, width, truncate)
        local result = {}
        local suffix = (" 󰁂 %d "):format(end_line - line_number)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width
        local current_width = 0

        for _, chunk in ipairs(virtual_text) do
          local text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(text)
          if current_width + chunk_width < target_width then
            result[#result + 1] = chunk
          else
            text = truncate(text, target_width - current_width)
            result[#result + 1] = { text, chunk[2] }
            chunk_width = vim.fn.strdisplaywidth(text)
            if current_width + chunk_width < target_width then
              suffix = suffix .. (" "):rep(target_width - current_width - chunk_width)
            end
            break
          end
          current_width = current_width + chunk_width
        end

        result[#result + 1] = { suffix, "MoreMsg" }
        return result
      end

      return {
        close_fold_kinds_for_ft = { default = { "imports", "comment" } },
        enable_get_fold_virt_text = true,
        fold_virt_text_handler = fold_text,
        open_fold_hl_timeout = 150,
        preview = {
          mappings = {
            jumpBot = "]",
            jumpTop = "[",
            scrollD = "<C-d>",
            scrollU = "<C-u>",
          },
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winblend = 0,
            winhighlight = "Normal:Folded",
          },
        },
        provider_selector = function(_, filetype)
          local overrides = {
            git = "",
            python = { "indent" },
            vim = "indent",
          }
          return overrides[filetype] or { "lsp", "indent" }
        end,
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx" },
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    opts = {
      -- require("render-markdown").setup({
      -- completions = { lsp = { enabled = true } },
      -- }),
    },
  },
}
