(setq tramp-shell-prompt-pattern "^[^$>\n]*[#$%>] *\\(\[[0-9;]*[a-zA-Z] *\\)*")
(setq tramp-default-proxies-alist nil)
(add-to-list 'tramp-default-proxies-alist
             '(".*" "\\`root\\'" "/ssh:%h:"))