local M = {}

local global_typescript

local function is_file(path)
  local stat = path and vim.uv.fs_stat(path)
  return stat and stat.type == "file"
end

local function read_package(package_json)
  if not is_file(package_json) then
    return
  end

  local ok_read, lines = pcall(vim.fn.readfile, package_json)
  if not ok_read then
    return
  end

  local ok_json, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok_json or type(package) ~= "table" or package.name ~= "typescript" then
    return
  end

  local major = tonumber(tostring(package.version):match("^(%d+)"))
  if not major then
    return
  end

  return package.version, major
end

local function package_info(package_root, workspace_root, tsc, source)
  local version, major = read_package(vim.fs.joinpath(package_root, "package.json"))
  if not version then
    return
  end

  local local_tsc = vim.fs.joinpath(workspace_root, "node_modules", ".bin", "tsc")
  if not is_file(local_tsc) then
    local_tsc = vim.fs.joinpath(package_root, "bin", "tsc")
  end

  return {
    major = major,
    package_root = package_root,
    source = source,
    tsc = is_file(local_tsc) and local_tsc or tsc,
    tsserver = vim.fs.joinpath(package_root, "lib", "tsserver.js"),
    version = version,
    workspace_root = workspace_root,
  }
end

local function sdk_path(info)
  if not info then
    return
  end

  local sdk = vim.fs.joinpath(info.package_root, "lib")
  if
    is_file(vim.fs.joinpath(sdk, "typescript.js"))
    or is_file(vim.fs.joinpath(sdk, "tsserverlibrary.js"))
  then
    return sdk
  end
end

local function find_local_typescript(start_dir)
  local directory = start_dir
  while directory do
    local package_root = vim.fs.joinpath(directory, "node_modules", "typescript")
    local info = package_info(package_root, directory, nil, "project")
    if info then
      return info
    end

    local parent = vim.fs.dirname(directory)
    if not parent or parent == directory then
      break
    end
    directory = parent
  end
end

local function find_global_typescript()
  if global_typescript ~= nil then
    return global_typescript or nil
  end

  global_typescript = false
  local executable = vim.fn.exepath("tsc")
  if executable == "" then
    return
  end

  local real_executable = vim.uv.fs_realpath(executable) or executable
  local directory = vim.fs.dirname(real_executable)
  while directory do
    local info = package_info(directory, directory, executable, "global")
    if info then
      global_typescript = info
      return info
    end

    local parent = vim.fs.dirname(directory)
    if not parent or parent == directory then
      break
    end
    directory = parent
  end
end

local function find_mason_typescript(workspace_root)
  local package_root = vim.fs.joinpath(
    vim.fn.stdpath("data"),
    "mason",
    "packages",
    "typescript-language-server",
    "node_modules",
    "typescript"
  )
  return package_info(package_root, workspace_root, nil, "Mason fallback")
end

local function project_root(buffer)
  return vim.fs.root(buffer, {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    ".git",
  })
end

function M.info(buffer)
  buffer = buffer or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buffer)
  local directory = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()

  local local_info = find_local_typescript(directory)
  if local_info then
    return local_info
  end

  local global_info = find_global_typescript()
  if global_info then
    local info = vim.deepcopy(global_info)
    info.workspace_root = project_root(buffer) or directory
    return info
  end

  return find_mason_typescript(project_root(buffer) or directory)
end

function M.sdk_path(root_dir)
  root_dir = root_dir or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()

  local local_sdk = sdk_path(find_local_typescript(root_dir))
  if local_sdk then
    return local_sdk
  end

  local global_sdk = sdk_path(find_global_typescript())
  if global_sdk then
    return global_sdk
  end

  return sdk_path(find_mason_typescript(root_dir))
end

local function is_deno_buffer(buffer, workspace_root)
  local deno_root = vim.fs.root(buffer, { "deno.json", "deno.jsonc", "deno.lock" })
  return deno_root and (not workspace_root or #deno_root >= #workspace_root)
end

function M.legacy_root(buffer, on_dir)
  local info = M.info(buffer)
  if not info or info.major >= 7 or not is_file(info.tsserver) then
    return
  end

  if is_deno_buffer(buffer, info.workspace_root) then
    return
  end

  on_dir(require("typescript-tools.utils").get_root_dir(buffer))
end

function M.native_root(buffer, on_dir)
  local info = M.info(buffer)
  if not info or info.major < 7 or not is_file(info.tsc) then
    return
  end

  if is_deno_buffer(buffer, info.workspace_root) then
    return
  end

  on_dir(info.workspace_root)
end

function M.native_cmd(dispatchers, config)
  local root = config and config.root_dir
  local info = root and find_local_typescript(root) or nil
  info = info or find_global_typescript() or (root and find_mason_typescript(root) or nil)
  local command = info and info.tsc or nil
  if not is_file(command) then
    error("TypeScript 7 executable not found")
  end

  return vim.lsp.rpc.start({ command, "--lsp", "--stdio" }, dispatchers)
end

local function has_client(name, method)
  return #vim.lsp.get_clients({
    bufnr = 0,
    method = method,
    name = name,
  }) > 0
end

function M.code_action(legacy_command, native_kinds)
  if has_client("typescript-tools") and vim.fn.exists(":" .. legacy_command) == 2 then
    vim.cmd(legacy_command)
    return
  end

  if not has_client("tsc_native", "textDocument/codeAction") then
    vim.notify("No TypeScript language server with code actions is attached", vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.code_action({
    apply = true,
    context = {
      diagnostics = vim.diagnostic.get(0),
      only = native_kinds,
    },
  })
end

local function native_rename(old_name, new_name)
  local params = {
    files = {
      {
        newUri = vim.uri_from_fname(new_name),
        oldUri = vim.uri_from_fname(old_name),
      },
    },
  }
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  for _, client in ipairs(clients) do
    if client:supports_method("workspace/willRenameFiles") then
      local response = client:request_sync("workspace/willRenameFiles", params, 10000, 0)
      if response and response.result then
        vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
      end
    end
  end

  local ok, error_message = pcall(vim.lsp.util.rename, old_name, new_name)
  if not ok then
    vim.notify("File rename failed: " .. tostring(error_message), vim.log.levels.ERROR)
    return
  end

  for _, client in ipairs(clients) do
    if client:supports_method("workspace/didRenameFiles") then
      client:notify("workspace/didRenameFiles", params)
    end
  end
end

function M.rename_file()
  if has_client("typescript-tools") and vim.fn.exists(":TSToolsRenameFile") == 2 then
    vim.cmd("TSToolsRenameFile")
    return
  end

  if not has_client("tsc_native") then
    vim.notify("No TypeScript language server is attached", vim.log.levels.WARN)
    return
  end

  local old_name = vim.api.nvim_buf_get_name(0)
  vim.ui.input({
    default = vim.fs.basename(old_name),
    prompt = "New file name: ",
  }, function(input)
    if not input or input == "" or input == vim.fs.basename(old_name) then
      return
    end

    local new_name = input
    if not vim.fs.is_absolute(new_name) then
      new_name = vim.fs.joinpath(vim.fs.dirname(old_name), new_name)
    end
    new_name = vim.fs.normalize(new_name)

    vim.cmd.update()
    native_rename(old_name, new_name)
  end)
end

return M
