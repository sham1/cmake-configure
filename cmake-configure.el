;;; cmake-configure.el --- a mode for configuring a CMake build -*- lexical-binding: t -*-

;; Copyright (C) 2020 Jani Juhani Sinervo <jani@sinervo.fi>

;; Author: Jani Juhani Sinervo <jani@sinervo.fi>
;; Version: 0.1
;; URL: https://github.com/sham1/cmake-configure

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;; This package provides a special mode for configuring and setting settings
;; in CMake-based projects.

;;; Code:

(require 'widget)

(eval-when-compile
  (require 'wid-edit))

(defvar cmake-configure--source-dir)
(defvar cmake-configure--build-dir)
(defvar cmake-configure--source-dir-widget)
(defvar cmake-configure--build-dir-widget)

(defcustom cmake-configure-cmake-executable "cmake"
  "The cmake executable `cmake-configure' shall use."
  :type 'file
  :group 'cmake-configure)

(defvar cmake-configure-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map (make-composed-keymap widget-keymap
						 special-mode-map))
    (define-key map "n" #'widget-forward)
    (define-key map "p" #'widget-backward)
    map)
  "Keymap for `cmake-configure-mode'.")

(define-derived-mode cmake-configure-mode special-mode "cmake configure"
  "A special mode for editing build variables of CMake projects"
  :group 'cmake-configure
  (use-local-map cmake-configure-mode-map))

;;;###autoload
(defun cmake-configure (source-dir build-dir)
  "Launches a configuration view for a cmake project at SOURCE-DIR with a build directory at BUILD-DIR."
  (interactive
   (let* ((src (read-directory-name "Source directory: "))
	  (build (read-directory-name "Build directory: " src)))
     (list src build)))
  (switch-to-buffer (get-buffer-create "*cmake-configure*"))
  (cmake-configure-mode)
  (setq-local cmake-configure--source-dir source-dir)
  (setq-local cmake-configure--build-dir build-dir)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (widget-insert "CMake project configuration\n")
  (widget-insert "\n")
  (setq-local cmake-configure--source-dir-widget
	      (widget-create 'directory
			     :tag "Source directory"
			     :value cmake-configure--source-dir))
  (setq-local cmake-configure--build-dir-widget
	      (widget-create 'directory
			     :tag "Build directory"
			     :value cmake-configure--build-dir))
  (widget-create 'push-button
		 "Generate")
  (goto-char (point-min))
  (widget-setup)
  (setq-local inhibit-read-only t))

(provide 'cmake-configure)
;;; cmake-configure.el ends here
