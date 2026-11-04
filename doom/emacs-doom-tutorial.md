# Doom Emacs Tutorial and Keymap

This is a practical guide to the Doom Emacs setup in this project. It assumes:

- Doom Emacs with Evil mode
- SPC as the leader key
- Vertico and Corfu for completion
- Eglot for LSP
- Treemacs, Vterm, Magit, Org, Org-roam, Dape, and gptel

The configuration lives in this folder. On a new machine, run the bootstrap
script once:

~~~sh
bash /path/to/doom/bootstrap.sh
~~~

Use M-x doom/reload after changing config.el. Run doom sync after changing
init.el or packages.el.

## 1. The mental model

| Concept | Meaning |
| --- | --- |
| Frame | A top-level Emacs window on the desktop |
| Window | A tiled view inside a frame |
| Buffer | The editable text or process displayed in a window |
| File | A file visited by a buffer |
| Major mode | The language or document behavior of a buffer |
| Minor mode | An additional feature layered on top of the major mode |
| Minibuffer | The prompt used for commands and completion |
| Project | A directory recognized by Git or project metadata |
| Workspace | A separate collection of buffers and windows |

One file can be shown in multiple windows. Killing a buffer is not the same as
deleting its file. Saving a buffer writes its contents to the file.

## 2. Key notation

~~~text
SPC           Space, Doom's leader key
,             Comma, the local leader in language/document buffers
RET           Enter
TAB           Tab
ESC           Escape
C-x           Hold Control and press x
M-x           Hold Meta, usually Alt, and press x
<leader>      Usually SPC
<localleader> Usually ,
~~~

Most commands also have an M-x name:

~~~text
M-x magit-status
M-x project-switch-project
M-x org-agenda
~~~

If you forget a key, use these:

~~~text
C-h k       Describe the key you press next
C-h f       Describe a function
C-h v       Describe a variable
C-h m       Describe the current modes
C-h b       Show bindings for the current buffer
SPC h b t   Show top-level keymaps with which-key
SPC h d h   Open Doom documentation
SPC h r r   Reload Doom configuration
~~~

Press SPC and pause. Which-key displays available prefixes and descriptions.

## 3. Evil editing

| State | Enter with | Use for |
| --- | --- | --- |
| Normal | ESC | Navigation and operators |
| Insert | i, a, o, or O | Typing text |
| Visual | v, V, or C-v | Selecting text |
| Command | : | Ex commands such as :w and :q |

### Essential editing keys

| Key | Action |
| --- | --- |
| i | Insert before the cursor |
| a | Insert after the cursor |
| I / A | Insert at the start or end of the line |
| o / O | Open a line below or above |
| ESC | Return to Normal state |
| u | Undo |
| C-r | Redo |
| . | Repeat the last change |
| x | Delete the character under the cursor |
| dd | Delete the current line |
| D | Delete to the end of the line |
| cc / C | Change the line or to its end |
| yy | Yank, or copy, the current line |
| p / P | Paste after or before the cursor |
| J | Join the current line with the next line |
| >> / << | Indent or unindent the line |
| gcc | Comment or uncomment the current line |
| gc | Comment or uncomment a motion or selection |
| gq | Reformat a paragraph or selection |

### Movement and search

| Key | Action |
| --- | --- |
| h j k l | Left, down, up, right |
| w / b | Next or previous word |
| e | End of word |
| 0 / ^ / $ | Start, first non-space, or end of line |
| gg / G | Start or end of buffer |
| :number | Go to a line, for example :42 |
| f{char} / F{char} | Find a character forward or backward |
| t{char} | Move until a character forward |
| ; / , | Repeat or reverse a character search |
| % | Jump between matching delimiters |
| /pattern | Search forward in the buffer |
| ?pattern | Search backward in the buffer |
| n / N | Next or previous search result |
| * | Search for the symbol under the cursor |
| zz | Center the current line |

### Text objects

The general pattern is:

