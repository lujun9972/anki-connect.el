(require 'request)
(defconst AnkiConnect-URL "http://127.0.0.1:8765"
  "URL for AnkiConnect")

(defun AnkiConnect-request (action params)
  "Commuicate with AnkiConnect.

PARAMS should be an alist"
  (let* ((data (if params
                   (json-encode `(("action" . ,action)
                                  ("version" . 6)
                                  ("params" . ,params)))
                 (json-encode `(("action" . ,action)
                                ("version" . 6)))))
         (response (request-response-data
                    (request AnkiConnect-URL
                             :type "POST"
                             :data data
                             :parser 'json-read
                             :sync t)))
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
;; (completing-read nil (cons "" (AnkiConnect-ModelFieldNames "Basic")))

(defun AnkiConnect-AddNote (deck model field-alist)
  "Add a note to DECK

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
