# Neovim configuration

This config targets Neovim 0.12 or newer. It keeps the editing, Git, testing, debugging, language, Tree-sitter, terminal, explorer, CSV, bookmark, Harpoon, formatting, and UI behavior from the old monolithic config. OpenCode and Codex add agent-style AI coding without replacing normal LSP completion.

## Requirements

Core commands:

- `git`
- `node` and `npm`
- `rg`
- `tree-sitter` 0.26.1 or newer
- `curl`, `tar`, `unzip`, and a C compiler

Useful optional commands:

- `fd`
- `lazygit`
- `make`
- `opencode`
- `codex`

Install each language's real runtime or SDK when you use it. Examples include `python3`, `go`, `dotnet`, a JDK, `php`, Elixir and Erlang, Flutter, and Rust. Mason installs editors' language servers, formatters, linters, and debuggers. It does not replace project runtimes.

On Arch Linux, the core packages can be installed with:

```bash
sudo pacman -S --needed neovim git nodejs npm ripgrep fd tree-sitter-cli base-devel lazygit
```

OpenCode and Codex must be available as `opencode` and `codex` on `PATH` to use their respective AI mappings.

## Install

Place the `nvim` directory at `~/.config/nvim`, start Neovim, and let the first-run installation finish. Then run:

```vim
:Lazy sync
:MasonToolsInstall
:TSUpdate
:checkhealth config
```

Run `:checkhealth config`, `:LspInfo`, and `:ConformInfo` from a real project buffer. Language server root detection depends on files such as `.git`, `package.json`, `pyproject.toml`, `go.mod`, or the language-specific equivalent.

## Language coverage

The requested language families are configured:

- JavaScript, TypeScript, React, Deno, Vue, Svelte, Astro, HTML, CSS, GraphQL, and Prisma
- Python
- Go
- C#, ASP.NET, Razor, and CSHTML
- Lua
- Elixir and Erlang
- Kotlin and Java
- C, C++, Objective-C, and CUDA
- YAML, GitHub Actions, JSON, TOML, XML, SQL, Markdown, and MDX
- PHP and Blade
- Bash, Docker, Terraform, Rust, Dart, Flutter, OCaml, Templ, Bicep, BrightScript, and Zig

See [LANGUAGE_SUPPORT.md](LANGUAGE_SUPPORT.md) for the exact server, formatter, linter, parser, runtime requirements, and validation level for each language.

## Python

Python uses BasedPyright for completion, navigation, hover, imports, type checking, and inlay hints. Ruff handles diagnostics, import organization, and formatting. BasedPyright discovers normal project environments, including `.venv` directories used by `venv` and `uv`.

Ruff's hover provider is disabled so `K` has one authoritative hover response from BasedPyright. If Ruff is unavailable, formatting falls back to isort followed by Black.

## TypeScript and React

The config detects the closest project TypeScript and starts one matching server:

- TypeScript 4 through 6: `typescript-tools.nvim`
- TypeScript 7 or newer: native `tsc --lsp --stdio`

Resolution order is project TypeScript, global TypeScript, then Mason's pinned fallback. A project-local TypeScript always wins. Generic `ts_ls` auto-start is excluded, so duplicate TypeScript clients cannot attach.

`K` is a global mapping. It tries LSP hover first, a folded-line preview second, and Neovim keyword help last. It therefore works in TSX and React buffers once either TypeScript route has attached, and remains useful when no LSP is present.

| Key | Action |
| --- | --- |
| `<leader>tso` | Organize imports |
| `<leader>tss` | Sort imports |
| `<leader>tsf` | Fix supported issues |
| `<leader>tsr` | Rename the current file and update imports |

## Formatting and linting

Formatting runs on save through Conform. Use `<leader>cf` or the retained `<leader>mp` mapping to format manually. Use `<leader>uf` to toggle format on save.

Linting runs after a write when the relevant executable is available. Use `<leader>cl` or `:Lint` to run it manually. Missing optional linters are skipped without raising an editor error.

