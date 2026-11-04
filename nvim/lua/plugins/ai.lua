local function open_tmux(tmux_args, session_args, target)
  if vim.env.TMUX == nil or vim.env.TMUX == "" then
    vim.notify(
      "OpenCode tmux " .. target .. " requires Neovim to run inside tmux",
      vim.log.levels.WARN
    )
    return
  end

  local command = { "tmux" }
  vim.list_extend(command, tmux_args)
  vim.list_extend(command, { "-c", vim.fn.getcwd(), "opencode", "--port" })
  vim.list_extend(command, session_args or {})
  vim.fn.jobstart(command, { detach = true })
end

local function open_tmux_pane(session_args)
  open_tmux({ "split-window", "-h" }, session_args, "pane")
end

local function open_tmux_window(session_args)
  open_tmux({ "new-window" }, session_args, "window")
end

local open_opencode = open_tmux_pane

local function open_tmux_menu()
  Snacks.picker.select({
    { label = "Split Pane · New Session", target = "pane", session_args = {} },
    { label = "Split Pane · Previous session", target = "pane", session_args = { "--continue" } },
    { label = "New Window · New Session", target = "window", session_args = {} },
    {
      label = "New Window · Previous Session",
      target = "window",
      session_args = { "--continue" },
    },
  }, {
    prompt = "OpenCode",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end

    local launcher = choice.target == "pane" and open_tmux_pane or open_tmux_window
    open_opencode = function()
      launcher(choice.session_args)
    end
    open_opencode()
  end)
end

local function prompt(text)
  return function()
    require("opencode").prompt(text)
  end
end

return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    init = function()
      vim.g.opencode_opts = {
        server = {
          start = function()
            open_opencode()
          end,
        },
        events = {
          permissions = {
            enabled = false,
            edits = { enabled = false },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>aa",
        function()
          require("opencode").ask("@this: ")
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode about context",
      },
      {
        "<leader>as",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Select OpenCode action",
      },
      {
        "<leader>ab",
        function()
          require("opencode").ask("@buffer: ")
        end,
        desc = "Ask about current buffer",
      },
      {
        "<leader>ad",
        function()
          require("opencode").ask("Explain and fix @diagnostics: ")
        end,
        mode = { "n", "x" },
        desc = "Fix diagnostics with OpenCode",
      },
      {
        "<leader>ae",
        prompt("Explain @this and its context."),
        mode = { "n", "x" },
        desc = "Explain context with OpenCode",
      },
      {
        "<leader>af",
        prompt("Fix @diagnostics in @this. Preserve intended behavior and add or update tests."),
        mode = { "n", "x" },
        desc = "Fix context with OpenCode",
      },
      {
        "<leader>ai",
        prompt("Implement @this. Follow the repository conventions and verify the result."),
        mode = { "n", "x" },
        desc = "Implement context with OpenCode",
      },
      {
        "<leader>ao",
        prompt("Optimize @this for performance and readability without changing behavior."),
        mode = { "n", "x" },
        desc = "Optimize context with OpenCode",
      },
      {
        "<leader>ar",
        prompt("Review @this for correctness, security, maintainability, and missing tests."),
        mode = { "n", "x" },
        desc = "Review context with OpenCode",
      },
      {
        "<leader>at",
        prompt("Add focused tests for @this. Cover failure paths and important edge cases."),
        mode = { "n", "x" },
        desc = "Add tests with OpenCode",
      },
      {
        "<leader>aT",
        open_tmux_menu,
        desc = "Open OpenCode tmux options",
      },
    },
  },
  {
    "nwiizo/codex.nvim",
    event = "VeryLazy",
    opts = {
      backend = "terminal",
      cmd = { "codex" },
      cwd = "root",
      terminal = {
        layout = "split",
        split_side = "right",
        split_width_percentage = 0.50,
        auto_insert = true,
        auto_close = false,
        normal_mode_keys = { "<M-n>" },
      },
      selection = {
        enabled = true,
        hint = false,
        keymaps = { ask = "<leader>aca", edit = "<leader>ace" },
      },
    },
    keys = {
      { "<leader>acc", "<cmd>CodexFocus<cr>", desc = "Toggle Codex terminal" },
      { "<leader>aca", "<cmd>CodexAsk<cr>", desc = "Ask Codex about context" },
      {
        "<leader>aca",
        ":<C-U>CodexAskVisual<CR>",
        mode = "x",
        desc = "Ask Codex about selection",
      },
      { "<leader>acb", "<cmd>CodexAdd<cr>", desc = "Add current buffer to Codex" },
      { "<leader>acp", "<cmd>CodexPrompt<cr>", desc = "Prompt Codex" },
      { "<leader>ace", "<cmd>CodexEdit<cr>", desc = "Edit context with Codex" },
      {
        "<leader>ace",
        ":<C-U>CodexEdit<CR>",
        mode = "x",
        desc = "Edit selection with Codex",
      },
      {
        "<leader>acv",
        ":<C-U>CodexSendVisual<CR>",
        mode = "x",
        desc = "Send selection to Codex",
      },
      { "<leader>acf", "<cmd>CodexFollowUp<cr>", desc = "Follow up with Codex" },
      { "<leader>acr", "<cmd>CodexReview --uncommitted<cr>", desc = "Review changes with Codex" },
      { "<leader>acR", "<cmd>CodexResume<cr>", desc = "Resume a Codex session" },
      { "<leader>acC", "<cmd>CodexContinue<cr>", desc = "Continue the latest Codex session" },
      { "<leader>acs", "<cmd>CodexStatus<cr>", desc = "Show Codex status" },
      { "<leader>acx", "<cmd>CodexStop<cr>", desc = "Stop Codex" },
    },
  },
  -- Exafunction/codeium.vim
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      vim.keymap.set("i", "<M-e>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-n>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-p>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-k>", function()
        return vim.fn["codeium#AcceptNextWord"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-l>", function()
        return vim.fn["codeium#AcceptNextLine"]()
      end, { expr = true, silent = true })
    end,
  },
}
