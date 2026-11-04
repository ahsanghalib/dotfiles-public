#!/usr/bin/env bash
set -euo pipefail

config_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v nvim >/dev/null 2>&1; then
  echo "nvim is required to run this check" >&2
  exit 1
fi

NVIM_CONFIG_AUDIT_ROOT="$config_root" nvim --headless --clean -u NONE \
  "+lua local root=vim.env.NVIM_CONFIG_AUDIT_ROOT; local files=vim.fn.glob(root .. '/**/*.lua', false, true); for _, file in ipairs(files) do local chunk, err=loadfile(file); assert(chunk, file .. ': ' .. tostring(err)) end; local lock=assert(io.open(root .. '/lazy-lock.json', 'r')); local contents=lock:read('*a'); lock:close(); assert(vim.json.decode(contents)); print(('validated %d Lua files and lazy-lock.json'):format(#files))" \
  "+qa"
