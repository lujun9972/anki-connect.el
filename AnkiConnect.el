;;; AnkiConnect.el --- AnkiConnect Client for Emacs

;; Copyright (C) 2019-2019 DarkSun <lujun9972@gmail.com>.

;; Author: DarkSun <lujun9972@gmail.com>
;; Keywords: lisp, anki
;; Package: AnkiConnect
;; Version: 1.0
;; Package-Requires: ((emacs "24.3"))

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
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Source code
;;
;; AnkiConnect's code can be found here:
;;   http://github.com/lujun9972/AnkiConnect.el

;;; Commentary:

;; AnkiConnect defined some functions to interactive with AnkiConnect in Anki


;;; Code:

(require 'url)
(defconst AnkiConnect-URL "http://127.0.0.1:8765"
  "URL for AnkiConnect")

(defun AnkiConnect-request (action params)
  "Commuicate with AnkiConnect.

PARAMS should be an alist"
  (let* ((request-data (if params
                               (json-encode `(("action" . ,action)
                                              ("version" . 6)
                                              ("params" . ,params)))
                             (json-encode `(("action" . ,action)
                                            ("version" . 6)))))
         (url-request-data (encode-coding-string request-data 'utf-8))
         (url-request-method "POST")
         (url-request-extra-headers '(("Content-Type" . "application/json")))
         (retrive-buffer (url-retrieve-synchronously AnkiConnect-URL))
         (response (with-current-buffer retrive-buffer
                     (goto-char (point-min))
                     (search-forward-regexp "^$")
                     (json-read)))
         (error-p (cdr (assoc 'error response))))
    (unless error-p
      (cdr (assoc 'result response)))))

(defun AnkiConnect-DeckNames ()
  "List decks"
  (append (AnkiConnect-request "deckNames" nil) nil))

(defun AnkiConnect-ModelNames ()
  "List models"
  (append  (AnkiConnect-request "modelNames" nil) nil))

(defun AnkiConnect-ModelFieldNames (model)
  "List fields in MODOEL"
  (append (AnkiConnect-request "modelFieldNames"
                               `(("modelName" . ,model)))
          nil))

(defun AnkiConnect-AddNote (deck model field-alist)
  "Add a note to DECK

MODEL specify the format of the note.
FIELD-ALIST specify the content of the note."
  (AnkiConnect-request "addNote"
                       `(("note" . (("deckName" . ,deck)
                                    ("modelName" . ,model)
                                    ("fields" . ,field-alist)
                                    ("tags" . []))))))


(provide 'AnkiConnect)
