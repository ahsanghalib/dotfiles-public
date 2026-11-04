# Doom Emacs: a friendly tour of this setup

This Doom configuration is meant to be a practical coding editor that feels
close to the Neovim setup in the sibling `nvim/` folder, while also helping with
notes, tasks, projects, notebooks, diagrams, and AI tools.

You do not need to learn everything at once. Start with the first section, then
try one feature whenever you need it.

## Start here

### 1. Install the Doom configuration

On a new machine, install Emacs and Git, copy this folder, then run its
bootstrap script. It installs Doom core when needed, links this folder as the
private Doom directory, and syncs the selected packages:

```sh
bash /path/to/doom/bootstrap.sh
```

After the first setup, ordinary `emacs` launches use this configuration. The
script never replaces an existing unrelated Doom core or config directory.

After changing `init.el` on an existing installation, run:

```sh
bash /path/to/doom/bootstrap.sh
```

Then start Emacs and run:

```text
M-x doom-doctor
```

If the config folder is not linked at `~/.config/doom`, use an explicit
`DOOMDIR` for a one-off launch:

```sh
DOOMDIR="/path/to/doom" emacs
```

`doom sync` installs the packages selected in `init.el`; package and compiled
state remain machine-local outside this folder.

After changing `config.el`, restart Emacs or use `M-x doom/reload`; normally you
do not need another sync.

### 2. Open a project

Open a file from a Git project, or run:

```text
M-x project-switch-project
```

Emacs uses the project root for LSP, Git, Make, Org project capture, Codex, and
OpenCode.

### 3. Remember how to run commands

This setup does not add a new keybinding system. Your normal Doom/Evil keys are
still available. The safest way to find any feature is:

```text
M-x command-name
```

For example, type `M-x org-agenda` or `M-x magit-status`.

## Installation checklist

There are two layers in this setup:

The availability notes below were checked on 2026-10-02 and can change as
project environments or system packages change.

1. Doom packages provide Emacs features. Run `doom sync` after changing
   `init.el`.
2. Language runtimes, SDKs, language servers, formatters, linters, kernels,
   and dictionaries are separate programs. Emacs can use them only when they
   are installed and visible on `PATH`.

The configuration automatically adds the Neovim Mason binaries directory when
it exists:

```text
~/.local/share/nvim/mason/bin/
```

That lets Doom reuse tools installed by Neovim. It does not install missing
tools. Check any dependency from Emacs with:

```text
M-x executable-find RET command-name RET
M-x doom-doctor
```

### Arch Linux dependency installer

For Arch Linux, the folder includes a simple system dependency installer:

```sh
bash doom/install-dependencies.sh
```

When run as a normal user it uses `yay` for official and AUR packages. Without
`yay`, run it as root for official repository packages:

```sh
sudo bash doom/install-dependencies.sh
```

The script deliberately does not pass `--needed`, so pacman/yay will reinstall
requested packages even if they are already installed. It does not install
project dependencies globally: use `uv` inside each Python project and `npm ci`
inside each Node/React/React Native project. AUR packages are third-party build
inputs; review yay's prompts before accepting them.

### AI/ML Python setup

For a project managed by `uv`, install the development tools in that project:

```sh
uv add --dev basedpyright ruff pytest jupyter ipykernel
```

The current machine has `uv`, Python, and Ruff. Based Pyright, Pytest, and
Jupyter still need to be added to a project before Python diagnostics, tests,
or Jupyter notebooks can run there.

### Runtime and language-server setup

Install the runtime first, then the matching server and formatter for each
language you use:

- JavaScript, TypeScript, React, React Native, Vue, Svelte, and Astro need
  Node.js project dependencies plus their language servers, ESLint, and
  Prettier where the project uses them.
- Dart and Flutter need the Dart/Flutter SDKs; the installer includes Dart and
  attempts the Flutter SDK through `yay` because Flutter is an AUR package.
- Go needs Go, `gopls`, and `goimports`.
- Rust needs the Rust toolchain and `rust-analyzer`.
- Java, Spring Boot, and Android Java need a JDK, `jdtls`, and
  `google-java-format`.
- Kotlin and Android Kotlin need a JDK, Kotlin tooling, and the project's
  Gradle wrapper.
- C# and Razor need the .NET SDK plus a Roslyn, C# LS, or OmniSharp server.
- C/C++ needs a compiler, `clangd`, `clang-format`, and preferably a
  `compile_commands.json` database.
