;; Diamond Emacs for Mac
;;
;; Diamond config started in 2022

(use-package auto-package-update
  :defer 0.2
  :ensure t
  :commands update-packages
  :custom
  (auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-maybe)
  )

(use-package gcmh
  :ensure t
  :demand t
  :config
  (gcmh-mode 1)
  )

(use-package org-auto-tangle
  :defer t
  :ensure t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t)
  )

(use-package no-littering
  :ensure t
  :demand t
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (setq custom-file (no-littering-expand-etc-file-name "packages.el"))
  (when (fboundp 'startup-redirect-eln-cache)
    (startup-redirect-eln-cache
     (convert-standard-filename
      (expand-file-name  "var/eln-cache/" user-emacs-directory))))
  )

(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (setq helm-split-window-in-side-p t
        helm-mode-to-line-cycle-in-source t)
  (helm-ff-icon-mode 1)
  (helm-mode 1)
  :bind(
        ("C-x b" . helm-buffers-list)
        ("C-x r b" . helm-bookmarks)
        ("C-x C-f" . helm-find-files)
        ("C-s" . helm-occur)
        ("M-x" . helm-M-x)
        ("M-y" . helm-show-kill-ring))
  )

(use-package savehist
  :ensure t
  :init
  (savehist-mode)
  )

(use-package all-the-icons
  :ensure t
  )

(use-package all-the-icons-dired
  :ensure t
  :defer t
  :hook
  (dired-mode . all-the-icons-dired-mode)
  )

(use-package solaire-mode
  :defer 0.5
  :ensure t
  :hook (after-init . solaire-global-mode)
  )

(use-package dashboard
  :ensure t
  :init
  (add-hook 'dashboard-mode-hook (lambda () (setq show-trailing-whitespace nil)))
  (progn
    (setq dashboard-items '((recents . 8)
                            (bookmarks . 5)))
    (setq dashboard-center-content t)
    (setq dashboard-set-init-info t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-startup-banner "~/.emacs.d/etc/banner/diamond_dogs.png")
    (setq dashboard-banner-logo-title "[ D I A M O N D   E M A C S ]")
    (setq dashboard-set-navigator t)

    ;; Format: "(icon title help action face prefix suffix)"
    (setq dashboard-navigator-buttons
          `(;; line1
            ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
              "Diamond Git"
              "Diamond homepage"
              (lambda (&rest _) (browse-url "https://github.com/MacPapo/Diamond-Emacs")))
             (,(all-the-icons-material "update" :height 1.1 :v-adjust -0.2)
              "Update"
              "Update Packages"
              (lambda (&rest _) (auto-package-update-now)))
             (,(all-the-icons-material "flag" :height 1.1 :v-adjust -0.2)
              "Report bug"
              "Report a bug"
              (lambda (&rest _) (browse-url "https://github.com/MacPapo/Diamond-Emacs/issues/new")))
             )
            ))

    (setq dashboard-footer-messages '("Vim! Ahahah, it’s only one of the many Emacs modes!  CIT. Master of the Masters"))
    (setq dashboard-footer-icon (all-the-icons-octicon "flame"
                                                       :height 1.1
                                                       :v-adjust -0.02
                                                       :face 'font-lock-keyword-face))
    )
  :config
  (
   dashboard-setup-startup-hook)
  )

(use-package winum
  :defer 0.5
  :ensure t
  :custom
  (winum-auto-setup-mode-line t)
  :config
  (winum-mode)
  :bind (
         ("M-1" . winum-select-window-1)
         ("M-2" . winum-select-window-2)
         ("M-3" . winum-select-window-3)
         ("M-4" . winum-select-window-4)
         ("M-5" . winum-select-window-5)
         ("M-6" . winum-select-window-6))
  )

(use-package magit
  :commands magit-file-delete
  :defer 0.5
  :ensure t
  :init
  (setq magit-auto-revert-mode nil)  ; we do this ourselves further down
  ;; Must be set early to prevent ~/.emacs.d/transient from being created
  :config
  (setq transient-default-level 5
        magit-diff-refine-hunk t ; show granular diffs in selected hunk
        ;; Don't autosave repo buffers. This is too magical, and saving can
        ;; trigger a bunch of unwanted side-effects, like save hooks and
        ;; formatters. Trust the user to know what they're doing.
        magit-save-repository-buffers nil
        ;; Don't display parent/related refs in commit buffers; they are rarely
        ;; helpful and only add to runtime costs.
        magit-revision-insert-related-refs nil)

  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode)

  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status))
  )

(use-package org-modern
  :ensure t
  :config
  (global-org-modern-mode)
  )

(use-package olivetti
  :defer 1
  :ensure t
  :bind ("C-M-z" . olivetti-mode)
  )

(use-package vterm
  :ensure t)

(use-package vterm-toggle
  :ensure t
  :defer t
  :bind
  ("C-c v" . vterm-toggle)
  )

(use-package eshell
  :ensure t
  :defer t
  :hook
  ;; (eshell-load . (lambda ()
  ;;                       (eshell-git-prompt-use-theme 'multiline2)))
  (eshell-mode . (lambda ()
                   (add-to-list 'eshell-visual-commands "rclone")
                   (add-to-list 'eshell-visual-commands "ssh")
                   (add-to-list 'eshell-visual-commands "tail")
                   (add-to-list 'eshell-visual-commands "top")
                   (eshell/alias "ff" "find-file $1")
                   (eshell/alias "emacs" "find-file $1")
                   (eshell/alias "untar" "tar -zxvf")
                   (eshell/alias "cpv" "rsync -ah --info=progress2")
                   (eshell/alias "ll" "ls -Alh")))
  :custom
  (eshell-error-if-no-glob t)
  (eshell-hist-ignoredups t)
  (eshell-save-history-on-exit t)
  (eshell-destroy-buffer-when-process-dies t)
  :config
  (setenv "PAGER" "cat")
  )

(use-package eshell-toggle
    :defer t
    :ensure t
    :custom
    (eshell-toggle-size-fraction 3)
    (eshell-toggle-run-command nil)
    (eshell-toggle-init-function #'eshell-toggle-init-eshell)
    (eshell-toggle-window-side 'right)
    :bind
    ("C-c e" . eshell-toggle)
    )

(use-package pdf-tools
  :defer 5
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config   (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil)
  )

(use-package saveplace-pdf-view
  :defer 2
  :ensure t
  :after pdf-view
  )

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  )

(use-package markdown-mode
  :ensure t
  :defer 1
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))


(use-package markdown-preview-mode
  :ensure t
  :defer 1
  :bind (("C-c m o" . markdown-preview-mode)))
