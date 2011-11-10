(setq inhibit-startup-message    t)  ; Don't want any startup message

; Backup file creation
(setq make-backup-files t)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying-when-linked t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq search-highlight           t)  ; Highlight search object
(setq query-replace-highlight    t)  ; Highlight query object
(setq mouse-sel-retain-highlight t)  ; Keep mouse highlighting

; Hide menubar
(menu-bar-mode -1)

; Hide the toolbar
(tool-bar-mode -1)

; Hide the scrollbar
(scroll-bar-mode -1)

; Region highlighting without key clobbering
(cua-mode)
(setq-default cua-enable-cua-keys nil)
(global-set-key (kbd "C-^") 'cua-set-rectangle-mark) ; C-^ because urxvt won't emit C-<Return>

; Load theme!
(require 'color-theme)
(load-library "color-theme")
(load-library "color-theme-library")
(color-theme-dark-laptop)

; Line numbers!
(require 'linum)
(global-linum-mode)
(setq linum-disabled-modes-list '(term-mode wl-summary-mode compilation-mode))
(defun linum-on ()
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
    (linum-mode 1)))

; Buffer cycling
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "M-p") 'previous-buffer)

; Window cycle helpers
(defun goto-next-window nil
  (interactive)
  (select-window (next-window)))

(defun goto-prev-window nil
  (interactive)
  (select-window (previous-window)))

; Window cycling
(global-set-key (kbd "C-M-n") 'goto-next-window)
(global-set-key (kbd "C-M-p") 'goto-prev-window)

; Term mode cycling too!
(add-hook 'term-mode-hook
	  (lambda ()
	    (define-key term-raw-map (kbd "M-n") 'next-buffer)
	    (define-key term-raw-map (kbd "M-p") 'previous-buffer)
            (define-key term-raw-map (kbd "C-M-n") 'goto-next-window)
            (define-key term-raw-map (kbd "C-M-p") 'goto-prev-window)))

; Regexp i-search
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)

; Because it's awesome
(global-set-key (kbd "C-.") 'repeat)

; Load magit
(autoload 'magit-status "magit" nil t)

; Load haskell
(autoload 'haskell-mode "haskell-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.hs\\'" . haskell-mode) auto-mode-alist))

; Load markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md\\'" . markdown-mode) auto-mode-alist))

; PDF bindings ftw
(require 'doc-view)
(define-key doc-view-mode-map (kbd "C-v") 'doc-view-scroll-up-or-next-page)
(define-key doc-view-mode-map (kbd "M-v") 'doc-view-scroll-down-or-previous-page)
(setq doc-view-continuous t)

; Rationalize file-buffer names
(require 'uniquify)

; Column numbers!
(setq column-number-mode t)

; Never use tabs
(setq-default indent-tabs-mode nil)

(defun kill-temp-buffer nil
  (setq name (buffer-name))
  (when (equal major-mode 'dired-mode) ; Kill old direds
    (kill-buffer))
  (when (equal major-mode 'calendar-mode) ; Kill old calendars
    (kill-buffer))
  (when (string-match "\*.+\*" name)
    (when (not (string-match "org\\|terminal\\|server\\|minibuf\\|scratch" name)) ; except
;    (when (string-match "Messages\\|Completions\\|Help\\|Buffer List" name)
      (kill-buffer))))

(defun kill-temp-buffers nil
  "Kill temporary buffers."
  (interactive)
  (save-excursion
    (setq windows (window-list nil t)) ; Get all windows in frame (visible)
    (setq buffers (buffer-list)) ; Get all buffers
    (dolist (window windows) ; For each window
      (setq buffers (remove (window-buffer window) buffers))) ; Skip buffers in windows
    (dolist (buffer buffers) ; For each buffer
      (set-buffer buffer)
      (kill-temp-buffer))))

; Blows up on a few obscure things still, can't autorun all the time
;(run-at-time nil 10 'kill-temp-buffers)

; Use keybinding instead
(global-set-key (kbd "C-M-k") 'kill-temp-buffers)

; Org Mode
(setq org-log-done 'time)
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode)))

(let ((default-directory "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(load "python")
;(load "erlang")
(load "tramp")
(load "wander")
(load "rainbow-delimiters")