- PHP needs PHP plus Intelephense or PHPActor.
- Elixir and Erlang need their runtimes, ELP/ElixirLS, and `erlfmt` where
  applicable.
- Terraform needs Terraform or OpenTofu, `terraform-ls`, and `tflint` if you
  want linting.

The language section below lists the enabled modules, while `config.el` holds
the extra server routes. A missing server affects only that language; it does
not prevent Emacs from opening the file.

### Optional external tools

- Hunspell is present, but an English dictionary was not detected. Install a
  dictionary through your operating system before using spelling suggestions.
- Java is present. PlantUML is not; `M-x plantuml-download-jar` can install the
  PlantUML JAR after Doom sync.
- `jq`, `xmllint`, Docker, Terraform, direnv, Go, Rust, Node.js, npm,
  TypeScript, ESLint, Prettier, Clang, Clangd, CMake, Java, Kotlin, .NET, and
  Android `adb` are available on the current machine.
- The dependency installer also covers `aspell`, `gnuplot`, ImageMagick,
  `xclip`, `wl-clipboard`, Dart, Elixir/Erlang, PHP, OCaml, Zig, `goimports`,
  StyLua, `tombi`, `ktlint`, and HTML Tidy from Arch's official repositories.
- Jupyter, Pytest, Based Pyright, JDTLS, Kotlin Language Server, Roslyn/C# LS,
  CSharpier, Maven, Gradle, Android `sdkmanager`, LemMinX,
  `google-java-format`, Pandoc, PlantUML, and `sqruff` are not currently on
  `PATH`.
- Direct `.ipynb` editing still needs JupyterLab or another notebook frontend;
  this configuration uses Org files with Jupyter source blocks.

### AI credentials

Codex and OpenCode use their own CLI authentication. gptel reads credentials
through Emacs `auth-source`; keep API keys in an encrypted auth file rather
than in `config.el`, Org files, or project repositories.

## What is enabled?

| Area | What it gives you |
| --- | --- |
| Evil | Vim-style editing throughout Emacs |
| Corfu, Orderless, Vertico | Fast completion and searching |
| Treemacs, tabs, workspaces | File tree and separate project workspaces |
| Fold, snippets, whitespace | Folding, snippets, and clean files |
| Eglot LSP | Completion, go-to-definition, hover help, renames, and errors |
| Flycheck | Extra error and warning checking |
| Spelling | Prose and programming-comment spell checking |
| Tree-sitter | Better syntax understanding where a grammar is available |
| Apheleia and format-on-save | Automatic formatting |
| Magit, VC, VC Gutter | Git status, history, commits, and changed lines |
| Dired, Ibuffer, Tramp | Files, buffers, and remote machines |
| Vterm, Eshell, Eval | Terminals and interactive code evaluation |
| Org | Tasks, notes, agendas, projects, calendars, and notebooks |
| Org-roam | Linked notes and a personal knowledge base |
| Citar and biblio | Bibliography search and Org citations |
| Org-noter and attachments | PDF annotations and images in Org |
| Jupyter | Live kernels and executable Org notebooks |
| Dape | Debug Adapter Protocol debugging |
| Make and direnv | Project tasks and project-specific environments |
| Python + uv | Reproducible Python environments and ML dependencies |
| Data and REST | CSV/XML inspection and API request experiments |
| PDF, LaTeX, PlantUML | Papers, PDFs, and text-based diagrams |
| RSS, EWW, EMMS | Feeds, web pages, and media |
| Codex and OpenCode | Project-rooted AI terminals |

## Coding like Neovim

### LSP, completion, and errors

When you open a supported source file, Doom starts Eglot, the built-in Emacs
LSP client. You should get:

- completion while typing;
- errors and warnings in the buffer and mode line;
- go-to-definition and references;
- hover documentation;
- rename and formatting when the server supports them.

Try these commands when something looks wrong:

```text
M-x eglot
M-x eglot-events-buffer
M-x flycheck-list-errors
M-x doom-doctor
```

This configuration prefers the same tools as Neovim where possible. For
example, Python prefers Based Pyright, PHP prefers Intelephense, JavaScript and
TypeScript use Deno in Deno projects, and ordinary TypeScript projects use the
TypeScript language server.

For web files, the filename chooses the language server: HTML, Astro, Svelte,
Vue, Razor, and Blade each get their matching setup.

