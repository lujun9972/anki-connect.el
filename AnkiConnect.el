(require 'request)
(defconst AnkiConnect-URL "http://127.0.0.1:8765"
  "URL for AnkiConnect")

(defun AnkiConnect-request (action params)
  "Commuicate with AnkiConnect.

PARAMS should be an alist"
  (let ((params (json-encode-alist params)))
    (request-response-data
     (request AnkiConnect-URL
              :type "POST"
              :data (format "{\"action\" : %S,\"params\" : %s}" action params)
              :parser 'json-read
              :sync t
              ))))

(defun AnkiConnect-DeckNames ()
  "list decks"
  (append (AnkiConnect-request "deckNames" nil) nil))

(defun AnkiConnect-ModelNames ()
  "list models"
  (append  (AnkiConnect-request "modelNames" nil) nil))

(defun AnkiConnect-ModelFieldNames (model)
  "list fields in MODOEL"
  (append (AnkiConnect-request "modelFieldNames"
                               `(("modelName" . ,model)))
          nil))
;; (completing-read nil (cons "" (AnkiConnect-ModelFieldNames "单词本")))

(defun AnkiConnect-AddNote (deck model field-alist)
  "add a note to DECK

MODEL specify the format of the note.
FIELD-ALIST specify the content of the note."
  (AnkiConnect-request "addNote"
                       `(("note" . (("deckName" . ,deck)
                                    ("modelName" . ,model)
                                    ("fields" . ,field-alist)
                                    ("tags" . []))))))

;; (AnkiConnect-AddNote "我的生词本" "单词本"
;;                      '(("拼写" . "Emacs")
;;                       ("意义" . "测试AnkiConnect")))

(provide 'AnkiConnect)
