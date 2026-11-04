;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

;; Themes available from `M-x editor-select-theme'. These are all provided by
;; doom-themes, so switching them does not add another package dependency.
(defconst editor-themes
  '(;; Deep and colorful dark themes.
    doom-tokyo-night
    doom-city-lights
    doom-dracula
    doom-nord-aurora
    doom-ayu-mirage
    doom-horizon
    doom-moonlight
    doom-palenight
    doom-snazzy
    doom-outrun-electric
    doom-laserwave
    doom-spacegrey
    doom-nova
    doom-monokai-pro
    doom-monokai-ristretto
    doom-monokai-spectrum
    doom-challenger-deep
    doom-peacock
    doom-material-dark
    doom-plain-dark
    doom-solarized-dark
    doom-solarized-dark-high-contrast
    doom-tomorrow-night
    doom-winter-is-coming-dark-blue
    doom-xcode
    doom-bluloco-dark
    doom-acario-dark
    doom-feather-dark
    doom-pine
    doom-rouge
    doom-sourcerer
    doom-old-hope
    doom-vibrant
    doom-1337
    doom-dark+
    doom-ephemeral
    doom-badger
    doom-miramare
    doom-henna
    ;; Calm and light themes.
    doom-nord
    doom-ayu-light
    doom-gruvbox
    doom-gruvbox-light
    doom-material
    doom-one
    doom-one-light
    doom-solarized-light
    doom-nord-light
    doom-bluloco-light
    doom-acario-light
    doom-feather-light
    doom-flatwhite
    doom-opera-light
    doom-oksolar-light
    doom-tomorrow-day
    doom-winter-is-coming-light
    doom-plain
    doom-homage-white
    doom-zenburn)
  "Themes offered by the personal theme switcher.")

(require 'cl-lib)

(defun editor--theme-symbol ()
  "Return the currently configured theme symbol."
  (if (symbolp doom-theme)
      doom-theme
    (car doom-theme)))

(defun editor-load-theme (theme)
  "Disable active themes and load THEME."
  (interactive
   (list
    (intern
     (completing-read
      "Theme: "
      (mapcar #'symbol-name editor-themes)
      nil t
      (symbol-name (editor--theme-symbol))))))
  (unless (memq theme editor-themes)
    (user-error "%s is not in editor-themes" theme))
  (mapc #'disable-theme custom-enabled-themes)
  (setq doom-theme theme)
  (load-theme theme t)
  (message "Loaded theme: %s" theme))

(defun editor-select-theme (theme)
  "Interactively select one of the configured themes."
  (interactive
   (list
    (intern
     (completing-read
      "Select theme: "
      (mapcar #'symbol-name editor-themes)
      nil t
      (symbol-name (editor--theme-symbol))))))
  (editor-load-theme theme))

(defun editor-cycle-theme (&optional backwards)
  "Load the next configured theme; with BACKWARDS, load the previous one."
  (interactive "P")
  (let* ((current (editor--theme-symbol))
         (index (or (cl-position current editor-themes) -1))
         (step (if backwards -1 1))
         (theme (nth (mod (+ index step) (length editor-themes))
                     editor-themes)))
    (editor-load-theme theme)))

(map! :leader
      :desc "Select theme" "t t" #'editor-select-theme
      :desc "Next theme" "t n" #'editor-cycle-theme
      :desc "Previous theme" "t p" (cmd! (editor-cycle-theme t)))

;; Make font-size changes global instead of buffer-local. `C-,' is an alias
;; for increase because it is convenient on this keyboard; the familiar Doom
;; `C-=', `C--', and `C-0' controls work globally as well.
(require 'face-remap)
(map! :g
      "C-," (cmd! (global-text-scale-adjust 1))
      "C-=" #'global-text-scale-adjust
      "C-+" #'global-text-scale-adjust
      "C--" #'global-text-scale-adjust
      "C-." (cmd! (global-text-scale-adjust -1))
      "C-0" #'global-text-scale-adjust)
(map! :nvi
      "C-," (cmd! (global-text-scale-adjust 1))
      "C-=" #'global-text-scale-adjust
      "C-+" #'global-text-scale-adjust
      "C--" #'global-text-scale-adjust
      "C-." (cmd! (global-text-scale-adjust -1))
      "C-0" #'global-text-scale-adjust)

;; Replace Doom's default splash image with a personal dashboard banner.
(defun editor--dashboard-banner ()
  (propertize
   (string-join
    '("=================     ===============     ===============   ========  ========"
      "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //"
      "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/. . . .||"
      "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||"
      "||. . ||   || . .|| ||. . ||   || . .|| || . . ||   || . .|| || . | . . . . .||"
      "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||"
      "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||"
      "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||"
      "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||"
      "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||"
      "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||"
      "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||"
      "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||"
      "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||"
      "||   .=='    _-'          '-__\\._-'         '-_./__-'         `' |. /|  |   ||"
      "||.=='    _-'                                                     `' |  /==.||"
      "=='    _-'                         A H S A N                          \\/   `=="
      "\\   _-'                                                                `-_   /"
      " `''                                                                      ``'")
    "\n")
   'face '+dashboard-banner))
(setq fancy-splash-image nil
      +dashboard-ascii-banner-fn #'editor--dashboard-banner)

;; Make the modeline an information hub instead of only a thin status bar.
;; The stock dashboard modeline omits the project and VCS segments, so the
;; current branch disappears as soon as no file buffer is open.  Keep Doom's
;; normal VCS segment for file buffers, and add a cached project branch segment
;; for dashboards and other directory-backed buffers.
(after! doom-modeline
  (setq doom-modeline-height 28
        doom-modeline-bar-width 4
        doom-modeline-window-width-limit 85
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-project-detection 'project
        doom-modeline-project-name t
        doom-modeline-workspace-name nil
        doom-modeline-persp-name nil
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-buffer-encoding 'nondefault
        doom-modeline-indent-info nil
        doom-modeline-enable-buffer-position t
        doom-modeline-total-line-number nil
        doom-modeline-selection-info nil
        doom-modeline-enable-word-count nil
        doom-modeline-minor-modes nil
        doom-modeline-lsp t
        doom-modeline-repl nil
        doom-modeline-spell nil
        doom-modeline-env-version nil
        doom-modeline-check 'simple
        doom-modeline-vcs-max-length 24
        doom-modeline-time t
        doom-modeline-time-icon t
        doom-modeline-battery nil)

  (setq display-time-24hr-format t
        display-time-format "%H:%M")
  (display-time-mode 1)

  (defvar editor--project-branch-cache (make-hash-table :test #'equal))
  (defconst editor--no-project-branch :editor-no-project-branch)

  (defun editor--git-command-output (directory &rest args)
    "Return trimmed output from Git ARGS in DIRECTORY, or nil on failure."
    (when (executable-find "git")
      (with-temp-buffer
        (when (zerop (apply #'process-file "git" nil t nil
                            "-C" directory args))
          (let ((output (string-trim (buffer-string))))
            (unless (string-empty-p output)
              output))))))

  (defun editor--git-branch-name (directory)
    "Return the branch at DIRECTORY, including a short detached HEAD marker."
    (or (editor--git-command-output directory "branch" "--show-current")
        (when-let ((commit (editor--git-command-output
                            directory "rev-parse" "--short" "HEAD")))
          (format "detached@%s" commit))))

  (defun editor--project-branch-name (directory)
    "Return the cached Git branch for DIRECTORY, if it is in a repository."
    (when (and directory
               (not (file-remote-p directory))
               (file-directory-p directory))
      (when-let ((root (locate-dominating-file
                        (file-name-as-directory (expand-file-name directory))
                        ".git")))
        (let* ((root (file-name-as-directory (expand-file-name root)))
               (cached (gethash root editor--project-branch-cache
                                editor--no-project-branch)))
          (if (eq cached editor--no-project-branch)
              (let ((branch (or (editor--git-branch-name root)
                                editor--no-project-branch)))
                (puthash root branch editor--project-branch-cache)
                (unless (eq branch editor--no-project-branch)
                  branch))
            (unless (eq cached editor--no-project-branch)
              cached))))))

  (defun editor--refresh-project-branch-cache (&rest _)
    "Refresh cached project branches and redraw every modeline."
    (clrhash editor--project-branch-cache)
    (force-mode-line-update t))

  (doom-modeline-def-segment editor-project-branch
    "Display the current project branch for buffers without a file."
    (when (and (not buffer-file-name) default-directory)
      (when-let ((branch (editor--project-branch-name default-directory)))
        (let* ((face (doom-modeline-face 'doom-modeline-vcs-default))
               (text (if (and doom-modeline-vcs-max-length
                              (> (length branch) doom-modeline-vcs-max-length))
                         (concat (substring branch 0
                                             (- doom-modeline-vcs-max-length 3))
                                 doom-modeline-ellipsis)
                       branch)))
          (concat (doom-modeline-spc)
                  (propertize
                   (concat
                    (doom-modeline-vcs-icon "nf-dev-git_branch" "" "@"
                                             face)
                    (unless doom-modeline--limited-width-p
                      (concat (doom-modeline-vspc)
                              (propertize text 'face face))))
                   'help-echo (format "Project branch: %s" branch)
                   'mouse-face 'doom-modeline-highlight)
                  (doom-modeline-spc))))))

  ;; Put the branch in the ordinary modeline for scratch, vterm, Dired, and
  ;; other directory-backed buffers, while file buffers retain Doom's richer
  ;; branch/status segment.
  (doom-modeline-def-modeline 'main
    '(bar window-number modals buffer-info remote-host buffer-position)
    '(compilation misc-info project-name editor-project-branch lsp
      buffer-encoding major-mode process vcs check time))

  (doom-modeline-def-modeline 'special
    '(bar window-number modals buffer-info remote-host buffer-position)
    '(compilation misc-info project-name editor-project-branch lsp
      buffer-encoding major-mode process check time))

  (doom-modeline-def-modeline 'project
    '(bar window-number modals buffer-default-directory-simple remote-host)
    '(compilation misc-info project-name editor-project-branch major-mode process
      check time))

  (doom-modeline-def-modeline 'dashboard
    '(bar window-number modals buffer-default-directory-simple remote-host)
    '(compilation project-name editor-project-branch major-mode check time))

  (doom-modeline-def-modeline 'vcs
    '(bar window-number modals buffer-info remote-host buffer-position)
    '(compilation misc-info project-name editor-project-branch major-mode
      process check time))

  ;; Magit and Doom's buffer-switch/revert hooks cover branch changes made
  ;; inside Emacs. A small timer handles a branch changed from an external
  ;; terminal while the dashboard is still visible.
  (add-hook 'after-revert-hook #'editor--refresh-project-branch-cache)
  (add-hook 'doom-switch-buffer-hook #'editor--refresh-project-branch-cache)
  (after! magit
    (add-hook 'magit-post-refresh-hook #'editor--refresh-project-branch-cache))
  (unless (timerp (bound-and-true-p editor--project-branch-refresh-timer))
    (setq editor--project-branch-refresh-timer
          (run-with-timer
           3 3
           (lambda ()
             (when (get-buffer (or (and (boundp '+dashboard-name)
                                         +dashboard-name)
                                     "*doom*"))
               (editor--refresh-project-branch-cache)))))))

;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Use quiet vertical guides instead of visible whitespace glyphs such as `›'
;; for tabs and `·' for spaces.  Trailing whitespace is still cleaned up by
;; ws-butler from the `whitespace +trim' module.
(after! whitespace
  (remove-hook 'after-change-major-mode-hook
               #'+whitespace-highlight-incorrect-indentation-h)
  (remove-hook 'editorconfig-after-apply-functions
               #'+whitespace-highlight-incorrect-indentation-again-h)
  (defun editor--disable-whitespace-glyphs-h ()
    "Disable visible whitespace glyphs in the current buffer."
    (when (bound-and-true-p whitespace-mode)
      (whitespace-mode -1)))
  ;; Run after Doom's whitespace hook, and also clean up buffers that already
  ;; existed when this configuration was reloaded.
  (add-hook 'after-change-major-mode-hook
            #'editor--disable-whitespace-glyphs-h 100)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (editor--disable-whitespace-glyphs-h))))

;; Dired + Dirvish provide an Oil.nvim-like file manager without leaving Emacs.
;; Mark entries first, then use the short actions below to create, copy, move,
;; rename, or delete files and directories. `C-c C-e' opens editable filenames.
(after! dired
  (setq dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        dired-create-destination-dirs 'ask)
  (map! :map dired-mode-map
        :n "a" #'dired-create-directory
        :n "c" #'dired-do-copy
        :n "r" #'dired-do-rename
        :n "d" #'dired-flag-file-deletion
        :n "x" #'dired-do-flagged-delete
        :n "m" #'dired-mark
        :n "u" #'dired-unmark
        :n "U" #'dired-unmark-all-marks
        :n "h" #'dired-up-directory
        :n "l" #'dired-find-file
        :n "g r" #'revert-buffer
        :n "C-c C-e" #'wdired-change-to-wdired-mode))

(after! dirvish
  ;; Keep the same actions in the enhanced Dirvish view. Its `?' dispatch menu
  ;; remains available for previews, sorting, layouts, links, and path tools.
  (map! :map dirvish-mode-map
        :n "a" #'dired-create-directory
        :n "c" #'dired-do-copy
        :n "r" #'dired-do-rename
        :n "d" #'dired-flag-file-deletion
        :n "x" #'dired-do-flagged-delete
        :n "m" #'dired-mark
        :n "u" #'dired-unmark
        :n "U" #'dired-unmark-all-marks
        :n "C-c C-e" #'wdired-change-to-wdired-mode))

;; Keep indentation guides simple, thin, and low-contrast across themes.
(after! indent-bars
  (setq indent-bars-prefer-character nil
        indent-bars-width-frac 0.10
        indent-bars-color-by-depth nil
        indent-bars-color '(font-lock-comment-face :face-bg nil :blend 0.15)
        indent-bars-highlight-current-depth nil
        indent-bars-display-on-blank-lines 'least))

;; Keep source text literal: display `function', `=>', `!=', and other
;; operators exactly as they are written instead of replacing them with glyphs.
(when (fboundp '+ligatures-init-extra-symbols-h)
  (remove-hook 'after-change-major-mode-hook #'+ligatures-init-extra-symbols-h))
(when (fboundp 'global-ligature-mode)
  (global-ligature-mode -1))
(dolist (buffer (buffer-list))
  (with-current-buffer buffer
    (when (bound-and-true-p ligature-mode)
      (ligature-mode -1))
    (when (bound-and-true-p prettify-symbols-mode)
      (prettify-symbols-mode -1))))

;; Keep the editing defaults close to the Neovim configuration. Doom/Evil
;; remains in charge of keybindings; these are behavior and display settings.
(setq-default tab-width 2
              indent-tabs-mode nil
              fill-column 120
              truncate-lines nil)
(setq scroll-margin 8
      scroll-conservatively 101
      sentence-end-double-space nil)

;; Reuse the language servers and formatters already installed by the Neovim
;; setup when Mason is present, without making Mason a Doom dependency.
(let ((mason-bin (expand-file-name "~/.local/share/nvim/mason/bin/")))
  (when (file-directory-p mason-bin)
    (add-to-list 'exec-path mason-bin)
    (setenv "PATH" (concat mason-bin path-separator (getenv "PATH")))))

;; Org is the project-management and knowledge layer. Doom supplies the
;; capture, agenda, clocking, refiling, project-local capture, and Babel
;; defaults; these settings make the storage layout explicit and predictable.
;; `org-directory' must be set before org loads. Allow each machine to select
;; its storage location with ORG_DIRECTORY, and use ~/org by default.
(setq org-directory
      (file-name-as-directory
       (or (getenv "ORG_DIRECTORY")
           (expand-file-name "~/org/")))
      org-agenda-files
      (mapcar (lambda (file) (expand-file-name file org-directory))
              '("inbox.org" "projects.org" "notes.org" "journal.org"))
      +org-capture-todo-file "inbox.org"
      +org-capture-notes-file "notes.org"
      +org-capture-journal-file "journal.org"
      +org-capture-projects-file "projects.org"
      org-roam-directory (expand-file-name "roam/" org-directory)
      org-babel-python-command
      (if (executable-find "python") "python" "python3")
      org-log-done 'time
      org-log-into-drawer t
      org-use-fast-todo-selection 'expert
      org-enforce-todo-dependencies t
      org-enforce-todo-checkbox-dependencies t
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-modules '(org-habit)
      calendar-week-start-day 1)

(after! org
  (add-hook! 'org-mode-hook #'visual-line-mode)
  (add-hook! 'org-mode-hook #'org-indent-mode))

;; Keep research files in one predictable place. Create the bibliography and
;; papers directory when you start using Citar; they are not created here.
(setq editor-bibliography-file (expand-file-name "references.bib" org-directory)
      editor-bibliography-library-path (expand-file-name "papers/" org-directory))

(after! citar
  (setq citar-bibliography (list editor-bibliography-file)
        citar-library-paths (list editor-bibliography-library-path)
        citar-notes-paths (list org-roam-directory)
        org-cite-global-bibliography (list editor-bibliography-file)))

(after! org-noter
  (setq org-noter-default-notes-file-names '("notes.org" "Notes.org")
        org-noter-notes-search-path (list org-roam-directory org-directory)))

;; Jupyter results can be shown inline when the backend provides a text/plain
;; representation; rich images and HTML remain available in the REPL/output
;; buffer. The Org +jupyter module loads the Babel integration lazily.
(after! jupyter
  (setq jupyter-eval-use-overlays t))

;; Doom's LLM module enables verbose gptel logging by default. Keep prompts and
;; responses out of the log; API keys still come from auth-source.
(after! gptel
  (setq gptel-log-level nil
        gptel-default-mode 'org-mode))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(when-let* ((runtime-dir (getenv "XDG_RUNTIME_DIR"))
            (env-file (expand-file-name "ssh-agent.env" runtime-dir)))
  (when (file-readable-p env-file)
    (condition-case nil
        (with-temp-buffer
          (insert-file-contents-literally env-file)
          (when (re-search-forward
                 "^[[:space:]]*\\(?:export[[:space:]]+\\)?SSH_AUTH_SOCK=\\(.+\\)$"
                 nil t)
            (let* ((value (string-trim (match-string 1)))
                   (socket (string-trim (car (split-string value ";" t)))))
              (setq socket
                    (replace-regexp-in-string
                     "\\`['\"]\\|['\"]\\'" "" socket))
              (when (file-exists-p socket)
                (setenv "SSH_AUTH_SOCK" socket)))))
      (error nil))))

;; Major modes for file types that are covered by the Neovim configuration but
;; do not have a dedicated Doom language module.
(define-derived-mode editor-prisma-mode prog-mode "Prisma")
(define-derived-mode editor-templ-mode prog-mode "Templ")
(define-derived-mode editor-bicep-mode prog-mode "Bicep")
(define-derived-mode editor-brightscript-mode prog-mode "BrightScript")

(dolist (entry
         '(("\\.blade\\.php\\'" . web-mode)
           ("\\.astro\\'" . astro-ts-mode)
           ("\\.svelte\\'" . web-mode)
           ("\\.vue\\'" . web-mode)
           ("\\.jsx\\'" . tsx-ts-mode)
           ("\\.razor\\'" . web-mode)
           ("\\.cshtml\\'" . web-mode)
           ("\\.gql\\'" . graphql-mode)
           ("\\.graphql\\'" . graphql-mode)
           ("\\.rest\\'" . restclient-mode)
           ("\\.jsonc\\'" . json-mode)
           ("\\.mdx\\'" . markdown-mode)
           ("\\.hcl\\'" . terraform-mode)
           ("\\.prisma\\'" . editor-prisma-mode)
           ("\\.templ\\'" . editor-templ-mode)
           ("\\.bicep\\'" . editor-bicep-mode)
           ("\\.brs\\'" . editor-brightscript-mode)
           ("\\.bs\\'" . editor-brightscript-mode)
           ("\\.tfvars\\'" . terraform-mode)))
  (add-to-list 'auto-mode-alist entry))

;; Astro components combine TypeScript, HTML, CSS, and Astro template syntax.
;; Use the dedicated Tree-sitter mode instead of treating them as generic web
;; buffers. The package supplies the pinned Astro grammar recipe; Doom provides
;; the common TypeScript and CSS grammar infrastructure.
(use-package! astro-ts-mode
  :demand t
  :config
  (setq astro-ts-mode-indent-offset 2))

;; REST and GraphQL requests can live in .http or .rest files. Doom's REST
;; module sends the request under point and opens the response in a popup;
;; GraphQL is just a POST with a JSON body, so this also covers GraphQL APIs.

;; Use an embedded WebKit browser when this Emacs was built with Xwidgets.
;; The current system Emacs was built without them, so fall back to the normal
;; browser until Emacs is rebuilt with --with-xwidgets.
(defun editor--xwidget-webkit-available-p ()
  "Return non-nil when this graphical Emacs can embed WebKit pages."
  (and (display-graphic-p)
       (require 'xwidget nil t)
       (featurep 'xwidget-internal)))

(defun editor-browse-url (url &optional external)
  "Open URL inside Emacs when possible, or in the system browser.
With a prefix argument EXTERNAL, always use the system browser."
  (interactive
   (list (read-string "URL: " (or (thing-at-point 'url t) ""))
         current-prefix-arg))
  (if (and (not external) (editor--xwidget-webkit-available-p))
      (xwidget-webkit-browse-url url t)
    (browse-url-default-browser url)
    (unless external
      (message "This Emacs has no Xwidgets; opened the system browser"))))

(map! :leader
      :desc "Open URL in WebKit/browser" "o b" #'editor-browse-url)

;; Eglot is the single LSP client. Doom's language modules start it for their
;; standard modes; these entries cover the extra servers and file types from
;; the Neovim setup.
(defun editor--typescript-sdk-directory-p (directory)
  "Return non-nil when DIRECTORY contains a usable TypeScript SDK."
  (and directory
       (file-directory-p directory)
       (or (file-readable-p (expand-file-name "typescript.js" directory))
           (file-readable-p (expand-file-name "tsserverlibrary.js" directory)))))

(defun editor--typescript-sdk-path ()
  "Find the TypeScript SDK directory for the current project or system."
  (let* ((root (or (locate-dominating-file default-directory "deno.json")
                   (locate-dominating-file default-directory "deno.jsonc")
                   (locate-dominating-file default-directory "deno.lock")
                   (locate-dominating-file default-directory "package.json")
                   default-directory))
         (tsc-sdk
          (when-let ((tsc (executable-find "tsc")))
            (expand-file-name "../lib"
                              (file-name-directory (file-truename tsc)))))
         (candidates
          (delq nil
                (list (expand-file-name "node_modules/typescript/lib" root)
                      (expand-file-name ".vscode/pnpify/typescript/lib" root)
                      (expand-file-name ".yarn/sdks/typescript/lib" root)
                      (expand-file-name ".pnpm/sdks/typescript/lib" root)
                      tsc-sdk
                      "/usr/lib/node_modules/typescript/lib"
                      "/usr/local/lib/node_modules/typescript/lib"))))
    (seq-find #'editor--typescript-sdk-directory-p candidates)))

(defun editor--typescript-contact (_interactive _project)
  (if (or (locate-dominating-file default-directory "deno.json")
          (locate-dominating-file default-directory "deno.jsonc")
          (locate-dominating-file default-directory "deno.lock"))
      (let ((tsdk (editor--typescript-sdk-path)))
        (unless tsdk
          (user-error
           "Deno LSP needs a TypeScript SDK; install TypeScript or add node_modules/typescript"))
        `("deno" "lsp"
          :initializationOptions (:typescript (:tsdk ,tsdk))))
    (eglot-alternatives '(("typescript-language-server" "--stdio")))))

(defun editor--astro-language-server-command ()
  "Return a project-local or global Astro language-server command, if found."
  (let* ((root (or (locate-dominating-file default-directory "package.json")
                   default-directory))
         (local (expand-file-name "node_modules/.bin/astro-ls" root)))
    (cond ((file-executable-p local) (list local "--stdio"))
          ((executable-find "astro-ls") '("astro-ls" "--stdio")))))

(defun editor--astro-eglot-contact (_interactive _project)
  "Return the Astro language-server command for the current project."
  (or (editor--astro-language-server-command)
      (user-error
       "Install @astrojs/language-server in this Astro project first")))

(defun editor--astro-eglot-ensure ()
  "Start Eglot for Astro only when the project has its language server."
  (when (editor--astro-language-server-command)
    (eglot-ensure)))

(after! eglot
  ;; Prefer the same server choices as Neovim where the executable exists,
  ;; while retaining portable fallbacks for machines without Mason.
  (set-eglot-client! '(python-mode python-ts-mode)
                     '("basedpyright-langserver" "--stdio")
                     '("pyright-langserver" "--stdio"))
  (set-eglot-client! '(java-mode java-ts-mode)
                     '("jdtls"))
  (set-eglot-client! '(php-mode php-ts-mode)
                     '("intelephense" "--stdio")
                     '("phpactor" "language-server"))
  (set-eglot-client! '(html-mode html-ts-mode)
                     '("vscode-html-language-server" "--stdio")
                     '("html-languageserver" "--stdio"))
  (set-eglot-client! '(markdown-mode markdown-ts-mode)
                     '("marksman" "server")
                     '("vscode-markdown-language-server" "--stdio"))
  (set-eglot-client! '(erlang-mode erlang-ts-mode)
                     '("elp" "server"))
  (set-eglot-client! '(kotlin-mode kotlin-ts-mode)
                     '("intellij-server" "--stdio")
                     '("kotlin-language-server"))
  (set-eglot-client! '(csharp-mode csharp-ts-mode)
                     '("roslyn" "--stdio")
                     '("roslyn_ls" "--stdio")
                     '("csharp-ls")
                     '("omnisharp" "-lsp"))
  (set-eglot-client!
   '((js-mode :language-id "javascript")
     (js-ts-mode :language-id "javascript")
     (tsx-ts-mode :language-id "typescriptreact")
     (typescript-mode :language-id "typescript")
     (typescript-ts-mode :language-id "typescript"))
   #'editor--typescript-contact)
  (set-eglot-client! 'astro-ts-mode #'editor--astro-eglot-contact)
  (set-eglot-client! '(graphql-mode graphql-ts-mode)
                     '("graphql-lsp" "server" "-m" "stream"))
  (set-eglot-client! '((editor-prisma-mode :language-id "prisma"))
                     '("prisma-language-server" "--stdio"))
  (set-eglot-client! '((editor-templ-mode :language-id "templ"))
                     '("templ" "lsp"))
  (set-eglot-client! '((editor-bicep-mode :language-id "bicep"))
                     '("bicep-lsp" "--stdio"))
  (set-eglot-client! '((editor-brightscript-mode :language-id "brightscript"))
                     '("bsc" "--lsp"))
  (set-eglot-client! 'sql-mode
                     '("sqruff" "lsp"))
  (set-eglot-client! '((conf-toml-mode :language-id "toml")
                       (toml-ts-mode :language-id "toml"))
                     '("taplo" "lsp" "stdio")
                     '("tombi" "lsp"))
  (set-eglot-client! '((nxml-mode :language-id "xml")
                       (xml-mode :language-id "xml"))
                     '("lemminx"))
  (dolist (hook '(editor-prisma-mode-local-vars-hook
                  editor-templ-mode-local-vars-hook
                  editor-bicep-mode-local-vars-hook
                  editor-brightscript-mode-local-vars-hook
                  sql-mode-local-vars-hook
                  java-mode-local-vars-hook
                  java-ts-mode-local-vars-hook
                  nxml-mode-local-vars-hook
                  xml-mode-local-vars-hook))
    (add-hook hook #'eglot-ensure 'append)))

(add-hook 'astro-ts-mode-hook #'editor--astro-eglot-ensure 'append)

;; web-mode is used for embedded web formats. Select the matching server
;; before Doom's web +lsp hook calls eglot-ensure.
(defun editor--web-eglot-server ()
  (let* ((file (or buffer-file-name ""))
         (language-id
          (cond ((string-suffix-p ".astro" file t) "astro")
                ((string-suffix-p ".svelte" file t) "svelte")
                ((string-suffix-p ".vue" file t) "vue")
                ((or (string-suffix-p ".razor" file t)
                     (string-suffix-p ".cshtml" file t))
                 "razor")
                ((string-suffix-p ".blade.php" file t) "php")
                (t "html")))
         (command
          (cond ((string-suffix-p ".astro" file t)
                 '("astro-ls" "--stdio"))
                ((string-suffix-p ".svelte" file t)
                 '("svelteserver" "--stdio"))
                ((string-suffix-p ".vue" file t)
                 '("vue-language-server" "--stdio"))
                ((or (string-suffix-p ".razor" file t)
                     (string-suffix-p ".cshtml" file t))
                 '("roslyn" "--stdio"))
                ((string-suffix-p ".blade.php" file t)
                 '("intelephense" "--stdio"))
                (t '("vscode-html-language-server" "--stdio")))))
    (setq-local eglot-server-programs
                `((((web-mode :language-id ,language-id)) . ,command)))))
(add-hook 'web-mode-local-vars-hook #'editor--web-eglot-server)

;; Doom's Docker module handles Dockerfiles, but Compose files are YAML. Route
;; only Compose filenames to the Compose server; all other YAML keeps yaml-ls.
(defun editor--compose-eglot-contact (_interactive _project)
  (require 'eglot)
  (eglot-alternatives
   '(("docker-compose-langserver" "--stdio")
     ("yaml-language-server" "--stdio"))))

(defun editor--compose-eglot-server ()
  (when (and buffer-file-name
             (string-match-p
              "\\`\\(?:docker-compose\\|compose\\)\\(?:[-.][^.]+\\)*\\.ya?ml\\'"
              (file-name-nondirectory (file-truename buffer-file-name))))
    (setq-local eglot-server-programs
                `((,major-mode . ,#'editor--compose-eglot-contact)))))
(dolist (hook '(yaml-mode-local-vars-hook yaml-ts-mode-local-vars-hook))
  (add-hook hook #'editor--compose-eglot-server))

;; Standalone formatters mirror the explicit Conform mappings in Neovim. The
;; format module falls back to the active LSP formatter when one is available.
(after! apheleia
  ;; Use every configured formatter on save, including modes Doom disables by
  ;; default. Buffers without a registered formatter remain unchanged.
  (setq +format-on-save-disabled-modes nil)

  (set-formatter! 'editor-prettier
    '("prettier" "--stdin-filepath" filepath)
    :modes '(html-mode html-ts-mode web-mode css-mode css-ts-mode scss-mode
             js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode
             json-mode json-ts-mode markdown-mode markdown-ts-mode
             graphql-mode graphql-ts-mode vue-mode svelte-mode))
  ;; HTML language servers may return partial or conservative edits. Run
  ;; Prettier's HTML parser over the complete buffer instead.
  (set-formatter! 'editor-prettier-html
    '("prettier" "--stdin-filepath" filepath "--parser=html")
    :modes '(html-mode html-ts-mode))
  (set-formatter! 'editor-blade-formatter
    '("blade-formatter" "--stdin"))
  (set-formatter! 'editor-ruff
    '("ruff" "format" "--stdin-filename" filepath "-")
    :modes '(python-mode python-ts-mode))
  (set-formatter! 'editor-stylua '("stylua" "-")
    :modes '(lua-mode lua-ts-mode))
  (set-formatter! 'editor-goimports '("goimports")
    :modes '(go-mode go-ts-mode))
  (set-formatter! 'editor-erlfmt '("erlfmt" "-")
    :modes '(erlang-mode erlang-ts-mode))
  (set-formatter! 'editor-google-java-format
    '("google-java-format" "--stdin" "--stdout")
    :modes '(java-mode java-ts-mode))
  (set-formatter! 'editor-ocamlformat
    '("ocamlformat" "-" "--name" filepath)
    :modes '(tuareg-mode caml-mode))
  (set-formatter! 'editor-clang-format
    '("clang-format" "-assume-filename" filepath)
    :modes '(c-mode c-ts-mode c++-mode c++-ts-mode objc-mode cuda-mode cuda-ts-mode))
  (set-formatter! 'editor-rustfmt
    '("rustfmt" "--emit" "stdout")
    :modes '(rustic-mode rust-mode rust-ts-mode))
  (set-formatter! 'editor-taplo '("taplo" "fmt" "-")
    :modes '(conf-toml-mode toml-ts-mode)))

;; Choose a complete-file formatter after Eglot has initialized. This prevents
;; the +lsp formatter from replacing Prettier in HTML/web buffers while keeping
;; Blade, Vue, and Svelte file handling intact.
(defun editor--web-formatter ()
  "Select the complete-file formatter for the current web buffer."
  (when (eq major-mode 'web-mode)
    (let ((file (or buffer-file-name "")))
      (setq-local apheleia-formatter
                  (cond ((string-suffix-p ".blade.php" file t)
                         'editor-blade-formatter)
                        ((member (downcase (or (file-name-extension file) ""))
                                 '("html" "htm" "xhtml"))
                         'editor-prettier-html)
                        (t 'editor-prettier))))))
(add-hook 'web-mode-hook #'editor--web-formatter)

(defun editor--html-formatter ()
  "Select full-buffer Prettier formatting for HTML buffers."
  (setq-local apheleia-formatter 'editor-prettier-html))
(dolist (hook '(html-mode-hook html-ts-mode-hook))
  (add-hook hook #'editor--html-formatter))

;; `:q' closes the current buffer. Keep `:qa' available for quitting Emacs.
(after! evil
  (evil-ex-define-cmd "q[uit]" #'kill-current-buffer))

;; Flycheck is provided by :checkers syntax. Keep Eglot diagnostics and Doom's
;; native CLI checkers available together, matching the Neovim LSP + lint setup.
(after! flycheck
  (setq flycheck-idle-change-delay 1.0
        flycheck-display-errors-delay 0.3
        flycheck-eglot-exclusive nil)
  (when (fboundp 'global-flycheck-eglot-mode)
    (global-flycheck-eglot-mode +1)))

;; Codex and OpenCode stay terminal-first, matching the Neovim setup without
;; introducing a second keybinding scheme. Invoke them through M-x in the
;; current project; the working directory is inherited from project.el.
(defun editor--ai-project-root ()
  (or (when-let* ((project (project-current nil)))
        (project-root project))
      default-directory))

(defun editor--ai-buffer-name (tool root)
  (format "*%s:%s*"
          tool
          (replace-regexp-in-string
           "[^[:alnum:]_.-]+" "_"
           (directory-file-name (abbreviate-file-name root)))))

(defun editor--ai-terminal (tool command)
  (require 'vterm)
  (let* ((root (file-name-as-directory (expand-file-name (editor--ai-project-root))))
         (program (car (split-string command)))
         (buffer-name (editor--ai-buffer-name tool root))
         (existing (get-buffer buffer-name)))
    (unless (executable-find program)
      (user-error "%s is not on PATH" program))
    (let ((default-directory root))
      (let ((buffer (or existing (vterm buffer-name))))
        (when existing
          (pop-to-buffer existing))
        (with-current-buffer buffer
          (unless (vterm-check-proc (current-buffer))
            (user-error "The %s terminal process is not running" tool))
          ;; Reuse the project buffer and do not start a nested process when the
          ;; command is invoked again.
          (unless (bound-and-true-p editor--ai-command-started)
            (setq-local editor--ai-command-started t)
            (vterm-send-string command)
            (vterm-send-return)))))))

(defun editor-codex ()
  "Open Codex CLI in a vterm rooted at the current project."
  (interactive)
  (editor--ai-terminal "codex" "codex"))

(defun editor-codex-resume ()
  "Resume the most recent Codex CLI session in a project vterm."
  (interactive)
  (editor--ai-terminal "codex-resume" "codex resume --last"))

(defun editor-codex-review ()
  "Review uncommitted project changes with Codex CLI."
  (interactive)
  (editor--ai-terminal "codex-review" "codex review --uncommitted"))

(defun editor-opencode ()
  "Open OpenCode in a vterm rooted at the current project."
  (interactive)
  (editor--ai-terminal "opencode" "opencode"))

(defun editor-opencode-continue ()
  "Continue the previous OpenCode session in a project vterm."
  (interactive)
  (editor--ai-terminal "opencode-continue" "opencode --continue"))

(defun editor--ai-one-shot-terminal (tool command)
  "Run COMMAND in a new project-rooted vterm buffer for TOOL."
  (require 'vterm)
  (let* ((root (file-name-as-directory (expand-file-name (editor--ai-project-root))))
         (program (car (split-string command)))
         (buffer-name (generate-new-buffer-name
                       (editor--ai-buffer-name tool root))))
    (unless (executable-find program)
      (user-error "%s is not on PATH" program))
    (let ((default-directory root))
      (let ((buffer (vterm buffer-name)))
        (pop-to-buffer buffer)
        (with-current-buffer buffer
          (unless (vterm-check-proc (current-buffer))
            (user-error "The %s terminal process is not running" tool))
          (vterm-send-string command)
          (vterm-send-return))))))

(defun editor-opencode-run (prompt)
  "Run a one-shot OpenCode PROMPT in the current project."
  (interactive "sOpenCode prompt: ")
  (editor--ai-one-shot-terminal
   "opencode-run"
   (format "opencode run %s" (shell-quote-argument prompt))))

(defun editor-codex-exec (prompt)
  "Run a one-shot Codex PROMPT in the current project."
  (interactive "sCodex prompt: ")
  (editor--ai-one-shot-terminal
   "codex-exec"
   (format "codex exec %s" (shell-quote-argument prompt))))