If a language server is missing, Emacs cannot create one. The configuration
adds this Neovim Mason directory to Emacs's executable path when it exists:

```text
~/.local/share/nvim/mason/bin/
```

### Tree-sitter

Tree-sitter gives Emacs better syntax highlighting and structure-aware editing.
It is enabled for the languages where Doom provides the module flag. A parser
grammar must be installed; otherwise Emacs simply uses the normal major mode.
LSP still works in the normal mode.

### Formatting

Formatting on save is enabled. The setup knows about the same common formatters
used by Neovim:

- Prettier for web, JSON, Markdown, and GraphQL;
- Blade Formatter for Blade templates;
- Ruff for Python;
- StyLua for Lua;
- Goimports for Go;
- erlfmt for Erlang;
- google-java-format for Java;
- ocamlformat for OCaml;
- clang-format for C/C++;
- rustfmt for Rust;
- Taplo for TOML.

If formatting does not happen, check that the formatter is installed:

```text
M-x executable-find RET prettier RET
M-x executable-find RET ruff RET
```

### Python projects with uv

The Python module has the `+uv` flag enabled because `uv` is installed on this
machine. When a project contains `pyproject.toml` or `uv.lock`, Doom can show
the project environment and activate it when you switch buffers.

For a new project, a simple starting point is:

```sh
uv init
uv add basedpyright ruff pytest jupyter ipykernel
uv run python -c "import sys; print(sys.executable)"
```

For an existing project, use its documented dependency workflow. Avoid mixing
global `pip` installs with a project that is managed by `uv`; keeping the
environment in the project makes LSP, tests, notebooks, and CI agree about
which packages are installed.

Check the active environment with:

```text
M-x executable-find RET python3 RET
M-x executable-find RET basedpyright-langserver RET
M-x +python/open-repl
```

The exact LSP executable still has to be installed in the project or on
`PATH`. `+uv` manages the environment; it does not install every language
server automatically.

## Languages and file types

These are the enabled Doom language modules:

```text
C/C++       C#/.NET       Dart/Flutter   Elixir       Erlang
Go          GraphQL       JSON           Java         JavaScript/TypeScript
Kotlin      LaTeX         Lua            Markdown     OCaml
PHP         Python        Rust           Shell        Web
YAML        Zig           Docker         Terraform
```

The configuration also recognizes these file types from the Neovim setup:

```text
Astro, Svelte, Vue, Razor, Blade, GraphQL, JSONC, MDX, HCL, TFVars,
Prisma, Templ, Bicep, BrightScript, SQL, TOML, and XML.
```

Some of those special formats use a small local major mode because Doom does
not have a dedicated module for them. Their LSP server still needs to be
installed separately.

## JavaScript, React, .NET, JVM, and Android

These stacks are supported by the existing language modules. They do not need
separate React Native, Spring Boot, or Android Emacs packages.

### Node.js, TypeScript, React, and React Native

The JavaScript module covers Node.js, JavaScript, TypeScript, JSX, and TSX. The
web module adds React-oriented HTML/CSS/JSX editing. This configuration also
maps `.jsx` files explicitly to Tree-sitter JavaScript mode and uses the
project's TypeScript language server when the Node project path is available.

For a project, install its own dependencies rather than relying on global
packages:

```sh
npm ci
# or, for a new project:
npm install
```

Useful project checks include:

```text
M-x +javascript/open-repl
M-x eglot-events-buffer
M-x +format/buffer
```

For React Native, the editor handles JavaScript/TypeScript source, JSX/TSX,
diagnostics, navigation, and formatting. Metro, device builds, and simulators
remain project commands:

```sh
npx react-native doctor
npx react-native start
npx react-native run-android
```

You still need the Android SDK for Android builds and Xcode on macOS for iOS
builds. See the [React Native setup guide][react-native-setup].

### C and C++

The `cc +lsp +tree-sitter` module provides C, C++, Objective-C, CUDA, CMake
mode, Tree-sitter, completion, navigation, and diagnostics. Install `clangd`,
`clang-format`, and a compiler. For the most accurate diagnostics, generate a
compilation database from CMake:

```sh
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
```

Keep `compile_commands.json` at the project root or where `clangd` can find it.

### C# and .NET

