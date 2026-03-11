;;; pal8-mode.el --- Programming language mode for PAL8 assembly language
;;; copyright 2018 Lars Brinkhoff

;; You can redistribute it and/or modify it under the terms of the
;; GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;; Author: Lars Brinkhoff <lars@nocrew.org>
;; Keywords: languages assembler pal8
;; URL: http://github.com/larsbrinkhoff/pal8-mode
;; Version: 0.1

;;; Commentary:
;; Programming language mode for PAL8 assembly language

;;; Code:

(eval-when-compile (byte-compile-disable-warning 'cl-functions))
(require 'cl)

(defvar pal8-mode-hook)

(unless (fboundp 'asm-mode)
  (defalias 'prog-mode 'fundamental-mode))

(unless (fboundp 'setq-local)
  (defmacro setq-local (var val)
    `(set (make-local-variable ',var) ,val)))

(defvar pal8-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\; "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\. "_" table)
    (modify-syntax-entry ?\% "_" table)
    (modify-syntax-entry ?\{ "_" table)
    (modify-syntax-entry ?\} "_" table)
    (modify-syntax-entry ?\[ "(" table)
    (modify-syntax-entry ?\] ")" table)
    (modify-syntax-entry ?\< "(" table)
    (modify-syntax-entry ?\> ")" table)
    (modify-syntax-entry ?\' "/" table)
    (modify-syntax-entry ?\" "/" table)
    (modify-syntax-entry ?^ "/" table)
    (modify-syntax-entry ?\/ "\"" table)
    table))

(defun pal8-next-tab-stop ()
  (interactive)
  (let ((x (current-column)))
    (cond ((>= x 37) nil)
          ((=  x 30) (backward-delete-char 1) (move-to-column 37 t) (insert "/"))
          ((>= x 29) (move-to-column 37 t) (insert "/"))
          ((>= x 21) (move-to-column 29 t) (insert "/"))
          ((>= x 13) (move-to-column 21 t))
          ((>= x 7)  (move-to-column 13 t))
          (t         (move-to-column 7 t)))))

(defun pal8-newline ()
  (interactive)
  (open-line 1)
  (next-line)
  (let ((x ""))
   (save-excursion
     (search-backward-regexp "^[0-7][0-7][0-7][0-7][0-7] ")
     (setq x (buffer-substring (point) (+ (point) 5))))
   (insert (format "%05o  " (1+ (car (read-from-string (concat "#o" x))))))))

(defun self-insert-upcase ()
  (interactive)
  (self-insert-command 1 (upcase last-command-event)))

;;;###autoload
(define-derived-mode pal8-mode asm-mode "PAL8"
		     "Major mode for editing PAL8 files."
		     :syntax-table pal8-mode-syntax-table
  (keymap-local-set "TAB" 'pal8-next-tab-stop)
  (keymap-local-set "RET" 'pal8-newline)
  (keymap-local-set ";" 'self-insert-command)
  (loop for i from ?a to ?z do
    (keymap-local-set (string i) 'self-insert-upcase))
  (setq font-lock-defaults '(nil))
  (setq-local comment-start-skip "/")
  (setq-local comment-start "/")
  (setq-local comment-end "$"))
