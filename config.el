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
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/OrgMode/")

(after! org
  (setq org-agenda-files '("~/OrgMode" "~/OrgMode/work")))


(setq projectile-project-search-path '("~/Code/"))

(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)

(defun set-frame-opacity (opacity)
  "Set the opacity of the current frame."
  (set-frame-parameter nil 'alpha opacity))

;; Set the default opacity (90 is fairly transparent, 100 is opaque)
(set-frame-opacity 85)


;; Sets indendation of TS and JS
;; For JavaScript and JSX
(after! js2-mode
  (setq js-indent-level 2)
  (setq js2-basic-offset 2))

;; For TypeScript and TSX
(after! typescript-mode
  (setq typescript-indent-level 2))

(setq-default tab-width 2)
(setq-default evil-shift-width 2)

(defun copy-filename-and-line-number-to-clipboard ()
  "Copy the current buffer's file name and line number to the clipboard."
  (interactive)
  (let ((filename (if (buffer-file-name)
                      (file-relative-name (buffer-file-name))
                    "No file"))
        (line-number (line-number-at-pos)))
    (kill-new (format "%s:%d" filename line-number))
    (message "Copied '%s:%d' to the clipboard" filename line-number)))


(map! :leader
      :desc "Copy filename and line number"
      "y c" #'copy-filename-and-line-number-to-clipboard)

(map! :leader
      :desc "Dired jump" "f j" #'dired-jump)

(map! :leader
      :desc "Go to line"
      "f L" #'goto-line)

(defun my/org-agenda-refresh-if-open ()
  "Refresh all Org Agenda buffers if any are open."
  (when (get-buffer "*Org Agenda*") ;; Check if the Org Agenda buffer exists
    (org-agenda nil "a"))) ;; Refresh the agenda view

(add-hook 'org-mode-hook (lambda ()
                           (add-hook 'after-save-hook #'my/org-agenda-refresh-if-open nil 'make-it-local)))

;; Inside ~/.doom.d/config.el

(use-package! calfw
  :commands (cfw:open-calendar-buffer)
  :config
  (setq cfw:display-calendar-holidays nil)) ; Customize according to your preferences

(use-package! calfw-org
  :after calfw)

(after! org-pomodoro
  (setq org-pomodoro-length 25)
  (setq org-pomodoro-short-break-length 5)
  (setq org-pomodoro-long-break-length 15))

(setq org-pomodoro-finished-hook
      '((lambda ()
          (call-process "osascript" nil 0 nil "-e"
                        "display notification \"Take a short break\" with title \"Pomodoro completed\""))))
(setq org-pomodoro-short-break-finished-hook
      '((lambda ()
          (call-process "osascript" nil 0 nil "-e"
                        "display notification \"Ready for another Pomodoro?\" with title \"Short Break finished\""))))
(setq org-pomodoro-long-break-finished-hook
      '((lambda ()
          (call-process "osascript" nil 0 nil "-e"
                        "display notification \"Ready for another Pomodoro?\" with title \"Long Break finished\""))))

(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
         ((agenda "" ((org-agenda-span 'day)))
          (alltodo "")))))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)


(electric-indent-mode -1)

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
