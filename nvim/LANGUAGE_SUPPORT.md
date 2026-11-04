# Language support audit

This file separates executable runtime tests from configuration and registry checks. An editor config can verify that every adapter and package name is valid without claiming that a missing SDK, compiler, framework, or private project was executed.

## Coverage matrix

| Language or format             | Language intelligence                                                             | Formatter                                                          | Linter or diagnostics               | Parser                             | Project runtime                                           |
| ------------------------------ | --------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ----------------------------------- | ---------------------------------- | --------------------------------------------------------- |
| JavaScript, TypeScript, React  | typescript-tools for TS 4 to 6, native tsc LSP for TS 7+, ESLint, Tailwind, Emmet | Prettierd, then Prettier                                           | ESLint LSP                          | javascript, typescript, tsx        | Node.js and project dependencies                          |
| Deno JavaScript and TypeScript | Deno LSP                                                                          | deno fmt                                                           | Deno LSP                            | javascript, typescript, tsx        | Mason-managed Deno runtime                                |
| Python                         | BasedPyright and Ruff                                                             | Ruff import organization and format, with isort and Black fallback | Ruff and BasedPyright               | python                             | Python 3 and the project's environment                    |
| Go                             | gopls and Go.nvim                                                                 | goimports, then gofumpt                                            | gopls staticcheck and golangci-lint | go, gomod, gosum, gowork           | Go                                                        |
| C#                             | roslyn.nvim                                                                       | CSharpier, then Roslyn fallback                                    | Roslyn analyzers                    | c_sharp                            | .NET SDK                                                  |
| ASP.NET, Razor, CSHTML         | Roslyn co-hosting                                                                 | Roslyn LSP fallback                                                | Roslyn analyzers                    | razor                              | .NET SDK and project workloads                            |
| Lua                            | lua-language-server                                                               | StyLua                                                             | Lua LS and Luacheck                 | lua, luadoc                        | Lua or LuaJIT when the project needs it                   |
| Elixir, EEx, HEEx              | elixir-tools with ElixirLS and Credo                                              | mix format                                                         | ElixirLS, Credo, Dialyzer           | elixir, eex, heex                  | Elixir and Erlang/OTP                                     |
| Erlang                         | ELP                                                                               | erlfmt when installed                                              | ELP                                 | erlang                             | Erlang/OTP; rebar3 for normal projects and erlfmt         |
| Kotlin                         | current JetBrains Kotlin LSP                                                      | ktlint                                                             | Kotlin LSP and ktlint               | kotlin                             | Kotlin/JVM project toolchain                              |
| Java                           | nvim-java with jdtls and Spring support                                           | google-java-format                                                 | jdtls                               | java                               | JDK 17 or newer                                           |
| C, C++, Objective-C, CUDA      | clangd with clangd_extensions                                                     | clang-format                                                       | clangd and clang-tidy               | c, cpp, auto-installed CUDA parser | Compiler and project build tools                          |
| YAML                           | yaml-language-server                                                              | Prettierd, then Prettier                                           | YAML LS and yamllint                | yaml                               | None                                                      |
| GitHub Actions YAML            | yaml-language-server                                                              | Prettierd, then Prettier                                           | actionlint and yamllint             | yaml                               | None                                                      |
| Markdown, MDX                  | Marksman                                                                          | Prettierd, then Prettier                                           | markdownlint-cli2                   | markdown, markdown_inline          | None                                                      |
| HTML and CSS                   | HTML LS, CSS LS, Emmet, Tailwind                                                  | Prettierd, then Prettier                                           | LSP diagnostics                     | html, css, scss                    | Node.js for the managed tools                             |
| PHP                            | Intelephense                                                                      | php-cs-fixer                                                       | Intelephense and PHPStan            | php                                | PHP                                                       |
| Blade                          | Intelephense and HTML LS                                                          | blade-formatter                                                    | LSP diagnostics                     | blade                              | PHP and the Laravel project                               |
| Bash and shell                 | bash-language-server                                                              | shfmt                                                              | ShellCheck                          | bash                               | Shell used by the project                                 |
| Docker and Compose             | Docker and Compose language servers                                               | LSP fallback                                                       | Hadolint and LSP diagnostics        | dockerfile, yaml                   | Docker only for running containers                        |
| JSON and JSONC                 | json-language-server                                                              | Prettierd, then Prettier                                           | JSON LS                             | json, json5                        | None                                                      |
| XML                            | LemMinX                                                                           | xmlformatter                                                       | LemMinX                             | xml                                | Java may be needed by LemMinX's distribution              |
| SQL                            | sqruff LSP                                                                        | sqruff                                                             | sqruff                              | sql                                | Project database tools                                    |
| TOML                           | Taplo                                                                             | Taplo                                                              | Taplo                               | toml                               | None                                                      |
| Terraform and HCL              | terraform-ls                                                                      | terraform fmt                                                      | terraform-ls and tflint             | terraform, hcl                     | Terraform or OpenTofu for formatting and project commands |
| Rust                           | rust-analyzer                                                                     | rustfmt                                                            | rust-analyzer                       | rust                               | Rust toolchain                                            |
| Dart and Flutter               | flutter-tools with Dart Analysis Server                                           | dart format                                                        | Dart Analysis Server                | dart                               | Flutter or Dart SDK                                       |
| Vue                            | Volar, ESLint, Tailwind, Emmet                                                    | Prettierd, then Prettier                                           | Volar and ESLint                    | vue                                | Node.js and project dependencies                          |
| Svelte                         | Svelte LS, ESLint, Tailwind, Emmet                                                | Prettierd, then Prettier                                           | Svelte LS and ESLint                | svelte                             | Node.js and project dependencies                          |
| Astro                          | Astro LS, ESLint, Tailwind, Emmet                                                 | Prettierd, then Prettier                                           | Astro LS and ESLint                 | astro                              | Node.js and project dependencies                          |
| GraphQL                        | GraphQL language service                                                          | Prettierd, then Prettier                                           | GraphQL LS                          | graphql                            | Node.js for the managed server                            |
| Prisma                         | Prisma LS                                                                         | LSP fallback                                                       | Prisma LS                           | prisma                             | Node.js and Prisma project dependencies                   |
| OCaml                          | ocaml-lsp                                                                         | ocamlformat                                                        | OCaml LSP                           | ocaml, ocaml_interface             | OCaml and opam                                            |
| Templ                          | templ LSP                                                                         | LSP fallback                                                       | templ LSP                           | templ                              | Go and templ                                              |
| Bicep                          | Bicep LSP                                                                         | LSP fallback                                                       | Bicep LSP                           | Auto-installed when available      | .NET runtime bundled or required by the package           |
| BrightScript                   | BrightScript LS                                                                   | LSP fallback                                                       | BrightScript LS                     | Auto-installed when available      | Project tools                                             |
| Zig                            | zls                                                                               | LSP fallback                                                       | zls                                 | zig                                | Zig                                                       |

