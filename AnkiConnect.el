(require 'request)
(defconst AnkiConnect-URL "http://127.0.0.1:8765"
  "URL for AnkiConnect")

(defun AnkiConnect-request (action params)
  (let ((params (json-encode-alist params)))
    (request-response-data
     (request AnkiConnect-URL
              :type "POST"
              :data (format "{\"action\" : %S,\"params\" : %s}" action params)
              :parser 'json-read
              :sync t
              ))))

(defun AnkiConnect-DeckNames ()
  "获取牌组列表"
  (AnkiConnect-request "deckNames" nil))

(defun AnkiConnect-ModeNames ()
  "获取卡片类型列表"
  (AnkiConnect-request "modelNames" nil))

(defun AnkiConnect-ModelFieldNames (model-name)
  "获取某卡片类型中的字段列表"
  (AnkiConnect-request "modelFieldNames"
                       `(("modelName" . ,model-name))))
;; (AnkiConnect-ModelFieldNames "单词本")

(defun AnkiConnect-AddNote (deck-name model-name field-alist)
  "添加卡片"
  (AnkiConnect-request "addNote"
                       `(("note" . (("deckName" . ,deck-name)
                                    ("modelName" . ,model-name)
                                    ("fields" . ,field-alist)
                                    ("tags" . []))))))

;; (AnkiConnect-AddNote "我的生词本" "单词本"
;;                      '(("拼写" . "Emacs")
;;                       ("意义" . "测试AnkiConnect")))