~~~text
operator + motion or text object
~~~

~~~text
dw       Delete to the next word
ciw      Change the inner word
di"      Delete inside double quotes
da(      Delete around parentheses
yi{      Yank inside braces
yap      Yank a paragraph
gqip     Reformat the inner paragraph
~~~

## 4. The Doom leader key

| Key | Action |
| --- | --- |
| SPC . | Find a file |
| SPC SPC | Find a file in the current project |
| SPC , | Switch buffers |
| SPC followed by backtick | Switch to the last buffer |
| SPC / | Search the current project |
| SPC * | Search the project for the symbol at point |
| SPC : | Run M-x |
| SPC ; | Evaluate an Emacs Lisp expression |
| SPC x | Toggle the scratch buffer |
| SPC h | Open help commands |
| SPC q q | Quit Emacs |
| SPC q r | Restart Emacs |

The leader is a prefix. For example, SPC f f means Space, f, f.

## 5. Files and buffers

### Files

| Key | Action |
| --- | --- |
| SPC f f | Find a file |
| SPC f F | Find a file relative to the current directory |
| SPC f r | Open a recent file |
| SPC f R | Rename or move the current file |
| SPC f s | Save the current file |
| SPC f S | Save as another file |
| SPC f d | Open a directory in Dired |
| SPC f y | Copy the absolute file path |
| SPC f Y | Copy the path relative to the project |
| SPC f p | Open a file in the private Doom config |
| SPC f P | Browse the private Doom config |

Built-in alternatives are C-x C-f to find a file, C-x C-s to save, and C-x C-w
to save as another file.

### Oil-like directory management

`SPC f d` opens the current directory in Dired/Dirvish. The enhanced view
supports previews, icons, sorting, and a `?` action menu. The configured normal
state keys are:

| Key | Action |
| --- | --- |
| a | Create a directory |
| m / u / U | Mark, unmark, or clear marks |
| c | Copy the marked entries |
| r | Rename or move the marked entries |
| d / x | Mark entries for deletion, then delete them |
| C-c C-e | Edit filenames in place; finish with C-c C-c |
| h / l | Go to the parent directory or open the entry |
| ? | Open Dirvish's action and preview menu |

For a move or copy, mark one or more files/directories with `m`, press `r` or
`c`, and enter the destination. Moving a directory works the same way as
moving a file. `q` closes the directory buffer; it does not quit Emacs.

### Buffers

| Key | Action |
| --- | --- |
| SPC b b | Switch buffers in the current workspace |
| SPC b B | Switch buffers without workspace filtering |
| SPC b i | Open Ibuffer |
| SPC b n / SPC b p | Next or previous buffer |
| SPC b l | Switch to the last buffer |
| SPC b d | Kill the current buffer |
| SPC b K | Kill all buffers |
| SPC b O | Kill all other buffers |
| SPC b r | Revert the buffer from disk |
| SPC b R | Rename the buffer |
| SPC b s | Save the buffer |
| SPC b S | Save all modified buffers |
| SPC b x | Open the scratch buffer |
| SPC b m | Set a bookmark |

Traditional Emacs equivalents include C-x b to switch buffers, C-x k to kill
one, and C-x C-b to open Ibuffer.

### Global font size

Font scaling is global, so existing and newly opened buffers use the same size:

| Key | Action |
| --- | --- |
| C-, / C-= / C-+ | Increase text size |
| C-- / C-. | Decrease text size |
| C-0 | Reset text size |

## 6. Searching and navigation

This setup uses Vertico and consult-style minibuffer interfaces where available.

| Key | Action |
| --- | --- |
| SPC / | Search the current project with ripgrep |
| SPC s p | Search the current project |
| SPC s b | Search the current buffer |
| SPC s B | Search all open buffers |
| SPC s d | Search the current directory |
| SPC s D | Search another directory |
| SPC s . | Search for the symbol at point in the project |
| SPC s i | Jump to a symbol or heading in the current buffer |
| SPC s I | Jump to a symbol in open buffers |
| SPC s f | Locate a file by name |
| SPC s l | Jump to a visible link |
| SPC s m | Jump to a bookmark |
| SPC s o | Look up the symbol online |
| SPC followed by apostrophe | Resume the last completion or search |

Inside a Vertico prompt:

| Key | Action |
| --- | --- |
| C-n / C-p | Next or previous candidate |
| RET | Choose the candidate |
| C-g | Cancel the prompt |
| TAB | Complete or inspect the candidate |
| M-RET | Use an alternative action when available |

## 7. Projects

Open a file from a Git repository and Doom will normally recognize the project
root. You can also run M-x project-switch-project.

| Key | Action |
| --- | --- |
| SPC p p | Switch projects |
| SPC p f | Find a file in the project |
| SPC p s | Search the project |
| SPC p b | Switch to a project buffer |
| SPC p c | Compile the project |
| SPC p T | Run project tests |
| SPC p R | Run the project |
| SPC p ! | Run a shell command at the project root |
| SPC p & | Run an asynchronous shell command at the project root |
| SPC p k | Kill project buffers |
| SPC p i | Invalidate the project file cache |
| SPC p r | Open recent project files |
| SPC p . | Search for the symbol at point in the project |
| SPC p x | Toggle the project scratch buffer |

SPC SPC is the fastest project file picker. SPC / is the fastest project text
search.

## 8. Windows and workspaces

### Windows

The standard Evil window prefix is C-w:

| Key | Action |
| --- | --- |
| C-w h/j/k/l | Move to the left, below, above, or right window |
| C-w s | Split horizontally and follow the new window |
| C-w v | Split vertically and follow the new window |
| C-w d | Delete the current window |
| C-w o | Enlarge the current window |
| C-w m m | Maximize the current buffer |
| C-w u | Undo the previous window layout |
| C-w C-r | Redo the window layout |
| C-w H/J/K/L | Move the current window |
| C-w C-w | Move to the next window |
| C-w C-S-w | Swap two windows with a prompt |

SPC w opens the same window map, so SPC w h, SPC w v, and similar combinations
are also available.

### Workspaces

| Key | Action |
| --- | --- |
| SPC TAB n | Create a workspace |
| SPC TAB N | Create a named workspace |
| SPC TAB . | Switch workspace |
| SPC TAB 1 through SPC TAB 9 | Switch to a numbered workspace |
| SPC TAB 0 | Switch to the final workspace |
| SPC TAB ] / SPC TAB [ | Next or previous workspace |
| SPC TAB r | Rename workspace |
| SPC TAB s | Save workspace |
| SPC TAB l | Load workspace |
| SPC TAB d | Delete the current workspace |
| SPC w d | Display workspaces |
| SPC w c | Create a workspace |
| SPC w o | Switch to another workspace |
| SPC w p / SPC w n | Move left or right |

## 9. Treemacs and terminals

| Key | Action |
| --- | --- |
| SPC o p | Toggle the Treemacs project sidebar |
| SPC o P | Find the current file in Treemacs |
| F9 | Toggle Treemacs |
| C-F9 | Find the current file in Treemacs |
| SPC o t | Toggle a Vterm popup |
| SPC o T | Open Vterm in the current location |
| SPC o e | Toggle an Eshell popup |
| SPC o E | Open Eshell in the current location |
| SPC o r | Open a language REPL in another window |
| SPC o R | Open a language REPL in the current window |

Vterm is a real terminal emulator. Eshell is an Emacs shell written in Elisp;
it is especially useful for Emacs commands, buffers, and file operations.

## 10. LSP and code navigation

This configuration uses Eglot. When you open a supported file, Doom attempts to
start the configured language server automatically.

| Key | Action |
| --- | --- |
| gd | Go to definition |
| gD | Find references |
| K | Show documentation or hover help |
| gf | Visit the file at point |
| gI | Find implementations |
| SPC c d | Go to definition |
| SPC c D | Find references |
| SPC c k | Show documentation |
| SPC c i | Find implementations |
| SPC c t | Go to type definition |
| SPC c j | Search symbols in the current workspace |
| SPC c r | Rename the symbol at point |
| SPC c a | Run code actions |
| SPC c x | Show diagnostics |
| SPC c f | Format the buffer or region |

Useful commands:

~~~text
M-x eglot                 Start or manage Eglot
M-x eglot-shutdown        Stop the current language server
M-x eglot-reconnect       Reconnect to the language server
M-x eglot-events-buffer   Inspect the JSON-RPC event log
M-x eglot-rename          Rename a symbol
M-x eglot-code-actions    Run available code actions
M-x flycheck-list-errors  Show diagnostics
M-x doom-doctor           Check Doom and external dependencies
~~~

If completion is missing, check the executable used by the language server:

~~~text
M-x executable-find RET basedpyright-langserver RET
M-x executable-find RET typescript-language-server RET
M-x executable-find RET gopls RET
~~~

## 11. Evaluation and REPL-driven development

The evaluation module is enabled. The exact REPL command depends on the major
mode, but the workflow is the same: start a REPL, send code to it, inspect the
result, and keep editing the source buffer.

| Key | Action |
| --- | --- |
| SPC e | Evaluate the current line or region |
| SPC ; | Evaluate an Emacs Lisp expression in the minibuffer |
| SPC c e | Evaluate the current buffer or region |
| SPC c E | Evaluate the region and replace it with the result |
| SPC c s | Send the buffer or region to the REPL |
| SPC o r | Open the REPL in another window |
| SPC o R | Open the REPL in the current window |
| M-r | Evaluate the current buffer |
| gr | Evaluate the selected region |
| gR | Evaluate the current buffer |

For Emacs Lisp:

~~~text
C-x C-e   Evaluate the expression before point
M-:       Evaluate an expression in the minibuffer
~~~

For Clojure, enable the Clojure language module in doom/init.el and run
doom sync before expecting a CIDER workflow. The current configuration has
Clojure commented out, so this is an optional addition.

## 12. Formatting, compilation, and tests

| Key | Action |
| --- | --- |
| SPC c f | Format the current buffer or region |
| gQ | Format the current region in Normal mode |
| SPC c c | Compile or run a build command |
| SPC c C | Re-run the last compilation command |
| SPC p c | Compile the project |
| SPC p T | Run project tests |
| M-x compile | Run a command and show its output |
| M-x recompile | Repeat the last compilation command |
| M-x +make/run | Select and run a Make target |
| M-x +make/run-last | Run the last Make target again |

Compilation output is navigable. In a compilation buffer, press RET on an error
to jump to the reported file and line.

## 13. Git with Magit

Magit is the main Git interface in this setup.

| Key | Action |
| --- | --- |
| SPC g g | Open Magit status |
| SPC g G | Open Magit status for the current directory |
| SPC g b | Switch branches |
| SPC g c c | Create a commit |
| SPC g c b | Create and switch to a branch |
| SPC g S | Stage the current file |
| SPC g U | Unstage the current file |
| SPC g B | Blame the current file or revision |
| SPC g F | Fetch from remotes |
| SPC g C | Clone a repository |
| SPC g L | Show the log for the current file |
| SPC g f f | Find a file in the repository |
| SPC g f c | Show a commit |
| SPC g o o | Open the current file or region on the remote |
| SPC g o r | Browse the remote repository |
| SPC g / | Open Magit dispatch |
| SPC g t | Toggle Git time machine |
| SPC g [ | Previous changed hunk |
| SPC g ] | Next changed hunk |
| SPC g s | Stage the hunk at point |
| SPC g r | Revert the hunk at point |

Inside a Magit status buffer:

| Key | Action |
| --- | --- |
| TAB | Expand or collapse the item at point |
| s | Stage the item |
| u | Unstage the item |
| c c | Create a commit |
| P p | Push the current branch |
| F p | Pull from the remote |
| b b | Switch branches |
| l l | View commit history |
| RET | Visit the file or commit at point |
| q | Quit the Magit buffer |

## 14. Org mode, tasks, and notes

The configuration uses `~/org/` by default. Set the `ORG_DIRECTORY`
environment variable to choose a different location. The files are:

~~~text
~/org/inbox.org       Quick capture inbox
~/org/projects.org    Projects and project tasks
~/org/notes.org       General notes
~/org/journal.org     Journal entries
~/org/roam/           Org-roam linked notes
~~~

### Doom Org commands

| Key | Action |
| --- | --- |
| SPC n n | Capture a task or note |
| SPC n a | Open the Org agenda |
| SPC n N | Go to the last capture target |
| SPC n f | Find a note |
| SPC n F | Browse the notes directory |
| SPC n s | Search notes |
| SPC n S | Search Org agenda headlines |
| SPC n t | Show the TODO list |
| SPC n c | Toggle the last active clock |
| SPC n C | Cancel the current clock |
| SPC n o | Jump to the active clock |
| SPC n l | Store an Org link |
| SPC n m | Search by Org tags |
| SPC n r f | Find an Org-roam node |
| SPC n r i | Insert a link to an Org-roam node |
| SPC n r r | Toggle the Org-roam buffer |
| SPC n r g | Show the Org-roam graph |
| SPC n r n | Capture an Org-roam node |
| SPC n r s | Sync the Org-roam database |

### Org editing

| Key | Action |
| --- | --- |
| TAB | Cycle the current heading |
| S-TAB | Cycle all headings in the buffer |
| M-RET | Insert a new heading at the same level |
| M-S-RET | Insert a new TODO heading |
| C-c C-t | Change TODO state |
| C-c C-s | Schedule the heading |
| C-c C-d | Add a deadline |
| C-c C-c | Recalculate, update, or apply the element at point |
| C-c C-x C-i | Clock in |
| C-c C-x C-o | Clock out |
| C-c C-o | Open the link at point |
| C-c C-l | Insert or edit a link |
| M-LEFT / M-RIGHT | Promote or demote a heading |
| M-UP / M-DOWN | Move a heading up or down |

## 15. AI assistance with gptel

The Doom LLM module is enabled. Keep credentials in Emacs auth-source, not in
config.el or a repository.

| Key | Action |
| --- | --- |
| SPC o l l | Open gptel |
| SPC o l L | Open gptel in the current window |
| SPC o l s | Send the current prompt |
| SPC o l e | Explain the selected text or current context |
| SPC o l r | Rewrite the selected text |
| SPC o l a | Add text to the gptel context |
| SPC o l f | Add a file to the gptel context |
| SPC o l m | Open the gptel menu |
| SPC o l o | Set an Org topic |
| SPC o l O | Set Org properties |

Treat model output as a draft. Review commands, code, citations, and external
actions before accepting them.

## 16. Debugging with Dape

Dape provides Debug Adapter Protocol support when the relevant debugger and
adapter are installed.

| Key | Action |
| --- | --- |
| SPC d d | Start or select a debug session |
| SPC d b | Toggle a breakpoint |
| SPC d B | Remove all breakpoints |
| SPC d c | Continue |
| SPC d p | Pause |
| SPC d n | Step over |
| SPC d s | Step in |
| SPC d o | Step out |
| SPC d r | Restart |
| SPC d i | Show debug information |
| SPC d R | Open the debug REPL |
| SPC d x | Evaluate an expression |
| SPC d w | Add or inspect a watch expression |
| SPC d D | Disconnect and quit |
| SPC d q | Quit the debug session |

## 17. Toggles and utilities

| Key | Action |
| --- | --- |
| SPC t l | Toggle line numbers |
| SPC t w | Toggle soft line wrapping |
| SPC t r | Toggle read-only mode |
| SPC t f | Toggle Flycheck diagnostics |
| SPC t F | Toggle fullscreen |
| SPC t I | Toggle indentation style |
| SPC t b | Toggle the large presentation font |
| SPC t c | Toggle the fill-column indicator |
| SPC t s | Toggle spell checking |
| SPC v n | Jump to the next Git hunk |
| SPC v p | Jump to the previous Git hunk |
| SPC v s | Stage the current hunk |
| SPC v r | Revert the current hunk |
| SPC v t | Toggle Git time machine |

## 18. A normal coding workflow

### Start a project

1. Launch Emacs with the correct DOOMDIR.
2. Press SPC p p and select the project.
3. Press SPC SPC and open a file.
4. Press SPC o p if you want the Treemacs sidebar.

### Edit and navigate code

1. Use gd to inspect a definition.
2. Use gD to find references.
3. Use K to read documentation.
4. Use SPC c a for code actions.
5. Use SPC c f to format.
6. Use SPC c x to inspect diagnostics.

### Search and change multiple files

1. Press SPC /.
2. Enter a search term.
3. Select a result and press RET.
4. Use SPC s b for a quick search within the current buffer.

### Run and test

1. Open a terminal with SPC o t.
2. Run the project command, or use SPC p T for the project test command.
3. Use SPC c c or M-x compile for a compilation buffer.
4. Press RET on an error to jump to the source location.

### Review and commit

1. Press SPC g g.
2. Review changed files with TAB.
3. Stage a file with s or a hunk with SPC g s from the source buffer.
4. Press c c in Magit and write a commit message.
5. Press P p to push only when you intend to update the remote.

## 19. Configuration and maintenance

| Task | Command |
| --- | --- |
| Reload config.el | M-x doom/reload or SPC h r r |
| Reload the theme | SPC h r t |
| Reload packages | SPC h r p |
| Reload environment | SPC h r e |
| Run diagnostics | M-x doom-doctor |
| Show Doom version | M-x doom/version |
| Open private Doom config | SPC f P |
| Sync after module/package changes | bash /path/to/doom/bootstrap.sh |

The bootstrap script detects or installs Doom core, then syncs this profile:

~~~sh
bash /path/to/doom/bootstrap.sh
~~~

Change config.el for behavior and keybindings. Change init.el when enabling or
disabling Doom modules. Change packages.el when adding packages. Run doom sync
after init.el or packages.el changes.

## 20. When a key does not work

Keybindings can depend on the current major mode, minor modes, and whether the
cursor is in a minibuffer, popup, terminal, Magit buffer, or Org buffer.

Use this sequence:

~~~text
C-h k KEY                  Find what a key currently does
C-h m                      List active modes
C-h b                      Show local and global bindings
SPC h b t                  Show top-level keymaps
M-x apropos-command        Search commands by name
M-x which-key-show-keymap  Inspect a keymap
M-x doom-doctor            Check Doom and external tools
~~~

If a key is unavailable, run the underlying command directly with M-x. For
example, use M-x projectile-ripgrep instead of SPC /, or M-x magit-status
instead of SPC g g.

## 21. A small learning plan

Learn these first:

~~~text
ESC, i, a, o, u, C-r, dd, yy, p, /, n, gg, G
SPC SPC, SPC /, SPC f s, SPC b b
SPC w h/j/k/l, C-w s, C-w v, C-w d
SPC c d, SPC c D, SPC c f, SPC c x
SPC g g, SPC o t, SPC n n, SPC n a
~~~

Then add one workflow at a time:

1. Project navigation and search.
2. LSP navigation and diagnostics.
3. Magit review and commits.
4. Org capture and agenda.
5. REPL-driven evaluation.
6. Workspaces and debugging.

You do not need to memorize the entire keymap. In Doom, the leader key and M-x
are the two escape hatches: SPC shows the organized command tree, and M-x lets
you search for a command by name.
