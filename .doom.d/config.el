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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; ;; Prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "JetBrains Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 18))
(setq fancy-splash-image (file-name-concat doom-user-dir "splash.png"))
;; ~/.doom.d/config.el
(custom-set-faces!
  '(font-lock-comment-face :foreground "#7f8c8d"))  ;; чуть светлее

;; I install nerd-icons via nixos
(setq nerd-icons-font-names '("SymbolsNerdFontMono-Regular.ttf"))


;; Фолбэки для emoji
(dolist (charset '(symbol emoji))
  (set-fontset-font t charset
                    (font-spec :name "Apple Color Emoji")
                    nil 'prepend))
;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Implicit /g flag, because I rarely use it without
(setq evil-ex-substitute-global t)

;; Автоматический перенос строк в тексте
(global-visual-line-mode +1)
;; Включить Tree-sitter везде, где это возможно
(setq +tree-sitter-hl-enabled-modes
      '(c-mode c++-mode python-mode rust-mode markdown-mode org-mode))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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
;; ;; Автоформатирование через ruff для Python
(after! python
  (setq +format-with-lsp nil))  ;; не использовать встроенный LSP-форматтер
(set-formatter! 'ruff-format
  '("ruff" "format" "--stdin-filename" "%s" "-")
  :modes '(python-mode))

;; Rust: форматирование на сохранении
(after! rustic
  (setq rustic-format-on-save t))
(after! lsp-rust
  (setq lsp-rust-server 'rust-analyzer
        ;; point at your freshly-updated ra
        lsp-rust-analyzer-server-command '("rust-analyzer")))

(use-package! dape
  :config
  (setq dape-debugger 'lldb-dap)
  (setq dape-lldb-path "/opt/homebrew/opt/llvm/bin/lldb-dap")
  )

(setenv "PATH" (concat "/opt/homebrew/opt/llvm/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/homebrew/opt/llvm/bin")

;; (after! dap-mode
;;   (require 'dap-codelldb)

;;   (setq dap-auto-configure-features '(sessions locals controls tooltip))

;;   (dap-register-debug-template
;;    "LLDB::Run Rust"
;;    (list :type "lldb"
;;          :request "launch"
;;          :name "LLDB::Run"
;;          :miDebuggerPath "~/.cargo/bin/rust-lldb"
;;          :target nil
;;          :cwd nil
;;          :program "~/my_app/target/debug/my_app"
;;          ))
;; )

;; C/C++: аргументы clangd и автоформат через clang-format
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"))
  (set-lsp-priority! 'clangd 2))
;; форматировать через clang-format при сохранении
(add-hook 'c-mode-common-hook
          (lambda ()
            (add-hook 'before-save-hook #'lsp-format-buffer nil t)))
