;; Diamond Emacs for Mac
;;
;; MacPapo config started in 2022

;; Update packages automatically
(use-package auto-package-update
  :defer 0.2
  :ensure t
  :commands update-packages
  :custom
  (auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-maybe))

;; Garbaege collection Hack
(use-package gcmh
  :ensure t
  :demand t
  :config
  (gcmh-mode 1))

;; Magit for git support
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

;; Declutter .emacs.d folder
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

;; Winum power
(use-package winum
  :defer 0.5
  :ensure t
  :custom
  (winum-auto-setup-mode-line t)
  :config
  (winum-mode)
  :bind (
         ;; Select the window with Meta
         ("M-1" . winum-select-window-1)
         ("M-2" . winum-select-window-2)
         ("M-3" . winum-select-window-3)
         ("M-4" . winum-select-window-4)
         ("M-5" . winum-select-window-5)
         ("M-6" . winum-select-window-6))
  )


;; Mail reader
(use-package mu4e
  :ensure nil
  :defer 5 ; whait until 5 seconds after startup
  :load-path "/opt/homebrew/Cellar/mu/1.6.11/share/emacs/site-lisp/mu4e/"
  :config
  (setq mu4e-update-interval 300)            ; Update interval (seconds)
  (setq mu4e-index-cleanup t)                ; Cleanup after indexing
  (setq mu4e-maildir "~/Documents/Mails")
  (setq mu4e-attachment-dir "~/Downloads")
  (setq mu4e-index-update-error-warning t)   ; Warnings during update
  (setq mu4e-index-update-in-background t)   ; Background update
  (setq mu4e-change-filenames-when-moving t) ; Needed for mbsync
  (setq mu4e-get-mail-command "/opt/homebrew/bin/mbsync -a")
  (setq mu4e-index-lazy-check nil)           ; Don't be lazy, index everything
  (setq mu4e-confirm-quit nil)
  (setq mu4e-headers-include-related t)
  (setq mu4e-headers-skip-duplicates t)
  (setq mu4e-sent-folder "/uni/sent")
  (setq mu4e-trash-folder "/uni/trash")
  (setq mu4e-drafts-folder "/uni/drafts")
  (setq mu4e-maildir-shortcuts '(("/uni/inbox" . ?i)
                                 ("/uni/archive". ?a)
                                 ("/uni/sent" . ?s)))
  )

;; Use All the ICONS
(use-package all-the-icons
  :ensure t)

;; Prais the suuuunnnn!!!!
(use-package solaire-mode
  :defer 0.5
  :ensure t
  :hook (after-init . solaire-global-mode))

;; Custom Dashboard
(use-package dashboard
  :ensure t
  :demand t
  :init
  (add-hook 'dashboard-mode-hook (lambda () (setq show-trailing-whitespace nil)))
  :custom
  (dashboard-banner-logo-title "[D I A M O N D  E M A C S]")
  (dashboard-startup-banner "~/.emacs.d/etc/banner/diamond_dogs.png")
  (dashboard-footer-messages '("Kept you waiting huh!"))
  (dashboard-footer-icon (all-the-icons-wicon "meteor" :height 1.1 :v-adjust -0.05 :face 'font-lock-keyword-face))
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-navigator t)
  (dashboard-navigator-buttons
   `(
     ;; Links
     ((,(all-the-icons-octicon "octoface" :height 1.1 :v-adjust 0.0)
       "Homepage"
       "Browse homepage"
       (lambda (&rest _) (browse-url "https://github.com/MacPapo/Diamond-Emacs")) nil "" " |")
      (,(all-the-icons-faicon "refresh" :height 1.1 :v-adjust 0.0)
       "Update"
       "Update Megumacs"
       (lambda (&rest _) (update-packages)) warning "" " |")
      (,(all-the-icons-faicon "flag" :height 1.1 :v-adjust 0.0) nil
       "Report a BUG"
       (lambda (&rest _) (browse-url "https://github.com/MacPapo/Diamond-Emacs/issues/new")) error "" ""))
     ;; Empty line
     (("" "\n" "" nil nil "" ""))
     ;; Keybindings
     ((,(all-the-icons-octicon "search" :height 0.9 :v-adjust -0.1)
       " Find file" nil
       (lambda (&rest _) (counsel-find-file)) nil "" "            C-x C-f"))
     ;; ((,(all-the-icons-octicon "file-directory" :height 1.0 :v-adjust -0.1)
     ;;   " Open project" nil
     ;;   (lambda (&rest _) (counsel-projectile-switch-project)) nil "" "         SPC p p"))
     ((,(all-the-icons-octicon "three-bars" :height 1.1 :v-adjust -0.1)
       " File explorer" nil
       (lambda (&rest _) (counsel-projectile-switch-project)) nil "" "           C-x d"))
     ((,(all-the-icons-octicon "settings" :height 0.9 :v-adjust -0.1)
       " Open settings" nil
       (lambda (&rest _) (open-config-file)) nil "" "        C-f C-P"))
     ))
  :config
  (dashboard-setup-startup-hook))

;; PDF Tools
(use-package pdf-tools
  :defer 5 ; whait until 5 seconds after startup
  :ensure t
  :config   (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))

;; Treemacs tool
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")'
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))
