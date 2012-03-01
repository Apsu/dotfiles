;; Backup file creation
(setq make-backup-files t)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying-when-linked t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq inhibit-startup-message    t)  ; Don't want any startup message
(setq search-highlight           t)  ; Highlight search object
(setq query-replace-highlight    t)  ; Highlight query object
(setq mouse-sel-retain-highlight t)  ; Keep mouse highlighting

;; Hide bars, if they exist
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Region highlighting without key clobbering
(cua-mode)
(setq-default cua-enable-cua-keys nil)
(global-set-key (kbd "C-^") 'cua-set-rectangle-mark) ; C-^ because urxvt won't emit C-<Return>

;; Load theme!
(require 'color-theme)
(load-library "color-theme")
(load-library "color-theme-library")
(color-theme-dark-laptop)

;; Line numbers!
(require 'linum)
(global-linum-mode)
(setq linum-disabled-modes-list '(term-mode wl-summary-mode compilation-mode))
(defun linum-on ()
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
    (linum-mode 1)))

;; Buffer cycling
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "M-p") 'previous-buffer)

;; Window cycle helpers
(defun goto-next-window nil
  (interactive)
  (select-window (next-window)))

(defun goto-prev-window nil
  (interactive)
  (select-window (previous-window)))

;; Window cycling
(global-set-key (kbd "C-M-n") 'goto-next-window)
(global-set-key (kbd "C-M-p") 'goto-prev-window)

;; Term mode cycling too!
(add-hook 'term-mode-hook
          (lambda ()
            (define-key term-raw-map (kbd "M-n") 'next-buffer)
            (define-key term-raw-map (kbd "M-p") 'previous-buffer)
            (define-key term-raw-map (kbd "C-M-n") 'goto-next-window)
            (define-key term-raw-map (kbd "C-M-p") 'goto-prev-window)))

;; Regexp i-search
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)

;; Because it's awesome
(global-set-key (kbd "C-.") 'repeat)

;; Load magit
(autoload 'magit-status "magit" nil t)

;; Load haskell
(autoload 'haskell-mode "haskell-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.hs\\'" . haskell-mode) auto-mode-alist))

;; Load markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md\\'" . markdown-mode) auto-mode-alist))

(add-hook 'markdown-mode-hook
          (lambda ()
            (define-key markdown-mode-map (kbd "M-n") 'next-buffer)
            (define-key markdown-mode-map (kbd "M-p") 'previous-buffer)))

;; PDF bindings ftw
(require 'doc-view)
(define-key doc-view-mode-map (kbd "C-v") 'doc-view-scroll-up-or-next-page)
(define-key doc-view-mode-map (kbd "M-v") 'doc-view-scroll-down-or-previous-page)
(setq doc-view-continuous t)

;; Rationalize file-buffer names
(require 'uniquify)

;; Column numbers!
(setq column-number-mode t)

;; Never use tabs
(setq-default indent-tabs-mode nil)

;; Make M-f/b/d/bkspc not suck!
(require 'thingatpt)
(global-set-key "\M-f" 'forward-same-syntax)
(global-set-key "\M-b"
                (lambda()
                  (interactive)
                  (forward-same-syntax -1)))
(defun kill-syntax (&optional arg) "Kill ARG sets of syntax characters after point."
  (interactive "p")
  (let ((opoint (point)))
    (forward-same-syntax arg)
    (kill-region opoint (point))))
(global-set-key "\M-d" 'kill-syntax)
(global-set-key [(meta backspace)]
                (lambda()
                  (interactive)
                  (kill-syntax -1)))

;; Not quite working yet; will deprecate kill-temp-buffer(s) eventually
(defun my-next-buffer nil
  (interactive)
  (save-excursion
    (let ((buffer (current-buffer)))
      (switch-to-buffer (other-buffer buffer t))
      (when (string-match "\*.+\*" (buffer-name (car buffers)))
        (setq buffers (cdr buffers))))
    (when (not (eq (car buffers) (current-buffer)))
      (switch-to-buffer buffer)
      (bury-buffer buffer))))

(defun kill-temp-buffer nil
  (setq name (buffer-name))
  (when (equal major-mode 'dired-mode) ; Kill old direds
    (kill-buffer))
  (when (equal major-mode 'calendar-mode) ; Kill old calendars
    (kill-buffer))
  (when (string-match "\*.+\*" name)
    (when (not (string-match "org\\|terminal\\|server\\|minibuf\\|scratch" name)) ; except
    ;;(when (string-match "log\\|messages\\|completion\\|help\\|buffer" name)
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

;; Blows up on a few obscure things still, can't autorun all the time
;;(run-at-time nil 10 'kill-temp-buffers)

;; Use keybinding instead
(global-set-key (kbd "C-M-k") 'kill-temp-buffers)

;; Org Mode
(setq org-log-done 'time)
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode)))

;; Set WM_URGENT hint if in X
(defun x-urgency-hint (frame arg &optional source)
  (let* ((wm-hints (append (x-window-property "WM_HINTS" frame "WM_HINTS" source nil t) nil))
         (flags (car wm-hints)))
    (setcar wm-hints
            (if arg
                (logior flags #x00000100)
              (logand flags #xFFFFFEFF)))
    (x-change-window-property "WM_HINTS" wm-hints frame "WM_HINTS" 32 t)))

;; Talk to xsel if in console
(setq x-select-enable-clipboard t)
(unless window-system
  (when (getenv "DISPLAY")
    ;; Callback for when user cuts
    (defun xsel-cut-function (text &optional push)
      ;; Insert text to temp-buffer, and "send" content to xsel stdin
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
    ;; Call back for when user pastes
    (defun xsel-paste-function()
      ;; Find out what is current selection by xsel. If it is different
      ;; from the top of the kill-ring (car kill-ring), then return
      ;; it. Else, nil is returned, so whatever is in the top of the
      ;; kill-ring will be used.
      (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
        (unless (string= (car kill-ring) xsel-output)
          xsel-output )))
    ;; Attach callbacks to hooks
    (setq interprogram-cut-function 'xsel-cut-function)
    (setq interprogram-paste-function 'xsel-paste-function)
    ))

;; Setup site-lisp
(let ((default-directory "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(load "python")
(load "erlang")
(load "tramp-init")
(load "wander")
(load "rainbow-delimiters")
(load "android-mode")
(load "smooth-scrolling")

;; android-mode
(require 'android-mode)
(setq android-mode-sdk-dir "~/workspace/android-sdk-linux")

(require 'smooth-scrolling)