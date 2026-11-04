return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      current_line_blame_opts = {
        delay = 1000,
        ignore_whitespace = false,
        virt_text = true,
        virt_text_pos = "eol",
      },
      max_file_length = 40000,
      numhl = true,
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, description)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = buffer,
            desc = "Git: " .. description,
          })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected hunk")
        map("n", "<leader>hP", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff file")
      end,
      preview_config = {
        border = "single",
        col = 1,
        relative = "cursor",
        row = 0,
        style = "minimal",
      },
      sign_priority = 6,
      signcolumn = true,
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        changedelete = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        untracked = { text = "┆" },
      },
      update_debounce = 100,
      watch_gitdir = { follow_files = true, interval = 1000 },
      word_diff = false,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewClose", "DiffviewFileHistory", "DiffviewOpen" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Repository file history" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { enhanced_diff_hl = true },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "GBrowse", "Gdiffsplit", "Git", "Gvdiffsplit" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
    },
    dependencies = { "tpope/vim-rhubarb" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "master",
    keys = {
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Mark file with Harpoon",
      },
      {
        "<leader>hf",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Show Harpoon marks",
      },
      {
        "<leader>hn",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Next Harpoon mark",
      },
      {
        "<leader>hp",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Previous Harpoon mark",
      },
      {
        "<leader>ht",
        function()
          require("harpoon.term").gotoTerminal(1)
        end,
        desc = "Harpoon terminal",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      global_settings = {
        save_on_change = true,
        save_on_toggle = true,
      },
    },
  },
}
