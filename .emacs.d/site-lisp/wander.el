;; wanderlust
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
(require 'wl)
(require 'elmo)
(require 'mime-view)

(setq wl-from "Apsu <apsu@propter.net>")

;; IMAP
(setq elmo-imap4-default-stream-type 'starttls)
(setq elmo-imap4-default-server "mail.propter.net")
(setq elmo-imap4-default-user "apsu") 
(setq elmo-imap4-default-authenticate-type 'clear) 
(setq elmo-imap4-default-port '143)

(setq elmo-imap4-use-modified-utf7 t) 

;; SMTP
(setq wl-smtp-connection-type 'starttls)
(setq wl-smtp-posting-port 10025)
(setq wl-smtp-authenticate-type "plain")
(setq wl-smtp-posting-user "apsu")
(setq wl-smtp-posting-server "mail.propter.net")
(setq wl-local-domain "propter.net")

(setq wl-default-folder "%inbox")
(setq wl-default-spec "%")
(setq wl-draft-folder "%Drafts")
(setq wl-trash-folder "%Trash")

(setq wl-folder-check-async t)
(setq wl-biff-notify-hook '(ding))
(setq wl-biff-check-interval 20)
(setq wl-biff-check-folder-list '("%INBOX"))

(add-hook 'wl-biff-notify-hook
          '(lambda ()
            (with-current-buffer wl-current-summary-buffer
              (save-excursion
                (wl-summary-sync-update)))
            (ding)))

(setq elmo-imap4-use-modified-utf7 t)

(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

(setq wl-stay-folder-window t)

(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

(setq mime-edit-split-message nil)
(setq wl-draft-reply-buffer-style 'keep)

(setq wl-fcc-force-as-read t)

(setq wl-summary-max-thread-depth 30)

(setq elmo-message-fetch-threshold 500000)

(setq wl-prefetch-threshold 500000)

(setq wl-stay-folder-window t)
(setq wl-folder-window-width 30) ;; toggle on/off with 'i'

(mime-set-field-decoder
 'From nil 'eword-decode-and-unfold-unstructured-field-body)
(mime-set-field-decoder
 'To nil 'eword-decode-and-unfold-unstructured-field-body)

(setq mime-view-ignored-field-list '("^.*"))

(setq wl-message-visible-field-list
      (append mime-view-visible-field-list
              '("^Subject:" "^From:" "^To:" "^Cc:"
                "^X-Mailer:" "^X-Newsreader:" ; "^User-Agent:"
                "^X-Face:" "^X-Mail-Count:" "^X-ML-COUNT:"
                )))

(setq wl-message-ignored-field-list
      (append mime-view-ignored-field-list
              '(".*Received:" ".*Path:" ".*Id:" "^References:"
                "^Replied:" "^Errors-To:"
                "^Lines:" "^Sender:" ".*Host:" "^Xref:"
                "^Content-Type:" "^Content-Transfer-Encoding:"
                "^Precedence:"
                "^Status:" "^X-VM-.*:"
                "^X-Info:" "^X-PGP" "^X-Face-Version:"
                "^X-UIDL:" "^X-Dispatcher:"
                "^MIME-Version:" "^X-ML"
                "^Delivered-To:" "^Mailing-List:"
                "^ML-Name:" "^Reply-To:" "Date:"
                "^X-Loop" "^X-List-Help:"
                "^X-Trace:" "^X-Complaints-To:"
                "^Received-SPF:" "^Message-ID:"
                "^MIME-Version:" "^Content-Transfer-Encoding:"
                "^Authentication-Results:"
                "^X-Priority:" "^X-MSMail-Priority:"
                "^X-Mailer:" "^X-MimeOLE:"
                )))

(eval-after-load "mime"
  '(defadvice mime-entity-filename
     (after eword-decode-for-broken-MUA activate)
     "Decode eworded file name for *BROKEN* MUA."
     (when (stringp ad-return-value)
       (setq ad-return-value (eword-decode-string ad-return-value t)))))

(eval-after-load "std11"
  '(defadvice std11-wrap-as-quoted-string (before encode-string activate)
     "Encode a string."
     (require 'eword-encode)
     (ad-set-arg 0 (or (eword-encode-string (ad-get-arg 0)) "" )) ))

(setq elmo-msgdb-extra-fields
      (cons "content-type" elmo-msgdb-extra-fields))
(setq wl-summary-line-format-spec-alist
      (append wl-summary-line-format-spec-alist
              '((?@ (wl-summary-line-attached)))))
(setq wl-summary-line-format "%n%T%P%1@%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %s")
(add-to-list 'wl-summary-sort-specs 'rdate) ;;reverse date as default sort