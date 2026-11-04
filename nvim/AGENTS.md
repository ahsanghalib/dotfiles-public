# Neovim configuration instructions

## Scope

These instructions apply to `nvim/`, the Neovim configuration in this repo.

## Architecture

- `init.lua`: Neovim version gate and configuration bootstrap.
- `lua/config/`: editor options, keymaps, autocmds, health checks, tooling, and
  TypeScript routing.
- `lua/plugins/`: lazy.nvim plugin specifications and plugin configuration.
- `scripts/check.sh`: static Lua and `lazy-lock.json` validation.
- `README.md`: installation, usage, and maintenance documentation.
- `LANGUAGE_SUPPORT.md`: language coverage and validation audit.

## Change rules

- Target Neovim 0.12 or newer.
- Follow existing module and plugin patterns; make the smallest coherent change.
- Follow `stylua.toml` for Lua formatting. Do not impose a different formatter.
- Preserve specialized ownership boundaries for TypeScript, Java, Go, Elixir,
  Dart/Flutter, and C#/Razor to avoid duplicate language-server clients.
- Change `lazy-lock.json` only when plugin specifications or dependencies are
  intentionally changed; do not edit it manually for unrelated work.
- Keep `README.md` and `LANGUAGE_SUPPORT.md` accurate when dependencies,
  supported languages, validation scope, or user-facing mappings change.
- Do not add secrets, credentials, generated plugin state, or unrelated cleanup.

## Validation

Run from this directory after Lua or plugin changes:

```bash
./scripts/check.sh
```

For language or plugin behavior changes, also use Neovim in a representative
project buffer and check `:checkhealth config`, `:LspInfo`, and `:ConformInfo` as
applicable. Review `git diff --check` and the complete diff before handoff.
