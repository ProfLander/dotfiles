;; -*- lexical-binding: t -*-

(load "bootstrap-elpaca.el")

(load "bootstrap-use-package.el")

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/mnt/projects/personal/org/batch/")
(add-to-list 'load-path "/mnt/projects/personal/org/farm/")
(add-to-list 'load-path "/mnt/projects/personal/org/farm/ox-farm")
(add-to-list 'load-path "/mnt/projects/personal/org/dat/")
(add-to-list 'load-path "/mnt/projects/personal/org/rose-unicode-input-method/")

(defvar jp/youtube-subs
  '("@Accursed_Farms"
    "@XboxAhoy" ;; Ahoy
    "@ashens"
    "@AvoidingThePuddle"
    "@BIL0471"
    "@BusterTBMPlays"
    "@Civvie11"
    "@JayTB123"
    "@JosephAndersonChannel"
    "@LGR"
    "@MandaloreGaming"
    "@Markiplier"
    "@Matthewmatosis"
    "@Majuular",
    "@broadcaststsatic" ;; Noah Caldwell-Gervais
    "@Raycevick"
    "@RewindArcade"
    "@SeanSeanson"
    "@SecondWindGroup"
    "@SolePorpoise"
    "@SsethTzeentach"
    "@Tehsnakerer"
    "@Whitelight"))


    (defun le (lhs rhs) (<= lhs rhs))
    (defun lt (lhs rhs) (< lhs rhs))

    (use-package emms
      :config
    (require 'emms-setup)
    
    ;;; vgm_tag info function
    (defvar emms-info-vgm-tag-command
      "vgm_tag")
    
    (defvar emms-info-vgm-tag-args
      '("-ShowTag8"))
    
    (defvar emms-info-vgm-tag-format-regex
      "\\.[Vv][Gg]\\([Zz]\\|[Mm]\\)\\'")
    
    (defvar emms-info-vgm-tag-parse-regex
      "^\\([^\t\n ][^\t\n:]+\\):[\t ]+\\([^\n]+\\)\n\\(?:[\t ]+\\([^\n\t:]+\\)\\)?")
    
    (defvar emms-info-vgm-tag-header-lines 4)
    
    (defvar emms-info-vgm-tag-alist
      '(("Track Title" . info-title)
        ("Game Name" . info-album)
        ("System" . info-artist)
        ("Composer" . info-composer)
        ("Release" . info-release)))
    
    (require 'emms)
    (require 'emms-player-simple)
    (define-emms-simple-player vgmplay '(file url)
                               (emms-player-simple-regexp "vgm" "vgz")
                               "vgmplay")

    (defun emms-info-provenance (track)
      (let ((name (emms-track-name track))
            (type (emms-track-type track)))
        (cond ((eq 'file type)
               (when (string-match "/mnt/media/audio/\\([^/]+\\)/.*" name)
                 (let ((provenance (match-string 1 name)))
                   (emms-track-set track
                                   'info-provenance
                                   provenance))))
              ((eq 'url type)
               (emms-track-set track
                               'info-provenance
                               "video")))))
    
    (defun emms-info-vgm-tag (track)
      (when (and (emms-track-file-p track)
                 (string-match emms-info-vgm-tag-format-regex
                               (emms-track-name track)))
        (with-temp-buffer 
          (when (zerop
                 (apply 'call-process
                        emms-info-vgm-tag-command
                        nil t nil
                        (append emms-info-vgm-tag-args
                                (list (emms-track-name track)))))
            (goto-char (point-min))
            (forward-line emms-info-vgm-tag-header-lines)
            (while (re-search-forward emms-info-vgm-tag-parse-regex nil t)
              (let ((key (match-string 1))
                    (value (match-string 2)))
                (when-let (key (alist-get key emms-info-vgm-tag-alist
                                          nil nil 'equal))
                  (emms-track-set track key value))))))))
    
    ;;; yt-dlp playlist source
    (defvar emms-source-yt-dlp-playlist-command "yt-dlp")
    (defvar emms-source-yt-dlp-playlist-parse-regex
      "\\(.*\\)\n\\(.*\\)\n\\(.*\\)\n\\(.*\\)\n\\(.*\\)\n\n")
    (defvar emms-source-yt-dlp-playlist-args
      '("--quiet"
        "--no-warnings"
        "--yes-playlist"
        "--flat-playlist"
        "--playlist-reverse"
        "-O" "%(webpage_url)s"
        "-O" "%(title)s"
        "-O" "%(playlist)s"
        "-O" "%(playlist_channel)s"
        "-O" "%(playlist_index)s"
        "-O" ""))
    
    (defun emms-ensure-active-playlist-p ()
      "Raise an error if there is no active playlist."
      (when (not emms-playlist-buffer)
        (error "No active EMMS playlist buffer")))
    
    (defun jp/emms-playlist-insert-yt-dlp-track (playlist
                                                 url title playlist-name channel index)
      (message "Inserting yt-dlp track: %s" title)
      (let ((track (emms-track 'url url)))
        (emms-track-set track 'info-title title)
        (emms-track-set track 'info-album playlist-name)
        (emms-track-set track 'info-artist channel)
        (emms-track-set track 'info-tracknumber index)
        (with-current-buffer playlist
          (emms-playlist-insert-track track))))
    
    (defun jp/yt-dlp-playlist-sentinel (url playlist recurse proc event)
      (let ((channel-name nil)
            (proc-buffer (process-buffer proc))
            (status (process-exit-status proc)))
        (if (zerop status)
            (pcase event
              ("finished\n"
               (with-current-buffer proc-buffer
                 (goto-char (point-min))
                 (while (looking-at
                         emms-source-yt-dlp-playlist-parse-regex)
                   (when-let ((url (match-string 1))
                              (title (match-string 2))
                              (playlist-name (match-string 3))
                              (playlist-name (if (equal playlist-name "NA")
                                                 nil
                                               playlist-name))
                              (channel (match-string 4))
                              (index (match-string 5)))
                     (when (not channel-name)
                       (message "EMMS: Processing channel %s %s"
                                channel-name
                                (if recurse "recursively" ""))
                       (setf channel-name channel))
                     (if recurse
                         (emms-later-do #'jp/yt-dlp-playlist url playlist)
                       (emms-later-do #'jp/emms-playlist-insert-yt-dlp-track
                                      playlist url title playlist-name channel index)))
                   (goto-char (match-end 0)))))
              (_ (message "Unexpected event in jp/yt-dlp-playlist-sentinel: %s\n%s"
                          event
                          (with-current-buffer proc-buffer (buffer-string)))))
          (display-warning "emms"
                           (format "Process for url %s exited with code %s:\n%s"
                                   url
                                   status
                                   (with-current-buffer proc-buffer (buffer-string)))
                           :warning))
        (kill-buffer proc-buffer)))
    
    (defvar yt-dlp-base-args
      '("--quiet"
        "--no-warnings"))

    (defvar yt-dlp-command "yt-dlp")
    
    (defun jp/yt-dlp-playlist (url &optional playlist recurse)
      (let ((proc-buffer (generate-new-buffer "*yt-dlp-playlist*" t)))
        (make-process :name (format "yt-dlp-%s" url)
                      :buffer proc-buffer
                      :command (cons emms-source-yt-dlp-playlist-command
                                     (append emms-source-yt-dlp-playlist-args
                                             (list url)))
                      :sentinel (apply-partially #'jp/yt-dlp-playlist-sentinel
                                                 url
                                                 playlist
                                                 recurse))))
    
    (defun yt-dlp-sentinel (url callback props proc event)
      (let ((status (process-exit-status proc))
            (proc-buffer (process-buffer proc))
            (prop-count (length props)))
        (if (zerop status)
            (pcase event
              ("finished\n"
               (with-current-buffer proc-buffer
                 (goto-char (point-min))
                 (let ((line-idx 0)
                       (entries '())
                       (entry '()))
                   (while (not (eobp))
                     (let* ((line (string-trim (thing-at-point 'line t) "" "\n"))
                            (prop-idx (mod line-idx prop-count))
                            (prop (nth prop-idx props)))
                       (push (cons prop line) entry)
                       (incf line-idx)
                       (when (zerop (mod line-idx prop-count))
                         (push (nreverse entry) entries)
                         (setf entry '())))
                     (next-line))
                   (funcall callback (nreverse entries)))))
              (_ (message "Unexpected event in yt-dlp-sentinel: %s\n%s"
                          event
                          (with-current-buffer proc-buffer (buffer-string)))))
          (display-warning
           "yt-dlp"
           (format "yt-dlp process for url %s exited with code %s:\n%s"
                   url status
                   (with-current-buffer proc-buffer
                     (buffer-string)))
           :warning))))
    
    (defun yt-dlp (url callback args &rest props)
      (let* ((name (format "yt-dlp-%s" url))
             (buffer (generate-new-buffer name))
             (args (append yt-dlp-base-args
                           args
                           (mapcan (lambda (prop)
                                     `("-O" ,(format "%%(%s)s" (symbol-name prop))))
                                   props)
                           (list url))))
        (message "yt-dlp: %s" args)
        (make-process :name name
                      :buffer buffer
                      :command
                      (cons yt-dlp-command args)
                      :sentinel (apply-partially #'yt-dlp-sentinel
                                                 url callback props))))
    
    (defun emms-add-yt-dlp-youtube-channel (url)
      (emms-ensure-active-playlist-p)
      (let ((list-buffer emms-playlist-buffer))
        (jp/yt-dlp-playlist (format "https://youtube.com/%s" url) list-buffer)))
    
    (defun emms-add-yt-dlp-youtube-playlists (url)
      (emms-ensure-active-playlist-p)
      (let ((list-buffer emms-playlist-buffer))
        (jp/yt-dlp-playlist (format "https://youtube.com/%s/playlists" url) list-buffer t)))
    
    (defun emms-add-yt-dlp-youtube (url)
      (interactive "sPlay YouTube channel ID: ")
      (emms-add-yt-dlp-youtube-channel url)
      (emms-add-yt-dlp-youtube-playlists url))
    
    (defun jp/yt-dlp-update ()
      (interactive)
      (dolist (user jp/youtube-subs)
        (emms-add-yt-dlp-youtube user)))
    
    (defun jp/yt-dlp-update-playlists ()
      (interactive)
      (dolist (user jp/youtube-subs)
        (emms-add-yt-dlp-youtube-playlists user)))
    
    ;;; yt-dlp info function
    (defvar emms-info-yt-dlp-command "yt-dlp")
    (setq emms-info-yt-dlp-parse-regex "\\([^:]+\\):[ ]+\\(.*\\)\n")
    (setq emms-info-yt-dlp-args
          '("--no-playlist"
            "-O" "info-title: %(title)s"
            "-O" "info-artist: %(channel)s"
            "-O" "info-date: %(upload_date)s"))
    
    (defun emms-info-yt-dlp (track)
      (when (eq 'url (emms-track-type track))
        ;; Avoid running redundantly for cases where info is already present
        (when (not (or (emms-track-get track 'info-album)
                       (emms-track-get track 'info-title)
                       (emms-track-get track 'info-artist)))
          (with-temp-buffer
            (when (zerop
                   (apply 'call-process
                          emms-info-yt-dlp-command
                          nil t nil
                          (append emms-info-yt-dlp-args
                                  (list (emms-track-name track)))))
              (goto-char (point-min))
              (emms-track-set track 'info-album "Videos")
              (while (looking-at
                      emms-info-yt-dlp-parse-regex)
                (when-let ((key (match-string 1))
                           (key (intern key))
                           (value (match-string 2)))
                  (when (not (equal value "NA"))
                    (emms-track-set track key value)))
                (goto-char (match-end 0))))))))
    
    ;; Custom name for the default playlist buffer
    (setq emms-playlist-buffer-name "*Import Playlist*")
    
    ;;; Window persistence for mpv player
    (defvar emms-player-mpv-last-time-remaining
      nil
      "Value of the most recent time-remaining event received from mpv.")
    
    (defvar emms-player-mpv-pause-stopped-threshold
      0.25
      "Margin of error determining whether a pause consistutes the end of a video.")
    
    (defun emms-player-mpv-persistent-window-stopped (event)
      "Listen for time-remaining events and issue stopped for persistent windows."
      (let ((event (alist-get 'event event))
            (name (alist-get 'name event))
            (data (alist-get 'data event)))
        (pcase event
          ("property-change"
           (pcase name
             ;;("time-remaining" (if (and data
             ;;                           (= data 0.0))
             ;;                      (or emms-player-stopped-p
             ;;                          (progn (emms-player-mpv-proc-playing nil)
             ;;                                 (emms-player-stopped)))
             ;;                    (setq emms-player-mpv-last-time-remaining
             ;;                          data)))
             ("pause" (and (eq data t)
                           emms-player-mpv-last-time-remaining
                           (le emms-player-mpv-last-time-remaining
                               emms-player-mpv-pause-stopped-threshold)
                           (or emms-player-stopped-p
                               (progn (emms-player-mpv-proc-playing nil)
                                      (emms-player-stopped))))))))))
    
    (defun emms-player-mpv-setup-observe ()
      (emms-player-mpv-observe-property 'pause)
      (emms-player-mpv-observe-property 'time-remaining))

    (defun emms-player-mpv-setup-persistent-window ()
      "Configure the EMMS mpv player to use a single persistent window."
      (add-to-list 'emms-player-mpv-parameters "--force-window=immediate")
      (add-to-list 'emms-player-mpv-parameters "--keep-open=always")
      (or (seq-contains-p emms-player-mpv-event-connect-hook
                          #'emms-player-mpv-setup-observe)
          (add-hook 'emms-player-mpv-event-connect-hook
                    #'emms-player-mpv-setup-observe))
      (or (seq-contains-p emms-player-mpv-event-functions
                          #'emms-player-mpv-persistent-window-stopped)
          (add-hook 'emms-player-mpv-event-functions
                    #'emms-player-mpv-persistent-window-stopped)))

    ;; include
    (emms-minimalistic)
    ;; define
    (eval-and-compile
      (require 'emms-playlist-mode)
      (require 'emms-info)
      (require 'emms-info-libtag)
      (require 'emms-cache)
      (require 'emms-tag-editor)
      (require 'emms-tag-tracktag)
      (require 'emms-show-all)
      (require 'emms-playlist-sort)
      (require 'emms-browser)
      (require 'emms-last-played)
      (require 'emms-metaplaylist-mode)
      (require 'emms-stream-info)
      (require 'emms-history)
      (require 'emms-volume))
    ;; setup
    (add-to-list 'emms-track-initialize-functions #'emms-info-initialize-track)
    (when (fboundp 'emms-cache)		; work around compiler warning
      (emms-cache 1))
    (add-hook 'emms-player-started-hook #'emms-last-played-update-current)

    (setq emms-source-file-default-directory "/mnt/media/audio")
    (setq emms-player-list '(emms-player-vgmplay emms-player-mpv))
    (setq emms-info-functions '(emms-info-provenance emms-info-vgm-tag emms-info-libtag))
    (setq emms-track-description-function #'emms-info-track-description)
    (setq emms-browser-covers #'emms-browser-cache-thumbnail-async)
    (setq emms-browser-thumbnail-small-size 256)
    (setq emms-browser-thumbnail-medium-size 512)

    (emms-browser-make-filter
     "all"
     #'ignore)
    
    (emms-browser-make-filter
     "recent"
     (lambda (track)
       (lt 30 (time-to-number-of-days
               (time-subtract (current-time)
                              (emms-info-track-file-mtime track))))))
    
    (emms-browser-make-filter
     "unwatched"
     (lambda (track)
       (emms-track-get track 'play-count)))

    (emms-browser-make-filter
     "video"
     (lambda (track)
       (not (equal (emms-track-get track 'info-provenance) "video"))))

    (emms-browser-make-filter
     "vgm"
     (lambda (track)
       (not (equal (emms-track-get track 'info-provenance) "vgm"))))

    (emms-browser-make-filter
     "music"
     (lambda (track)
       (not (equal (emms-track-get track 'info-provenance) "music"))))

    (emms-browser-make-filter
     "radio"
     (lambda (track)
       (not (equal (emms-track-get track 'info-provenance) "radio"))))

    (emms-browser-make-filter
     "audiobook"
     (lambda (track)
       (not (equal (emms-track-get track 'info-provenance) "audiobook"))))

    (defun jp/emms-playlist-switch-buffer ()
      "Display the current EMMS playlist buffer, if it is valid."
      (interactive)
      (when (buffer-live-p emms-playlist-buffer)
        (switch-to-buffer emms-playlist-buffer)))
    
    ;; History
    (emms-history-load)
    ;; Window persistence
    (emms-player-mpv-setup-persistent-window)

    ;; Setup ivy browser filter switching
    (defun emms-browser--read-filter (&rest args)
      "Display an Ivy interface to choose an EMMS filter.
  Optional argument ARGS Arguments to pass to \='ivy-read\='."
      (interactive)
      (apply 'ivy-read "Filter EMMS browser by: "
             emms-browser-filters
             :require-match t
             :preselect (-find-index (lambda (entry)
                                       (eq (car entry) emms-browser-current-filter-name))
                                     emms-browser-filters)
             args))
    
    (defun emms-browser-switch-filter ()
      (interactive)
      (emms-browser--read-filter :action (lambda (output)
                                           (emms-browser-refilter
                                            output)))))

(use-package elfeed
  :custom
  (elfeed-db-directory "~/.emacs.d/elfeed")
  :config
  ;; Allow deleting entries from the UI
  (defun sk/elfeed-db-remove-entry (id)
    "Removes the entry for ID"
    (avl-tree-delete elfeed-db-index id)
    (remhash id elfeed-db-entries))

  (defun sk/elfeed-search-remove-selected ()
    "Remove selected entries from database"
    (interactive)
    (let* ((entries (elfeed-search-selected))
           (count (length entries)))
      (when (y-or-n-p (format "Delete %d entires?" count))      
        (cl-loop for entry in entries
                 do (sk/elfeed-db-remove-entry (elfeed-entry-id entry)))))
    (elfeed-search-update--force))
  
  (setq youtube-rss-regex "title=\"RSS\" href=\"\\([^\"]+\\)\"")

  (defun jp/elfeed-import-youtube-url-callback (callback status &rest args)
    (when-let ((string (buffer-string))
               (match (string-match youtube-rss-regex string))
               (url (match-string 1 string)))
      (funcall callback url)))
  
  (defun jp/elfeed-import-youtube-url (url callback)
    (when-let ((buffer (url-retrieve
                        url
                        (apply-partially #'jp/elfeed-import-youtube-url-callback
                                         callback)
                        nil t t)))
      (with-current-buffer buffer
        (set-buffer-multibyte t))))
  
  (defun jp/elfeed-import-youtube-user (user callback)
    (jp/elfeed-import-youtube-url (format "https://youtube.com/%s" user)
                                  callback))
  
  (setq yt-elfeed-buffer-name "*Import Playlist*")

  (defun jp/yt-elfeed-parse-hook (entry)
    (let ((tags (elfeed-entry-tags entry)))
      (when (and (seq-contains-p tags 'unread)
                 (seq-contains-p tags 'youtube))
        (elfeed-untag entry 'unread)
        (let* ((title (elfeed-entry-title entry))
               (link (elfeed-entry-link entry))
               (date (elfeed-entry-date entry))
               (meta (elfeed-entry-meta entry))
               (author (car (plist-get meta :authors)))
               (author-name (plist-get author :name)))
          (message "Elfeed parsed YouTube entry:
Title: %s
Link: %s
Date: %s
Meta: %s
Author: %s"
                   title link date meta author-name)
          (if-let (buffer (get-buffer yt-elfeed-buffer-name))
              (jp/emms-playlist-insert-yt-dlp-track buffer
                                                    link
                                                    title
                                                    nil
                                                    author-name
                                                    nil)
            (error "Playlist buffer %s is invalid" yt-elfeed-buffer-name))))))
  
  (defun jp/yt-elfeed-update ()
    (or (seq-contains-p elfeed-new-entry-hook #'jp/yt-elfeed-parse-hook)
        (add-hook 'elfeed-new-entry-hook #'jp/yt-elfeed-parse-hook))
    (let ((pending (copy-tree jp/youtube-subs)))
      (dolist (user pending)
        (jp/elfeed-import-youtube-user
         user
         (lambda (feed)
           (cl-pushnew `(,feed youtube) elfeed-feeds)
           (setf pending (delete user pending))
           (when (not pending)
             (elfeed-update)))))))
  
  (defun jp/yt-elfeed-reparse-all ()
    (mapc (lambda (feed)
            (mapc #'jp/yt-elfeed-parse-hook
                  (elfeed-feed-entries feed)))
          (elfeed-feed-list)))
  
  (jp/yt-elfeed-update))

(use-package frames-only-mode
  :config
  (frames-only-mode-remap-common-window-split-keybindings)
  (frames-only-mode))

(load "settings.el")