The C# module has `+dotnet` enabled. It provides C# and C# Tree-sitter support,
Roslyn/OmniSharp-compatible LSP routing, solution/project modes, and Doom's
Sharper interface for .NET project management.

Use the project's normal commands from `M-x compile` or `M-x project-compile`:

```sh
dotnet restore
dotnet build
dotnet test
```

Install a compatible Roslyn language server or C# LS separately. `csharpier` is
optional if you want standalone C# formatting.

### Java and Spring Boot

The Java module provides Java Tree-sitter support, Android mode, Groovy/Gradle
mode, Maven/Gradle project support, Spring Initializr integration, and JDTLS
integration. This configuration explicitly starts `jdtls` through Eglot for
both `java-mode` and `java-ts-mode`.

Spring Boot itself remains a normal Maven or Gradle project. Use its wrapper so
the project chooses the correct tool version:

```sh
./mvnw test
./mvnw spring-boot:run

./gradlew test
./gradlew bootRun
```

Install a JDK and `jdtls`; keep `JAVA_HOME` project-specific with `direnv` when
different projects need different JDK versions. See the [Spring Boot project
page](https://spring.io/projects/spring-boot).

### Kotlin and Android

Kotlin support covers `.kt` and `.kts` files, Kotlin Tree-sitter, Kotlin LSP,
REPL support, and Gradle build/test commands. Android XML uses `nxml-mode` with
the configured LemMinX XML language server, while Android Java/Kotlin files use
the Java and Kotlin language support above.

For Android projects, install the Android SDK command-line tools, platform
tools, required SDK platforms/build-tools, and keep using the repository's
`gradlew` wrapper. The current machine has `adb`, but `sdkmanager` and a global
Gradle executable are not currently available. See the [Android developer
tools][android-tools].

## API requests and data files

The `rest` module turns Emacs into a small API playground. It also has jq
response filtering enabled because the `jq` command is available on this
machine. Open a `.http` file or run `M-x restclient-mode`, then write a request
such as:

```http
GET https://api.example.com/health
Accept: application/json

###

POST https://api.example.com/items
Content-Type: application/json

{"name": "demo"}
```

Put the cursor inside a request and run `M-x restclient-http-send-current`.
The response opens in a separate buffer; use the module's jq commands when you
want to filter JSON responses. This is useful for checking an API contract,
testing an ML inference endpoint, or saving a reproducible request next to a
project. The module also supports REST requests from Org Babel.

The `data` module adds CSV and XML support. Open a `.csv` file and use
`M-x csv-align-fields`, `M-x csv-sort-fields`, or `M-x csv-transpose` when you
need to inspect or reshape a small data file. For large datasets, use a proper
Python or database workflow and keep Emacs as the place where you document the
query or experiment.

## Projects and Git

### Project navigation

Try:

```text
M-x project-switch-project
M-x treemacs
M-x dired
M-x ibuffer
```

Workspaces let you keep different projects separate. Tabs, popups, folding, and
relative line numbers are already enabled. `Tramp` lets you open remote files,
for example with an `/ssh:host:/path/to/file` filename.

### Git with Magit

The most useful starting command is:

```text
M-x magit-status
```

From there you can inspect changes, stage files, commit, view history, and work
with branches. `vc-gutter` shows changed lines in the fringe, similar to a
Neovim Git signs plugin.

### Makefile tasks

If a project has a `Makefile`, run its targets with:

```text
M-x +make/run
M-x +make/run-last
```

The current system already has `make` available.

### Project environments with direnv

If a project uses `.envrc`, the `direnv` module loads its environment when you
visit the project. Use:

```text
M-x envrc-reload
M-x envrc-show
```

Review an `.envrc` before authorizing it because it runs shell code. The current
system already has `direnv` available.

## Tasks, notes, and project management with Org

Org is the biggest addition beyond a normal code editor. By default, Org files
live in `~/org/`. Set the `ORG_DIRECTORY` environment variable to use another
location. The main files are:

```text
~/org/inbox.org       quick tasks
~/org/projects.org    project tasks and notes
~/org/notes.org       general notes
~/org/journal.org     dated journal entries
```

The files do not have to exist yet. Capture can create them.

### Add and review tasks

Start with:

```text
M-x org-capture
M-x org-agenda
```

The capture menu includes personal tasks, notes, journal entries, and project
tasks. Capture quickly into the inbox, then move the item to the right project
with:

```text
M-x org-refile
```

The default task flow is:

```text
TODO -> STRT -> DONE
```

You can also use `WAIT` when someone else is blocking the task, `HOLD` when you
paused it, `PROJ` for a project heading, `LOOP` for recurring work, and `KILL`
for cancelled work. Completed tasks get a timestamp, and clocking history is
kept between Emacs sessions.

Useful time-tracking commands are:

```text
M-x org-clock-in
M-x org-clock-out
M-x org-clock-goto
```

For a recurring habit, add `:PROPERTIES:` with `STYLE: habit` to the task and
give it a schedule. It will then appear in the agenda.

### Linked notes with Org-roam

Org-roam stores connected notes in:

```text
~/org/roam/
```

Try:

```text
M-x org-roam-node-find
M-x org-roam-node-insert
M-x org-roam-buffer-toggle
M-x org-roam-graph
```

Think of it as a personal wiki: make one note per idea, link related notes,
and let Org-roam show the connections. The Emacs build here has SQLite support,
which Org-roam needs.

### Research papers and citations

The research setup uses these locations:

```text
~/org/references.bib   your BibTeX or BibLaTeX library
~/org/papers/          downloaded papers and books
~/org/roam/            linked notes and citation notes
```

Create the first two when you are ready:

```sh
mkdir -p ~/org/papers ~/org/roam
touch ~/org/references.bib
```

Then try:

```text
M-x citar-open
M-x citar-insert-citation
M-x org-cite-insert
M-x citar-create-note
```

Use `org-noter` when you want notes that stay synchronized with a PDF while
you read it:

```text
Open a PDF, then run M-x org-noter
```

The notes live in Org files, so they can contain headings, source blocks,
links, and Org-roam connections. Citar needs a real bibliography file before
it can search references; the path above is already configured for it.

### Images and attachments

With Org `+dragndrop`, drag an image or file into an Org buffer. Images can be
previewed inline, while other files become links managed by Org's attachment
system. This is useful for experiment plots, architecture screenshots, client
meeting files, and scanned paper notes.

### Calendar and presentations

For a calendar view of your Org agenda:

```text
M-x =calendar
M-x +calendar/open-calendar
```

The week starts on Monday. Google Calendar synchronization is not configured;
it needs a separate OAuth setup.

For presentations, try:

```text
M-x org-tree-slide-mode
```

The Org `+pretty` and `+present` options are enabled for a nicer writing and
presentation experience.

### Spelling

Spelling is enabled for prose and comments. Use:

```text
M-x ispell-buffer
M-x ispell-change-dictionary
```

The current machine has Hunspell but no dictionary was detected. Install an
English Hunspell dictionary before expecting spelling suggestions. The
`+everywhere` flag checks comments in programming buffers; it does not check
source-code identifiers.

## Jupyter-style notebooks

This setup uses `emacs-jupyter` through Org. The recommended notebook format is
an `.org` file containing executable Jupyter source blocks. It gives you a
notebook-like document with text, code, and saved results, without leaving
Emacs.

It does not turn `.ipynb` files into ordinary editable Org buffers. If direct
`.ipynb` editing is essential, keep using JupyterLab or add a separate notebook
frontend later.

### Install a Python kernel

Install Jupyter in a virtual environment or project environment:

```sh
# Inside an existing uv project:
uv add --dev jupyter ipykernel
uv run python -m ipykernel install --user --name editor-python

# Or for a small standalone environment:
uv venv
uv pip install jupyter ipykernel
source .venv/bin/activate
python -m ipykernel install --user --name editor-python
```

At the time this file was written, `jupyter` was not on the current system
`PATH`, so this part still needs local setup.

### Start a live kernel

```text
M-x jupyter-run-repl
M-x jupyter-connect-repl
M-x jupyter-repl-associate-buffer
```

`jupyter-run-repl` asks which installed kernel to start. You can then associate
a Python buffer with it and evaluate code interactively.

### Make an Org notebook

Create `~/org/experiment.org` and add:

```org
#+title: Experiment

#+begin_src jupyter-python :session py :kernel editor-python
import math
answer = math.sqrt(81)
answer
#+end_src
```

Put the cursor inside the block and run:

```text
M-x org-babel-execute-src-block
```

The `:session` keeps variables alive between blocks. Use `:async yes` when you
want asynchronous execution. Doom loads the Jupyter Babel integration lazily,
so you do not need extra Babel setup.

More examples are in the official project documentation:

<https://github.com/emacs-jupyter/jupyter>

## AI assistance inside Emacs

The `llm` module provides `gptel` for asking an AI model about the current
buffer, a selected region, or a project file. It is useful for explaining an
unfamiliar function, drafting tests, summarizing a traceback, or turning rough
notes into a first outline.

Try:

```text
M-x gptel
M-x gptel-menu
M-x gptel-add-file
M-x gptel-rewrite
```

The configuration deliberately disables verbose gptel request/response logs.
Keep API credentials in Emacs `auth-source` (for example an encrypted
`~/.authinfo.gpg`) rather than putting a key in `config.el` or a project file.
Do not commit credentials. A local backend such as Ollama can be configured
later if you decide to run models locally; no local model endpoint is assumed
by this setup.

Codex and OpenCode remain separate terminal workflows below. That keeps their
native approvals, sessions, and project context available while gptel is handy
for smaller in-buffer questions.

## Debugging and interactive code

### Debugging

The `debugger` module provides DAPE, which speaks the Debug Adapter Protocol:

```text
M-x +debugger/start
M-x +debugger/quit
```

You still need a debug adapter for the language you want to debug. LSP errors
and DAPE debugging are separate: LSP tells you what is wrong, while DAPE lets
you stop at breakpoints and inspect execution.

### REPLs and evaluation

The `eval` module and language modules provide interactive evaluation. Useful
general commands are:

```text
M-x eval-buffer
M-x eval-region
```

For Python, Go, Elixir, Lisp, and other languages, use the language's REPL
command when you want a persistent interactive process. Org Babel is another
way to run small experiments and keep the result next to the code.

## PDFs, diagrams, and other useful Emacs features

- `M-x pdf-tools-install` or opening a PDF uses Doom's PDF improvements.
- `plantuml` lets you draw diagrams as text. After sync, run
  `M-x plantuml-download-jar` if Java/PlantUML is not already installed.
- `latex +lsp` is ready for technical papers and LaTeX projects.
- `M-x eww` opens a small web browser inside Emacs.
- `M-x elfeed` opens the RSS reader; it is integrated with Org.
- `M-x emms` opens the media manager.
- `M-x tldr` shows short command-line help pages from the extra `tldr` package.

These are optional conveniences. You can ignore them until you have a reason to
use them.

## Practical workflows for your work

### AI/ML experiment notebook

1. Create a project with `uv init` and add the project dependencies.
2. Open an `.org` file under `~/org/` or inside the project.
3. Add `jupyter-python` source blocks with a named `:session`.
4. Execute blocks, save the results, and link the experiment to an Org-roam
   note.
5. Keep the final Python module or script in the project; use the Org file for
   explanation, parameters, plots, and conclusions.

This gives you a literate, reviewable experiment log without treating an
`.ipynb` file as source code. For direct `.ipynb` editing, use JupyterLab or a
dedicated notebook frontend.

### Remote GPU or server development

Open a remote file with a TRAMP name such as:

```text
C-x C-f /ssh:gpu-host:/srv/project/train.py
```

Run the remote project's `uv`, Python, Jupyter, LSP, and test commands on the
remote machine. If completion or diagnostics do not start, check that the
remote shell can find the language server; local Mason paths do not install
tools on the server. For long training jobs, start the process in a remote
`vterm` or `tmux` session and keep the Org experiment log local or remote as
appropriate.

### Solo-entrepreneur operating system

Use the existing Org files as a small, plain-text operating system:

- `inbox.org`: every new idea, follow-up, or commitment;
- `projects.org`: one top-level heading per client, product, or internal goal;
- `notes.org`: reusable technical and business notes;
- `journal.org`: dated decisions, calls, and daily logs.

Capture first, then refile during a daily review. Use agenda views for due
work, clocking for time spent, and `WAIT` tasks for things blocked by a client
or collaborator. For a lightweight pipeline, give each prospect a heading with
fields such as `CONTACT`, `NEXT`, `STATUS`, and `LAST_CONTACT`; this stays
searchable and versionable without forcing a CRM database into Emacs.

### Client delivery and engineering

Keep the code in Git, use Magit for review and history, use Make or project
commands for repeatable checks, and store architecture decisions or meeting
notes beside the project. Use `restclient` for API examples, PlantUML for
diagrams, PDF tools for papers and contracts, and gptel/Codex/OpenCode only
within the privacy and approval boundaries appropriate to the material.

### A useful weekly review

Run `M-x org-agenda`, clear the inbox, refile new items, mark blocked work as
`WAIT`, review project headings, and create one next action for every active
client or product. Then use `M-x magit-status` in each active repository to
close unfinished engineering work or record the next step.

## Official references

These are the references behind the workflow choices:

- [Org manual](https://orgmode.org/org.html): task management, agendas,
  project planning, literate programming, and reproducible research.
- [emacs-jupyter](https://github.com/emacs-jupyter/jupyter): Jupyter REPLs and
  executable `jupyter-LANG` Org source blocks.
- [gptel](https://github.com/karthink/gptel): in-buffer LLM interaction,
  multiple backends, and auth-source-based credentials.
- [Org-noter](https://github.com/weirdNox/org-noter): synchronized notes while
  reading PDFs and other documents.
- [Citar](https://github.com/emacs-citar/citar): bibliography search and
  Org-cite insertion with completion.
- [Emacs Projects](https://www.gnu.org/software/emacs/manual/html_node/emacs/Projects.html):
  project roots and project commands.
- [TRAMP quick start](https://www.gnu.org/software/emacs/manual/html_node/tramp/Quick-Start-Guide.html):
  remote files and commands over SSH.
- [Dape](https://github.com/svaante/dape): Debug Adapter Protocol debugging.
- [Doom official modules](https://github.com/doomemacs/modules): language and
  platform module documentation, including JavaScript, Java, C/C++, and C#.
- [React Native setup][react-native-setup]: Android and iOS build prerequisites.
- [Codex CLI](https://developers.openai.com/codex/cli/): official installation,
  authentication, and command reference.
- [OpenCode CLI](https://dev.opencode.ai/docs/cli/): the interactive TUI,
  session continuation, and non-interactive `opencode run` workflows.

[android-tools]: https://developer.android.com/tools
[react-native-setup]: https://reactnative.dev/docs/set-up-your-environment

## Codex and OpenCode

Codex and OpenCode stay in normal terminal buffers. This keeps their native
interactive behavior, approvals, and project context intact. OpenCode is
started as its normal TUI; the separate `--port` option is for explicitly
exposing a listening server and is not needed for this workflow.

Run:

```text
M-x editor-codex
M-x editor-codex-resume
M-x editor-codex-review
M-x editor-opencode
M-x editor-opencode-continue
M-x editor-codex-exec
M-x editor-opencode-run
```

Each command opens or reuses one vterm per tool and project. The project root is
used as the working directory. The `codex` and `opencode` commands must already
be available on `PATH`; the Arch dependency installer intentionally does not
install either CLI globally. Follow the upstream installation instructions and
verify them with `command -v codex opencode`. The `*-exec` and `*-run` commands
ask for one prompt and start a separate terminal buffer for that run; use them
for focused checks, summaries, or automation while the normal commands keep an
interactive session.

## If something does not work

Use this order:

1. Run `M-x doom-doctor`.
2. Check the executable with `M-x executable-find`.
3. Check the LSP log with `M-x eglot-events-buffer`.
4. Check errors with `M-x flycheck-list-errors`.
5. Confirm that the project has the expected config file, such as
   `deno.json`, `pyproject.toml`, `package.json`, or `Makefile`.

Most failures are missing external tools, not broken Emacs Lisp. The config can
route to a language server or formatter only when that program is installed.

## What the files do

- [`init.el`](init.el) chooses Doom modules and language support.
- [`config.el`](config.el) sets editing behavior, Org paths, LSP routing,
  formatters, diagnostics, and AI terminal commands.
- [`packages.el`](packages.el) adds the small extra package not supplied by a
  Doom module.
- `docs.md` is this user-friendly tour.

Only the `doom/` files in this workspace were changed. The Neovim configuration
was used as the reference and was not modified.

## What has been checked

The Elisp files pass balanced-parentheses checks, all newly enabled Doom module
paths exist in the installed Doom source, the Org settings load in a stubbed
config check, and the LSP, web/Compose routing, formatter registration,
Python executable selection, bibliography paths, gptel safety override, and
Codex/OpenCode terminal command checks pass. Markdownlint also passes.

A live `doom sync`, GUI startup, Jupyter kernel, formatter session, LSP session,
and debug-adapter session still need to be run locally because they use external
runtime state.
