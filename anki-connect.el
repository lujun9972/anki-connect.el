;;; anki-connect.el --- AnkiConnect API -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2019 DarkSun <lujun9972@gmail.com>.

;; Author: DarkSun <lujun9972@gmail.com>
;; Keywords: lisp, anki
;; Package: anki-connect
;; Version: 1.0
;; Package-Requires: ((emacs "24.3"))
;; URL: https://github.com/lujun9972/anki-connect.el

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Source code
;;
;; anki-connect's code can be found here:
;;   https://github.com/lujun9972/anki-connect.el

;;; Commentary:

;; anki-connect.el defined some functions to interactive with AnkiConnect in Anki


;;; Code:

(require 'url)
(defconst anki-connect-url "http://127.0.0.1:8765"
  "URL for anki-connect.")

(defun anki-connect-request (action params)
  "Commuicate with anki-connect.

ACTION describe the action.
PARAMS should be an alist."
  (let* ((request-data (if params
                           (json-encode `(("action" . ,action)
                                          ("version" . 6)
                                          ("params" . ,params)))
                         (json-encode `(("action" . ,action)
                                        ("version" . 6)))))
         (url-request-data (encode-coding-string request-data 'utf-8))
         (url-request-method "POST")
         (url-request-extra-headers '(("Content-Type" . "application/json")))
         (retrive-buffer (url-retrieve-synchronously anki-connect-url))
         (response (with-current-buffer retrive-buffer
                     (goto-char (point-min))
                     (search-forward-regexp "^$")
                     (json-read)))
         (error-p (cdr (assoc 'error response))))
    (unless error-p
      (cdr (assoc 'result response)))))

(defun anki-connect-deck-names ()
  "List decks."
  (append (anki-connect-request "deckNames" nil) nil))

(defun anki-connect-model-names ()
  "List models."
  (append  (anki-connect-request "modelNames" nil) nil))

(defun anki-connect-model-field-names (model)
  "List fields in MODEL."
  (append (anki-connect-request "modelFieldNames"
                               `(("modelName" . ,model)))
          nil))

(defun anki-connect-add-note (deck model field-alist &optional audio)
  "Add a note to DECK.

MODEL specify the format of the note.
FIELD-ALIST specify the content of the note.
AUDIO specify the audio information."
  (let ((note `(("deckName" . ,deck)
                ("modelName" . ,model)
                ("fields" . ,field-alist)
                ("tags" . []))))
    (when audio
      (setq note (append note `(("audio" . ,audio)))))
    (anki-connect-request "addNote" `(("note" . ,note)))))


(provide 'anki-connect)

;;; anki-connect.el ends here