Razor is formatted through Roslyn's LSP support. CSharpier remains enabled for C# only because CSharpier does not format Razor files.

## Adding another language

The common path needs little or no Lua editing:

1. Open a file of that type and run `:LspInstall`. Mason-lspconfig automatically enables installed servers unless they are in the specialized-owner exclusion list.
2. If nvim-treesitter knows the filetype, its parser installs automatically when the file is opened. `:TSInstall <parser>` is still available for manual installation.
3. Conform falls back to LSP formatting when the server supports it.

A standalone formatter or linter cannot be guessed safely. Add its Mason package once in `lua/config/tooling.lua`, then add its filetype mapping in the Conform or nvim-lint table in `lua/plugins/lsp.lua`. Custom or unsupported Tree-sitter parsers still require an explicit parser definition.

Specialized plugins own TypeScript, Java, Elixir, Dart and Flutter, and C# and Razor. Their generic Mason server names stay excluded to prevent duplicate clients.

## OpenCode

| Key | Action |
| --- | --- |
| `<leader>aa` | Ask about the cursor or selection |
| `<leader>ab` | Ask about the current buffer |
| `<leader>ad` | Explain and fix diagnostics |
| `<leader>ae` | Explain context |
| `<leader>af` | Fix context |
| `<leader>ai` | Implement context |
| `<leader>ao` | Optimize context |
| `<leader>ar` | Review context |
| `<leader>at` | Add tests |
| `<leader>as` | Open the OpenCode action selector |
| `<leader>aT` | Toggle the OpenCode terminal |

Inside a Snacks picker, `<M-o>` sends the selected item or items to OpenCode.

## Codex

Codex uses the real interactive `codex` CLI in a Neovim split. It keeps the CLI conversation alive when the split is hidden and uses the nearest `.git` root as its working directory.

| Key | Action |
| --- | --- |
| `<leader>acc` | Toggle the Codex terminal |
| `<leader>aca` | Ask Codex about the current file or selection |
| `<leader>acb` | Add the current buffer to Codex |
| `<leader>ace` | Ask Codex to edit the current file or selection |
| `<leader>acv` | Send the visual selection to Codex |
| `<leader>acp` | Prompt Codex |
| `<leader>acf` | Follow up with Codex |
| `<leader>acr` | Review uncommitted changes with Codex |
| `<leader>acR` | Resume a previous Codex session |
| `<leader>acC` | Continue the latest Codex session |
| `<leader>acs` | Show Codex status |
| `<leader>acx` | Stop Codex |

In Codex terminal mode, `<M-n>` enters Neovim terminal Normal mode; use `i` to return to the Codex CLI. Codex's own conversation/session switching remains available inside the TUI.

## Notifications

| Key | Action |
| --- | --- |
| `<leader>n` | Show Snacks notification history |
| `<leader>un` | Dismiss visible notifications |

## Conflict fixes

- `<C-h/j/k/l>` always moves between windows in normal and terminal mode. LSP signature help uses `gK`, so it does not steal `<C-k>`.
- Harpoon keeps `<leader>hp` for the previous mark. Git hunk preview uses `<leader>hP`.
- `<leader>e` remains the diagnostic float. NvimTree uses `<leader>ee`, Oil uses `-`, and Snacks Explorer uses `<leader>E`.
- Undo tree uses `<leader>uu`, `<leader>uo`, and `<leader>uc`. There is no exact `<leader>u` mapping to delay every UI toggle.
- Trouble keeps `<leader>xl` for the location list. The LSP list uses `<leader>xL`.

## Validation

Run the static Lua and lock-file check from this directory:

```bash
./scripts/check.sh
```

The delivered archive was also checked with Neovim 0.12 using an isolated plugin installation. The exact validation scope is recorded in [LANGUAGE_SUPPORT.md](LANGUAGE_SUPPORT.md).

## Intentional AI exclusions

Codeium and Claude Code are not included. Normal completion remains enabled through `nvim-cmp`, while OpenCode handles agent-style coding without adding another inline completion engine.
