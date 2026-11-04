local M = {}

local required = {
  { "cc", "Tree-sitter parser compilation" },
  { "curl", "plugin and tool downloads" },
  { "git", "plugin installation" },
  { "node", "JavaScript-based language tooling" },
  { "npm", "Mason's JavaScript-based packages" },
  { "rg", "live grep" },
  { "tar", "tool extraction" },
  { "tree-sitter", "parser generation" },
  { "unzip", "tool extraction" },
}

local optional = {
  { "fd", "faster file discovery" },
  { "lazygit", "LazyGit integration" },
  { "make", "telescope-fzf-native" },
  { "opencode", "AI coding integration" },
}

local language_runtimes = {
  { "cargo", "Rust builds and tests" },
  { "cmake", "CMake-based C and C++ projects" },
  { "dart", "standalone Dart projects" },
  { "dotnet", "C#, ASP.NET, and Razor projects" },
  { "docker", "Docker and Compose commands" },
  { "elixir", "Elixir projects" },
  { "erl", "Erlang projects" },
  { "flutter", "Flutter projects" },
  { "go", "Go builds, tests, and debugging" },
  { "java", "Java and Kotlin projects" },
  { "opam", "OCaml tools installed through opam" },
  { "php", "PHP projects and PHP-based formatters" },
  { "python3", "Python projects and virtual environments" },
  { "rebar3", "Erlang project discovery and erlfmt" },
  { "terraform", "Terraform formatting and project commands" },
  { "zig", "Zig projects" },
}

local function check_executable(name, purpose, mandatory, project_runtime)
  if vim.fn.executable(name) == 1 then
    vim.health.ok(("%s is available for %s"):format(name, purpose))
    return true
  end

  if mandatory then
    vim.health.error(("%s is missing; required for %s"):format(name, purpose))
  elseif project_runtime then
    vim.health.warn(("%s is missing; needed for %s"):format(name, purpose))
  else
    vim.health.warn(("%s is missing; optional for %s"):format(name, purpose))
  end
  return false
end

local function check_tree_sitter_version()
  if vim.fn.executable("tree-sitter") ~= 1 then
    return
  end

  local output = vim.fn.system({ "tree-sitter", "--version" })
  local major, minor, patch = output:match("(%d+)%.(%d+)%.(%d+)")
  local version = major and { tonumber(major), tonumber(minor), tonumber(patch) } or nil
  local current = version and version[1] * 1000000 + version[2] * 1000 + version[3] or 0
  if current >= 26001 then
    vim.health.ok(("tree-sitter %d.%d.%d is supported"):format(unpack(version)))
  else
    vim.health.error("tree-sitter CLI 0.26.1 or newer is required")
  end
end

local function check_plugins()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.health.error("lazy.nvim is not available")
    return
  end

  local missing = vim.tbl_filter(function(plugin)
    return not plugin._.installed
  end, lazy.plugins())
  if #missing == 0 then
    vim.health.ok("All configured plugins are installed")
  else
    vim.health.warn(("%d plugin(s) are missing; run :Lazy sync"):format(#missing))
  end
end

local function check_mason_packages()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    vim.health.error("Mason is not available; run :Lazy sync")
    return
  end

  local packages = require("config.tooling").mason_packages
  local missing = vim.tbl_filter(function(name)
    return not registry.is_installed(name)
  end, packages)

  if #missing == 0 then
    vim.health.ok(("All %d managed language tools are installed"):format(#packages))
    return
  end

  table.sort(missing)
  vim.health.warn(("%d managed language tool(s) are missing"):format(#missing))
  vim.health.info(table.concat(missing, ", "))
  vim.health.info("Run :MasonToolsInstall to install the missing tools")
end

local function check_typescript()
  local typescript = require("config.typescript").info(0)
  if not typescript then
    vim.health.warn("TypeScript was not found in the project, globally, or in Mason")
    return
  end

  local server = typescript.major >= 7 and "native tsc LSP" or "typescript-tools.nvim"
  vim.health.ok(
    ("TypeScript %s from %s detected; %s will be used"):format(
      typescript.version,
      typescript.source or "unknown source",
      server
    )
  )
end

function M.check()
  vim.health.start("Neovim configuration")

  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim 0.12 or newer")
  else
    vim.health.error("Neovim 0.12 or newer is required")
  end

  for _, item in ipairs(required) do
    check_executable(item[1], item[2], true)
  end
  check_tree_sitter_version()

  for _, item in ipairs(optional) do
    check_executable(item[1], item[2], false)
  end
  check_plugins()

  vim.health.start("Managed language tools")
  check_mason_packages()
  check_typescript()

  vim.health.start("Project runtimes")
  for _, item in ipairs(language_runtimes) do
    check_executable(item[1], item[2], false, true)
  end

  vim.health.info("Missing project runtimes do not affect languages you do not use")
  vim.health.info("Use :LspInfo in a project buffer to inspect attached language servers")
  vim.health.info("Use :ConformInfo to inspect formatters for the current buffer")
  vim.health.info("Use :Lint to run the configured linter for the current buffer")
  vim.health.info("Use :checkhealth opencode to inspect the AI integration")
end

return M