## Automatic support behavior

- Mason's managed package list is centralized in `lua/config/tooling.lua`.
- mason-lspconfig automatically enables a newly installed server. The exclusion list protects languages owned by specialized plugins and the custom TypeScript router.
- Opening a recognized filetype starts its installed Tree-sitter parser. If nvim-treesitter has that parser but it is missing locally, the config installs it and starts it after installation.
- Conform uses a configured standalone formatter first and LSP formatting as a safe fallback.
- nvim-lint skips missing executables, so opening or saving an unsupported project does not produce a Lua error.

There is no safe universal way to infer an unknown language's preferred formatter or linter. Those two mappings remain explicit so a formatter never rewrites a file using the wrong dialect or project convention.

## Validation levels

Runtime-tested in isolated Neovim 0.12 sessions:

- Clean startup and plugin graph loading
- TypeScript and TSX server attachment
- `K` hover in a React TypeScript buffer
- TypeScript single-client routing
- Python BasedPyright and Ruff attachment
- Python `K` hover, Ruff diagnostics, import organization, and formatting

Configuration and current-registry validated:

- Every Mason package in `lua/config/tooling.lua`
- Every generic nvim-lspconfig server name
- Every Conform formatter adapter
- Every nvim-lint adapter
- Every declared Tree-sitter parser
- Requested filetype detection, including Razor, Blade, MDX, and GitHub Actions YAML
- Specialized ownership for Java, Go, Elixir, Flutter, Roslyn, and TypeScript
- Static parsing of every Lua file and JSON parsing of `lazy-lock.json`

The second group was not represented as a full compiler or framework test. Running every language end to end would require each SDK and a real project for every build system. Use `:checkhealth config` inside the target project to see the remaining runtime or tool requirement.

## Useful checks

```vim
:checkhealth config
:LspInfo
:ConformInfo
:Lint
:Mason
:TSInstallInfo
```

For a new language, use `:LspInstall` from a project buffer and reopen the file. If it needs a standalone formatter or linter, add the package and filetype mapping described in the README.

## Upstream references

- [mason-lspconfig automatic server enablement](https://github.com/mason-org/mason-lspconfig.nvim)
- [nvim-treesitter main branch setup](https://github.com/nvim-treesitter/nvim-treesitter)
- [BasedPyright environment and import resolution](https://docs.basedpyright.com/latest/usage/import-resolution/)
- [Ruff editor integration](https://docs.astral.sh/ruff/editors/setup/)
- [Roslyn.nvim Razor support](https://github.com/seblyng/roslyn.nvim)
- [JetBrains Kotlin language server](https://github.com/Kotlin/kotlin-lsp)
- [Erlang Language Platform](https://whatsapp.github.io/erlang-language-platform/)
- [erlfmt installation](https://github.com/WhatsApp/erlfmt)
